import 'package:flutter/material.dart';

class LightTheme {
  LightTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      secondary:  Color(0xFF6C63FF),
      surface: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.black,
    ),

    tabBarTheme: TabBarThemeData(
      labelColor:  Color(0xFF6C63FF),
      unselectedLabelColor: Colors.grey[400],
      indicatorColor:  Color(0xFF6C63FF),
      indicatorSize: TabBarIndicatorSize.tab,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F5F5),
      elevation: 1,
      iconTheme: IconThemeData(color:  Color(0xFF6C63FF)),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}