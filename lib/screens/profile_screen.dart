// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 100,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                userInfo.displayName,
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
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
                    width: 10,
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
            ],
          ),
        ),
      ),
    );
  }
}
