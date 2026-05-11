import 'product_model.dart';

class CartItemModel {
  final String productId;
  final String name;
  final String imageUrl;
  final double pricePerKg;
  final String unit;
  final double quantity;

  const CartItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.pricePerKg,
    required this.unit,
    required this.quantity,
  });

  double get totalPrice => pricePerKg * quantity;

  factory CartItemModel.fromProduct(ProductModel p, {double quantity = 1}) =>
      CartItemModel(
        productId: p.id,
        name: p.name,
        imageUrl: p.imageUrl,
        pricePerKg: p.pricePerKg,
        unit: p.unit,
        quantity: quantity,
      );

  factory CartItemModel.fromMap(Map<String, dynamic> m) => CartItemModel(
        productId: m['productId'] ?? '',
        name: m['name'] ?? '',
        imageUrl: m['imageUrl'] ?? '',
        pricePerKg: (m['pricePerKg'] as num?)?.toDouble() ?? 0,
        unit: m['unit'] ?? 'kg',
        quantity: (m['quantity'] as num?)?.toDouble() ?? 1,
      );

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'name': name,
        'imageUrl': imageUrl,
        'pricePerKg': pricePerKg,
        'unit': unit,
        'quantity': quantity,
      };

  CartItemModel copyWith({double? quantity}) => CartItemModel(
        productId: productId,
        name: name,
        imageUrl: imageUrl,
        pricePerKg: pricePerKg,
        unit: unit,
        quantity: quantity ?? this.quantity,
      );
}
