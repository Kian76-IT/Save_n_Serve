import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_n_serve/controllers/auth_controller.dart';
import 'package:save_n_serve/splash_screen.dart';
import 'package:save_n_serve/pages/activity/giver_activity_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
      ],
      child: MaterialApp(
        title: "Save n Serve",
        debugShowCheckedModeBanner: false,
        routes: {
          '/giver-activity': (_) => const GiverActivityPage(),
        },
        home: SplashScreen(),
      ),
    );
  }
}