import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:save_n_serve/constants/api_constants.dart';
import 'package:save_n_serve/controllers/giver_activity_controller.dart';
import 'package:save_n_serve/models/food_item.dart';
import 'package:save_n_serve/services/session_service.dart';

class GiverController extends ChangeNotifier {
  final titleController       = TextEditingController();
  final descriptionController = TextEditingController();
  final instructionController = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  TimeOfDay? get startTime => _startTime;
  TimeOfDay? get endTime   => _endTime;

  final List<int> quantities = [1, 2, 3, 4, 5];
  int _selectedQuantity = 1;
  int get selectedQuantity => _selectedQuantity;

  final _picker = ImagePicker();
  List<XFile> _pickedImages = [];
  List<XFile> get pickedImages => List.unmodifiable(_pickedImages);

  Future<void> pickImages() async {
    final remaining = 10 - _pickedImages.length;
    if (remaining <= 0) return;
    final picked = await _picker.pickMultiImage(
      limit: remaining,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (picked.isNotEmpty) {
      _pickedImages = [..._pickedImages, ...picked];
      notifyListeners();
    }
  }

  void removeImage(int index) {
    final updated = List<XFile>.of(_pickedImages);
    updated.removeAt(index);
    _pickedImages = updated;
    // Reset AI result when the first image (the one that was checked) is removed
    if (index == 0) _aiStatus = null;
    notifyListeners();
  }

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  // null = belum dicek, "fresh", "rotten", "unknown" (error/timeout)
  String? _aiStatus;
  String? get aiStatus => _aiStatus;

  bool _isCheckingAi = false;
  bool get isCheckingAi => _isCheckingAi;

  void setStartTime(TimeOfDay t) {
    _startTime = t;
    notifyListeners();
  }

  void setEndTime(TimeOfDay t) {
    _endTime = t;
    notifyListeners();
  }

  String get pickupTimeDisplay {
    if (_startTime == null || _endTime == null) return '-';
    final s = '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
    final e = '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';
    return '$s - $e';
  }

  void selectQuantity(int qty) {
    _selectedQuantity = qty;
    notifyListeners();
  }

  bool isTimeReversed() {
    if (_startTime == null || _endTime == null) return false;
    final startMin = _startTime!.hour * 60 + _startTime!.minute;
    final endMin   = _endTime!.hour   * 60 + _endTime!.minute;
    return endMin <= startMin;
  }

  bool validate() {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      return false;
    }
    if (_startTime == null || _endTime == null) return false;
    return !isTimeReversed();
  }

  String? getToken() => SessionService.token;

  // Runs AI freshness check on the first picked image and stores the result
  // in [aiStatus]. Called automatically after the user picks photos.
  Future<void> runAiCheck() async {
    if (_pickedImages.isEmpty) return;
    final token = SessionService.token;
    if (token == null) return;

    _isCheckingAi = true;
    _aiStatus = null;
    notifyListeners();

    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/ai/check');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('image', _pickedImages.first.path,
            filename: _pickedImages.first.name),
      );
      final streamed = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final status = body['status'] as String?;
        _aiStatus = (status == 'fresh' || status == 'rotten') ? status : 'unknown';
      } else {
        _aiStatus = 'unknown';
      }
    } catch (_) {
      _aiStatus = 'unknown';
    }

    _isCheckingAi = false;
    notifyListeners();
  }

  // Legacy method kept for backwards compatibility — delegates to runAiCheck.
  Future<String?> checkFirstImageFreshness(String token) async {
    await runAiCheck();
    return _aiStatus;
  }

  // Uploads picked images to the backend, returns a comma-separated URL string.
  // Returns empty string if there are no images or the upload fails.
  Future<String> _uploadImages(String token) async {
    if (_pickedImages.isEmpty) return '';
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/uploads');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token';

      for (final img in _pickedImages) {
        request.files.add(
          await http.MultipartFile.fromPath('images', img.path,
              filename: img.name),
        );
      }

      final streamed = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is Map && body['urls'] is List) {
          return (body['urls'] as List).map((e) => e.toString()).join(',');
        }
      }
    } catch (_) {}
    return '';
  }

  // Returns null on success, or an error string to display in the UI.
  Future<String?> submitDonation() async {
    if (!validate()) return 'Validasi gagal. Periksa kembali isian form.';

    _isSubmitting = true;
    notifyListeners();

    try {
      final token = SessionService.token;
      if (token == null) {
        _isSubmitting = false;
        notifyListeners();
        return 'Sesi tidak ditemukan. Silakan login ulang.';
      }

      // Upload images first; proceed even if upload returns empty.
      final imageUrlString = await _uploadImages(token);

      // Build the pickup window from today's date + the chosen times.
      // If the end time has already passed today, advance both start AND end
      // by one day so the window stays coherent (same relative gap).
      final now = DateTime.now();
      DateTime pickupStart = DateTime(
        now.year, now.month, now.day,
        _startTime!.hour, _startTime!.minute,
      );
      DateTime expiry = DateTime(
        now.year, now.month, now.day,
        _endTime!.hour, _endTime!.minute,
      );
      if (!expiry.isAfter(now)) {
        pickupStart = pickupStart.add(const Duration(days: 1));
        expiry = expiry.add(const Duration(days: 1));
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/foods');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'quantity': _selectedQuantity,
          'portion_unit': 'porsi',
          'status': 'available',
          'pickup_location': instructionController.text.trim().isNotEmpty
              ? instructionController.text.trim()
              : 'Lokasi belum disetel',
          // .toUtc().toIso8601String() appends 'Z', giving Supabase an
          // unambiguous UTC timestamp ("2026-05-22T16:55:00.000Z").
          // This is intentional — never send a naive local string.
          'pickup_start': pickupStart.toUtc().toIso8601String(),
          'expiry_date': expiry.toUtc().toIso8601String(),
          if (imageUrlString.isNotEmpty) 'image_url': imageUrlString,
        }),
      );

      _isSubmitting = false;
      notifyListeners();

      if (response.statusCode == 201) {
        try {
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          final foodJson = body['food'] as Map<String, dynamic>?;
          if (foodJson != null) {
            giverActivityController.prependFood(FoodItem.fromApi(foodJson));
          }
        } catch (_) {}
        reset();
        return null;
      }

      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return body['message'] as String? ?? 'Server error (${response.statusCode})';
      } catch (_) {
        return 'Server error (${response.statusCode})';
      }
    } catch (e) {
      _isSubmitting = false;
      notifyListeners();
      return 'Koneksi gagal: $e';
    }
  }

  void reset() {
    titleController.clear();
    descriptionController.clear();
    instructionController.clear();
    _startTime = null;
    _endTime   = null;
    _selectedQuantity = 1;
    _pickedImages = [];
    _aiStatus = null;
    _isCheckingAi = false;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    instructionController.dispose();
    super.dispose();
  }
}

final giverController = GiverController();
