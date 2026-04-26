import 'package:flutter/material.dart';
import 'package:save_n_serve/pages/auth/signup.dart';
import 'package:save_n_serve/theme.dart';

class ButtonSwitch extends StatelessWidget {
  const ButtonSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: text, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: text, width: 1.5)
                ),
                child: Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regularPoppins20.copyWith(
                    color: background,
                  ),
                ),
              ),
            ),

            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) => const SignUp(),
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.regularPoppins20.copyWith(color: accent),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}