import 'package:cloud_firestore/cloud_firestore.dart';

enum FreshnessLevel { fresh, good, limited }

extension FreshnessLevelX on FreshnessLevel {
  String get label {
    switch (this) {
      case FreshnessLevel.fresh:
        return 'Fresh';
      case FreshnessLevel.good:
        return 'Good';
      case FreshnessLevel.limited:
        return 'Limited';
    }
  }

  String get value {
    switch (this) {
      case FreshnessLevel.fresh:
        return 'fresh';
      case FreshnessLevel.good:
        return 'good';
      case FreshnessLevel.limited:
        return 'limited';
    }
  }

  static FreshnessLevel fromString(String s) {
    switch (s) {
      case 'good':
        return FreshnessLevel.good;
      case 'limited':
        return FreshnessLevel.limited;
      default:
        return FreshnessLevel.fresh;
    }
  }
}

class NutritionalInfo {
  final int calories;
  final String vitamins;
  final String fiber;
  final String protein;
  final String carbs;

  const NutritionalInfo({
    required this.calories,
    required this.vitamins,
    required this.fiber,
    required this.protein,
    required this.carbs,
  });

  factory NutritionalInfo.fromMap(Map<String, dynamic> m) => NutritionalInfo(
        calories: (m['calories'] as num?)?.toInt() ?? 0,
        vitamins: m['vitamins'] ?? '',
        fiber: m['fiber'] ?? '',
        protein: m['protein'] ?? '',
        carbs: m['carbs'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'calories': calories,
        'vitamins': vitamins,
        'fiber': fiber,
        'protein': protein,
        'carbs': carbs,
      };
}

class ProductModel {
  final String id;
  final String name;
  final String category;
  final double pricePerKg;
  final String unit;
  final String description;
  final String imageUrl;
  final List<String> imageUrls;
  final FreshnessLevel freshnessLevel;
  final double rating;
  final int reviewCount;
  final NutritionalInfo? nutritionalInfo;
  final bool isAvailable;
  final bool isFeatured;
  final DateTime? createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerKg,
    required this.unit,
    required this.description,
    required this.imageUrl,
    this.imageUrls = const [],
    required this.freshnessLevel,
    required this.rating,
    required this.reviewCount,
    this.nutritionalInfo,
    this.isAvailable = true,
    this.isFeatured = false,
    this.createdAt,
  });

  factory ProductModel.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: m['name'] ?? '',
      category: m['category'] ?? '',
      pricePerKg: (m['pricePerKg'] as num?)?.toDouble() ?? 0,
      unit: m['unit'] ?? 'kg',
      description: m['description'] ?? '',
      imageUrl: m['imageUrl'] ?? '',
      imageUrls: List<String>.from(m['imageUrls'] ?? []),
      freshnessLevel: FreshnessLevelX.fromString(m['freshnessLevel'] ?? 'fresh'),
      rating: (m['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (m['reviewCount'] as num?)?.toInt() ?? 0,
      nutritionalInfo: m['nutritionalInfo'] != null
          ? NutritionalInfo.fromMap(m['nutritionalInfo'])
          : null,
      isAvailable: m['isAvailable'] ?? true,
      isFeatured: m['isFeatured'] ?? false,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'category': category,
        'pricePerKg': pricePerKg,
        'unit': unit,
        'description': description,
        'imageUrl': imageUrl,
        'imageUrls': imageUrls,
        'freshnessLevel': freshnessLevel.value,
        'rating': rating,
        'reviewCount': reviewCount,
        'nutritionalInfo': nutritionalInfo?.toMap(),
        'isAvailable': isAvailable,
        'isFeatured': isFeatured,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      };
}
