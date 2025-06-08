import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workflow_shift/widgets/schedule_list_by_date_shift.dart';
// import 'package:workflow_shift/widgets/schedule_by_date_shift.dart';
// import 'package:intl/date_symbol_data_local.dart';
// initializeDateFormatting('fr_FR', null).then((_) => runMyCode());

class ScheduleListByDate extends StatelessWidget {
  const ScheduleListByDate({
    super.key,
    required this.date,
    required this.scheduleData,
  });

  final DateTime date;
  final List scheduleData;

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('yyyy-MM-dd');
    // print(scheduleData);

    List getDataByShift(String shift) {
      return scheduleData.where(
        (doc) {
          return doc['shift'] == shift;
        },
      ).toList();
    }

    return Container(
      padding: EdgeInsets.only(top: 12),
      color: Theme.of(context).colorScheme.onSecondary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              f.format(date),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            ScheduleListByDateShift(
              date: date,
              shift: 'Shift 1',
              scheduleData: getDataByShift('Shift 1'),
              // color: Theme.of(context).colorScheme.onTertiary,
            ),
            ScheduleListByDateShift(
              date: date,
              shift: 'Shift 2',
              scheduleData: getDataByShift('Shift 2'),
              // color: Theme.of(context).colorScheme.onPrimary,
            ),
            ScheduleListByDateShift(
              date: date,
              shift: 'Shift 3',
              scheduleData: getDataByShift('Shift 3'),
              // color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
            ),
          ],
        ),
      ),
    );
  }
}
