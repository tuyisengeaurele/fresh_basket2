import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;

  // Collection references
  static CollectionReference<Map<String, dynamic>> get users =>
      firestore.collection('users');

  static CollectionReference<Map<String, dynamic>> get products =>
      firestore.collection('products');

  static CollectionReference<Map<String, dynamic>> get orders =>
      firestore.collection('orders');

  static CollectionReference<Map<String, dynamic>> get reviews =>
      firestore.collection('reviews');

  static CollectionReference<Map<String, dynamic>> get promoCodes =>
      firestore.collection('promo_codes');

  static CollectionReference<Map<String, dynamic>> notifications(String userId) =>
      firestore.collection('notifications').doc(userId).collection('items');

  static User? get currentUser => auth.currentUser;
  static String? get currentUserId => auth.currentUser?.uid;
}
