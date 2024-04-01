import 'package:flutter/material.dart';

SnackBar buildSnackBar(String content, bool status, BuildContext context) {
  return SnackBar(
    content: Text(
      content,
      style: TextStyle(color: Colors.white),
    ),
    duration: Duration(seconds: 2),
    backgroundColor: status ? Colors.green : Colors.red,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
  );
}
