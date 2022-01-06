// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:we_chat/screens/login_screen.dart';
import 'package:we_chat/screens/myprofile_screen.dart';
import 'package:we_chat/screens/registration_screen.dart';
import 'package:we_chat/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        //ChatScreen.id: (context) => ChatScreen(conversationData: '',),
        ProfileScreen.id: (context) => ProfileScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        // UserProfile.id:(context)=>UserProfile(userData: ''),
      },
    );
  }
}
