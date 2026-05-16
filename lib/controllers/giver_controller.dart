import 'package:flutter/material.dart';

class GiverController extends ChangeNotifier {
  final titleController       = TextEditingController();
  final descriptionController = TextEditingController();
  final pickupTimeController  = TextEditingController();
  final instructionController = TextEditingController();

  final List<int> quantities = [1, 2, 3, 4, 5];

  int _selectedQuantity = 1;
  int get selectedQuantity => _selectedQuantity;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  void selectQuantity(int qty) {
    _selectedQuantity = qty;
    notifyListeners();
  }

  bool validate() {
    return titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        pickupTimeController.text.trim().isNotEmpty;
  }

  Future<bool> submitDonation() async {
    if (!validate()) return false;
    _isSubmitting = true;
    notifyListeners();
    // Placeholder — akan diganti HTTP call ke backend
    await Future.delayed(const Duration(milliseconds: 800));
    _isSubmitting = false;
    notifyListeners();
    return true;
  }

  void reset() {
    titleController.clear();
    descriptionController.clear();
    pickupTimeController.clear();
    instructionController.clear();
    _selectedQuantity = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    pickupTimeController.dispose();
    instructionController.dispose();
    super.dispose();
  }
}
