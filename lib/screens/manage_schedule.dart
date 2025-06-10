import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workflow_shift/screens/add_schedule.dart';
import 'package:workflow_shift/widgets/schedule_table_by_date.dart';

class ManageScheduleScreen extends StatefulWidget {
  const ManageScheduleScreen({super.key});

  @override
  State<ManageScheduleScreen> createState() => _ManageScheduleScreenState();
}

class _ManageScheduleScreenState extends State<ManageScheduleScreen> {
  final now = DateTime.now();

  @override
  void dispose() {
    super.dispose();
  }

  Stream<QuerySnapshot> schedulesStream() {
    var startDate = DateTime(now.year, now.month, now.day + 2);
    var endDate = DateTime(now.year, now.month, now.day + 30);
    return FirebaseFirestore.instance
        .collection('schedule')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // print(schedulesData);
    var startDate = DateTime(now.year, now.month, now.day);
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage Schedule'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddScheduleScreen(),
                  ),
                );
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: StreamBuilder(
          stream: schedulesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('Empty Data'),
              );
            }
            return Container(
              margin: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: ScheduleTableByDate(
                  date: startDate,
                  dataList: snapshot.data!.docs,
                ),
              ),
            );
          },
        ));
  }
}
