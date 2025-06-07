import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workflow_shift/widgets/user_detail.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  Timer? deleteTimer;
  final storageRef = FirebaseStorage.instance.ref();
  var isSearch = false;
  var enteredSearch = '';

  void deleteData(data) async {
    // final userImageRef =
    // storageRef.child("user_image/${data.reference.id}.jpg");
    // await userImageRef.delete();
    deleteTimer = Timer(
      Duration(seconds: 3),
      () async {
        await FirebaseStorage.instance.refFromURL(data['image']).delete();
        await data.reference.delete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage User'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });
            },
            icon: Icon(
              !isSearch ? Icons.search : Icons.close,
              color: !isSearch ? Colors.black : Colors.red.shade900,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                decoration: InputDecoration(
                  label: Text('Search Name'),
                ),
                onChanged: (value) {
                  setState(() {
                    enteredSearch = value;
                  });
                },
              ),
            ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
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

              final dataUser = snapshot.data!.docs;
              final filteredData = dataUser
                  .where(
                    (user) => user['name']
                        .toString()
                        .toLowerCase()
                        .contains(enteredSearch.toLowerCase()),
                  )
                  .toList();
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(filteredData[index].reference.id),
                    onDismissed: (direction) {
                      final deletedUser = filteredData[index];
                      // final File deletedImage = File(deletedUser['image']);

                      deleteData(filteredData[index]);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${deletedUser['name']} Deleted'),
                          duration: Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              setState(() {
                                deleteTimer?.cancel();
                                print('Delete Cancel.');
                                // FirebaseFirestore.instance
                                //     .collection('user')
                                //     .add(deletedUser.data());
                                // final storageRef = FirebaseStorage.instance
                                //     .ref()
                                //     .child("user_image")
                                //     .child('${deletedUser['image']}.jpg');
                                // storageRef.putFile(deletedImage);
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
                      style: ListTileStyle.drawer,
                      title: Row(
                        children: [
                          Expanded(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              foregroundImage: NetworkImage(
                                filteredData[index]['image'],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(filteredData[index]['name']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(filteredData[index]['role']),
                          ),
                          Icon(Icons.arrow_right)
                        ],
                      ),
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
                            return UserDetail(data: filteredData[index]);
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
