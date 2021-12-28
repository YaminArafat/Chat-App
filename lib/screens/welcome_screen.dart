// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/components/all_buttons.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/login_screen.dart';
import 'package:we_chat/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  bool isDarkMode = false;
  late AnimationController animationControllerLogo;
  late Animation curvedAnimation;
  @override
  void initState() {
    super.initState();
    animationControllerLogo = AnimationController(
      duration: Duration(
        milliseconds: 600,
      ),
      vsync: this,
      //upperBound: 60,
    );
    curvedAnimation = CurvedAnimation(
        parent: animationControllerLogo, curve: Curves.easeOutBack);
    animationControllerLogo.forward();
    animationControllerLogo.addListener(() {
      setState(() {});
      //print(curvedAnimation.value);
    });
  }

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
            //activeColor: activeSwitchColor,
            //activeTrackColor: activeSwitchTrackColor,
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
                  // lowerTextColor = Colors.white;

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
                  // lowerTextColor = Colors.blue;
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
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    child: Image.asset('images/logo.png'),
                    height: curvedAnimation.value * 60,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'We Chat',
                      speed: Duration(
                        milliseconds: 200,
                      ),
                      textStyle: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.bold,

                        ///
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                  isRepeatingAnimation: false,
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
              child: AllButtons(
                buttonText: 'Log In',
                buttonColor: Colors.lightBlueAccent,
                buttonTextColor: Colors.white,
                onTap: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: AllButtons(
                buttonText: 'Register',
                buttonTextColor: Colors.black,
                buttonColor: Colors.greenAccent,
                onTap: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
