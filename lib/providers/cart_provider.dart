import 'package:flutter/foundation.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';
import '../data/repositories/cart_repository.dart';
import '../data/repositories/product_repository.dart';

class CartProvider extends ChangeNotifier {
  final _cartRepo = CartRepository();
  final _productRepo = ProductRepository();

  final List<CartItemModel> _items = [];
  String? _promoCode;
  double _discountPercent = 0;
  bool _isSyncing = false;

  static const double deliveryFee = 2000;

  List<CartItemModel> get items => List.unmodifiable(_items);
  String? get promoCode => _promoCode;
  double get discountPercent => _discountPercent;
  bool get isEmpty => _items.isEmpty;
  bool get isSyncing => _isSyncing;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity.ceil());

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * (_discountPercent / 100);

  double get total => subtotal + deliveryFee - discountAmount;

  void addItem(ProductModel product, {double quantity = 1}) {
    final idx = _items.indexWhere((i) => i.productId == product.id);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(
        quantity: _items[idx].quantity + quantity,
      );
    } else {
      _items.add(CartItemModel.fromProduct(product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((i) => i.productId == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, double quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    final idx = _items.indexWhere((i) => i.productId == productId);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void incrementItem(String productId) {
    final idx = _items.indexWhere((i) => i.productId == productId);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity + 0.5);
      notifyListeners();
    }
  }

  void decrementItem(String productId) {
    final idx = _items.indexWhere((i) => i.productId == productId);
    if (idx >= 0) {
      final newQty = _items[idx].quantity - 0.5;
      if (newQty <= 0) {
        removeItem(productId);
      } else {
        _items[idx] = _items[idx].copyWith(quantity: newQty);
        notifyListeners();
      }
    }
  }

  Future<String?> applyPromoCode(String code) async {
    final data = await _productRepo.validatePromoCode(code);
    if (data == null) return 'Invalid or expired promo code.';
    _promoCode = code.toUpperCase();
    _discountPercent = (data['discount'] as num).toDouble();
    notifyListeners();
    await _cartRepo.incrementPromoUsage(code);
    return null;
  }

  void removePromoCode() {
    _promoCode = null;
    _discountPercent = 0;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _promoCode = null;
    _discountPercent = 0;
    notifyListeners();
  }

  Future<void> syncToFirestore(String userId) async {
    _isSyncing = true;
    notifyListeners();
    try {
      await _cartRepo.syncCart(userId, _items);
    } catch (_) {}
    _isSyncing = false;
    notifyListeners();
  }

  Future<void> loadFromFirestore(String userId) async {
    try {
      final items = await _cartRepo.fetchCart(userId);
      _items.clear();
      _items.addAll(items);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> reorder(List<CartItemModel> items) async {
    for (final item in items) {
      final product = await _productRepo.getById(item.productId);
      if (product != null && product.isAvailable) {
        addItem(product, quantity: item.quantity);
      }
    }
  }

  bool containsProduct(String productId) =>
      _items.any((i) => i.productId == productId);

  double quantityOf(String productId) {
    final idx = _items.indexWhere((i) => i.productId == productId);
    return idx >= 0 ? _items[idx].quantity : 0;
  }
}
