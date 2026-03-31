import 'package:flutter/material.dart';

Color primary = const Color(0xFF2E7D32);
Color secondry = const Color(0xFF81C784);
Color accent = const Color(0xFFFFA726);
Color background = const Color(0xFFFFFFFF);
Color text = const Color(0xFF212121);

// Typography

class AppTextStyle {
  static const regularPoppins20 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20,
  );

  static const regularPoppins10 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 10,
  );

  static const regularPoppins12 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontStyle: FontStyle.italic,
  );

  static const interRegular14 = TextStyle(fontFamily: 'Inter', fontSize: 14);

  static const interSemibold32 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );

  static const interMedium20 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
}
