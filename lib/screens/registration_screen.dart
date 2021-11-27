// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables, must_be_immutable, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/login_screen.dart';
/*
enum TextFieldType {
  firstName,
  lastName,
  email,
  mobile,
  password,
  confirmPassword,
}*/

class RegistrationScreen extends StatefulWidget {
  static String id = '/registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? errorFirstName;
  String? errorLastName;
  String? errorEmail;
  String? errorMobile;
  String? errorPassword;
  String? errorConfirmPassword;

  String firstName = '';
  String lastName = '';
  String email = '';
  String mobile = '';
  String password = '';
  String confirmPassword = '';

  void check() {
    print('hello');
    if (firstName.isEmpty) {
      print('firstname empty');
      errorFirstName = 'Name field should not be empty';
      print(errorFirstName);
    } else {
      errorFirstName = null;
    }
    if (lastName.isEmpty) {
      errorLastName = 'Name field should not be empty';
    } else {
      errorLastName = null;
    }
    if (email.isEmpty) {
      errorEmail = 'Email required';
    } else {
      errorEmail = null;
    }
    if (mobile.isEmpty) {
      errorMobile = 'This field should not be empty';
    } else {
      errorMobile = null;
    }
    if (password.isEmpty) {
      errorPassword = 'Password required';
    } else {
      if (password.length < 8) {
        errorPassword = 'Password length must be minimum 8';
      } else {
        errorPassword = null;
      }
    }
    if (confirmPassword.isEmpty) {
      errorConfirmPassword = 'Confirm your password';
    } else {
      if (confirmPassword != password) {
        errorConfirmPassword = 'Password did not match';
      } else {
        errorConfirmPassword = null;
        Navigator.pushNamed(context, LoginScreen.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 50,
          left: 24,
          right: 24,
        ),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              child: Image.asset('images/logo.png'),
              height: 150,
            ),
            RegInfo(
              icon: Icon(Icons.edit),
              givenErrorText: errorFirstName,
              givenHintText: 'First Name',
              topPadding: 50,
              onComplete: (value) {
                setState(() {
                  firstName = value;
                });
              },
              isPassword: false,
            ),
            RegInfo(
              icon: Icon(Icons.edit),
              givenErrorText: errorLastName,
              givenHintText: 'Last Name',
              topPadding: 10,
              onComplete: (value) {
                setState(() {
                  lastName = value;
                });
              },
              isPassword: false,
            ),
            RegInfo(
              icon: Icon(Icons.email_outlined),
              givenErrorText: errorEmail,
              givenHintText: 'Email',
              topPadding: 10,
              onComplete: (value) {
                setState(() {
                  email = value;
                });
              },
              isPassword: false,
            ),
            RegInfo(
              icon: Icon(Icons.call),
              givenErrorText: errorMobile,
              givenHintText: 'Mobile No',
              topPadding: 10,
              onComplete: (value) {
                setState(() {
                  mobile = value;
                });
              },
              isPassword: false,
            ),
            RegInfo(
              icon: Icon(Icons.password),
              givenErrorText: errorPassword,
              givenHintText: 'Password',
              topPadding: 10,
              onComplete: (value) {
                setState(() {
                  password = value;
                });
              },
              isPassword: true,
            ),
            RegInfo(
              icon: Icon(Icons.password),
              givenErrorText: errorConfirmPassword,
              givenHintText: 'Confirm Password',
              topPadding: 10,
              onComplete: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
              isPassword: true,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(20),
                onPressed: () {
                  setState(() {
                    check();
                  });
                },
                color: Colors.blue,
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
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

class RegInfo extends StatelessWidget {
  final String? givenErrorText;
  final String givenHintText;
  final Icon icon;
  final double topPadding;
  final void Function(String)? onComplete;
  final bool isPassword;
  RegInfo(
      {required this.icon,
      required this.givenErrorText,
      required this.givenHintText,
      required this.topPadding,
      required this.onComplete,
      required this.isPassword});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: 20,
        right: 20,
      ),
      child: TextField(
        obscureText: isPassword,
        onChanged: onComplete,
        style: inputTextStyle,
        cursorHeight: 20,
        decoration: InputDecoration(
          enabledBorder: borderStyle,
          border: borderStyle,
          disabledBorder: borderStyle,
          errorStyle: TextStyle(
            fontSize: 10,
            fontFamily: 'Ubuntu',
            color: Colors.red,
          ),
          errorText: givenErrorText,
          prefixIcon: icon,
          hintText: givenHintText,
          hintStyle: hintTextStyle,
        ),
        cursorColor: Colors.black,
      ),
    );
  }
}
