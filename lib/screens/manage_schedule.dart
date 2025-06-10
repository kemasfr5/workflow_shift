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
  List schedulesData = [];

  @override
  void initState() {
    super.initState();
    getSchedules();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getSchedules() async {
    var startDate = DateTime(now.year, now.month, now.day - 30);
    var endDate = DateTime(now.year, now.month, now.day + 30);
    final snapshot = await FirebaseFirestore.instance
        .collection('schedule')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date')
        .get();
    setState(() {
      schedulesData = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(schedulesData);
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
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ScheduleTableByDate(
            date: startDate,
            dataList: schedulesData,
          ),
        ),
      ),
    );
  }
}
