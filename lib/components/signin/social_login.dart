import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: background,
                boxShadow: [
                  BoxShadow(
                    color: text,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/icons/google.png',
                height: 15,
                width: 15,
              ),
            ),
          ),
          const SizedBox(width: 28),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: background,
                boxShadow: [
                  BoxShadow(
                    color: text,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset('assets/icons/fb.png', height: 15, width: 15),
            ),
          ),
          const SizedBox(width: 28),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: background,
                boxShadow: [
                  BoxShadow(
                    color: text,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/icons/twitter.png',
                height: 15,
                width: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
