import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../services/session_service.dart';

class NotificationController extends ChangeNotifier {
  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  void setUnread(int count) {
    _unreadCount = count;
    notifyListeners();
  }

  Future<void> fetchUnreadCount() async {
    if (!SessionService.isLoggedIn) return;
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}/notifications?limit=1'),
            headers: {'Authorization': 'Bearer ${SessionService.token}'},
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _unreadCount = (body['unread_count'] as num?)?.toInt() ?? 0;
        notifyListeners();
      }
    } catch (_) {}
  }
}

final notificationController = NotificationController();
