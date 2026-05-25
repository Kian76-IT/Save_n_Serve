import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class ButtonPassword extends StatefulWidget {
  final TextEditingController controller;

  const ButtonPassword({super.key, required this.controller});

  @override
  State<ButtonPassword> createState() => _ButtonPasswordState();
}

class _ButtonPasswordState extends State<ButtonPassword> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 42, left: 5, right: 5),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: AppTextStyle.regularPoppins20.copyWith(color: text),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => setState(() => _obscure = !_obscure),
              child: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                size: 26,
                color: Colors.grey,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: primary, width: 2),
          ),
        ),
      ),
    );
  }
}
