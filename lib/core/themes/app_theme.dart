import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryPurple = Color(0xFFBB96FF);
  static const Color secondaryPurple = Color(0xFF522E98);
  static const Color tertiaryLime = Color(0xFFD7FF82);
  static const Color darkBackground = Color(0xFF371F7D);
  static const Color surfaceColor = Color(0xFF1E1E2E);
  static const Color deleteRed = Color(0xFFEF4444);
  static const Color keepGreen = Color(0xFF22C55E);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF000000);
  static const Color textSecondary = Color(0xFFA1A1AA);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryPurple,
      colorScheme: ColorScheme.dark(
        primary: primaryPurple,
        secondary: secondaryPurple,
        tertiary: tertiaryLime,
        surface: surfaceColor,
        error: deleteRed,
        onPrimary: textWhite,
        onSecondary: textWhite,
        onTertiary: textBlack,
        onSurface: textWhite,
        onError: textWhite,
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w600,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w600,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        displayLarge: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w600,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w600,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        headlineLarge: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w600,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        bodyLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textWhite,
          fontFamily: 'Outfit',
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
