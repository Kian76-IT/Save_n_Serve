import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';
import 'package:save_n_serve/pages/home/home_tab.dart';

class ButtonLogin extends StatelessWidget {
  const ButtonLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 27),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) => MainPageBene(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
            color: primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Login',
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