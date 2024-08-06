import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    secondary: const Color.fromARGB(255, 83, 83, 83),
    tertiary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade300,
  ),
  dividerTheme: const DividerThemeData(color: Colors.transparent)
);