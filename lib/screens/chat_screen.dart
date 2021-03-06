// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_init_to_null, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/myprofile_screen.dart';
import 'package:we_chat/screens/user_profile_screen.dart';
import 'package:we_chat/screens/welcome_screen.dart';

class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  late String conversationData;
  ChatScreen({required this.conversationData});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser = null;
  bool loading = false;
  bool imgLoading = true;
  String? curUserText;
  String? name, email, phone, conversationId;
  var img = null;
  ImageProvider<Object>? curUserImg, userImg;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late var userInfo = null;
  TextEditingController textEditingController = TextEditingController();
  // bool showTime = false;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextButton(
          onPressed: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
            if (email != null) {
              try {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UserProfile(userData: email!);
                }));
              } catch (e) {
                print(e);
                smallErrorMsg(e.toString());
              }
            }
          },
          child: Row(
            children: [
              SizedBox(
                child: imgLoading
                    ? SizedBox(
                        height: 5,
                        width: 5,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 15,
                        backgroundImage: img,
                      ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                name ?? 'Loading...',
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
              if (value == 2) {
                setState(() {
                  loading = true;
                });
                Future.delayed(Duration(seconds: 1), () {
                  _auth.signOut();
                  setState(() {
                    loading = false;
                  });
                  Navigator.pushNamedAndRemoveUntil(
                      context, WelcomeScreen.id, (route) => false);
                });
              } else {
                Navigator.pushNamed(context, ProfileScreen.id);
              }
            },
            color: Colors.white,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(width: 1, color: Colors.blueGrey),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.perm_identity,
                      color: Colors.blueAccent,
                    ),
                    Text(
                      'My Profile',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.subdirectory_arrow_left_outlined,
                      color: Colors.redAccent,
                    ),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        //centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    reverse: true,
                    children: [
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: firebaseFirestore
                            .collection('$conversationId')
                            .orderBy('createdAt', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Widget> chatHistory = [];
                          if (snapshot.hasData) {
                            try {
                              for (var message in snapshot.data!.docs) {
                                if (message.data()['sender'] ==
                                    loggedInUser.email) {
                                  chatHistory.add(showCurUserText(
                                      message.data()['text'],
                                      message.data()['createdAt']));
                                } else {
                                  /*chatHistory.add(getUserInfo(
                                      message.data()['sender'],
                                      message.data()['text'],
                                      message.data()['createdAt']));*/
                                  chatHistory.add(showUserText(
                                      email,
                                      message.data()['text'],
                                      message.data()['createdAt']));
                                }
                              }
                              return Column(
                                children: chatHistory,
                              );
                            } catch (e) {
                              print(e);
                              return Center(
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'No Data Found!',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 30,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.,
                    children: [
                      Expanded(
                        child: TextField(
                          onTap: () {
                            scrollController.animateTo(
                                scrollController.position.minScrollExtent,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut);
                          },
                          controller: textEditingController,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                curUserText = value;
                              });
                            }
                          },
                          style: TextStyle(
                            color: inputTextColor,
                            fontFamily: 'Ubuntu',
                            fontSize: 15,
                          ),
                          cursorHeight: 20,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
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
                            prefixIcon: Icon(
                              Icons.message_outlined,
                              color: iconColor,
                            ),
                            hintText: 'Enter Message Here',
                            hintStyle: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                              color: hintTextColor,
                            ),
                          ),
                          cursorColor: cursorColor,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        onPressed: () {
                          textEditingController.clear();
                          textEditingController.clearComposing();
                          storeMessage();
                          scrollController.animateTo(
                              scrollController.position.minScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getCurrentUser(String _email) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        curUserImg = NetworkImage(loggedInUser.photoURL);
        /*Future.delayed(Duration(seconds: 2), () {
          setState(() {
            imgLoading = false;
          });
        });*/
        userInfo = await firebaseFirestore.collection("UserInfo").get();
        List<String> chatId = [
          loggedInUser.email,
          _email,
        ];
        chatId.sort();
        for (var user in userInfo!.docs) {
          if (user.data()['Email'] == _email) {
            // print(user.data()['Image']);
            setState(() {
              name = user.data()['First Name'] + ' ' + user.data()['Last Name'];
              email = user.data()['Email'];
              img = NetworkImage(user.data()['Image']);
              phone = user.data()['Mobile No'];
              imgLoading = false;
              conversationId = chatId[0] + '-' + chatId[1];
            });
            firebaseFirestore.collection('$conversationId').get();
            break;
          }
        }
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
      logInError(context, e).show();
    }
  }

  void modeCheck() {
    setState(() {
      if (isDarkMode) {
        backgroundColor = Colors.black;
        inputTextColor = Colors.white;
        hintTextColor = Colors.white60;
        iconColor = Colors.white60;
        borderColor = Colors.white;
        cursorColor = Colors.white;
        imgPickTextColor = Colors.black;
        msgCardColorMe = Colors.green;
        msgCardColorU = Colors.deepPurpleAccent;
        msgTextColor = Colors.white;
      } else {
        backgroundColor = Colors.white;
        inputTextColor = Colors.black;
        hintTextColor = Colors.black45;
        iconColor = Colors.black45;
        borderColor = Colors.black;
        cursorColor = Colors.black;
        imgPickTextColor = Colors.white;
        msgCardColorMe = Colors.orange[50];
        msgCardColorU = Colors.cyan[50];
        msgTextColor = Colors.black;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    modeCheck();
    getCurrentUser(widget.conversationData);
    // getUserInfo(widget.conversationData);
  }

  void storeMessage() {
    try {
      firebaseFirestore.collection("$conversationId").add({
        'sender': loggedInUser.email,
        'text': curUserText,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print(e);
      smallErrorMsg(e.toString());
    }
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

  /*Future<Widget?> loadMessage() async {
    try {
      await for (var snapshot
          in firebaseFirestore.collection('messages').snapshots()) {
        for (var message in snapshot.docs) {
          return getUserInfo(message.data()['sender'], message.data()['text'], message.data()['createdAt']);
        }
      }
    } catch (e) {
      print(e);
      smallErrorMsg(e.toString());
    }
  }*/

  Widget showCurUserText(String text, Timestamp createdAt) {
    DateTime timeData = createdAt.toDate();
    DateTime currDateTime = DateTime.now();
    String timeOnly = DateFormat('hh:mm a').format(timeData);
    String dateTime = DateFormat('hh:mm a, dd/MM/yyyy').format(timeData);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: GestureDetector(
                  /*onTap: () {
                    setState(() {
                      showTime = !showTime;
                    });
                  },*/
                  child: Container(
                    decoration: BoxDecoration(
                      color: msgCardColorMe,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: msgTextColor,
                          fontFamily: 'Ubuntu',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                currDateTime.difference(timeData).inDays == 1
                    ? dateTime
                    : timeOnly,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontFamily: 'Ubuntu',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic getUserInfo(String email, String text, Timestamp createdAt) {
    try {
      for (var user in userInfo!.docs) {
        if (user.data()['Email'] == email) {
          // print(user.data()['Image']);
          return showUserText(user, text, createdAt);
        }
      }
    } catch (e) {
      print(e);
      smallErrorMsg(e.toString());
    }
  }

  Widget showUserText(var user, String text, Timestamp createdAt) {
    DateTime timeData = createdAt.toDate();
    DateTime currDateTime = DateTime.now();
    String timeOnly = DateFormat('hh:mm a').format(timeData);
    String dateTime = DateFormat('hh:mm a, dd/MM/yyyy').format(timeData);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundImage: img,
              ),
              SizedBox(
                width: 5,
              ),
              Flexible(
                child: GestureDetector(
                  /*onTap: () {
                    setState(() {
                      showTime = !showTime;
                    });
                  },*/
                  child: Container(
                    decoration: BoxDecoration(
                      color: msgCardColorU,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: msgTextColor,
                          fontFamily: 'Ubuntu',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                currDateTime.difference(timeData).inDays == 1
                    ? dateTime
                    : timeOnly,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontFamily: 'Ubuntu',
                ),
              ),
            ),
          ),
        ],
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
        Navigator.pushNamedAndRemoveUntil(
            context, WelcomeScreen.id, (route) => false);
      },
      buttons: [
        DialogButton(
          color: Colors.green,
          width: 200,
          height: 30,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, WelcomeScreen.id, (route) => false);
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
