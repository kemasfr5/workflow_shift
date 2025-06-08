import 'package:flutter/material.dart';

class ScheduleListByDateShift extends StatelessWidget {
  const ScheduleListByDateShift({
    super.key,
    required this.date,
    required this.shift,
    required this.scheduleData,
  });

  final DateTime date;
  final String shift;
  final List scheduleData;

  @override
  Widget build(BuildContext context) {
    final employees =
        scheduleData.isNotEmpty ? scheduleData[0].data()['employees'] : null;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              shift,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                if (employees == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Data Empty',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (employees != null)
                  for (var employee in employees)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                employee,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            // Text(
                            //   'Manager',
                            //   style: Theme.of(context).textTheme.titleSmall,
                            // ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
