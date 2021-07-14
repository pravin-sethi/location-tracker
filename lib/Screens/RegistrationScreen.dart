import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_tracker/Utilities/Constants.dart';
import 'package:location_tracker/Utilities/DatabaseManagement.dart' as db;
import 'package:location_tracker/Utilities/Components.dart';
import 'HomeScreen.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'RegistrationId';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String error;

  late String name;
  late String email;
  late String password;

  final _auth = FirebaseAuth.instance;

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.blue,
                      child: Text('hi'),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Material(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0),
                      ),
                      color: Colors.white,
                      elevation: 50.0,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User Name',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                TextField(
                                  controller: controller3,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  onChanged: (value) {
                                    name = value;
                                  },
                                  decoration: kTextFieldDecoration,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                TextField(
                                  controller: controller2,
                                  obscureText: true,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  onChanged: (value) {
                                    password = value;
                                  },
                                  decoration: kTextFieldDecoration,
                                ),
                              ],
                            ),
                          ),
                          MaterialButton(
                            color: Colors.blueGrey,
                            onPressed: () async {
                              try {
                                UserCredential user =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email, password: password);
                                db.addUser(name, email);
                                Navigator.pushNamed(context, HomeScreen.id);
                                controller1.clear();
                                controller2.clear();
                                controller3.clear();
                                email = '';
                                name = '';
                                password = '';
                              } catch (e) {
                                errorAlert(e.toString(), context);
                              }
                            },
                            child: Text('Sign Up'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
