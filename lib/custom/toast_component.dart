import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ToastComponent {
  static showDialog(String msg, {duration = 0, ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: duration != 0 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: const Color.fromRGBO(239, 239, 239, .9),
      textColor: MyTheme.font_grey,
      fontSize: 14.0,
    );
  }
}
