import 'package:flutter/material.dart';

abstract class AppColor {}

abstract class _SpatiumColor {
  //Blue
  static const int _bluePrimaryValue = 0xFF1D2957;

  static const MaterialColor blue =
      MaterialColor(_bluePrimaryValue, <int, Color>{
        50: Color(0xFFE3E6F0),
        100: Color(0xFFB9C3DB),
        200: Color(0xFF8A9FC1),
        300: Color(0xFF5C7BA7),
        400: Color(0xFF375992),
        500: Color(_bluePrimaryValue),
        600: Color(0xFF19254F),
        700: Color(0xFF121D40),
        800: Color(0xFF0B142F),
        900: Color(0xFF030A1C),
      });
}
