// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/cupertino.dart';

class Buttons extends StatelessWidget {
  final Color buttonColor;
  final Color buttonTextColor;
  final void Function()? onTap;
  final String buttonText;

  Buttons(
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
