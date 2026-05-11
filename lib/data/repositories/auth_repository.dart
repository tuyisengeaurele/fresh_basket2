import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../services/email_service.dart';
import '../services/notification_service.dart';

class AuthRepository {
  final _auth = FirebaseService.auth;
  final _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await _saveFcmToken(cred.user!.uid);
    return _fetchUser(cred.user!.uid);
  }

  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user!.updateDisplayName(name);

    final user = UserModel(
      id: cred.user!.uid,
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      createdAt: DateTime.now(),
    );
    await FirebaseService.users.doc(user.id).set(user.toMap());
    await _saveFcmToken(user.id);

    // Send welcome email — fire and forget
    EmailService().sendWelcomeEmail(email: email.trim(), name: name.trim());

    return user;
  }

  Future<UserModel> signInWithGoogle() async {
    final gUser = await _googleSignIn.signIn();
    if (gUser == null) throw FirebaseAuthException(code: 'sign_in_cancelled');

    final gAuth = await gUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    final uid = cred.user!.uid;

    final doc = await FirebaseService.users.doc(uid).get();
    if (!doc.exists) {
      final user = UserModel(
        id: uid,
        name: cred.user!.displayName ?? '',
        email: cred.user!.email ?? '',
        phone: cred.user!.phoneNumber ?? '',
        photoUrl: cred.user!.photoURL,
        createdAt: DateTime.now(),
      );
      await FirebaseService.users.doc(uid).set(user.toMap());
      EmailService().sendWelcomeEmail(
        email: user.email,
        name: user.name,
      );
    }

    await _saveFcmToken(uid);
    return _fetchUser(uid);
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  Future<UserModel> _fetchUser(String uid) async {
    final doc = await FirebaseService.users.doc(uid).get();
    if (!doc.exists) throw Exception('User document not found');
    return UserModel.fromDoc(doc);
  }

  Future<void> _saveFcmToken(String uid) async {
    try {
      final token = await NotificationService().getToken();
      if (token != null) {
        await FirebaseService.users
            .doc(uid)
            .update({'fcmToken': token});
      }
    } catch (_) {}
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    try {
      return await _fetchUser(user.uid);
    } catch (_) {
      return null;
    }
  }

  static String friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'sign_in_cancelled':
        return 'Google sign-in was cancelled.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
