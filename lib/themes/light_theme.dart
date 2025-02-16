import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 245, 249),
  primarySwatch: Colors.pink,
  primaryColor: const Color.fromARGB(255, 250, 127, 168),

  appBarTheme: AppBarTheme(
    foregroundColor: const Color.fromARGB(255, 250, 127, 168),
    backgroundColor: const Color.fromARGB(255, 255, 245, 249),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color.fromARGB(255, 250, 127, 168),
    foregroundColor: const Color.fromARGB(255, 255, 245, 249),
  )
);
