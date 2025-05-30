import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workflow_shift/screens/add_role.dart';

class ManageRole extends StatefulWidget {
  const ManageRole({super.key});

  @override
  State<ManageRole> createState() => _ManageRoleState();
}

class _ManageRoleState extends State<ManageRole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Role'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddRoleScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('role')
            .orderBy('title', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Data Found.'),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Oops.. Something Wrong!'),
            );
          }

          final dataRole = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: dataRole.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(dataRole[index].reference.id),
                onDismissed: (direction) {
                  final deletedRole = dataRole[index];
                  dataRole[index].reference.delete();
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${deletedRole['title']} Deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          setState(() {
                            FirebaseFirestore.instance
                                .collection('role')
                                .add(deletedRole.data());
                          });
                        },
                      ),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red.shade900,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                child: ListTile(
                  title: Text(dataRole[index]['title']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
