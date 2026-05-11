import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';
import '../services/firebase_service.dart';

class CartRepository {
  Future<void> syncCart(String userId, List<CartItemModel> items) async {
    await FirebaseService.users.doc(userId).update({
      'cart': items.map((i) => i.toMap()).toList(),
    });
  }

  Future<List<CartItemModel>> fetchCart(String userId) async {
    final doc = await FirebaseService.users.doc(userId).get();
    if (!doc.exists) return [];
    final data = doc.data() ?? {};
    final raw = data['cart'] as List<dynamic>? ?? [];
    return raw.map((i) => CartItemModel.fromMap(i as Map<String, dynamic>)).toList();
  }

  Future<void> incrementPromoUsage(String code) async {
    await FirebaseService.promoCodes.doc(code.toUpperCase()).update({
      'currentUses': FieldValue.increment(1),
    });
  }
}
