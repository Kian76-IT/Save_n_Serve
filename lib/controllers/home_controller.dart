import 'package:flutter/material.dart';
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
    'assets/images/CategoryVegetables.png'
  ];

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<void> fetchFoods() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _foodList = List.of(recommendedItems);
    _foodList.sort((a, b) => a.distance.compareTo(b.distance));
    _isLoading = false;
    notifyListeners();
  }

  void sortFoodsByDistance() {
    _foodList.sort((a, b) => a.distance.compareTo(b.distance));
    notifyListeners();
  }

  void changeCategory(int index) {
    _selectedCategory = index;
    notifyListeners(); 
  }

  List<FoodItem> getFilteredFoods() {
    if (_selectedCategory == 0) return _foodList;
    return _foodList.where((food) => food.category == categories[_selectedCategory]).toList();
  }
}

final homeController = HomeController();