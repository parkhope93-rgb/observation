import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: cream,
  colorScheme: ColorScheme.fromSeed(
    seedColor: forest,
    surface: cream,
  ),
  fontFamily: 'Pretendard',
  textTheme: const TextTheme(
    bodyLarge: TextStyle(letterSpacing: -0.1),
    bodyMedium: TextStyle(letterSpacing: -0.1),
    bodySmall: TextStyle(letterSpacing: -0.1),
    titleLarge: TextStyle(letterSpacing: -0.3),
    titleMedium: TextStyle(letterSpacing: -0.2),
    titleSmall: TextStyle(letterSpacing: -0.1),
    headlineLarge: TextStyle(letterSpacing: -0.4),
    headlineMedium: TextStyle(letterSpacing: -0.3),
    headlineSmall: TextStyle(letterSpacing: -0.2),
  ),
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.zero,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: inputBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);
