import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blueGrey,
                    Colors.blue,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'MyShiftSchedule',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              )),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              onSelectScreen('Home');
            },
          ),
        ],
      ),
    );
  }
}
