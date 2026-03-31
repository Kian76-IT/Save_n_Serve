import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class ButtonSwitch extends StatelessWidget {
  const ButtonSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60,),
      child: Container(
        // clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black.withOpacity(0.65), width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Color(0xFFFC87700), width: 1.5)
                ),
                child: Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regularPoppins20.copyWith(color: background),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
