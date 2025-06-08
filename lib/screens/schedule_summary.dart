import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workflow_shift/screens/manage_role.dart';
import 'package:workflow_shift/screens/manage_schedule.dart';
import 'package:workflow_shift/screens/manage_user.dart';
import 'package:workflow_shift/widgets/main_drawer.dart';
import 'package:workflow_shift/widgets/schedule_list_by_date.dart';

class ScheduleSummaryScreen extends StatefulWidget {
  const ScheduleSummaryScreen({super.key});

  @override
  State<ScheduleSummaryScreen> createState() => _ScheduleSummaryScreenState();
}

class _ScheduleSummaryScreenState extends State<ScheduleSummaryScreen> {
  List scheduleData = [];
  late final DateTime startDate;
  var isLoading = true;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, now.day);
    getSchedules();
  }

  Stream<QuerySnapshot> getSchedules() {
    return FirebaseFirestore.instance
        .collection('schedule')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .snapshots();
  }

  void setScreen(String identifier) {
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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            title: Text('WORKFLOW SHIFT'),
            centerTitle: true,
          ),
          drawer: MainDrawer(onSelectScreen: setScreen),
          body: StreamBuilder(
              stream: getSchedules(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Data Empty',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  );
                }
                final scheduleData = snapshot.data!.docs;
                return TabBarView(
                  children: <Widget>[
                    for (var i = 0; i < 7; i++)
                      ScheduleListByDate(
                        date: DateTime(now.year, now.month, now.day + i),
                        scheduleData: scheduleData.where(
                          (doc) {
                            return doc['date'].toDate().year == now.year &&
                                doc['date'].toDate().month == now.month &&
                                doc['date'].toDate().day == now.day + i;
                          },
                        ).toList(),
                      ),
                  ],
                );
              }),
        ));
  }
}
