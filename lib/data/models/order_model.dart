import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item_model.dart';
import 'user_model.dart';

enum OrderStatus { placed, preparing, dispatched, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.placed:
        return 'placed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.dispatched:
        return 'dispatched';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.dispatched:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get step {
    switch (this) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.dispatched:
        return 2;
      case OrderStatus.delivered:
        return 3;
      case OrderStatus.cancelled:
        return -1;
    }
  }

  static OrderStatus fromString(String s) {
    switch (s) {
      case 'preparing':
        return OrderStatus.preparing;
      case 'dispatched':
        return OrderStatus.dispatched;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.placed;
    }
  }
}

class DriverLocation {
  final double latitude;
  final double longitude;

  const DriverLocation({required this.latitude, required this.longitude});

  factory DriverLocation.fromMap(Map<String, dynamic> m) => DriverLocation(
        latitude: (m['lat'] as num?)?.toDouble() ?? 0,
        longitude: (m['lng'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toMap() => {'lat': latitude, 'lng': longitude};
}

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? promoCode;
  final double discount;
  final UserAddress address;
  final String timeSlot;
  final String paymentMethod;
  final String paymentReference;
  final OrderStatus status;
  final DriverLocation? driverLocation;
  final DateTime? estimatedDelivery;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.promoCode,
    this.discount = 0,
    required this.address,
    required this.timeSlot,
    required this.paymentMethod,
    required this.paymentReference,
    required this.status,
    this.driverLocation,
    this.estimatedDelivery,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayId => '#${id.substring(0, 8).toUpperCase()}';

  CartItemModel get firstItem => items.first;

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: m['userId'] ?? '',
      items: (m['items'] as List<dynamic>? ?? [])
          .map((i) => CartItemModel.fromMap(i as Map<String, dynamic>))
          .toList(),
      subtotal: (m['subtotal'] as num?)?.toDouble() ?? 0,
      deliveryFee: (m['deliveryFee'] as num?)?.toDouble() ?? 0,
      total: (m['total'] as num?)?.toDouble() ?? 0,
      promoCode: m['promoCode'],
      discount: (m['discount'] as num?)?.toDouble() ?? 0,
      address: UserAddress.fromMap(m['address'] as Map<String, dynamic>? ?? {}),
      timeSlot: m['timeSlot'] ?? '',
      paymentMethod: m['paymentMethod'] ?? '',
      paymentReference: m['paymentReference'] ?? '',
      status: OrderStatusX.fromString(m['status'] ?? 'placed'),
      driverLocation: m['driverLocation'] != null
          ? DriverLocation.fromMap(m['driverLocation'])
          : null,
      estimatedDelivery: (m['estimatedDelivery'] as Timestamp?)?.toDate(),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (m['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'items': items.map((i) => i.toMap()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'total': total,
        'promoCode': promoCode,
        'discount': discount,
        'address': address.toMap(),
        'timeSlot': timeSlot,
        'paymentMethod': paymentMethod,
        'paymentReference': paymentReference,
        'status': status.value,
        'driverLocation': driverLocation?.toMap(),
        'estimatedDelivery': estimatedDelivery != null
            ? Timestamp.fromDate(estimatedDelivery!)
            : null,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  OrderModel copyWith({OrderStatus? status, DriverLocation? driverLocation}) =>
      OrderModel(
        id: id,
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
        status: status ?? this.status,
        driverLocation: driverLocation ?? this.driverLocation,
        estimatedDelivery: estimatedDelivery,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}
