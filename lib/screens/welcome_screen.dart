// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          top: 40,
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: Switch(
            value: isDarkMode,

            ///
            activeColor: Colors.blue,
            activeTrackColor: Colors.lightBlue,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
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
