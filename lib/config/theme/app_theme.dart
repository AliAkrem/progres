import 'package:flutter/material.dart';

class AppTheme {
  // Claude brand colors
  static const Color claudePrimary = Color(0xFF6B4CF6);
  static const Color claudeSecondary = Color(0xFFE3E0FF);
  static const Color claudeBackground = Color(0xFFF9F8FF);
  static const Color claudeTextPrimary = Color(0xFF141013);
  static const Color claudeTextSecondary = Color(0xFF6E6E80);
  static const Color claudeBorder = Color(0xFFE6E6EF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: claudePrimary,
        secondary: claudeSecondary,
        background: claudeBackground,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: claudePrimary,
        onBackground: claudeTextPrimary,
        onSurface: claudeTextPrimary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: claudeTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: claudeTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: claudeTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: claudeTextSecondary,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: claudeBorder),
        ),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: claudeBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: claudePrimary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: claudeBorder),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: claudePrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: claudeTextPrimary,
      ),
      scaffoldBackgroundColor: claudeBackground,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: claudePrimary,
        secondary: claudeSecondary,
        background: const Color(0xFF141013),
        surface: const Color(0xFF1E1A1F),
        onPrimary: Colors.white,
        onSecondary: claudePrimary,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFFADAEBD),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF2D2A2E)),
        ),
        color: const Color(0xFF1E1A1F),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2D2A2E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: claudePrimary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2D2A2E)),
        ),
        filled: true,
        fillColor: const Color(0xFF1E1A1F),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: claudePrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E1A1F),
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF141013),
    );
  }
} 