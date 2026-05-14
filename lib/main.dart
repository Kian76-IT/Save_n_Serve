import 'package:flutter/material.dart';
import 'package:save_n_serve/pages/activity/giver_activity_page.dart';

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

      routes: {
        '/giver-activity': (_) => const GiverActivityPage(),
      },

      home: SignUp(),
    );
  }
}
