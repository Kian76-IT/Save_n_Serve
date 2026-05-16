import 'package:flutter/material.dart';

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

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

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
    if (_startTime == null || _endTime == null) {
      return false;
    }
    final startMin = _startTime!.hour * 60 + _startTime!.minute;
    final endMin   = _endTime!.hour   * 60 + _endTime!.minute;
    return endMin <= startMin;
  }

  bool validate() {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      return false;
    }
    if (_startTime == null || _endTime == null) {
      return false;
    }
    return !isTimeReversed();
  }

  Future<bool> submitDonation() async {
    if (!validate()) return false;
    _isSubmitting = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _isSubmitting = false;
    notifyListeners();
    return true;
  }

  void reset() {
    titleController.clear();
    descriptionController.clear();
    instructionController.clear();
    _startTime = null;
    _endTime   = null;
    _selectedQuantity = 1;
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
