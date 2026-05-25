import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class ButtonUsername extends StatelessWidget {
  // 1. PENANGKAP BOLA DARI LUAR
  final TextEditingController controller;

  // 2. WAJIBKAN DI CONSTRUCTOR
  const ButtonUsername({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 5, right: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Username or Email',
          hintStyle: AppTextStyle.regularPoppins20.copyWith(color: text),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: accent, width: 2), // Warna disesuain sama tema signup lo
          ),
        ),
      ),
    );
  }
}