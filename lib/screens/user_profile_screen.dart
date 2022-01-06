// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, must_be_immutable, avoid_print, avoid_init_to_null, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/constants.dart';

class UserProfile extends StatefulWidget {
  static String id = '/user_profile_screen';
  late String userData;
  UserProfile({required this.userData});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool loading = false;
  bool imgLoading = true;
  var userInfo;
  String? name, email, phone;
  var img = null;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  void getUserInfo(String _email) async {
    try {
      userInfo = await firebaseFirestore.collection('UserInfo').get();
      for (var user in userInfo!.docs) {
        if (user.data()['Email'] == _email) {
          // print(user.data()['Image']);
          setState(() {
            name = user.data()['First Name'] + ' ' + user.data()['Last Name'];
            email = user.data()['Email'];
            img = NetworkImage(user.data()['Image']);
            phone = user.data()['Mobile No'];
            imgLoading = false;
          });
          break;
        }
      }
    } catch (e) {
      print(e);
      smallErrorMsg(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.userData);
    getUserInfo(widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),*/
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
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 50,
            left: 24,
            right: 24,
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  child: imgLoading
                      ? SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator.adaptive(
                              // backgroundColor: Colors.white,
                              ),
                        )
                      : CircleAvatar(
                          // backgroundColor: Colors.blue,
                          radius: 100,
                          backgroundImage: img,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 90.0,
                              top: 180,
                            ),
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  name ?? 'Loading...',
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
                      color: Colors.red[400],
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      email ?? '',
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      phone ?? '',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 30,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.messenger,
                            size: 15,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Chat',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        Navigator.pop(context);
                        /*Future.delayed(Duration(seconds: 1), () {

                          Navigator.pushNamedAndRemoveUntil(
                              context, WelcomeScreen.id, (route) => false);
                        });*/
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Alert smallErrorMsg(String msg) {
    return Alert(
      context: context,
      title: 'Something Went Wrong!',
      style: alertStyle,
      desc: msg,
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
            'Try Again',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Ubuntu",
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
