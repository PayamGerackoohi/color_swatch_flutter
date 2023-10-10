import 'dart:math';

import 'package:flutter/material.dart';

class ColorUtil {
  static Color invert(Color color) {
    double x = cos(pi * color.computeLuminance());
    x = x.sign * pow(x.abs(), 1 / 8).toDouble();
    x = (1 + x) / 2;
    int lum = (x * 0xff).toInt();
    return Color.fromARGB(0xff, lum, lum, lum);
  }

  static Color codeToColor(String colorCode) =>
      Color(int.parse(colorCode, radix: 16) | 0xff000000);
}
