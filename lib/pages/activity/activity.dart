import 'package:flutter/material.dart';
import 'package:save_n_serve/components/activity/header.dart';
import 'package:save_n_serve/components/activity/list_view.dart';
import 'package:save_n_serve/theme.dart';
import 'package:save_n_serve/components/empty/empty_state.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  // 0 = Done (default — matching existing visual where "Done" has underline)
  // 1 = On Process
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              selectedTab: _selectedTab,
              onTabChanged: (index) => setState(() => _selectedTab = index),
            ),
            Expanded(
              child: _selectedTab == 0
                  ? _buildDoneTab()
                  : _buildOnProcessTab(),
            ),
          ],
        ),
      ),
    );
  }

  // Tab "Done" — riwayat donasi yang sudah selesai
  Widget _buildDoneTab() {
    return const SingleChildScrollView(
      child: Column(children: [ActivityList()]),
    );
  }

  // Tab "On Process" — belum ada reservasi aktif dalam simulasi
  Widget _buildOnProcessTab() {
    return const EmptyState(
      imagePath: 'assets/images/whoopies2.png',
      title: 'Belum Ada!',
      subtitle: 'Kamu belum memiliki donasi yang sedang diproses saat ini.',
      buttonColor: Color(0xFF2A6B35),
    );
  }
}
