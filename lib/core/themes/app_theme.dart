import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color surfaceColor = Color(0xFF1E1E2E);
  static const Color deleteRed = Color(0xFFEF4444);
  static const Color keepGreen = Color(0xFF22C55E);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryPurple,
      textTheme: TextTheme(
        displaySmall: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w600,
            color: textWhite,
            fontFamily: 'Outfit'),
        displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w600,
            color: textWhite,
            fontFamily: 'Outfit'),
        displayLarge: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w600,
            color: textWhite,
            fontFamily: 'Outfit'),
        headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textWhite,
            fontFamily: 'Outfit'),
        headlineMedium: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w600,
            color: textWhite,
            fontFamily: 'Outfit'),
        headlineLarge: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w600,
            color: textWhite,
            fontFamily: 'Outfit'),
        titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textWhite,
            fontFamily: 'Outfit'),
        titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textWhite,
            fontFamily: 'Outfit'),
        titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textWhite,
            fontFamily: 'Outfit'),
        bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textWhite,
            fontFamily: 'Outfit'),
        bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textWhite,
            fontFamily: 'Outfit'),
        bodyLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: textWhite,
            fontFamily: 'Outfit'),
        labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: textWhite,
            fontFamily: 'Outfit'),
        labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textWhite,
            fontFamily: 'Outfit'),
        labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textWhite,
            fontFamily: 'Outfit'),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
