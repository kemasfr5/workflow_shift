import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  var isSearch = false;
  var enteredSearch = '';
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
                      filteredData[index].reference.delete();
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${deletedUser['name']} Deleted'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              setState(() {
                                FirebaseFirestore.instance
                                    .collection('role')
                                    .add(deletedUser.data());
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
                            flex: 2,
                            child: Text(filteredData[index]['name']),
                          ),
                          // (MediaQuery.of(context).size.width / 4).toInt()),
                          Expanded(
                            flex: 1,
                            child: Text(filteredData[index]['role']),
                            // textAlign: TextAlign.left,
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
                            return SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          'Name: ${filteredData[index]['name']}'),
                                      Text(
                                          'Role: ${filteredData[index]['role']}'),
                                      Text(
                                          'Email: ${filteredData[index]['email']}'),
                                    ],
                                  ),
                                ),
                              ),
                            );
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
