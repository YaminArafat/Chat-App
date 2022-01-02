// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePick extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final Function() onPress;

  ImagePick(
      {required this.icon,
      required this.color,
      required this.text,
      required this.onPress});

  dynamic galleryPicker() async {
    try {
      final pickedImg =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImg != null) {
        return File(pickedImg.path);
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  dynamic cameraPicker() async {
    try {
      final pickedImg =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImg != null) {
        return File(pickedImg.path);
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Ubuntu',
              color: color,
              fontSize: 20,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
