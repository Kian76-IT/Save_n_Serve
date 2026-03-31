import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class ButtonConfrim extends StatelessWidget {
  const ButtonConfrim({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 42, left: 5, right: 5),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Confrim Password',
          hintStyle: AppTextStyle.regularPoppins20.copyWith(color: text),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset('assets/icons/mata.png', width: 30, height: 30),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: accent, width: 2),
          ),
        ),
      ),
    );
  }
}
