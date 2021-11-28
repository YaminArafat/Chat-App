// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:we_chat/constants.dart';

class RegInfo extends StatelessWidget {
  final String? givenErrorText;
  final String givenHintText;
  final Icon icon;
  final double topPadding;
  final void Function(String)? onComplete;
  final bool isPassword;
  final bool togglePassword;
  final void Function()? showHidePassword;
  RegInfo(
      {required this.icon,
      required this.givenErrorText,
      required this.givenHintText,
      required this.topPadding,
      required this.onComplete,
      required this.isPassword,
      required this.togglePassword,
      this.showHidePassword});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: 20,
        right: 20,
      ),
      child: TextField(
        obscureText: togglePassword,
        onChanged: onComplete,
        style: TextStyle(
          color: inputTextColor,
          fontFamily: 'Ubuntu',
          fontSize: 20,
        ),
        cursorHeight: 20,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: iconColor,
                  ),
                  onPressed: showHidePassword,
                )
              : null,

          ///
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: borderColor,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: borderColor,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: borderColor,
              width: 2,
            ),
          ),
          errorStyle: TextStyle(
            fontSize: 10,
            fontFamily: 'Ubuntu',
            // color: Colors.red,
          ),
          errorText: givenErrorText,
          prefixIcon: icon,
          hintText: givenHintText,
          hintStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 20,
            color: hintTextColor,
          ),
        ),
        cursorColor: cursorColor,
      ),
    );
  }
}
