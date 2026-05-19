import 'package:flutter/material.dart';
import 'package:save_n_serve/models/food_item.dart';

class FoodController extends ChangeNotifier {
  List<FoodItem> watchlistFoods = [];

  bool isWatchlistEmpty() {
    return watchlistFoods.isEmpty;
  }

  int totalItems() {
    int total = 0;

    for (var food in watchlistFoods) {
      total += food.quantity;
    }

    return total;
  }

  void addToWatchlist(FoodItem food) {
    if (food.quantity == 0) {
      watchlistFoods.add(food);
    }

    food.quantity++;

    notifyListeners();
  }

  void removeFromWatchlist(FoodItem food) {
    if (food.quantity > 0) {
      food.quantity--;
    }

    if (food.quantity == 0) {
      watchlistFoods.remove(food);
    }

    notifyListeners();
  }
}

final foodController = FoodController();
