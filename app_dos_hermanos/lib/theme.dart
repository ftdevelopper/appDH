import 'package:flutter/material.dart';

final theme = ThemeData(
  primaryColor: const Color(0xFFec1b25),
  colorScheme: ColorScheme(
    background: const Color(0xFFE0F2F1),
    brightness: Brightness.light,
    error: Colors.red,
    onBackground: const Color(0xFFE0F2F1),
    onError: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    primary: const Color(0xFFec1b25),
    secondary: const Color(0xFFec1b25),
    primaryVariant: Colors.white,
    secondaryVariant: Colors.white,
    surface: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
  ),
);