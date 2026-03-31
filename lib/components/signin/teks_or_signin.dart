import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class TeksOrSignin extends StatelessWidget {
  const TeksOrSignin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 37, right: 37, top: 0),
      child: Row(
        children: [
          Expanded(
            child: Divider(thickness: 1, color: Colors.grey, endIndent: 10),
          ),
          Text(
            textAlign: TextAlign.center,
            'Or Sign In with',
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
