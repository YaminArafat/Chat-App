// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/login_screen.dart';

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
    print(userInfo.phoneNumber);
  }

  bool imgLoading = true;
  bool loading = false;
  void getCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        userInfo = currentUser;

        await getPhoneNum();
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            imgLoading = false;
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  bool isVerified = false;
  late String verifySmsCode;
  Future<void> phoneVerification() async {
    print(_mobile);
    await _auth.verifyPhoneNumber(
      phoneNumber: _mobile,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        Navigator.pop(context);
        print('in');
        //await _auth.signInWithCredential(phoneAuthCredential);
        // await linkPhoneWithEmail(phoneAuthCredential);
        await userInfo.linkWithCredential(phoneAuthCredential);
        User? refreshedUser = await refreshUser(userInfo);
        if (refreshedUser != null) {
          setState(() {
            userInfo = refreshedUser;
          });
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
        print('Aalif');
      },
      codeSent: (String verificationId, int? resendToken) async {
        Alert(
          context: context,
          title: 'Verification OTP Sent',
          desc:
              'Check your messages & write the OTP code here.\nThen click the refresh button to get the verification icon',
          closeIcon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          content: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    verifySmsCode = value;
                  });
                }
              },
              style: TextStyle(
                color: inputTextColor,
                fontFamily: 'Ubuntu',
                fontSize: 20,
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
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: borderColor,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(Icons.security),
                hintText: 'Enter OTP Code Here',
                hintStyle: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 20,
                  color: hintTextColor,
                ),
              ),
              cursorColor: cursorColor,
            ),
          ),
          buttons: [
            DialogButton(
              color: Colors.green,
              width: 100,
              height: 30,
              onPressed: () {
                try {
                  /*PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: verifySmsCode);
                  // await _auth.signInWithCredential(phoneAuthCredential);
                  await userInfo.linkWithCredential(phoneAuthCredential);
                  // await linkPhoneWithEmail(phoneAuthCredential);*/
                  setState(() {
                    isVerified = true;
                  });
                } catch (e) {
                  print(e);
                  print('Aalif 2');
                }
                if (isVerified) {
                  Navigator.pop(context);
                }
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
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //Navigator.pop(context);
        Alert(
          context: context,
          title: 'Timed Out!!',
          desc: 'Timed out waiting for SMS.',
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
        ).show();
      },
    );
  }

  /*Future<void> linkPhoneWithEmail(
      PhoneAuthCredential phoneAuthCredential) async {
    final AuthCredential authCredential = EmailAuthProvider.credential(
        email: userInfo.email, password: _password);
    final UserCredential userCredential =
        await _auth.signInWithCredential(authCredential);
    await userInfo.linkWithCredential(phoneAuthCredential);
    // await userCredential.user!.linkWithCredential(phoneAuthCredential);
    // await userCredential.user!.linkWithPhoneNumber(_mobile);
  }*/

  Future<String> getPhoneNum() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var users = await firebaseFirestore.collection('UserInfo').get();
    String? phoneNum; // password;
    for (var user in users.docs) {
      if (user.data()['UserID'] == userInfo.uid) {
        phoneNum = user.data()['Mobile No'];
        // password = user.data()['Password'];
        setState(() {
          _mobile = phoneNum!;
          // _password = password!;
        });
        break;
        // print(user.data()['Mobile No']);
      }
    }
    phoneNum ??= 'Mobile number not available';
    return phoneNum;
  }

  final _auth = FirebaseAuth.instance;
  var userInfo;

  late String _mobile;
  //late String _password;
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
