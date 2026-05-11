import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedFirestore() async {
  final db = FirebaseFirestore.instance;

  final products = [
    // Vegetables
    {
      'name': 'Tomatoes',
      'category': 'Vegetables',
      'pricePerKg': 1200.0,
      'unit': 'kg',
      'description':
          'Farm-fresh tomatoes harvested at peak ripeness. Rich in lycopene and vitamin C. Perfect for salads, sauces, and cooking.',
      'imageUrl': 'https://source.unsplash.com/300x300/?tomatoes',
      'imageUrls': ['https://source.unsplash.com/300x300/?tomatoes'],
      'freshnessLevel': 'fresh',
      'rating': 4.7,
      'reviewCount': 124,
      'nutritionalInfo': {
        'calories': 18,
        'vitamins': 'C, K, B9',
        'fiber': '1.2g per 100g',
        'protein': '0.9g per 100g',
        'carbs': '3.9g per 100g',
      },
      'isAvailable': true,
      'isFeatured': true,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Carrots',
      'category': 'Vegetables',
      'pricePerKg': 800.0,
      'unit': 'kg',
      'description':
          'Crunchy, sweet carrots fresh from Musanze farms. High in beta-carotene and fiber. Great for juicing, salads, and stews.',
      'imageUrl': 'https://source.unsplash.com/300x300/?carrots',
      'imageUrls': ['https://source.unsplash.com/300x300/?carrots'],
      'freshnessLevel': 'fresh',
      'rating': 4.5,
      'reviewCount': 89,
      'nutritionalInfo': {
        'calories': 41,
        'vitamins': 'A, B6, K',
        'fiber': '2.8g per 100g',
        'protein': '0.9g per 100g',
        'carbs': '9.6g per 100g',
      },
      'isAvailable': true,
      'isFeatured': true,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Spinach',
      'category': 'Vegetables',
      'pricePerKg': 1000.0,
      'unit': 'kg',
      'description':
          'Tender, dark-green spinach leaves. Iron-rich and packed with vitamins. Ideal for salads, smoothies, and sautéed dishes.',
      'imageUrl': 'https://source.unsplash.com/300x300/?spinach',
      'imageUrls': ['https://source.unsplash.com/300x300/?spinach'],
      'freshnessLevel': 'fresh',
      'rating': 4.6,
      'reviewCount': 67,
      'nutritionalInfo': {
        'calories': 23,
        'vitamins': 'A, C, K, Iron',
        'fiber': '2.2g per 100g',
        'protein': '2.9g per 100g',
        'carbs': '3.6g per 100g',
      },
      'isAvailable': true,
      'isFeatured': false,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Onions',
      'category': 'Vegetables',
      'pricePerKg': 600.0,
      'unit': 'kg',
      'description':
          'Golden onions from Rwanda\'s Eastern Province. Essential kitchen staple with natural antibacterial properties.',
      'imageUrl': 'https://source.unsplash.com/300x300/?onions',
      'imageUrls': ['https://source.unsplash.com/300x300/?onions'],
      'freshnessLevel': 'good',
      'rating': 4.3,
      'reviewCount': 45,
      'nutritionalInfo': {
        'calories': 40,
        'vitamins': 'C, B6, Folate',
        'fiber': '1.7g per 100g',
        'protein': '1.1g per 100g',
        'carbs': '9.3g per 100g',
      },
      'isAvailable': true,
      'isFeatured': false,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Bell Peppers',
      'category': 'Vegetables',
      'pricePerKg': 2000.0,
      'unit': 'kg',
      'description':
          'Vibrant mixed bell peppers — red, yellow, and green. Sweet, crunchy, and loaded with vitamin C. Perfect for stir-fries and salads.',
      'imageUrl': 'https://source.unsplash.com/300x300/?bell+peppers',
      'imageUrls': ['https://source.unsplash.com/300x300/?bell+peppers'],
      'freshnessLevel': 'fresh',
      'rating': 4.8,
      'reviewCount': 103,
      'nutritionalInfo': {
        'calories': 31,
        'vitamins': 'A, C, B6',
        'fiber': '2.1g per 100g',
        'protein': '1.0g per 100g',
        'carbs': '6.0g per 100g',
      },
      'isAvailable': true,
      'isFeatured': true,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Broccoli',
      'category': 'Vegetables',
      'pricePerKg': 2500.0,
      'unit': 'kg',
      'description':
          'Premium broccoli crowns, a nutritional powerhouse. Rich in sulforaphane, vitamins C and K. Great steamed, roasted, or raw.',
      'imageUrl': 'https://source.unsplash.com/300x300/?broccoli',
      'imageUrls': ['https://source.unsplash.com/300x300/?broccoli'],
      'freshnessLevel': 'fresh',
      'rating': 4.4,
      'reviewCount': 58,
      'nutritionalInfo': {
        'calories': 34,
        'vitamins': 'C, K, B9',
        'fiber': '2.6g per 100g',
        'protein': '2.8g per 100g',
        'carbs': '6.6g per 100g',
      },
      'isAvailable': true,
      'isFeatured': true,
      'createdAt': FieldValue.serverTimestamp(),
    },
    // Fruits
    {
      'name': 'Mangoes',
      'category': 'Fruits',
      'pricePerKg': 1500.0,
      'unit': 'kg',
      'description':
          'Sweet Rwandan mangoes at peak ripeness. Tropical flavor with smooth, fiber-free flesh. A natural energy booster.',
      'imageUrl': 'https://source.unsplash.com/300x300/?mangoes',
      'imageUrls': ['https://source.unsplash.com/300x300/?mangoes'],
      'freshnessLevel': 'fresh',
      'rating': 4.9,
      'reviewCount': 215,
      'nutritionalInfo': {
        'calories': 60,
        'vitamins': 'A, C, E, B6',
        'fiber': '1.6g per 100g',
        'protein': '0.8g per 100g',
        'carbs': '15g per 100g',
      },
      'isAvailable': true,
      'isFeatured': true,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Bananas',
      'category': 'Fruits',
      'pricePerKg': 500.0,
      'unit': 'kg',
      'description':
          'Local Rwandan bananas — naturally sweet and creamy. Great source of potassium and instant energy. Perfect for breakfast.',
      'imageUrl': 'https://source.unsplash.com/300x300/?bananas',
      'imageUrls': ['https://source.unsplash.com/300x300/?bananas'],
      'freshnessLevel': 'fresh',
      'rating': 4.6,
      'reviewCount': 178,
      'nutritionalInfo': {
        'calories': 89,
        'vitamins': 'B6, C, Potassium',
        'fiber': '2.6g per 100g',
        'protein': '1.1g per 100g',
        'carbs': '23g per 100g',
      },
      'isAvailable': true,
      'isFeatured': false,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Avocados',
      'category': 'Fruits',
      'pricePerKg': 3000.0,
      'unit': 'kg',
      'description':
          'Creamy Hass avocados from Southern Rwanda. Rich in healthy monounsaturated fats and potassium. Ready to eat.',
      'imageUrl': 'https://source.unsplash.com/300x300/?avocado',
      'imageUrls': ['https://source.unsplash.com/300x300/?avocado'],
      'freshnessLevel': 'fresh',
      'rating': 4.8,
      'reviewCount': 143,
      'nutritionalInfo': {
        'calories': 160,
        'vitamins': 'K, E, C, B5, B6',
        'fiber': '6.7g per 100g',
        'protein': '2.0g per 100g',
        'carbs': '9.0g per 100g',
      },
      'isAvailable': true,
      'isFeatured': true,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Pineapple',
      'category': 'Fruits',
      'pricePerKg': 1000.0,
      'unit': 'kg',
      'description':
          'Juicy tropical pineapples. Contains bromelain which aids digestion. Tangy-sweet flavor, perfect for smoothies and desserts.',
      'imageUrl': 'https://source.unsplash.com/300x300/?pineapple',
      'imageUrls': ['https://source.unsplash.com/300x300/?pineapple'],
      'freshnessLevel': 'good',
      'rating': 4.5,
      'reviewCount': 92,
      'nutritionalInfo': {
        'calories': 50,
        'vitamins': 'C, B6, Manganese',
        'fiber': '1.4g per 100g',
        'protein': '0.5g per 100g',
        'carbs': '13g per 100g',
      },
      'isAvailable': true,
      'isFeatured': false,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Strawberries',
      'category': 'Fruits',
      'pricePerKg': 5000.0,
      'unit': 'kg',
      'description':
          'Premium strawberries from highland farms. Exceptionally sweet with intense aroma. Rich in vitamin C and antioxidants.',
      'imageUrl': 'https://source.unsplash.com/300x300/?strawberries',
      'imageUrls': ['https://source.unsplash.com/300x300/?strawberries'],
      'freshnessLevel': 'fresh',
      'rating': 4.9,
      'reviewCount': 197,
      'nutritionalInfo': {
        'calories': 32,
        'vitamins': 'C, Folate, Potassium',
        'fiber': '2.0g per 100g',
        'protein': '0.7g per 100g',
        'carbs': '7.7g per 100g',
      },
      'isAvailable': true,
      'isFeatured': true,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'Oranges',
      'category': 'Fruits',
      'pricePerKg': 900.0,
      'unit': 'kg',
      'description':
          'Seedless navel oranges bursting with juice. High in vitamin C and flavonoids. Great for juicing or eating fresh.',
      'imageUrl': 'https://source.unsplash.com/300x300/?oranges',
      'imageUrls': ['https://source.unsplash.com/300x300/?oranges'],
      'freshnessLevel': 'fresh',
      'rating': 4.7,
      'reviewCount': 134,
      'nutritionalInfo': {
        'calories': 47,
        'vitamins': 'C, B1, Folate',
        'fiber': '2.4g per 100g',
        'protein': '0.9g per 100g',
        'carbs': '11.8g per 100g',
      },
      'isAvailable': true,
      'isFeatured': false,
      'createdAt': FieldValue.serverTimestamp(),
    },
  ];

  // Seed products
  final batch = db.batch();
  for (final p in products) {
    final ref = db.collection('products').doc();
    batch.set(ref, p);
  }

  // Seed promo codes
  const promoCodes = {
    'FRESH10': {
      'discount': 10,
      'maxUses': 1000,
      'currentUses': 0,
      'isActive': true,
      'expiresAt': null,
    },
    'BASKET20': {
      'discount': 20,
      'maxUses': 500,
      'currentUses': 0,
      'isActive': true,
      'expiresAt': null,
    },
    'NEWUSER15': {
      'discount': 15,
      'maxUses': 200,
      'currentUses': 0,
      'isActive': true,
      'expiresAt': null,
    },
  };

  for (final entry in promoCodes.entries) {
    batch.set(db.collection('promo_codes').doc(entry.key), entry.value);
  }

  await batch.commit();
}
