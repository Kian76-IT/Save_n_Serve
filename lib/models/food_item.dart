import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final String location;
  final String category; 
  final double rating;
  final double originalPrice;
  final double discountedPrice;
  final double distance;
  final Color imageColor;
  final String imagePath;

  const FoodItem({
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    required this.originalPrice,
    required this.discountedPrice,
    required this.distance,
    required this.imageColor,
    required this.imagePath,
  });
}


const List<FoodItem> recommendedItems = [
  FoodItem(
    name: 'Burger King',
    location: 'Tanah Abang Square',
    category: 'Heavy Meals',
    rating: 4.8,
    originalPrice: 3.99,
    discountedPrice: 1.67,
    distance: 0.5,
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
    imageColor: Color(0xFF81B29A),
    imagePath: 'assets/images/GambarProduk3.png',
  ),
];