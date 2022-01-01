// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/components/all_buttons.dart';
import 'package:we_chat/components/all_textfields.dart';
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
  void loginCheck() async {
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
      } catch (e) {
        print(e);
        String errorLogin = e.toString(); //.substring(30);
        Alert(
          context: context,
          title: 'Log In Failed!!',
          desc: errorLogin,
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
          style: AlertStyle(
            //backgroundColor: Colors.blueAccent,
            isButtonVisible: true,
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
          ),
        ).show();
      }
    } else {
      errorTextPassword = null;
    }
  }

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
              /*Padding(
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
              ),*/
              RegInfo(
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
              RegInfo(
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
                      ///
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
                        Navigator.pushNamed(context, RegistrationScreen.id);
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
                child: AllButtons(
                  buttonText: 'Log In',
                  buttonColor: Colors.lightBlueAccent,
                  buttonTextColor: Colors.white,
                  onTap: () {
                    setState(() {
                      loginCheck();
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
}
