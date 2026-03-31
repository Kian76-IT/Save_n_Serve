import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class TextTerms extends StatelessWidget {
  const TextTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        'Terms of Service • Privacy Policy',
        textAlign: TextAlign.center,
        style: AppTextStyle.regularPoppins12.copyWith(color: text),
      ),
    );
  }
}
