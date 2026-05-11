import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../services/firebase_service.dart';
import '../services/email_service.dart';
import '../services/notification_service.dart';

class OrderRepository {
  Future<OrderModel> createOrder(OrderModel order) async {
    final ref = FirebaseService.orders.doc();
    final newOrder = OrderModel(
      id: ref.id,
      userId: order.userId,
      items: order.items,
      subtotal: order.subtotal,
      deliveryFee: order.deliveryFee,
      total: order.total,
      promoCode: order.promoCode,
      discount: order.discount,
      address: order.address,
      timeSlot: order.timeSlot,
      paymentMethod: order.paymentMethod,
      paymentReference: order.paymentReference,
      status: OrderStatus.placed,
      estimatedDelivery:
          DateTime.now().add(const Duration(hours: 3)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.set(newOrder.toMap());

    // Notify user
    final userDoc = await FirebaseService.users.doc(order.userId).get();
    final fcmToken = userDoc.data()?['fcmToken'] as String?;
    final email = userDoc.data()?['email'] as String?;
    final name = userDoc.data()?['name'] as String?;

    if (fcmToken != null) {
      NotificationService().sendOrderNotification(
        token: fcmToken,
        type: 'ORDER_PLACED',
        orderId: ref.id,
        userId: order.userId,
      );
    }

    if (email != null) {
      EmailService().sendOrderConfirmationEmail(
        email: email,
        name: name ?? '',
        order: newOrder,
      );
    }

    return newOrder;
  }

  Stream<OrderModel> watchOrder(String orderId) =>
      FirebaseService.orders.doc(orderId).snapshots().map((doc) {
        if (!doc.exists) throw Exception('Order not found');
        return OrderModel.fromDoc(doc);
      });

  Stream<List<OrderModel>> watchUserOrders(String userId) =>
      FirebaseService.orders
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(OrderModel.fromDoc).toList());

  Future<List<OrderModel>> getUserOrders(String userId) async {
    final snap = await FirebaseService.orders
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map(OrderModel.fromDoc).toList();
  }

  Future<OrderModel?> getOrder(String orderId) async {
    final doc = await FirebaseService.orders.doc(orderId).get();
    if (!doc.exists) return null;
    return OrderModel.fromDoc(doc);
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    await FirebaseService.orders.doc(orderId).update({
      'status': status.value,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}
