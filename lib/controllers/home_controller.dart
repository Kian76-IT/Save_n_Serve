import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/food_item.dart';

class HomeController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _selectedCategory = 0;
  int get selectedCategory => _selectedCategory;

  List<FoodItem> _foodList = [];
  List<FoodItem> get foodList => _foodList;

  String _selectedRole = 'Beneficiary';
  String get selectedRole => _selectedRole;

  final List<String> categories = ['All', 'Heavy Meals', 'Beverages', 'Vegetables'];
  final List<String> categoryEmojis = [
    'assets/images/CategoryAll.png',
    'assets/images/CategoryHeavy.png',
    'assets/images/CategoryBeverages.png',
    'assets/images/CategoryVegetables.png',
  ];

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<void> fetchFoods() async {
    _isLoading = true;
    notifyListeners();

    String urlStr = '${ApiConstants.baseUrl}/foods/feed?limit=20';

    // Request GPS and append coordinates so backend can distance-sort
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
          ),
        ).timeout(const Duration(seconds: 5));
        urlStr += '&lat=${pos.latitude}&lng=${pos.longitude}';
      }
    } catch (_) {
      // Location unavailable — feed loads without distance sorting
    }

    try {
      final response = await http
          .get(Uri.parse(urlStr))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final foodsJson = (body is Map && body['foods'] is List)
            ? body['foods'] as List<dynamic>
            : <dynamic>[];
        _foodList = foodsJson
            .whereType<Map<String, dynamic>>()
            .map(FoodItem.fromApi)
            .toList();
      } else {
        _foodList = List.of(recommendedItems);
      }
    } catch (_) {
      _foodList = List.of(recommendedItems);
    }

    _foodList.sort((a, b) => a.distance.compareTo(b.distance));
    _isLoading = false;
    notifyListeners();
  }

  void changeCategory(int index) {
    _selectedCategory = index;
    notifyListeners();
  }

  List<FoodItem> getFilteredFoods() {
    if (_selectedCategory == 0) return _foodList;
    return _foodList
        .where((food) => food.category == categories[_selectedCategory])
        .toList();
  }
}

final homeController = HomeController();
