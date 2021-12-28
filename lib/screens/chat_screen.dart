// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_init_to_null, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser = null;
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  List<PopupMenuEntry<Text>> popUpMenuItems = [
    PopupMenuItem(
      child: Text(
        'Log Out',
        style: TextStyle(
          fontFamily: 'Ubuntu',
        ),
      ),
    ),
    PopupMenuItem(
      child: Text(
        'My Profile',
        style: TextStyle(
          fontFamily: 'Ubuntu',
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.perm_identity,
        ),
        title: Text(
          'We Chat',
          style: TextStyle(
            fontFamily: 'Ubuntu',
          ),
        ),
        actions: [
          PopupMenuButton(
            tooltip: 'Menu',
            onSelected: (value) {
              if (value == 1) {
                // Navigator.pop(context);
                _auth.signOut();
                Navigator.pop(context);
              } else {
                ///
              }
            },
            color: Colors.blueAccent,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.blue)),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  'My Profile',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
    );
  }
}
