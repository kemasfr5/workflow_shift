import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workflow_shift/screens/add_role.dart';

class ManageRole extends StatelessWidget {
  const ManageRole({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
          body: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: dataRole.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataRole[index]['title']),
              );
            },
          ),
        );
      },
    );
  }
}
