import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:save_n_serve/constants/api_constants.dart';
import 'package:save_n_serve/models/food_item.dart';
import 'package:save_n_serve/services/session_service.dart';

class GiverActivityController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<FoodItem> _myFoods = [];
  List<FoodItem> get myFoods => _myFoods;

  List<FoodItem> get activeFoods =>
      _myFoods.where((f) => f.status == 'available').toList();

  List<FoodItem> get doneFoods =>
      _myFoods.where((f) => f.status != 'available').toList();

  Future<void> fetchMyFoods() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = SessionService.token;
      if (token == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}/foods/my?limit=50'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is Map && body['foods'] is List) {
          _myFoods = (body['foods'] as List<dynamic>)
              .whereType<Map<String, dynamic>>()
              .map(FoodItem.fromApi)
              .toList();
        }
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  // Called by GiverController right after a successful POST so the list
  // updates instantly without waiting for a refresh.
  void prependFood(FoodItem food) {
    _myFoods = [food, ..._myFoods];
    notifyListeners();
  }

  Future<void> cancelFood(String foodId) async {
    final token = SessionService.token;
    if (token == null) throw Exception('Sesi tidak ditemukan');
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/foods/$foodId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      String msg = 'Gagal membatalkan donasi';
      try {
        final body = jsonDecode(response.body);
        if (body is Map) msg = body['message']?.toString() ?? msg;
      } catch (_) {}
      throw Exception(msg);
    }
    await fetchMyFoods();
  }
}

final giverActivityController = GiverActivityController();
