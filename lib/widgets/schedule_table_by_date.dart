import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workflow_shift/widgets/schedule_detail.dart';

class ScheduleTableByDate extends StatelessWidget {
  const ScheduleTableByDate(
      {super.key, required this.date, required this.dataList});

  final DateTime date;
  final List dataList;
  @override
  Widget build(BuildContext context) {
    final f = DateFormat('yyyy-MM-dd');
    DateTime? prevDate;
    DateTime? currentDate;

    final widgets = <Widget>[];

    bool isSameDate(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    for (var doc in dataList) {
      currentDate = doc.data()['date'].toDate();
      final employeesData = doc.data()['employees'];

      if (prevDate != null && !isSameDate(currentDate!, prevDate)) {
        widgets.add(
          SizedBox(
            height: 12,
          ),
        );
      }
      if (prevDate == null || !isSameDate(prevDate, currentDate!)) {
        widgets.add(
          Text(
            f.format(doc.data()['date'].toDate()),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        );
      }

      widgets.add(
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              context: context,
              builder: (context) {
                return ScheduleDetail(data: doc.data());
              },
            );
          },
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 80,
                  decoration: BoxDecoration(border: Border.all()),
                  alignment: Alignment.center,
                  child: Text(
                    doc.data()['shift'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    child: Column(
                      children: [
                        for (var employee in employeesData.asMap().entries)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 1),
                            decoration: BoxDecoration(
                              border: employee.key == employeesData.length
                                  ? Border(bottom: BorderSide())
                                  : null,
                            ),
                            child: Text(employee.value),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      prevDate = currentDate;
    }

    // print(dataList[0].data());
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ],
    );
  }
}
