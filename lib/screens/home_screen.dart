// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_typing_uninitialized_variables, unused_local_variable, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/chat_screen.dart';
import 'package:we_chat/screens/myprofile_screen.dart';
import 'package:we_chat/screens/user_profile_screen.dart';
import 'package:we_chat/screens/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = '/home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  bool imgLoading = true;
  ImageProvider<Object>? curUserImg, userImg;
  final _auth = FirebaseAuth.instance;
  late var loggedInUser;
  late var userInfo;
  int curIndex = 0;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool isRequested = false;
  List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.messenger_outline), label: 'Messages'),
    BottomNavigationBarItem(
        icon: Icon(Icons.people_alt), label: 'Active Friends'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find Friends'),
  ];
  late var curUserFriends;
  late var sentRequests;
  Function()? friendRequestAction(var user) {
    return () {
      firebaseFirestore.collection('${loggedInUser.email}-sent').add({
        'Friend Email': user.data()['Email'],
        'Friend Name':
            user.data()['First Name'] + ' ' + user.data()['Last Name'],
        'Friend Image': user.data()['Image'],
      });
      firebaseFirestore.collection('${user.data()['Email']}-requests').add({
        'Friend Email': loggedInUser.email,
        'Friend Name': loggedInUser.displayName,
        'Friend Image': loggedInUser.photoURL,
      });
      setState(() {
        curIndex = 2;
        isRequested = true;
      });
      // Navigator.pushReplacementNamed(context, HomeScreen.id);
    };
  }

  bool showRequests = false;
  Column findFriendsStream() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showRequests = false;
                });
              },
              child: Text(
                'My Friends',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu',
                  fontSize: 20,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showRequests = true;
                });
              },
              child: Text(
                'Requests',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu',
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.grey,
        ),
        showRequests
            ? Column(
                children: [
                  SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: firebaseFirestore
                            .collection('${loggedInUser.email}-requests')
                            .orderBy('Friend Name', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Widget> friends = [];
                          if (snapshot.hasData) {
                            try {
                              for (var friend in snapshot.data!.docs) {
                                if (friend.data()['Friend Email'] !=
                                    loggedInUser.email) {
                                  friends.add(Padding(
                                    // key: Key(friend.data()['Friend Email']),
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        ///
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UserProfile(
                                            userData:
                                                friend.data()['Friend Email'],
                                          );
                                        }));
                                      },
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                friend.data()['Friend Image']),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  friend.data()['Friend Name'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Ubuntu',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orangeAccent,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.email,
                                                      color: Colors.redAccent,
                                                      size: 12,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        friend.data()[
                                                            'Friend Email'],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Ubuntu',
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          DialogButton(
                                              color: Colors.green,
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        '${loggedInUser.email}-friends')
                                                    .add({
                                                  'Friend Email': friend
                                                      .data()['Friend Email'],
                                                  'Friend Name': friend
                                                      .data()['Friend Name'],
                                                  'Friend Image': friend
                                                      .data()['Friend Image'],
                                                });
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        '${friend.data()['Friend Email']}-friends')
                                                    .add({
                                                  'Friend Email':
                                                      loggedInUser.email,
                                                  'Friend Name':
                                                      loggedInUser.displayName,
                                                  'Friend Image':
                                                      loggedInUser.photoURL,
                                                });
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        '${loggedInUser.email}-requests')
                                                    .where("Friend Email",
                                                        isEqualTo:
                                                            friend.data()[
                                                                'Friend Email'])
                                                    .get()
                                                    .then((value) {
                                                  value.docs.forEach((element) {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            '${loggedInUser.email}-requests')
                                                        .doc(element.id)
                                                        .delete()
                                                        .then((value) {
                                                      print("Success!");
                                                    });
                                                  });
                                                });
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        '${friend.data()['Friend Email']}-sent')
                                                    .where("Friend Email",
                                                        isEqualTo:
                                                            loggedInUser.email)
                                                    .get()
                                                    .then((value) {
                                                  value.docs.forEach((element) {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            '${friend.data()['Friend Email']}-sent')
                                                        .doc(element.id)
                                                        .delete()
                                                        .then((value) {
                                                      print("Success!");
                                                    });
                                                  });
                                                });
                                                getCurrentUserFriends();
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ));
                                }
                              }
                              return Column(
                                children: friends,
                              );
                            } catch (e) {
                              print(e);
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No Requests',
                                      style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 10,
                                      ),
                                    ),
                                  ]);
                            }
                          } else if (snapshot.hasError) {
                            print(snapshot.error.toString());
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'No Friends Added Yet.',
                                    style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 10,
                                    ),
                                  ),
                                ]);
                          } else {
                            return Column(children: [
                              SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator.adaptive(
                                      // backgroundColor: Colors.blue,
                                      )),
                            ]);
                          }
                        }),
                  ),
                ],
              )
            : Column(
                children: [
                  SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: firebaseFirestore
                            .collection('${loggedInUser.email}-friends')
                            .orderBy('Friend Name', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Widget> friends = [];
                          if (snapshot.hasData) {
                            try {
                              for (var friend in snapshot.data!.docs) {
                                if (friend.data()['Friend Email'] !=
                                    loggedInUser.email) {
                                  friends.add(Padding(
                                    // key: Key(friend.data()['Friend Email']),
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        ///
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UserProfile(
                                            userData:
                                                friend.data()['Friend Email'],
                                          );
                                        }));
                                      },
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                friend.data()['Friend Image']),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  friend.data()['Friend Name'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Ubuntu',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orangeAccent,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.email,
                                                      color: Colors.redAccent,
                                                      size: 12,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        friend.data()[
                                                            'Friend Email'],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Ubuntu',
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          DialogButton(
                                              color: Colors.lightGreen,
                                              onPressed: () {
                                                setState(() {
                                                  curIndex = 0;
                                                });
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ChatScreen(
                                                    conversationData: friend
                                                        .data()['Friend Email'],
                                                  );
                                                }));
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.messenger_outline,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Chat',
                                                    style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ));
                                }
                              }
                              return Column(
                                children: friends,
                              );
                            } catch (e) {
                              print(e);
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No Friends Added Yet.',
                                      style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 10,
                                      ),
                                    ),
                                  ]);
                            }
                          } else if (snapshot.hasError) {
                            print(snapshot.error.toString());
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'No Friends Added Yet.',
                                    style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 10,
                                    ),
                                  ),
                                ]);
                          } else {
                            return Column(children: [
                              SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator.adaptive(
                                      // backgroundColor: Colors.blue,
                                      )),
                            ]);
                          }
                        }),
                  ),
                ],
              ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Suggested Friends',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontFamily: 'Ubuntu',
            fontSize: 20,
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        Expanded(
          child: Column(
            children: [
              SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: firebaseFirestore
                        .collection('UserInfo')
                        .orderBy('First Name', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<Widget> findFriends = [];
                      if (snapshot.hasData) {
                        try {
                          for (var user in snapshot.data!.docs) {
                            if (user.data()['Email'] != loggedInUser.email) {
                              bool alreadyFriend = false;
                              for (var friend in curUserFriends!.docs) {
                                if (user.data()['Email'] ==
                                    friend.data()['Friend Email']) {
                                  setState(() {
                                    alreadyFriend = true;
                                  });
                                  break;
                                }
                              }
                              if (alreadyFriend) {
                                continue;
                              } else {
                                for (var isSent in sentRequests!.docs) {
                                  if (user.data()['Email'] ==
                                      isSent.data()['Friend Email']) {
                                    //setState(() {
                                    isRequested = true;
                                    //});
                                    break;
                                  }
                                }
                                if (isRequested) {
                                  findFriends.add(Padding(
                                    //key: Key(user.data()['Email']),
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UserProfile(
                                              userData: user.data()['Email']);
                                        }));
                                      },
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                user.data()['Image']),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.data()['First Name'] +
                                                      ' ' +
                                                      user.data()['Last Name'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Ubuntu',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orangeAccent,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.email,
                                                      color: Colors.redAccent,
                                                      size: 12,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        user.data()['Email'],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Ubuntu',
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          DialogButton(
                                              color: Colors.grey,
                                              onPressed: null,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.pending,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Sent',
                                                    style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          //checkIfFriend(user.data()['Email']),
                                        ],
                                      ),
                                    ),
                                  ));
                                } else {
                                  findFriends.add(Padding(
                                    //key: Key(user.data()['Email']),
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UserProfile(
                                              userData: user.data()['Email']);
                                        }));
                                      },
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                user.data()['Image']),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.data()['First Name'] +
                                                      ' ' +
                                                      user.data()['Last Name'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Ubuntu',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orangeAccent,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.email,
                                                      color: Colors.redAccent,
                                                      size: 12,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        user.data()['Email'],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Ubuntu',
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          DialogButton(
                                              color: Colors.lightBlue,
                                              onPressed:
                                                  friendRequestAction(user),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.mobile_friendly,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Add Friend',
                                                    style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          //checkIfFriend(user.data()['Email']),
                                        ],
                                      ),
                                    ),
                                  ));
                                }
                              }
                              /*findFriends =
                                  removeIfFriend(user.data()['Email'], findFriends);
                                for (var friend in curUserFriends!.docs) {
                                  if (user.data()['Email'] ==
                                      friend.data()['Friend Email']) {
                                    setState(() {
                                      findFriends.removeWhere((element) =>
                                      element.key ==
                                          Key(user.data()['Email']));
                                    });

                                    break;
                                  }
                                }*/

                            }
                          }
                          return Column(
                            children: findFriends,
                          );
                        } catch (e) {
                          print(e);
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator.adaptive(
                                        // backgroundColor: Colors.blue,
                                        )),
                              ]);
                        }
                      } else if (snapshot.hasError) {
                        print(snapshot.error.toString());
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Not Available Now!',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Ubuntu',
                                    fontSize: 20),
                              ),
                            ]);
                      } else {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator.adaptive(
                                      // backgroundColor: Colors.blue,
                                      )),
                            ]);
                      }
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column activeFriendsStream() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'Active Friends',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontFamily: 'Ubuntu',
            fontSize: 20,
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        Column(
          children: [
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: firebaseFirestore
                      .collection('${loggedInUser.email}-friends')
                      .orderBy('Friend Name', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Widget> friends = [];
                    if (snapshot.hasData) {
                      try {
                        for (var friend in snapshot.data!.docs) {
                          if (friend.data()['Friend Email'] !=
                              loggedInUser.email) {
                            friends.add(Padding(
                              // key: Key(friend.data()['Friend Email']),
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  ///
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UserProfile(
                                      userData: friend.data()['Friend Email'],
                                    );
                                  }));
                                },
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                          friend.data()['Friend Image']),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            friend.data()['Friend Name'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Ubuntu',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orangeAccent,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.email,
                                                color: Colors.redAccent,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  friend.data()['Friend Email'],
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'Ubuntu',
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    DialogButton(
                                        color: Colors.lightGreen,
                                        onPressed: () {
                                          setState(() {
                                            curIndex = 0;
                                          });
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ChatScreen(
                                              conversationData:
                                                  friend.data()['Friend Email'],
                                            );
                                          }));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.messenger_outline,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Chat',
                                              style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ));
                          }
                        }
                        return Column(
                          children: friends,
                        );
                      } catch (e) {
                        print(e);
                        return Column(children: [
                          Text(
                            'No Friends Added Yet.',
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontFamily: 'Ubuntu',
                              fontSize: 10,
                            ),
                          ),
                        ]);
                      }
                    } else if (snapshot.hasError) {
                      return Column(children: [
                        Text(
                          snapshot.error.toString(),
                          style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontFamily: 'Ubuntu',
                              fontSize: 20),
                        ),
                      ]);
                    } else {
                      return Column(children: [
                        SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator.adaptive(
                                // backgroundColor: Colors.blue,
                                )),
                      ]);
                    }
                  }),
            ),
          ],
        ),
      ],
    );
  }

  /*Future<bool> check(String id) async {
    var snapshot = await firebaseFirestore
        .collection("$id")
        .orderBy('createdAt', descending: false)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }*/
  List<String> conversationId = [];
  late Map<String, String> friendEmail, friendImg, friendName;

  void getIds() async {
    try {
      for (var friend in curUserFriends.docs) {
        List<String> chatId = [
          friend.data()['Friend Email'],
          loggedInUser.email,
        ];
        chatId.sort();
        var snapshot = await firebaseFirestore
            .collection("${chatId[0]}-${chatId[1]}")
            .orderBy('createdAt', descending: false)
            .get();
        if (snapshot.docs.isNotEmpty) {
          print('ok');
          setState(() {
            conversationId.add('${chatId[0]}-${chatId[1]}');
            friendEmail['${chatId[0]}-${chatId[1]}'] =
                friend.data()['Friend Email'];
            friendName['${chatId[0]}-${chatId[1]}'] =
                friend.data()['Friend Name'];
            friendImg['${chatId[0]}-${chatId[1]}'] =
                friend.data()['Friend Image'];
          });
        }
      }
    } catch (e) {
      print(e);
      smallErrorMsg(e.toString());
    }
  }

  dynamic conversations() {
    getIds();
    print(conversationId);
    try {
      for (var id in conversationId) {
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firebaseFirestore
              .collection("$id")
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            List<Widget> conversations = [];
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              DateTime timeData =
                  snapshot.data!.docs.last['createdAt'].toDate();
              DateTime currDateTime = DateTime.now();
              String timeOnly = DateFormat('hh:mm a').format(timeData);
              String dateTime = DateFormat('EEE, MMM d y').format(timeData);
              conversations.add(GestureDetector(
                // key: Key(friendEmail['$id']!),
                onTap: () {
                  ///
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatScreen(
                      conversationData: friendEmail['$id']!,
                    );
                  }));
                },
                child: Card(
                  color: Colors.white10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(friendImg['%id']!),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friendName['$id']!,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    snapshot.data!.docs.last['sender'] ==
                                            loggedInUser.email
                                        ? 'You: ' +
                                            snapshot.data!.docs.last['text']
                                        : snapshot.data!.docs.last['text'],
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontFamily: 'Ubuntu',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    currDateTime.difference(timeData).inDays ==
                                            1
                                        ? dateTime
                                        : timeOnly,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontFamily: 'Ubuntu',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
              return Column(
                children: conversations,
              );
            } else {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ]);
            }
          },
        );
      }
    } catch (e) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator.adaptive(
                  // backgroundColor: Colors.blue,
                  )),
        ],
      );
    }
    return Column();
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
              smallErrorMsg(e.toString()).show();
            }
          },
          child: Row(
            children: [
              Hero(
                tag: 'profilePic',
                child: imgLoading
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 15,
                        backgroundImage: curUserImg,
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
                      'Profile',
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        showUnselectedLabels: false,
        items: bottomNavBarItems,
        currentIndex: curIndex,
        onTap: (index) {
          if (index == 0) {
            setState(() {
              curIndex = index;
            });
          } else if (index == 1) {
            setState(() {
              curIndex = index;
            });
          } else {
            setState(() {
              curIndex = index;
            });
          }
        },
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Ubuntu',
          color: Colors.grey,
        ),
        selectedLabelStyle: TextStyle(
          fontFamily: 'Ubuntu',
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: curIndex == 2
              ? findFriendsStream()
              : (curIndex == 1)
                  ? activeFriendsStream()
                  : conversations(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // getCurUserFriends();
  }

  void getCurrentUserFriends() async {
    curUserFriends =
        await firebaseFirestore.collection('${loggedInUser.email}').get();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        curUserImg = NetworkImage(loggedInUser.photoURL);
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            imgLoading = false;
          });
        });
        // userInfo = await firebaseFirestore.collection("UserInfo").get();
        curUserFriends =
            await firebaseFirestore.collection('${loggedInUser.email}').get();
        sentRequests = await firebaseFirestore
            .collection('${loggedInUser.email}-sent')
            .get();
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
      smallErrorMsg(e.toString()).show();
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
}
