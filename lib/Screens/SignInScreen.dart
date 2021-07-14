import 'dart:ui';
import 'package:location_tracker/Screens/HomeScreen.dart';
import 'package:location_tracker/Utilities/Constants.dart';
import 'package:location_tracker/Utilities/Components.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'SignInId';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late String email;
  late String password;

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

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
                    // flex: 5,
                    child: Container(
                      color: Colors.blue,
                      child: Text('hi'),
                    ),
                  ),
                  Expanded(
                    // flex: 5,
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
                                UserCredential userCredential =
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: password);
                                Navigator.pushNamed(context, HomeScreen.id);
                                controller2.clear();
                                controller1.clear();
                                email = '';
                                password = '';
                              } catch (e) {
                                errorAlert(e.toString(), context);
                              }
                            },
                            child: Text('Log In'),
                          )
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

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }
}
