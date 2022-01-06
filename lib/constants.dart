// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<User?> refreshUser(User user) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await user.reload();
  User? refreshedUser = auth.currentUser;
  return refreshedUser;
}

var borderStyle = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20.0),
  borderSide: BorderSide(
    color: borderColor,
    width: 2,
  ),
);

var inputTextStyle = TextStyle(
  color: inputTextColor,
  fontFamily: 'Ubuntu',
  fontSize: 20,
);
var hintTextStyle = TextStyle(
  fontFamily: 'Ubuntu',
  fontSize: 20,
  color: hintTextColor,
);
Color backgroundColor = Colors.white;
Color activeSwitchColor = Colors.blue;
Color activeSwitchTrackColor = Colors.lightBlueAccent;
Color inactiveSwitchTrackColor = Colors.white;
Color inputTextColor = Colors.black;
Color hintTextColor = Colors.black45;
Color iconColor = Colors.black45;
Color borderColor = Colors.black;
Color cursorColor = Colors.black;
Color lowerTextColor = Colors.blue;
Color imgPickTextColor = Colors.white;
Color? msgCardColorMe = Colors.orange[50];
Color? msgCardColorU = Colors.cyan[50];
Color msgTextColor = Colors.black;

bool isDarkMode = false;

void modeCheck() {
  if (isDarkMode) {
    backgroundColor = Colors.black;
    inputTextColor = Colors.white;
    hintTextColor = Colors.white60;
    iconColor = Colors.white60;
    borderColor = Colors.white;
    cursorColor = Colors.white;
    imgPickTextColor = Colors.black;
    msgCardColorMe = Colors.green;
    msgCardColorU = Colors.deepPurpleAccent;
    msgTextColor = Colors.white;
  } else {
    backgroundColor = Colors.white;
    inputTextColor = Colors.black;
    hintTextColor = Colors.black45;
    iconColor = Colors.black45;
    borderColor = Colors.black;
    cursorColor = Colors.black;
    imgPickTextColor = Colors.white;
    msgCardColorMe = Colors.orange[50];
    msgCardColorU = Colors.cyan[50];
    msgTextColor = Colors.black;
  }
}

var alertDescStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontFamily: 'Ubuntu',
);
var alertTitleStyle = TextStyle(
  color: Colors.redAccent,
  fontFamily: 'Ubuntu',
  fontSize: 30,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.5,
  //backgroundColor: Colors.orangeAccent,
);
var alertStyle2 = AlertStyle(
  titleStyle: TextStyle(
    color: Colors.blue,
    fontFamily: 'Ubuntu',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
    //backgroundColor: Colors.orangeAccent,
  ),
  descStyle: TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: 'Ubuntu',
  ),
);

var alertStyle = AlertStyle(
  // backgroundColor: Colors.blueAccent,
  // isButtonVisible: true,
  titleStyle: TextStyle(
    color: Colors.redAccent,
    fontFamily: 'Ubuntu',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
    //backgroundColor: Colors.orangeAccent,
  ),
  descStyle: TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: 'Ubuntu',
  ),
);
