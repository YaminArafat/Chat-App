// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables, must_be_immutable, avoid_print, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, avoid_init_to_null

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:we_chat/components/buttons.dart';
import 'package:we_chat/components/image_pick.dart';
import 'package:we_chat/components/textfields.dart';
import 'package:we_chat/constants.dart';
import 'package:we_chat/screens/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? errorImg;
  String? errorFirstName;
  String? errorLastName;
  String? errorEmail;
  String? errorMobile;
  String? errorPassword;
  String? errorConfirmPassword;

  String? imgUrl;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _mobile;
  String? _password;
  String? _confirmPassword;

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  final _auth = FirebaseAuth.instance;
  final _userInfo = FirebaseFirestore.instance;
  var img = null;
  var imgFile = null;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;
  late ImagePick imagePick;
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
            children: [
              CircleAvatar(
                child: (img == null)
                    ? TextButton(
                        onPressed: () {
                          showPickOptions(context).show();
                        },
                        child: Text(
                          'Add Image',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: imgPickTextColor,
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
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Center(
                  child: Text(
                    (errorImg == null) ? '' : errorImg!,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Ubuntu',
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              TextFields(
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
              TextFields(
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
              TextFields(
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
              TextFields(
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
              TextFields(
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
              TextFields(
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
                child: Buttons(
                  buttonText: 'Register',
                  buttonColor: Colors.greenAccent,
                  buttonTextColor: Colors.black,
                  onTap: () {
                    setState(() {
                      registerUser();
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

  bool regErrorCheck() {
    if (img == null) {
      errorImg = 'User Image Required.';
    } else {
      errorImg = null;
    }
    if (_firstName == null) {
      errorFirstName = 'Name field should not be empty.';
    } else {
      errorFirstName = null;
    }
    if (_lastName == null) {
      errorLastName = 'Name field should not be empty.';
    } else {
      errorLastName = null;
    }
    if (_email == null) {
      errorEmail = 'Email required.';
    } else {
      errorEmail = null;
    }
    if (_mobile == null) {
      errorMobile = 'Contact details required.';
    } else {
      errorMobile = null;
    }
    if (_password == null) {
      errorPassword = 'Password required.';
    } else {
      if (_password!.length < 8) {
        errorPassword = 'Password length must be minimum 8.';
      } else {
        errorPassword = null;
      }
    }
    if (_confirmPassword == null) {
      errorConfirmPassword = 'Confirm your password.';
    } else {
      if (_confirmPassword != _password) {
        errorConfirmPassword = 'Password did not match';
      } else if (errorImg == null &&
          errorFirstName == null &&
          errorLastName == null &&
          errorEmail == null &&
          errorMobile == null &&
          errorPassword == null) {
        errorConfirmPassword = null;
        return true;
      } else {
        errorConfirmPassword = null;
        return false;
      }
    }
    return false;
  }

  void registerUser() async {
    if (regErrorCheck()) {
      try {
        setState(() {
          loading = true;
        });
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email!, password: _password!);
        var newUser = user.user;
        if (newUser != null) {
          await newUser.updateDisplayName(_firstName! + ' ' + _lastName!);
          Reference imgReference =
              firebaseStorage.ref().child('UserImages/$_email');
          UploadTask uploadTask = imgReference.putFile(imgFile);
          TaskSnapshot taskSnapshot = await uploadTask;
          String url = await taskSnapshot.ref.getDownloadURL();
          if (url != null) {
            setState(() {
              imgUrl = url;
            });
          }
          print(imgUrl);
          await newUser.updatePhotoURL(imgUrl);
          User? refreshedUser = await refreshUser(newUser);
          if (refreshedUser != null) {
            setState(() {
              newUser = refreshedUser;
            });
          }
          if (newUser != null) {
            _userInfo.collection("UserInfo").add({
              'UserID': newUser!.uid,
              'Image': newUser!.photoURL,
              'Email': _email,
              'First Name': _firstName,
              'Last Name': _lastName,
              'Mobile No': '+88' + _mobile!,
              'Password': _password,
            });
          }
          Navigator.popAndPushNamed(context, LoginScreen.id);
          setState(() {
            loading = false;
          });
        }
      } on FirebaseException catch (e) {
        print(e);
        String errorMsg = e.toString(); //.substring(30);
        userCreationError(errorMsg).show();
      }
    }
  }

  Alert userCreationError(String errorMsg) {
    return Alert(
      context: context,
      title: 'Registration Unsuccessful!!',
      desc: errorMsg,
      closeIcon: Icon(
        Icons.close,
        color: Colors.black,
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
      style: alertStyle,
    );
  }

  Alert showPickOptions(BuildContext context) {
    return Alert(
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
          child: Row(
            children: [
              Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Ubuntu",
                  color: Colors.white,
                ),
              ),
            ],
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
              ImagePick(
                icon: Icons.account_box_outlined,
                color: Colors.green,
                text: 'Gallery',
                onPress: () async {
                  setState(() async {
                    imgFile = await imagePick.galleryPicker();
                    img = Image.file(imgFile).image;
                  });
                  Navigator.pop(context);
                },
              ),
              ImagePick(
                icon: Icons.camera_alt_outlined,
                color: Colors.blueGrey,
                text: 'Camera',
                onPress: () async {
                  setState(() async {
                    imgFile = await imagePick.cameraPicker();
                    img = Image.file(imgFile).image;
                  });
                  Navigator.pop(context);
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
    );
  }
}
