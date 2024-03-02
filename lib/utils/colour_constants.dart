import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColourConstants {
  static LinearGradient customGradient = const LinearGradient(colors: [
    Color(0xFF3CB371),
    Color(0xFF2E8B57),
    Color(0xFF228B22),
    Color(0xFF006400),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
  static Color greenColor = Colors.greenAccent;
  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;
}

ColourConstants colourConstants = ColourConstants();
