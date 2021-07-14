import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(
    color: Colors.blueGrey,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
      // borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    // borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    // borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18.0,
);