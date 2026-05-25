import 'package:flutter/material.dart';

class FoodItem {
  final String foodId;
  final String name;
  final String location;
  final String category;
  final double rating;
  final double originalPrice;
  final double discountedPrice;
  final double distance;
  final String duration;
  final Color imageColor;
  final String imagePath;
  final String? description;
  final int totalQuantity;
  final String? giverName;
  final String? giverId;
  final String? expiryDate;
  final DateTime? pickupStart;
  final String? imageUrl;
  final String? status;
  final String? portionUnit;
  final double? pickupLat;
  final double? pickupLng;

  int quantity;

  /// Splits the stored `image_url` comma-separated string into a clean list.
  List<String> get imageUrls => _parseImageUrls(imageUrl);

  static List<String> _parseImageUrls(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  FoodItem({
    this.foodId = '',
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    required this.originalPrice,
    required this.discountedPrice,
    required this.distance,
    required this.duration,
    required this.imageColor,
    required this.imagePath,
    this.description,
    this.totalQuantity = 1,
    this.giverName,
    this.giverId,
    this.expiryDate,
    this.pickupStart,
    this.imageUrl,
    this.status,
    this.portionUnit,
    this.pickupLat,
    this.pickupLng,
    this.quantity = 0,
  });

  /// PostgREST can return timestamptz columns as naive ISO strings such as
  /// "2026-05-22T16:55:00" (no 'Z', no '+HH:MM').  Dart's DateTime.parse()
  /// treats a string without a timezone marker as **local** time, which on a
  /// WIB device (UTC+7) produces a 7-hour error.  This helper appends 'Z' to
  /// force UTC interpretation when no zone marker is present.
  static String? _toUtcString(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().trim();
    if (s.isEmpty) return null;
    final hasZone = s.endsWith('Z') ||
        s.contains('+') ||
        (s.length > 19 && s[19] == '-');
    return hasZone ? s : '${s}Z';
  }

  factory FoodItem.fromApi(Map<String, dynamic> json) {
    print('📦 RAW JSON RECEIVED: $json');
    print('🔍 DEBUG MODEL: Parsed giverId = ${json['giver_id']}, profiles = ${json['profiles']}');
    try {
      final name = json['name']?.toString() ?? 'Unknown';
      // Normalize timestamps before parsing — see _toUtcString().
      final expiryRaw     = _toUtcString(json['expiry_date']);
      final pickupStartRaw = _toUtcString(json['pickup_start']);
      return FoodItem(
        foodId: json['id']?.toString() ?? '',
        name: name,
        location: json['pickup_location']?.toString() ?? 'Lokasi tidak tersedia',
        category: _inferCategory(name),
        rating: 4.5,
        originalPrice: 0,
        discountedPrice: 0,
        distance: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
        duration: '20 mins',
        imageColor: const Color(0xFF4CAF50),
        imagePath: 'assets/images/GambarProduk1.png',
        description: json['description']?.toString(),
        totalQuantity: (json['quantity'] as num?)?.toInt() ?? 1,
        giverName: (json['profiles'] as Map<String, dynamic>?)?['full_name']?.toString(),
        // Primary: giver_id is the FK column, always present when foods table
        // is queried with * or explicitly listed (getFoodFeed, getMyClaims after fix).
        // Fallback: profiles.id from the join — same UUID, used when giver_id
        // was omitted from an older explicit-field select.
        giverId: json['giver_id']?.toString() ??
            (json['profiles'] as Map<String, dynamic>?)?['id']?.toString(),
        expiryDate: expiryRaw,
        pickupStart: pickupStartRaw != null
            ? DateTime.tryParse(pickupStartRaw)?.toLocal()
            : null,
        imageUrl: json['image_url']?.toString(),
        status: json['status']?.toString(),
        portionUnit: json['portion_unit']?.toString(),
        pickupLat: (json['pickup_lat'] as num?)?.toDouble(),
        pickupLng: (json['pickup_lng'] as num?)?.toDouble(),
      );
    } catch (e, stack) {
      print('🚨 CRITICAL FOOD PARSING ERROR: $e');
      print(stack);
      return FoodItem.fallback();
    }
  }

  factory FoodItem.fallback() {
    return FoodItem(
      foodId: '',
      name: 'Unknown Item',
      location: 'Lokasi tidak tersedia',
      category: 'Heavy Meals',
      rating: 0,
      originalPrice: 0,
      discountedPrice: 0,
      distance: 0,
      duration: '-',
      imageColor: const Color(0xFF4CAF50),
      imagePath: 'assets/images/GambarProduk1.png',
    );
  }

  static String _inferCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('jus') ||
        lower.contains('minum') ||
        lower.contains('teh') ||
        lower.contains('kopi') ||
        lower.contains('drink') ||
        lower.contains('beverage')) {
      return 'Beverages';
    }
    if (lower.contains('sayur') ||
        lower.contains('salad') ||
        lower.contains('vege') ||
        lower.contains('buah')) {
      return 'Vegetables';
    }
    return 'Heavy Meals';
  }
}

List<FoodItem> recommendedItems = [
  FoodItem(
    name: 'Burger King',
    location: 'Tanah Abang Square',
    category: 'Heavy Meals',
    rating: 4.8,
    originalPrice: 3.99,
    discountedPrice: 1.67,
    distance: 0.5,
    duration: '15 mins',
    imageColor: Color(0xFFD4A373),
    imagePath: 'assets/images/GambarProduk1.png',
  ),
  FoodItem(
    name: 'Sushi Rolls',
    location: 'Grand Indonesia',
    category: 'Heavy Meals',
    rating: 4.9,
    originalPrice: 5.50,
    discountedPrice: 2.20,
    distance: 1.2,
    duration: '15 mins',
    imageColor: Color(0xFFE07A5F),
    imagePath: 'assets/images/GambarProduk2.png',
  ),
  FoodItem(
    name: 'Fresh Beverages',
    location: 'SCBD Food Court',
    category: 'Beverages',
    rating: 4.7,
    originalPrice: 2.50,
    discountedPrice: 1.00,
    distance: 0.8,
    duration: '15 mins',
    imageColor: Color(0xFF81B29A),
    imagePath: 'assets/images/GambarProduk3.png',
  ),
  FoodItem(
    name: 'Fresh Salad',
    location: 'Kemang Village',
    category: 'Vegetables',
    rating: 4.6,
    originalPrice: 2.00,
    discountedPrice: 0.80,
    distance: 1.5,
    duration: '20 mins',
    imageColor: Color(0xFF8BC34A),
    imagePath: 'assets/images/GambarProduk4.png',
  ),
];
