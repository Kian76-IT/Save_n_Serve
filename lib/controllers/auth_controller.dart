import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:save_n_serve/constants/api_constants.dart';
import 'package:save_n_serve/services/session_service.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/auth/signup');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      _isLoading = false;
      notifyListeners();
      return response.statusCode == 201;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clears the local session and tells the backend to invalidate the token.
  Future<void> logoutUser() async {
    final token = SessionService.token;

    // Clear local state immediately so the UI never sees a stale session
    SessionService.clear();

    // Best-effort server-side invalidation (Supabase revokes the refresh token)
    if (token != null) {
      try {
        await http.post(
          Uri.parse('${ApiConstants.baseUrl}/auth/logout'),
          headers: {'Authorization': 'Bearer $token'},
        );
      } catch (_) {
        // Ignore — local session is already cleared
      }
    }
  }

  // Returns the full profile map from GET /auth/profile, null on failure.
  Future<Map<String, dynamic>?> fetchProfile() async {
    final token = SessionService.token;
    if (token == null) return null;
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/auth/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is Map<String, dynamic>) {
          final profile = body['profile'];
          return profile is Map<String, dynamic> ? profile : null;
        }
        return null;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // Returns the user's role on success, null on failure.
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/auth/signin');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is Map<String, dynamic>) {
          final user = body['user'];
          if (user is Map<String, dynamic>) {
            SessionService.save(
              token: body['access_token']?.toString() ?? '',
              userId: user['id']?.toString() ?? '',
              role: user['role']?.toString() ?? 'receiver',
              fullName: user['full_name']?.toString() ?? '',
              email: user['email']?.toString() ?? '',
            );
            return user['role']?.toString();
          }
        }
        return null;
      }
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
