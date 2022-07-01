import 'package:flutter/material.dart';
import 'package:playground_ifma/theme/constants.dart';

class Message {
  static void showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Style.primaryColor,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, letterSpacing: 0.5),
        ),
      ),
    );
  }

  static void showError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 17, color: Colors.white, letterSpacing: 0.5),
        ),
      ),
    );
  }
}
