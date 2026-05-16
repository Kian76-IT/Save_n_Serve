import 'package:flutter/material.dart';
import 'package:save_n_serve/pages/home/home_tab.dart';
import 'package:save_n_serve/theme.dart';

class ButtonSignup extends StatelessWidget {
  const ButtonSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 98, vertical: 41),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const MainPageBene(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    var curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    );
                    return FadeTransition(
                      opacity: curvedAnimation,
                      child: child,
                    );
                  },
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Sign Up',
            style: AppTextStyle.regularPoppins20.copyWith(
              color: background,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
