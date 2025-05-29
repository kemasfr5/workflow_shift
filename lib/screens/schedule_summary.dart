import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workflow_shift/widgets/main_drawer.dart';
import 'package:workflow_shift/widgets/schedule_list_by_date.dart';
import 'package:intl/intl.dart';

class ScheduleSummaryScreen extends StatelessWidget {
  const ScheduleSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _setScreen(String identifier) {
      Navigator.of(context).pop();
    }

    final now = DateTime.now();
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text('WORKFLOW SHIFT'),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        drawer: MainDrawer(onSelectScreen: _setScreen),
        body: TabBarView(
          children: <Widget>[
            ScheduleListByDate(
              date: DateTime(now.year, now.month, now.day),
            ),
            ScheduleListByDate(
              date: DateTime(now.year, now.month, now.day + 1),
            ),
            ScheduleListByDate(
              date: DateTime(now.year, now.month, now.day + 2),
            ),
            ScheduleListByDate(
              date: DateTime(now.year, now.month, now.day + 3),
            ),
            ScheduleListByDate(
              date: DateTime(now.year, now.month, now.day + 4),
            ),
            ScheduleListByDate(
              date: DateTime(now.year, now.month, now.day + 5),
            ),
            ScheduleListByDate(
              date: DateTime(now.year, now.month, now.day + 6),
            ),
          ],
        ),
      ),
    );
  }
}
