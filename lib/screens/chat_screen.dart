// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_init_to_null, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/profile_screen.dart';

class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser = null;
  bool loading = false;
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
      logInError(context, e).show();
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextButton(
          onPressed: () {
            try {
              Navigator.pushNamed(context, ProfileScreen.id);
            } catch (e) {
              print(e);
              logInError(context, e).show();
            }
          },
          child: Row(
            children: [
              Hero(
                tag: 'profilePic',
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(loggedInUser.photoURL),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                loggedInUser.displayName,
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            elevation: 10,
            tooltip: 'Menu',
            onSelected: (value) {
              setState(() {
                loading = true;
              });
              if (value == 1) {
                // Navigator.pop(context);
                _auth.signOut();
                setState(() {
                  loading = false;
                });
                Navigator.pop(context);
              }
            },
            color: Colors.orangeAccent,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(width: 1, color: Colors.blueGrey),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
        //centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Padding(
          padding: EdgeInsets.only(
            top: 50,
            left: 24,
            right: 24,
          ),
        ),
      ),
    );
  }

  Alert logInError(BuildContext context, Object e) {
    return Alert(
      context: context,
      title: 'Something Went Wrong',
      desc: e.toString(),
      closeIcon: Icon(
        Icons.close,
        color: Colors.black,
      ),
      closeFunction: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      buttons: [
        DialogButton(
          color: Colors.green,
          width: 200,
          height: 30,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(
            'Log Out & Try Again',
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
    );
  }
}
