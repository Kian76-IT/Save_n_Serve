import 'package:flutter/material.dart';
import 'package:save_n_serve/components/activity/header.dart';
import 'package:save_n_serve/components/activity/list_view.dart';
import 'package:save_n_serve/theme.dart';

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
              child: SingleChildScrollView(
                child: Column(children: [ActivityList()]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
