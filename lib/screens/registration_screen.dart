// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables, must_be_immutable, avoid_print, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, avoid_init_to_null

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/components/all_buttons.dart';
import 'package:we_chat/components/all_textfields.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? errorFirstName;
  String? errorLastName;
  String? errorEmail;
  String? errorMobile;
  String? errorPassword;
  String? errorConfirmPassword;

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _mobile = '';
  String _password = '';
  String _confirmPassword = '';

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  final _auth = FirebaseAuth.instance;
  final _userInfo = FirebaseFirestore.instance;
  bool loading = false;

  void regCheck() async {
    if (_firstName.isEmpty) {
      errorFirstName = 'Name field should not be empty';
    } else {
      errorFirstName = null;
    }
    if (_lastName.isEmpty) {
      errorLastName = 'Name field should not be empty.';
    } else {
      errorLastName = null;
    }
    if (_email.isEmpty) {
      errorEmail = 'Email required.';
    } else {
      errorEmail = null;
    }
    if (_mobile.isEmpty) {
      errorMobile = 'Contact details required.';
    } else {
      errorMobile = null;
    }
    if (_password.isEmpty) {
      errorPassword = 'Password required.';
    } else {
      if (_password.length < 8) {
        errorPassword = 'Password length must be minimum 8.';
      } else {
        errorPassword = null;
      }
    }
    if (_confirmPassword.isEmpty) {
      errorConfirmPassword = 'Confirm your password';
    } else {
      if (_confirmPassword != _password) {
        errorConfirmPassword = 'Password did not match';
      } else if (errorFirstName == null &&
          errorLastName == null &&
          errorEmail == null &&
          errorMobile == null &&
          errorPassword == null) {
        errorConfirmPassword = null;
        try {
          setState(() {
            loading = true;
          });
          UserCredential user = await _auth.createUserWithEmailAndPassword(
              email: _email, password: _password);
          var newUser = user.user;
          if (newUser != null) {
            await newUser.updateDisplayName(_firstName + ' ' + _lastName);
            await newUser.reload();
            _userInfo.collection("UserInfo").add({
              'UserID': newUser.uid,
              'Email': _email,
              'First Name': _firstName,
              'Last Name': _lastName,
              'Mobile No': _mobile,
              'Password': _password,
            });
            Navigator.pushNamed(context, LoginScreen.id);
            setState(() {
              loading = false;
            });
          }
        } catch (e) {
          print(e);
          String errorLogin = e.toString().substring(30);
          Alert(
            context: context,
            title: 'Registration Unsuccessful!!',
            desc: errorLogin,
            closeIcon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            closeFunction: () {
              Navigator.pop(context);
              setState(() {
                loading = false;
              });
            },
            buttons: [
              DialogButton(
                color: Colors.green,
                width: 100,
                height: 30,
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    loading = false;
                  });
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
              backgroundColor: Colors.blueAccent,
              isButtonVisible: true,
              titleStyle: TextStyle(
                color: Colors.redAccent,
                fontFamily: 'Ubuntu',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                //backgroundColor: Colors.orangeAccent,
              ),
              descStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Ubuntu',
              ),
            ),
          ).show();
        }
      } else {
        errorConfirmPassword = null;
      }
    }
  }

  var img = null;
  void galleryPicker() async {
    try {
      final pickedImg =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImg != null) {
        setState(() {
          img = Image.file(
            File(pickedImg.path),
          ).image;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  void cameraPicker() async {
    try {
      final pickedImg =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImg != null) {
        setState(() {
          img = Image.file(
            File(pickedImg.path),
          ).image;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///
      backgroundColor: backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Padding(
          padding: EdgeInsets.only(
            top: 50,
            left: 24,
            right: 24,
          ),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /*Hero(
                tag: 'logo',
                child: SizedBox(
                  child: Image.asset('images/logo.png'),
                  height: 100,
                ),
              ),*/
              CircleAvatar(
                child: (img == null)
                    ? TextButton(
                        onPressed: () {
                          Alert(
                            context: context,
                            title: 'Choose your option',
                            closeIcon: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            buttons: [
                              DialogButton(
                                color: Colors.blueAccent,
                                width: 100,
                                height: 30,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
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
                                fontFamily: 'Ubuntu',
                                fontSize: 20,
                              ),
                            ),
                            content: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.account_box_outlined,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    ImgPickOp(
                                      color: Colors.green,
                                      text: 'Gallery',
                                      onPress: () {
                                        galleryPicker();
                                      },
                                    ),
                                    VerticalDivider(
                                      color: Colors.black,
                                    ),
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.blueGrey,
                                      size: 30,
                                    ),
                                    ImgPickOp(
                                      color: Colors.blueGrey,
                                      text: 'Camera',
                                      onPress: () {
                                        cameraPicker();
                                      },
                                    )
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 2,
                                ),
                              ],
                            ),
                          ).show();
                        },
                        child: Text(
                          'Add Image',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 1.5,
                          ),
                        ),
                      )
                    : null,
                backgroundColor: (img == null) ? Colors.blueAccent : null,
                radius: 100,
                backgroundImage: (img == null) ? null : img,
              ),
              RegInfo(
                icon: Icon(
                  Icons.edit,

                  ///
                  color: iconColor,
                ),
                givenErrorText: errorFirstName,
                givenHintText: 'First Name',
                topPadding: 20,
                onComplete: (value) {
                  setState(() {
                    _firstName = value;
                  });
                },
                isPassword: false,
                togglePassword: false,
                inputType: TextInputType.name,
              ),
              RegInfo(
                icon: Icon(
                  Icons.edit,

                  ///
                  color: iconColor,
                ),
                givenErrorText: errorLastName,
                givenHintText: 'Last Name',
                topPadding: 10,
                onComplete: (value) {
                  setState(() {
                    _lastName = value;
                  });
                },
                isPassword: false,
                togglePassword: false,
                inputType: TextInputType.name,
              ),
              RegInfo(
                icon: Icon(
                  Icons.email_outlined,

                  ///
                  color: iconColor,
                ),
                givenErrorText: errorEmail,
                givenHintText: 'Email',
                topPadding: 10,
                onComplete: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                isPassword: false,
                togglePassword: false,
                inputType: TextInputType.emailAddress,
              ),
              RegInfo(
                icon: Icon(
                  Icons.call,

                  ///
                  color: iconColor,
                ),
                givenErrorText: errorMobile,
                givenHintText: 'Mobile No',
                topPadding: 10,
                onComplete: (value) {
                  setState(() {
                    _mobile = value;
                  });
                },
                isPassword: false,
                togglePassword: false,
                inputType: TextInputType.phone,
              ),
              RegInfo(
                icon: Icon(
                  Icons.password,

                  ///
                  color: iconColor,
                ),
                givenErrorText: errorPassword,
                givenHintText: 'Password',
                topPadding: 10,
                onComplete: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                isPassword: true,
                togglePassword: hidePassword,
                showHidePassword: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
              ),
              RegInfo(
                icon: Icon(
                  Icons.password,

                  ///
                  color: iconColor,
                ),
                givenErrorText: errorConfirmPassword,
                givenHintText: 'Confirm Password',
                topPadding: 10,
                onComplete: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
                isPassword: true,
                togglePassword: hideConfirmPassword,
                showHidePassword: () {
                  setState(() {
                    hideConfirmPassword = !hideConfirmPassword;
                  });
                },
              ),
              /* Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24,
                  top: 4,
                ),
                child: MaterialButton(
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Alert(
                      context: context,
                      title: 'Choose your option',
                      closeIcon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      buttons: [
                        DialogButton(
                          color: Colors.blueAccent,
                          width: 100,
                          height: 30,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
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
                          fontFamily: 'Ubuntu',
                          fontSize: 20,
                        ),
                      ),
                      content: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.account_box_outlined,
                                color: Colors.green,
                                size: 30,
                              ),
                              ImgPickOp(
                                color: Colors.green,
                                text: 'Gallery',
                                onPress: () {
                                  galleryPicker();
                                },
                              ),
                              VerticalDivider(
                                color: Colors.black,
                              ),
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.blueGrey,
                                size: 30,
                              ),
                              ImgPickOp(
                                color: Colors.blueGrey,
                                text: 'Camera',
                                onPress: () {
                                  cameraPicker();
                                },
                              )
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ).show();
                  },
                  color: Colors.lightBlue,
                  child: Text(
                    'Add Image',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: Text(
                        'Already have an account? Sign In',
                        style: TextStyle(
                          color: lowerTextColor,
                          fontFamily: 'Ubuntu',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: AllButtons(
                  buttonText: 'Register',
                  buttonColor: Colors.greenAccent,
                  buttonTextColor: Colors.black,
                  onTap: () {
                    setState(() {
                      regCheck();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImgPickOp extends StatelessWidget {
  final Color color;
  final String text;
  final Function() onPress;

  ImgPickOp({required this.color, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Ubuntu',
          color: color,
          fontSize: 20,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
