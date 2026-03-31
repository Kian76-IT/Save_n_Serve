import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class ButtonUsername extends StatelessWidget {
  const ButtonUsername({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 5, right: 5),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Username or Email',
          hintStyle: AppTextStyle.regularPoppins20.copyWith(color: text),
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