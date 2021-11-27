import 'package:flutter/material.dart';

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
