import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final _repo = AuthRepository();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _error;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _status == AuthStatus.loading;

  void _setLoading() {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();
  }

  void _setError(String msg) {
    _status = AuthStatus.error;
    _error = msg;
    notifyListeners();
  }

  Future<bool> checkAuthState() async {
    final u = await _repo.getCurrentUser();
    if (u != null) {
      _user = u;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
    return u != null;
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading();
    try {
      _user = await _repo.signInWithEmail(email, password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(AuthRepository.friendlyError(e));
      return false;
    } catch (e) {
      _setError('Sign in failed. Please try again.');
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading();
    try {
      _user = await _repo.registerWithEmail(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(AuthRepository.friendlyError(e));
      return false;
    } catch (e) {
      _setError('Registration failed. Please try again.');
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading();
    try {
      _user = await _repo.signInWithGoogle();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(AuthRepository.friendlyError(e));
      return false;
    } catch (e) {
      _setError('Google sign-in failed.');
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    _setLoading();
    try {
      await _repo.sendPasswordReset(email);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(AuthRepository.friendlyError(e));
      return false;
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _error = null;
    notifyListeners();
  }

  void updateUser(UserModel updated) {
    _user = updated;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
