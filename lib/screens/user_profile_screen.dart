/*
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:we_chat/constants.dart';

class UserProfile extends StatefulWidget {
  static String id = '/user_profile_screen';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool loading = false;
  bool imgLoading = true;
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
                Hero(
                  tag: 'profilePic',
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
                          backgroundImage: NetworkImage(userInfo.photoURL),
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
                      color: Colors.red[400],
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
                      userInfo.emailVerified
                          ? Icons.verified_user_rounded
                          : Icons.cancel,
                      color: userInfo.emailVerified
                          ? Colors.greenAccent
                          : Colors.red,
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
                        color: userInfo.emailVerified
                            ? Colors.greenAccent
                            : Colors.red,
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
                                      try {
                                        await userInfo.sendEmailVerification();
                                      } catch (e) {
                                        print(e);
                                        smallErrorMsg(e.toString()).show();
                                      }
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
                                        style: alertStyle2,
                                      ).show();
                                    }
                                  }),
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
                    SizedBox(
                      child: userInfo.phoneNumber != null
                          ? Text(
                              userInfo.phoneNumber,
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                color: Colors.blue,
                                fontSize: 20,
                              ),
                            )
                          : FutureBuilder<String>(
                              future: getPhoneNum(),
                              initialData: 'Loading...',
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data != 'Loading...') {
                                  return Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.blue,
                                      fontSize: 20,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    '${snapshot.error}',
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  );
                                } else {
                                  return Row(
                                    children: [
                                      Text(
                                        '${snapshot.data}',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          color: Colors.blue,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                    ],
                                  );
                                }
                              }),
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
                      userInfo.phoneNumber != null
                          ? Icons.verified_user_rounded
                          : Icons.cancel,
                      color: userInfo.phoneNumber != null
                          ? Colors.greenAccent
                          : Colors.red,
                      size: 17,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      userInfo.phoneNumber != null
                          ? 'Number verified'
                          : 'Number not verified',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        color: userInfo.phoneNumber != null
                            ? Colors.greenAccent
                            : Colors.red,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: (userInfo.phoneNumber != null)
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
                                    if (userInfo.phoneNumber == null) {
                                      await phoneVerification();
                                    }
                                  }),
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      imgLoading = true;
                    });
                    User? refreshedUser = await refreshUser(userInfo);
                    if (refreshedUser != null) {
                      setState(() {
                        imgLoading = false;
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
                        setState(() {
                          loading = true;
                        });
                        Future.delayed(Duration(seconds: 1), () {
                          _auth.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginScreen.id, (route) => false);
                        });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
