import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:save_n_serve/models/food_item.dart';
import 'package:save_n_serve/constants/api_constants.dart';
import 'package:save_n_serve/services/session_service.dart';

class ClaimedItem {
  final String claimId;
  final FoodItem food;
  int remainingSeconds;
  int? rating;

  ClaimedItem({required this.claimId, required this.food, int? initialSeconds})
      : remainingSeconds = initialSeconds ?? 20 * 60;

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
  bool _isClaiming = false;
  bool get isClaiming => _isClaiming;
  bool _isLoadingClaims = false;

  // Returns true on success (or offline fallback).
  Future<bool> claimItem(FoodItem food) async {
    _isClaiming = true;
    notifyListeners();

    String claimId = '';
    try {
      final token = SessionService.token;

      // Only hit the API if we have a token and a real food_id
      if (token != null && food.foodId.isNotEmpty) {
        final url = Uri.parse('${ApiConstants.baseUrl}/claims/${food.foodId}');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode != 201) {
          _isClaiming = false;
          notifyListeners();
          String msg = 'Gagal mengklaim makanan';
          try {
            final body = jsonDecode(response.body);
            if (body is Map) msg = body['message']?.toString() ?? msg;
          } catch (_) {}
          throw Exception(msg);
        }

        try {
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          claimId =
              (body['claim'] as Map<String, dynamic>?)?['claim_id']?.toString() ??
              '';
        } catch (_) {}
      }

      onProcess.add(ClaimedItem(claimId: claimId, food: food));
      _ensureTimer();
    } catch (e) {
      // If food has no ID (dummy data), still add it locally so the demo flow works
      if (food.foodId.isEmpty) {
        onProcess.add(ClaimedItem(claimId: '', food: food));
        _ensureTimer();
      } else {
        _isClaiming = false;
        notifyListeners();
        rethrow;
      }
    }

    _isClaiming = false;
    notifyListeners();
    return true;
  }

  // Receiver confirms physical pickup. Calls backend, then moves item to Done.
  Future<bool> grabItem(ClaimedItem item) async {
    final token = SessionService.token;
    if (token != null && item.claimId.isNotEmpty) {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}/claims/${item.claimId}/grab',
      );
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        String msg = 'Gagal mengkonfirmasi pengambilan';
        try {
          final body = jsonDecode(response.body);
          if (body is Map) msg = body['message']?.toString() ?? msg;
        } catch (_) {}
        throw Exception(msg);
      }
    }
    complete(item);
    return true;
  }

  // Syncs pending claims from the server into onProcess.
  // Safe to call multiple times — guards against concurrent fetches and
  // deduplicates by claim_id so restarting the app never creates doubles.
  Future<void> loadClaims() async {
    if (_isLoadingClaims) return;
    _isLoadingClaims = true;
    try {
      final token = SessionService.token;
      if (token == null) return;

      final url = Uri.parse(
        '${ApiConstants.baseUrl}/claims/my?status=pending&limit=50',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) return;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final claims = (body['claims'] as List<dynamic>?) ?? [];

      final existingIds = onProcess.map((e) => e.claimId).toSet();
      bool added = false;

      for (final raw in claims) {
        final claimId = raw['claim_id']?.toString() ?? '';
        if (claimId.isEmpty || existingIds.contains(claimId)) continue;

        final foodJson = raw['foods'] as Map<String, dynamic>?;
        if (foodJson == null) continue;

        final food = FoodItem.fromApi(foodJson);

        // Calculate remaining seconds from expiry_date instead of defaulting
        // to 20 min — a restored claim may have less time left.
        int secs = 20 * 60;
        final expiryRaw = foodJson['expiry_date']?.toString();
        if (expiryRaw != null && expiryRaw.isNotEmpty) {
          try {
            final s = expiryRaw.trim();
            final hasZone = s.endsWith('Z') ||
                s.contains('+') ||
                (s.length > 19 && s[19] == '-');
            final utcStr = hasZone ? s : '${s}Z';
            final expiry = DateTime.parse(utcStr).toUtc();
            secs = expiry
                .difference(DateTime.now().toUtc())
                .inSeconds
                .clamp(0, 86400);
          } catch (_) {}
        }

        onProcess.add(
          ClaimedItem(claimId: claimId, food: food, initialSeconds: secs),
        );
        added = true;
      }

      if (added) _ensureTimer();
      // Always notify — even when nothing was added (dedup path) the
      // ListenableBuilder must get a signal so the UI redraws with whatever
      // is currently in onProcess.
      notifyListeners();
    } catch (e, st) {
      debugPrint('loadClaims error: $e\n$st');
    } finally {
      _isLoadingClaims = false;
    }
  }

  void complete(ClaimedItem item) {
    onProcess.remove(item);
    done.add(item);
    if (onProcess.isEmpty) _ticker?.cancel();
    notifyListeners();
  }

  Future<void> cancelItem(ClaimedItem item) async {
    final token = SessionService.token;
    if (token != null && item.claimId.isNotEmpty) {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}/claims/${item.claimId}/cancel',
      );
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        String msg = 'Gagal membatalkan klaim';
        try {
          final body = jsonDecode(response.body);
          if (body is Map) msg = body['message']?.toString() ?? msg;
        } catch (_) {}
        throw Exception(msg);
      }
    }
    onProcess.remove(item);
    if (onProcess.isEmpty) _ticker?.cancel();
    notifyListeners();
  }

  Future<void> rateItem(ClaimedItem item, int stars, String comment) async {
    final token = SessionService.token;
    if (token != null && item.claimId.isNotEmpty) {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}/claims/${item.claimId}/rate',
      );
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'rating': stars, 'comment': comment}),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        String msg = 'Gagal mengirim penilaian';
        try {
          final body = jsonDecode(response.body);
          if (body is Map) msg = body['message']?.toString() ?? msg;
        } catch (_) {}
        throw Exception(msg);
      }
    }
    item.rating = stars;
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
