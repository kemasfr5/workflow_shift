import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workflow_shift/screens/add_schedule.dart';
import 'package:workflow_shift/widgets/schedule_table_by_date.dart';

class ManageScheduleScreen extends StatefulWidget {
  const ManageScheduleScreen({super.key});

  @override
  State<ManageScheduleScreen> createState() => _ManageScheduleScreenState();
}

class _ManageScheduleScreenState extends State<ManageScheduleScreen> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, now.day);
    endDate = DateTime(now.year, now.month, now.day + 30);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<QuerySnapshot> schedulesStream(DateTime startDate, DateTime endDate) {
    return FirebaseFirestore.instance
        .collection('schedule')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('yyyy-MM-dd');
    final now = DateTime.now();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton.icon(
                  icon: Icon(Icons.calendar_month),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100),
                  onPressed: () {
                    showCustomDateRangePicker(
                      context,
                      dismissible: true,
                      minimumDate:
                          DateTime.now().subtract(const Duration(days: 360)),
                      maximumDate:
                          DateTime.now().add(const Duration(days: 360)),
                      endDate: startDate,
                      startDate: startDate,
                      backgroundColor: Colors.white,
                      primaryColor: const Color.fromARGB(255, 0, 34, 94),
                      onApplyClick: (start, end) {
                        setState(() {
                          endDate = end;
                          startDate = start;
                        });
                      },
                      onCancelClick: () {
                        setState(() {
                          startDate = DateTime(now.year, now.month, now.day);
                          endDate = DateTime(now.year, now.month, now.day + 30);
                        });
                      },
                    );
                  },
                  label: Text('${f.format(startDate)} - ${f.format(endDate)}')),
              StreamBuilder(
                stream: schedulesStream(startDate, endDate),
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
                    child: ScheduleTableByDate(
                      date: startDate,
                      dataList: snapshot.data!.docs,
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
