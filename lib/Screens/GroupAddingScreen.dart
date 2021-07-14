import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_tracker/Utilities/Components.dart';
import 'package:location_tracker/Utilities/Constants.dart';
import 'package:location_tracker/Utilities/DatabaseManagement.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class GroupAddingScreen extends StatefulWidget {
  static const String id = 'GroupAddingScreen';

  @override
  _GroupAddingScreenState createState() => _GroupAddingScreenState();
}

class _GroupAddingScreenState extends State<GroupAddingScreen> {
  late String groupName;
  late String email;
  late User loggedInUser;

  TextEditingController controller1 = TextEditingController();

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

  late List<Map<String, String>> memberList = [];
  bool isError = false;

  void addMember() {
    controller1.clear();
    for (var i in memberList) {
      if (i['Email'] == email) {
        isError = true;
        break;
      }
    }
    if (!isError) {
      memberList.add({
        'Email': email,
      });
    }
    print(memberList);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create A Group'),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Group Name',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  TextField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      groupName = value;
                    },
                    decoration: kTextFieldDecoration,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email ID of member',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  TextField(
                    controller: controller1,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      addMember();
                      if (isError) {
                        errorAlert('Request Already Sent', context);
                        isError = false;
                      } else
                        messageAlert('Request Sent', context);
                      controller1.clear();
                    });
                  },
                  child: Text('Add Member'),
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 15.0,
                ),
                MaterialButton(
                  onPressed: () {
                    if (loggedInUser.email == null) {
                      getUserData();
                    }
                    createGroup(groupName, loggedInUser.email!, memberList);
                    Navigator.pop(context);
                  },
                  child: Text('Create Group'),
                  color: Colors.blueGrey,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }
}
