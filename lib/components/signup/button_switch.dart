import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';
import 'package:save_n_serve/pages/auth/signin.dart';

class ButtonSwitch extends StatelessWidget {
  const ButtonSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Container(
        // clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black.withValues(alpha: 0.65), width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SignIn(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const curve = Curves.easeInOut;
                            var curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: curve,
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.regularPoppins20.copyWith(
                      color: primary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: const Color(0xFFC87700),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regularPoppins20.copyWith(
                    color: background,
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
