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
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('yyyy-MM-dd');
    return Container(
      padding: EdgeInsets.all(20),
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
              date: DateTime(date.year, date.month, date.day),
              shift: '1',
              // color: Theme.of(context).colorScheme.onTertiary,
            ),
            ScheduleListByDateShift(
              date: DateTime(date.year, date.month, date.day + 1),
              shift: '2',
              // color: Theme.of(context).colorScheme.onPrimary,
            ),
            ScheduleListByDateShift(
              date: DateTime(date.year, date.month, date.day + 1),
              shift: '3',
              // color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
            ),
          ],
        ),
      ),
    );
  }
}
