// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/login_Screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorTextEmail;
  String? errorTextPassword;
  String email = '';
  String password = '';
  void check() {
    if (email.isEmpty) {
      errorTextEmail = 'This field can not be empty.';
    } else {
      errorTextEmail = null;
    }
    if (password.isEmpty) {
      errorTextPassword = 'This field can not be empty.';
    } else if (password.length < 8) {
      errorTextPassword = 'Password length must be minimum 8';
    } else if (errorTextEmail == null) {
      errorTextPassword = null;
      Navigator.pushNamed(context, ChatScreen.id);
    } else {
      errorTextPassword = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              child: Image.asset('images/logo.png'),
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
              ),
              child: TextField(
                cursorHeight: 20,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },

                ///
                style: TextStyle(
                  color: inputTextColor,
                  fontFamily: 'Ubuntu',
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  ///
                  disabledBorder: OutlineInputBorder(
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: 2,
                    ),
                  ),
                  hintText: 'Enter Your Email',

                  ///
                  hintStyle: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 20,
                    color: hintTextColor,
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,

                    ///
                    color: iconColor,
                  ),
                  errorText: errorTextEmail,
                  errorStyle: TextStyle(
                    fontSize: 10,
                    fontFamily: 'Ubuntu',
                    //color: Colors.red,
                  ),
                ),

                ///
                cursorColor: cursorColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
              ),
              child: TextField(
                obscureText: true,
                cursorHeight: 20,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },

                ///
                style: TextStyle(
                  color: inputTextColor,
                  fontFamily: 'Ubuntu',
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  ///
                  disabledBorder: OutlineInputBorder(
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: 2,
                    ),
                  ),
                  hintText: 'Enter Your Password',

                  ///
                  hintStyle: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 20,
                    color: hintTextColor,
                  ),
                  prefixIcon: Icon(
                    Icons.password,

                    ///
                    color: iconColor,
                  ),
                  errorText: errorTextPassword,
                  errorStyle: TextStyle(
                    fontSize: 10,
                    fontFamily: 'Ubuntu',
                    //color: Colors.red,
                  ),
                ),

                ///
                cursorColor: cursorColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: CupertinoButton(
                ///
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(20),
                onPressed: () {
                  setState(() {
                    check();
                  });
                },
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    fontSize: 20,

                    ///
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
