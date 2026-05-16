import 'package:flutter/material.dart';
import 'package:save_n_serve/home_page.dart';
import 'package:save_n_serve/pages/activity/giver_activity_page.dart';

import 'package:save_n_serve/splash_screen.dart';
import 'package:save_n_serve/pages/auth/signup.dart';

import 'package:save_n_serve/pages/home/home_tab.dart';
import 'package:save_n_serve/pages/watchlist/watchlist.dart';

import 'package:save_n_serve/pages/home/detail_makanan.dart';
import 'package:save_n_serve/models/food_item.dart';

import 'package:save_n_serve/pages/profile/profile.dart';
import 'package:save_n_serve/controllers/food_controller.dart';

final FoodController foodController = FoodController();

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

      home: SplashScreen(),
    );
  }
}