import 'package:flutter/material.dart';

class Style {
  static const subtitleTextStyle = TextStyle(
    // color: Colors.black54,
    fontSize: 23,
    // fontWeight: FontWeight.w400,
  );

  static const cardTexStyle =
      TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold);

  static const defaultTextStyle = TextStyle(
    fontSize: 17,
  );

  // static const smallerSubTextStyle = TextStyle(
  //   color: Colors.black54,
  //   fontSize: 20,
  //   fontWeight: FontWeight.normal,
  // );

  // static const captionSubTextStyle = TextStyle(
  //   color: Colors.grey,
  //   fontSize: 18,
  //   fontWeight: FontWeight.bold,
  // );

  // static const titleTextStyle = TextStyle(
  //   color: Colors.teal,
  //   fontSize: 24,
  //   fontWeight: FontWeight.w400,
  // );

  // static const titleTextTwo = TextStyle(
  //   color: Color(0xFF1C1C1C),
  //   fontSize: 18,
  //   fontWeight: FontWeight.w400,
  // );

  // static const titleTextBoldStyle = TextStyle(
  //   color: Colors.black,
  //   fontSize: 24,
  //   fontWeight: FontWeight.w800,
  // );

  // static const titleTextBlackStyle = TextStyle(
  //   color: Color.fromRGBO(19, 19, 19, 1.0),
  //   fontSize: 24,
  // );

  // static const appBarTitleTextStyle = TextStyle(
  //   color: Colors.teal,
  //   fontSize: 20,
  //   fontWeight: FontWeight.w400,
  // );

static var divider = const Divider(
    height: 10,
    thickness: 3,
    color: Style.borderColor,
  );
  
  static const sizedBox = SizedBox(width: 30, height: 30);

  static const formSizedBox = SizedBox(width: 10, height: 10);

  static const subtitlePadding = EdgeInsets.only(bottom: 30.0);

  static const double padding = 10;

  static const buttonTextStyle = TextStyle(fontSize: 18, color: Colors.white);
  static const double buttonHeight = 50;

  static final BorderRadius borderRadius = BorderRadius.circular(10);
  static final boxDecoration = BoxDecoration(
      border: Border.all(color: borderColor), borderRadius: borderRadius);

  static const primaryColor = Colors.teal;
  static const secondaryColor = Colors.tealAccent;
  static const borderColor = Colors.grey;
}
