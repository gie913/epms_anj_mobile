import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushBarManager {

  static showFlushBarSuccess(BuildContext context, String title, String message) {
    Flushbar(
      message: "$message",
      title: "$title",
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.check_circle),
      ),
      flushbarStyle: FlushbarStyle.GROUNDED,
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.green,
    ).show(context);
  }

  static showFlushBarError(BuildContext context, String title, String message) {
    Flushbar(
      message: "$message",
      title: "$title",
      icon: Icon(Icons.block),
      flushbarStyle: FlushbarStyle.GROUNDED,
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.red,
    ).show(context);
  }

  static showFlushBarWarning(BuildContext context, String title, String message) {
    Flushbar(
      message: "$message",
      title: "$title",
      icon: Icon(Icons.warning_rounded),
      flushbarStyle: FlushbarStyle.GROUNDED,
      messageColor: Colors.black,
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.amber,
    ).show(context);
  }
}
