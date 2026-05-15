import 'package:flutter/material.dart';
import 'package:save_n_serve/components/activity/header.dart';
import 'package:save_n_serve/components/activity/list_view.dart';
import 'package:save_n_serve/theme.dart';
import 'package:save_n_serve/components/empty/empty_state.dart';

List activityItems = [
  'Activity 1',
];

class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            Expanded(
              child: activityItems.isEmpty
                  ? const EmptyState(
                      imagePath: 'assets/images/whoopies2.png',
                      title: 'Whoopsie!',
                      subtitle: "You didn’t have any activity yet",
                      buttonColor: Color(0xFF2D9CDB),
                    )
                  : SingleChildScrollView(
                      child: Column(children: [ActivityList()]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
