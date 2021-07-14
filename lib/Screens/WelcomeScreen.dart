import 'package:flutter/material.dart';
import 'package:location_tracker/Screens/RegistrationScreen.dart';
import 'package:location_tracker/Screens/SignInScreen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color(0xFFF6F6F6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    child: Image(
                      image: AssetImage("images/Top.jpeg"),
                    ),
                  ),
                  Text(
                    "Live Location Tracking",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      " \" Navigate To Find Your Friends Faster & Easier \" ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Image(
                  width: 250,
                  image: AssetImage("images/Circle.jpeg"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignInScreen.id);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 50, top: 20, bottom: 20, right: 50),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(80)),
                      child: Center(
                          child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 40, top: 20, bottom: 20, right: 40),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(80)),
                      child: Center(
                          child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
