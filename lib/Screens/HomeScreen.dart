import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_tracker/Utilities/Components.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'GroupAddingScreen.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
Geoflutterfire geo = Geoflutterfire();

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? loggedInUser;
  late String email;

  void getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  late String UID;

  @override
  void initState() {
    super.initState();
    getUserData();
    email = loggedInUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Groups'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pop(context);
                _auth.signOut();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('User')
                  .where('UserEmail', isEqualTo: email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final userData = snapshot.data!.docs;
                List<dynamic> groupList = [];
                List<Widget> Groups = [];
                for (var group in userData) {
                  UID = group.get('UID');
                  groupList = group.get('GroupList');
                  for (var i in groupList) {
                    GroupButton GB = GroupButton(
                      groupName: i['GroupName'],
                      admin: i['Admin'],
                      gid: i['GID'],
                    );
                    Groups.add(GB);
                  }
                }
                return Expanded(
                  child: ListView(
                    children: Groups,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupAddingScreen()));
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35.0,
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('User')
                    .where('UserEmail', isEqualTo: email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  final userData = snapshot.data!.docs;

                  late List<dynamic> requestsList;
                  late List<Widget> requestWidgets = [
                    Container(
                      height: 56.0,
                      child: Center(
                        child: Text(
                          'Join Requests',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(color: Colors.blue),
                    ),
                  ];

                  for (var group in userData) {
                    UID = group.get('UID');
                    requestsList = group.get('Requests');
                    for (var i in requestsList) {
                      RequestCards RC = RequestCards(
                        groupName: i['GroupName'],
                        admin: i['Admin'],
                        gid: i['GID'],
                        uid: UID,
                        email: email,
                        // list: requestWidgets,
                      );
                      requestWidgets.add(RC);
                    }
                  }
                  return Expanded(
                    child: ListView(
                      children: requestWidgets,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
