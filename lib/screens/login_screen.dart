// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_null_comparison, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/components/buttons.dart';
import 'package:we_chat/components/textfields.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/chat_screen.dart';
import 'package:we_chat/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/login_Screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorTextEmail;
  String? errorTextPassword;
  String _email = '';
  String _password = '';
  bool hidePass = true;
  bool loading = false;

  final _auth = FirebaseAuth.instance;

  ///TODO: Registration Successful message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'logo',
                child: SizedBox(
                  child: Image.asset('images/logo.png'),
                  height: 150,
                ),
              ),
              TextFields(
                togglePassword: false,
                isPassword: false,
                onComplete: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                topPadding: 50,
                icon: Icon(
                  Icons.email_outlined,
                  color: iconColor,
                ),
                givenErrorText: errorTextEmail,
                givenHintText: 'Enter Your Email',
                inputType: TextInputType.emailAddress,
              ),
              TextFields(
                togglePassword: hidePass,
                isPassword: true,
                onComplete: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                topPadding: 10,
                icon: Icon(
                  Icons.password,
                  color: iconColor,
                ),
                givenErrorText: errorTextPassword,
                givenHintText: 'Enter Your Password',
                showHidePassword: () {
                  setState(() {
                    hidePass = !hidePass;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      ///TODO
                      onPressed: () {},
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          color: lowerTextColor,
                          fontFamily: 'Ubuntu',
                          fontSize: 15,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(
                            context, RegistrationScreen.id);
                      },
                      child: Text(
                        'New Here? Sign Up',
                        style: TextStyle(
                          color: lowerTextColor,
                          fontFamily: 'Ubuntu',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: Buttons(
                  buttonText: 'Log In',
                  buttonColor: Colors.lightBlueAccent,
                  buttonTextColor: Colors.white,
                  onTap: () {
                    setState(() {
                      logInUser();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool logInErrorCheck() {
    if (_email.isEmpty) {
      errorTextEmail = 'This field can not be empty.';
    } else {
      errorTextEmail = null;
    }
    if (_password.isEmpty) {
      errorTextPassword = 'This field can not be empty.';
    } else if (_password.length < 8) {
      errorTextPassword = 'Password length must be minimum 8';
    } else if (errorTextEmail == null) {
      errorTextPassword = null;
      return true;
    } else {
      errorTextPassword = null;
      return false;
    }
    return false;
  }

  void logInUser() async {
    if (logInErrorCheck()) {
      try {
        setState(() {
          loading = true;
        });
        final loginUser = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        if (loginUser != null) {
          Navigator.pushNamed(context, ChatScreen.id);
          setState(() {
            loading = false;
          });
        }
      } on FirebaseException catch (e) {
        print(e);
        String? errorMsg = e.message; // e.toString(); //.substring(30);
        userLogInError(errorMsg).show();
      }
    }
  }

  Alert userLogInError(String? errorMsg) {
    return Alert(
      context: context,
      title: 'Log In Failed!!',
      desc: errorMsg,
      closeIcon: Icon(
        Icons.close,
        color: Colors.black,
      ),
      closeFunction: () {
        Navigator.pop(context);
        setState(() {
          loading = false;
        });
      },
      buttons: [
        DialogButton(
          color: Colors.green,
          width: 100,
          height: 30,
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              loading = false;
            });
          },
          child: Text(
            'Try Again',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Ubuntu",
              color: Colors.white,
            ),
          ),
        ),
      ],
      style: alertStyle,
    );
  }
}
