// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/constants.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'Profile_Screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        userInfo = currentUser;
      }
    } catch (e) {
      print(e);
    }
  }

  final _auth = FirebaseAuth.instance;
  var userInfo;

  bool verifyPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile Information',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Ubuntu',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          left: 24,
          right: 24,
        ),
        child: Center(
          child: Column(
            children: [
              Hero(
                tag: 'profilePic',
                child: CircleAvatar(
                  // backgroundColor: Colors.blue,
                  radius: 100,
                  backgroundImage: NetworkImage(userInfo.photoURL),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                userInfo.displayName,
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                  fontSize: 40,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.email,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    userInfo.email,
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Colors.blue,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    userInfo.emailVerified ? Icons.check_circle : Icons.cancel,
                    color: userInfo.emailVerified ? Colors.green : Colors.red,
                    size: 17,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    userInfo.emailVerified
                        ? 'E-mail verified'
                        : 'E-mail not verified',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: userInfo.emailVerified ? Colors.green : Colors.red,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: (userInfo.emailVerified)
                        ? null
                        : Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                            ),
                            child: TextButton(
                                // color: Colors.green,
                                child: Text(
                                  'Verify Now',
                                  style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                onPressed: () async {
                                  if (!userInfo.emailVerified) {
                                    await userInfo.sendEmailVerification();
                                    Alert(
                                      context: context,
                                      title: 'Verification E-mail Sent',
                                      desc:
                                          'Check your e-mail & Follow the given link to verify your e-mail.\nThen click the refresh button to get the verification icon',
                                      closeIcon: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                      buttons: [
                                        DialogButton(
                                          color: Colors.green,
                                          width: 100,
                                          height: 30,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Done',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Ubuntu",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                      style: AlertStyle(
                                        titleStyle: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Ubuntu',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
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
                                }),
                          ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  User? refreshedUser = await refreshUser(userInfo);
                  if (refreshedUser != null) {
                    setState(() {
                      userInfo = refreshedUser;
                    });
                  }
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 30,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu',
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _auth.signOut();
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
