import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

void toast(message) {
  showToast(message,
      textStyle: TextStyle(color: Colors.black, fontSize: 16.0),
      position: ToastPosition.bottom,
      duration: Duration(seconds: 5),
      backgroundColor: Colors.grey[200].withOpacity(0.3));
}
