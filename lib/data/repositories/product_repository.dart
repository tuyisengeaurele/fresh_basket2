import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';
import '../services/firebase_service.dart';

class ProductRepository {
  Stream<List<ProductModel>> watchAll() => FirebaseService.products
      .where('isAvailable', isEqualTo: true)
      .snapshots()
      .map((s) => s.docs.map(ProductModel.fromDoc).toList());

  Stream<List<ProductModel>> watchByCategory(String category) {
    if (category == 'All') return watchAll();
    return FirebaseService.products
        .where('isAvailable', isEqualTo: true)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((s) => s.docs.map(ProductModel.fromDoc).toList());
  }

  Stream<List<ProductModel>> watchFeatured() => FirebaseService.products
      .where('isAvailable', isEqualTo: true)
      .where('isFeatured', isEqualTo: true)
      .snapshots()
      .map((s) => s.docs.map(ProductModel.fromDoc).toList());

  Stream<List<ProductModel>> watchBestSellers() => FirebaseService.products
      .where('isAvailable', isEqualTo: true)
      .orderBy('rating', descending: true)
      .limit(10)
      .snapshots()
      .map((s) => s.docs.map(ProductModel.fromDoc).toList());

  Future<List<ProductModel>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final q = query.trim().toLowerCase();
    final snap = await FirebaseService.products
        .where('isAvailable', isEqualTo: true)
        .get();
    return snap.docs
        .map(ProductModel.fromDoc)
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }

  Future<ProductModel?> getById(String id) async {
    final doc = await FirebaseService.products.doc(id).get();
    if (!doc.exists) return null;
    return ProductModel.fromDoc(doc);
  }

  Stream<List<ReviewModel>> watchReviews(String productId) =>
      FirebaseService.reviews
          .where('productId', isEqualTo: productId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(ReviewModel.fromDoc).toList());

  Future<void> submitReview(ReviewModel review) async {
    final ref = FirebaseService.reviews.doc();
    await ref.set(review.toMap());

    // Recalculate product rating
    final reviews = await FirebaseService.reviews
        .where('productId', isEqualTo: review.productId)
        .get();
    final ratings =
        reviews.docs.map((d) => (d['rating'] as num).toDouble()).toList();
    final avg = ratings.isEmpty
        ? 0.0
        : ratings.reduce((a, b) => a + b) / ratings.length;

    await FirebaseService.products.doc(review.productId).update({
      'rating': double.parse(avg.toStringAsFixed(1)),
      'reviewCount': ratings.length,
    });
  }

  Future<Map<String, dynamic>?> validatePromoCode(String code) async {
    final doc = await FirebaseService.promoCodes.doc(code.toUpperCase()).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    if (!(data['isActive'] ?? false)) return null;
    final expiry = (data['expiresAt'] as Timestamp?)?.toDate();
    if (expiry != null && expiry.isBefore(DateTime.now())) return null;
    final maxUses = (data['maxUses'] as num?)?.toInt() ?? 9999;
    final currentUses = (data['currentUses'] as num?)?.toInt() ?? 0;
    if (currentUses >= maxUses) return null;
    return data;
  }
}
