import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class TeksOrSignUp extends StatelessWidget {
  const TeksOrSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 37, right: 37),
      child: Row(
        children: [
          Expanded(
            child: Divider(thickness: 1, color: Colors.grey, endIndent: 10),
          ),
          Text(
            textAlign: TextAlign.center,
            'Or Sign Up with',
            style: AppTextStyle.regularPoppins10.copyWith(
              fontSize: 14,
              color: text,
            ),
          ),
          Expanded(
            child: Divider(thickness: 1, color: Colors.grey, indent: 10),
          ),
        ],
      ),
    );
  }
}
