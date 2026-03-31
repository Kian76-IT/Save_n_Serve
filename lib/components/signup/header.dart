import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230,
      color: accent,
      child: Center(
        child: Image.asset('assets/logo/Logo_Save_n_Serve.png', height:500),
      ),
    );
  }
}
