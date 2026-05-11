import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/order_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/order_repository.dart';

class OrderProvider extends ChangeNotifier {
  final _repo = OrderRepository();

  List<OrderModel> _orders = [];
  OrderModel? _activeOrder;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<OrderModel>>? _ordersSub;
  StreamSubscription<OrderModel>? _trackingSub;

  List<OrderModel> get orders => _orders;
  OrderModel? get activeOrder => _activeOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void watchUserOrders(String userId) {
    _ordersSub?.cancel();
    _ordersSub = _repo.watchUserOrders(userId).listen(
      (orders) {
        _orders = orders;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load orders.';
        notifyListeners();
      },
    );
  }

  void watchOrder(String orderId) {
    _trackingSub?.cancel();
    _trackingSub = _repo.watchOrder(orderId).listen(
      (order) {
        _activeOrder = order;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load order tracking.';
        notifyListeners();
      },
    );
  }

  void stopTracking() {
    _trackingSub?.cancel();
    _trackingSub = null;
    _activeOrder = null;
  }

  Future<OrderModel?> placeOrder({
    required String userId,
    required List<CartItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String? promoCode,
    required double discount,
    required UserAddress address,
    required String timeSlot,
    required String paymentMethod,
    required String paymentReference,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final order = await _repo.createOrder(
        OrderModel(
          id: '',
          userId: userId,
          items: items,
          subtotal: subtotal,
          deliveryFee: deliveryFee,
          total: total,
          promoCode: promoCode,
          discount: discount,
          address: address,
          timeSlot: timeSlot,
          paymentMethod: paymentMethod,
          paymentReference: paymentReference,
          status: OrderStatus.placed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      _isLoading = false;
      notifyListeners();
      return order;
    } catch (e) {
      _error = 'Failed to place order. Please try again.';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<OrderModel?> getOrder(String orderId) => _repo.getOrder(orderId);

  @override
  void dispose() {
    _ordersSub?.cancel();
    _trackingSub?.cancel();
    super.dispose();
  }
}
