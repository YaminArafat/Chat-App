// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/login_screen.dart';
import 'package:we_chat/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///
      backgroundColor: backgroundColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          top: 40,
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: Switch(
            value: isDarkMode,

            ///
            activeColor: activeSwitchColor,
            activeTrackColor: activeSwitchTrackColor,
            //inactiveTrackColor: inactiveSwitchTrackColor,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
                if (isDarkMode) {
                  backgroundColor = Colors.black;
                  inputTextColor = Colors.white;
                  hintTextColor = Colors.white60;
                  iconColor = Colors.white60;
                  borderColor = Colors.white;
                  cursorColor = Colors.white;

                  /*activeSwitchColor = Colors.white;
                  activeSwitchTrackColor = Colors.white38;
                  inactiveSwitchTrackColor = Colors.white10;*/
                } else {
                  backgroundColor = Colors.white;
                  inputTextColor = Colors.black;
                  hintTextColor = Colors.black45;
                  iconColor = Colors.black45;
                  borderColor = Colors.black;
                  cursorColor = Colors.black;
                  /*activeSwitchColor = Colors.blue;
                  activeSwitchTrackColor = Colors.lightBlueAccent;
                  inactiveSwitchTrackColor = Colors.white;*/
                }
              });
            },
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Image.asset('images/logo.png'),
                  height: 60,
                ),
                Text(
                  'We Chat',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.bold,

                    ///
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 10,
              ),
              child: CupertinoButton(
                ///
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(20),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    fontSize: 20,
                    letterSpacing: 2,

                    ///
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: CupertinoButton(
                ///
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(20),
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    fontSize: 20,
                    letterSpacing: 2,

                    ///
                    color: Colors.black,
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
