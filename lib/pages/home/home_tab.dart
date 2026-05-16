import 'package:flutter/material.dart';
import 'package:save_n_serve/home_page.dart';
import 'package:save_n_serve/pages/watchlist/watchlist.dart';
import 'package:save_n_serve/pages/activity/activity.dart';
import 'package:save_n_serve/pages/profile/profile.dart';
import 'package:save_n_serve/theme.dart';

class MainPageBene extends StatefulWidget {
  const MainPageBene({super.key});

  static _MainPageBeneState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainPageBeneState>();
  }

  @override
  State<MainPageBene> createState() => _MainPageBeneState();
}

class _MainPageBeneState extends State<MainPageBene> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const Watchlist(),
    const Activity(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Activity',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
