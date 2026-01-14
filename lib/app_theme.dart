import 'package:flutter/material.dart';

class AppTheme {
  static const teal = Colors.teal;
  static const orange = Colors.orange;

  static ThemeData theme = ThemeData(
    primaryColor: teal,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: teal,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: orange,
    ),
  );
}
