import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SexData{
  IconData icon;
  Color? color;

  SexData({required this.icon,}) {
    color = determineSexColor(icon);
  }

  Color? determineSexColor(IconData icon) {
    Color? result = Colors.red;

    if(icon == Icons.male) {
      result = Colors.lightBlue;
    }
    return result;
  }
}