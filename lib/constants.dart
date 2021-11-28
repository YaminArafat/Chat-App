// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/cupertino.dart';
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

class AllButtons extends StatelessWidget {
  final Color buttonColor;
  final Color buttonTextColor;
  final void Function()? onTap;
  final String buttonText;

  AllButtons(
      {required this.buttonText,
      required this.buttonTextColor,
      required this.buttonColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      ///
      color: buttonColor,
      borderRadius: BorderRadius.circular(20),
      onPressed: onTap,
      child: Text(
        buttonText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Ubuntu',
          fontSize: 20,
          letterSpacing: 2,

          ///
          color: buttonTextColor,
        ),
      ),
    );
  }
}
