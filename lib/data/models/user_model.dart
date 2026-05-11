import 'package:cloud_firestore/cloud_firestore.dart';

class UserAddress {
  final String id;
  final String label;
  final String street;
  final String sector;
  final String district;
  final String city;
  final double? latitude;
  final double? longitude;

  const UserAddress({
    required this.id,
    required this.label,
    required this.street,
    required this.sector,
    required this.district,
    required this.city,
    this.latitude,
    this.longitude,
  });

  factory UserAddress.fromMap(Map<String, dynamic> m) => UserAddress(
        id: m['id'] ?? '',
        label: m['label'] ?? 'Home',
        street: m['street'] ?? '',
        sector: m['sector'] ?? '',
        district: m['district'] ?? '',
        city: m['city'] ?? '',
        latitude: (m['latitude'] as num?)?.toDouble(),
        longitude: (m['longitude'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'label': label,
        'street': street,
        'sector': sector,
        'district': district,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
      };

  String get fullAddress => '$street, $sector, $district, $city';
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final String? fcmToken;
  final List<UserAddress> addresses;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    this.fcmToken,
    this.addresses = const [],
    required this.createdAt,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: m['name'] ?? '',
      email: m['email'] ?? '',
      phone: m['phone'] ?? '',
      photoUrl: m['photoUrl'],
      fcmToken: m['fcmToken'],
      addresses: (m['addresses'] as List<dynamic>? ?? [])
          .map((a) => UserAddress.fromMap(a as Map<String, dynamic>))
          .toList(),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl,
        'fcmToken': fcmToken,
        'addresses': addresses.map((a) => a.toMap()).toList(),
        'createdAt': Timestamp.fromDate(createdAt),
      };

  UserModel copyWith({
    String? name,
    String? phone,
    String? photoUrl,
    String? fcmToken,
    List<UserAddress>? addresses,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email,
        phone: phone ?? this.phone,
        photoUrl: photoUrl ?? this.photoUrl,
        fcmToken: fcmToken ?? this.fcmToken,
        addresses: addresses ?? this.addresses,
        createdAt: createdAt,
      );
}
