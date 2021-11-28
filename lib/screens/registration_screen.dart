// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables, must_be_immutable, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/components/all_buttons.dart';
import 'package:we_chat/components/all_textfields.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/login_screen.dart';

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

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  void regCheck() {
    if (firstName.isEmpty) {
      errorFirstName = 'Name field should not be empty';
    } else {
      errorFirstName = null;
    }
    if (lastName.isEmpty) {
      errorLastName = 'Name field should not be empty.';
    } else {
      errorLastName = null;
    }
    if (email.isEmpty) {
      errorEmail = 'Email required.';
    } else {
      errorEmail = null;
    }
    if (mobile.isEmpty) {
      errorMobile = 'Contact details required.';
    } else {
      errorMobile = null;
    }
    if (password.isEmpty) {
      errorPassword = 'Password required.';
    } else {
      if (password.length < 8) {
        errorPassword = 'Password length must be minimum 8.';
      } else {
        errorPassword = null;
      }
    }
    if (confirmPassword.isEmpty) {
      errorConfirmPassword = 'Confirm your password';
    } else {
      if (confirmPassword != password) {
        errorConfirmPassword = 'Password did not match';
      } else if (errorFirstName == null &&
          errorLastName == null &&
          errorEmail == null &&
          errorMobile == null &&
          errorPassword == null) {
        errorConfirmPassword = null;
        Navigator.pushNamed(context, LoginScreen.id);
      } else {
        errorConfirmPassword = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///
      backgroundColor: backgroundColor,
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
            Hero(
              tag: 'logo',
              child: SizedBox(
                child: Image.asset('images/logo.png'),
                height: 150,
              ),
            ),
            RegInfo(
              icon: Icon(
                Icons.edit,

                ///
                color: iconColor,
              ),
              givenErrorText: errorFirstName,
              givenHintText: 'First Name',
              topPadding: 50,
              onComplete: (value) {
                setState(() {
                  firstName = value;
                });
              },
              isPassword: false,
              togglePassword: false,
            ),
            RegInfo(
              icon: Icon(
                Icons.edit,

                ///
                color: iconColor,
              ),
              givenErrorText: errorLastName,
              givenHintText: 'Last Name',
              topPadding: 10,
              onComplete: (value) {
                setState(() {
                  lastName = value;
                });
              },
              isPassword: false,
              togglePassword: false,
            ),
            RegInfo(
              icon: Icon(
                Icons.email_outlined,

                ///
                color: iconColor,
              ),
              givenErrorText: errorEmail,
              givenHintText: 'Email',
              topPadding: 10,
              onComplete: (value) {
                setState(() {
                  email = value;
                });
              },
              isPassword: false,
              togglePassword: false,
            ),
            RegInfo(
              icon: Icon(
                Icons.call,

                ///
                color: iconColor,
              ),
              givenErrorText: errorMobile,
              givenHintText: 'Mobile No',
              topPadding: 10,
              onComplete: (value) {
                setState(() {
                  mobile = value;
                });
              },
              isPassword: false,
              togglePassword: false,
            ),
            RegInfo(
              icon: Icon(
                Icons.password,

                ///
                color: iconColor,
              ),
              givenErrorText: errorPassword,
              givenHintText: 'Password',
              topPadding: 10,
              onComplete: (value) {
                setState(() {
                  password = value;
                });
              },
              isPassword: true,
              togglePassword: hidePassword,
              showHidePassword: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
            ),
            RegInfo(
              icon: Icon(
                Icons.password,

                ///
                color: iconColor,
              ),
              givenErrorText: errorConfirmPassword,
              givenHintText: 'Confirm Password',
              topPadding: 10,
              onComplete: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
              isPassword: true,
              togglePassword: hideConfirmPassword,
              showHidePassword: () {
                setState(() {
                  hideConfirmPassword = !hideConfirmPassword;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: AllButtons(
                buttonText: 'Register',
                buttonColor: Colors.greenAccent,
                buttonTextColor: Colors.black,
                onTap: () {
                  setState(() {
                    regCheck();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
