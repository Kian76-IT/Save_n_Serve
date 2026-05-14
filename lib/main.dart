import 'package:flutter/material.dart';
import 'package:save_n_serve/splash_screen.dart';
import 'package:save_n_serve/pages/auth/signup.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Save n Serve",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
} 
