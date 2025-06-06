import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workflow_shift/screens/manage_role.dart';
import 'package:workflow_shift/screens/manage_schedule.dart';
import 'package:workflow_shift/screens/manage_user.dart';
import 'package:workflow_shift/widgets/main_drawer.dart';
import 'package:workflow_shift/widgets/schedule_list_by_date.dart';

class ScheduleSummaryScreen extends StatelessWidget {
  const ScheduleSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _setScreen(String identifier) {
      Navigator.of(context).pop();
      if (identifier == 'Role') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ManageRole(),
          ),
        );
      } else if (identifier == 'User') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ManageUser(),
          ),
        );
      } else if (identifier == 'Schedule') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ManageScheduleScreen(),
          ),
        );
      } else if (identifier == 'SignOut') {
        FirebaseAuth.instance.signOut();
      }
    }

    final now = DateTime.now();
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text('WORKFLOW SHIFT'),
          centerTitle: true,
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
