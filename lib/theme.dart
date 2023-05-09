import 'package:flutter/material.dart';

class Themes {
  static int defaultIndex = 0;
  static List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey
  ];

  static ThemeData changeTheme(int index, bool brightness) {
    return ThemeData(
      colorSchemeSeed: colors[index],
      useMaterial3: true,
      brightness: brightness ? Brightness.dark : Brightness.light,
    );
  }
}
