import 'dart:async';
import 'package:flutter/material.dart';
import 'package:save_n_serve/models/food_item.dart';

class ClaimedItem {
  final FoodItem food;
  int remainingSeconds;

  ClaimedItem({required this.food}) : remainingSeconds = 20 * 60;

  String get timerText {
    final m = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class ClaimController extends ChangeNotifier {
  final List<ClaimedItem> onProcess = [];
  final List<ClaimedItem> done = [];

  Timer? _ticker;

  void claimItem(FoodItem food) {
    onProcess.add(ClaimedItem(food: food));
    _ensureTimer();
    notifyListeners();
  }

  void complete(ClaimedItem item) {
    onProcess.remove(item);
    done.add(item);
    if (onProcess.isEmpty) _ticker?.cancel();
    notifyListeners();
  }

  void _ensureTimer() {
    if (_ticker?.isActive ?? false) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      bool changed = false;
      for (final item in onProcess) {
        if (item.remainingSeconds > 0) {
          item.remainingSeconds--;
          changed = true;
        }
      }
      if (changed) notifyListeners();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final claimController = ClaimController();
