import 'package:color_swatch/data/util/color_util.dart';
import 'package:flutter/material.dart';

class ColorData {
  final String label;
  final String colorCode;
  final Color color;
  late final Color textColor;
  final bool isHeader;

  ColorData(this.label, this.colorCode)
      : color = ColorUtil.codeToColor(colorCode),
        isHeader = false {
    textColor = ColorUtil.invert(color);
  }
  ColorData.header(String header, this.color)
      : label = header,
        isHeader = true,
        colorCode = '' {
    textColor = ColorUtil.invert(color);
  }
}
