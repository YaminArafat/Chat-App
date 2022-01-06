// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/constants.dart';
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
  List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.messenger_outline), label: 'Messages'),
    BottomNavigationBarItem(
        icon: Icon(Icons.people_alt), label: 'Active Friends'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find Friends'),
  ];
  late var curStream;
  late var activeFriendsStream;
  late var conversations;
  late var curUserFriends;
  List<Widget> curItems = [];
  List<Widget> messages = [
    Text(
      'Your Messages',
    ),
  ];
  List<Widget> activeFriends = [
    Text(
      'Active Friends',
    ),
  ];

  List<Widget> removeIfFriend(String email, List<Widget> findFriends) {
    for (var friend in curUserFriends!.docs) {
      if (email == friend.data()['Friend Email']) {
        findFriends.removeWhere((element) => element.key == Key(email));
        break;
      }
    }
    return findFriends;
  }

  Column findFriendsStream() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'My Friends',
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
                      .collection('${loggedInUser.email}')
                      //.orderBy('First Name', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Widget> friends = [];
                    if (snapshot.hasData) {
                      try {
                        for (var friend in snapshot.data!.docs) {
                          if (friend.data()['Friend Email'] !=
                              loggedInUser.email) {
                            friends.add(Padding(
                              key: Key(friend.data()['Friend Email']),
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
                        return Center(
                          child: Text(
                            'No Friends Added Yet.',
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontFamily: 'Ubuntu',
                              fontSize: 10,
                            ),
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                          style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontFamily: 'Ubuntu',
                              fontSize: 20),
                        ),
                      );
                    } else {
                      return Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator.adaptive(
                                // backgroundColor: Colors.blue,
                                )),
                      );
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
        Column(
          children: [
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: firebaseFirestore
                      .collection('UserInfo')
                      .orderBy('First Name', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Widget> findFriends = [];
                    List<Widget> conversations = [];
                    List<Widget> activeFriends = [];
                    List<Widget> display = [];
                    if (snapshot.hasData) {
                      try {
                        for (var user in snapshot.data!.docs) {
                          if (user.data()['Email'] != loggedInUser.email) {
                            findFriends.add(Padding(
                              key: Key(user.data()['Email']),
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ProfileScreen.id);
                                },
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          NetworkImage(user.data()['Image']),
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
                                        onPressed: () {
                                          firebaseFirestore
                                              .collection(
                                                  '${loggedInUser.email}')
                                              .add({
                                            'Friend Email':
                                                user.data()['Email'],
                                            'Friend Name':
                                                user.data()['First Name'] +
                                                    ' ' +
                                                    user.data()['Last Name'],
                                            'Friend Image':
                                                user.data()['Image'],
                                          });
                                          Navigator.restorablePopAndPushNamed(
                                              context, HomeScreen.id);
                                          //setState(() {});
                                        },
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
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )),
                                    //checkIfFriend(user.data()['Email']),
                                  ],
                                ),
                              ),
                            ));
                            /*findFriends =
                                removeIfFriend(user.data()['Email'], findFriends);*/
                            for (var friend in curUserFriends!.docs) {
                              if (user.data()['Email'] ==
                                  friend.data()['Friend Email']) {
                                findFriends.removeWhere((element) =>
                                    element.key == Key(user.data()['Email']));
                              }
                            }
                          }
                        }
                        return Column(
                          children: findFriends,
                        );
                      } catch (e) {
                        print(e);
                        return Center(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator.adaptive(
                                  // backgroundColor: Colors.blue,
                                  )),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Ubuntu',
                              fontSize: 20),
                        ),
                      );
                    } else {
                      return Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator.adaptive(
                                // backgroundColor: Colors.blue,
                                )),
                      );
                    }
                  }),
            ),
          ],
        ),
      ],
    );
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
        showUnselectedLabels: false,
        items: bottomNavBarItems,
        currentIndex: curIndex,
        onTap: (index) {
          if (index == 0) {
            setState(() {
              //curStream = conversations;
              curIndex = index;
            });
          } else if (index == 1) {
            setState(() {
              //curStream = activeFriendsStream;
              curIndex = index;
            });
          } else {
            setState(() {
              curStream = findFriendsStream;
              curIndex = index;
            });
          }
        },
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Ubuntu',
        ),
        selectedLabelStyle: TextStyle(
          fontFamily: 'Ubuntu',
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: findFriendsStream(),
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
