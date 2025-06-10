import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  User? user;
  Map userData = {};

  void getUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user!.email)
        .get();
    setState(() {
      userData = snapshot.docs[0].data();
    });
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    getUserData();
  }

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
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 40,
                  foregroundImage: userData.isNotEmpty
                      ? NetworkImage(userData['image'])
                      : null,
                ),
                SizedBox(
                  width: 10,
                ),
                if (userData.isNotEmpty)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['name'],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(userData['email']),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              widget.onSelectScreen('Home');
            },
          ),
          ListTile(
            leading: Icon(Icons.group_work),
            title: Text('Role'),
            onTap: () {
              widget.onSelectScreen('Role');
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('User'),
            onTap: () {
              widget.onSelectScreen('User');
            },
          ),
          ListTile(
            leading: Icon(Icons.schedule),
            title: Text('Schedule'),
            onTap: () {
              widget.onSelectScreen('Schedule');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () {
              widget.onSelectScreen('SignOut');
            },
          ),
        ],
      ),
    );
  }
}
