import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static Color blendColors(int from, int to, double ratio) {
    var inverseRatio = 1 - ratio;
    var colorFrom = Color(from);
    var colorTo = Color(to);
    var r = colorTo.red * ratio + colorFrom.red * inverseRatio;
    var b = colorTo.blue * ratio + colorFrom.blue * inverseRatio;
    var g = colorTo.green * ratio + colorFrom.green * inverseRatio;
    return Color.fromARGB(255, r.toInt(), g.toInt(), b.toInt());
  }

  static String formatNumber(int number) {
    final formatter = new NumberFormat("#,###,###");
    return formatter.format(number).replaceAll(",", ".") + "đ";
  }
}
