import 'package:flutter/material.dart';
import 'package:location_tracker/Screens/GroupAddingScreen.dart';
import 'package:location_tracker/Screens/MapScreen.dart';
import 'package:location_tracker/Utilities/DatabaseManagement.dart';
import 'package:location_tracker/Utilities/Constants.dart';

void errorAlert(String error, BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Error'),
      content: Text(error),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void messageAlert(String message, BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Message'),
      content: Text(message),
    ),
  );
}

class GroupButton extends StatefulWidget {
  final String groupName;
  final String admin;
  final String gid;
  const GroupButton(
      {required this.groupName, required this.admin, required this.gid});

  @override
  _GroupButtonState createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Material(
        type: MaterialType.button,
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10.0),
        elevation: 8.0,
        child: MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 2.0),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MapScreen(GID: widget.gid),
              ),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Group Name: ${widget.groupName}',
                      style: kTextStyle,
                    ),
                    Text(
                      'Admin: ${widget.admin}',
                      style: kTextStyle,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupAddingScreen()));
                        },
                        icon: Icon(Icons.add)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RequestCards extends StatefulWidget {
  final String groupName;
  final String admin;
  final String gid;
  final String email;
  final String uid;
  // final List<Widget> list;
  RequestCards({
    required this.groupName,
    required this.admin,
    required this.gid,
    required this.email,
    required this.uid,
    // required this.list,
  });

  @override
  _RequestCardsState createState() => _RequestCardsState();
}

class _RequestCardsState extends State<RequestCards> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Material(
        type: MaterialType.button,
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10.0),
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group Name: ${widget.groupName}',
                style: kTextStyle,
              ),
              Text(
                'Admin: ${widget.admin}',
                style: kTextStyle,
              ),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      deleteFromRequest(widget.gid, widget.uid, widget.email);
                      addGroupToGroupList(widget.uid, widget.admin,
                          widget.groupName, widget.gid);
                      updateUserInMembersList(widget.gid, widget.uid);
                    },
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      print([widget.gid, widget.uid, widget.email]);
                      deleteFromRequest(widget.gid, widget.uid, widget.email);
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
