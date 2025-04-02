import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color claudePrimary = Color(0xFF6B4CF6); // Primary Purple
  static const Color claudeSecondary = Color(0xFFE3E0FF); // Light Purple
  static const Color claudeBackground = Color(0xFFF9F8FF); // Background
  static const Color claudeTextPrimary = Color(0xFF141013); // Dark Text
  static const Color claudeTextSecondary = Color(0xFF6E6E80); // Secondary Text
  static const Color claudeBorder = Color(0xFFE6E6EF); // Border Color
  
  // Accent colors
  static const Color accentGreen = Color(0xFF00C48C);
  static const Color accentBlue = Color(0xFF1A73E8);
  static const Color accentRed = Color(0xFFEB5757);
  static const Color accentYellow = Color(0xFFF2C94C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: claudePrimary,
      scaffoldBackgroundColor: claudeBackground,
      colorScheme: ColorScheme.light(
        primary: claudePrimary,
        onPrimary: Colors.white,
        secondary: claudeSecondary,
        onSecondary: claudePrimary,
        surface: Colors.white,
        onSurface: claudeTextPrimary,
        background: claudeBackground,
        onBackground: claudeTextPrimary,
        error: accentRed,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: claudeTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: claudeTextPrimary,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: claudeTextPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: claudeTextPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: claudeTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: claudeTextPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.w700,
          color: claudeTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: claudeTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: claudeTextPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
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
        bodySmall: TextStyle(
          fontSize: 12,
          color: claudeTextSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: claudePrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: claudePrimary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24, 
            vertical: 16,
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: claudePrimary,
          side: const BorderSide(color: claudePrimary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24, 
            vertical: 16,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: claudePrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16, 
            vertical: 8,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20, 
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: claudeBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: claudeBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: claudePrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentRed, width: 1.5),
        ),
        labelStyle: const TextStyle(
          color: claudeTextSecondary,
          fontSize: 16,
        ),
        hintStyle: const TextStyle(
          color: claudeTextSecondary,
          fontSize: 16,
        ),
        errorStyle: TextStyle(
          color: accentRed,
          fontSize: 12,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: claudeBorder, width: 1.5),
        ),
        color: Colors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: claudeSecondary,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(
              color: claudePrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: claudeTextSecondary,
            fontSize: 12,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(
              color: claudePrimary,
              size: 24,
            );
          }
          return const IconThemeData(
            color: claudeTextSecondary,
            size: 24,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: claudeBorder,
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: claudePrimary,
        unselectedLabelColor: claudeTextSecondary,
        indicatorColor: claudePrimary,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: claudePrimary,
      scaffoldBackgroundColor: const Color(0xFF141013),
      colorScheme: ColorScheme.dark(
        primary: claudePrimary,
        onPrimary: Colors.white,
        secondary: claudeSecondary,
        onSecondary: claudePrimary,
        surface: const Color(0xFF1E1A1F),
        onSurface: Colors.white,
        background: const Color(0xFF141013),
        onBackground: Colors.white,
        error: accentRed,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1A1F),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
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
        bodySmall: TextStyle(
          fontSize: 12,
          color: Color(0xFFADAEBD),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: claudePrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: claudePrimary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24, 
            vertical: 16,
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: claudePrimary,
          side: const BorderSide(color: claudePrimary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24, 
            vertical: 16,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: claudePrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16, 
            vertical: 8,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1A1F),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20, 
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D2A2E), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D2A2E), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: claudePrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentRed, width: 1.5),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFFADAEBD),
          fontSize: 16,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFFADAEBD),
          fontSize: 16,
        ),
        errorStyle: TextStyle(
          color: accentRed,
          fontSize: 12,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2D2A2E), width: 1.5),
        ),
        color: const Color(0xFF1E1A1F),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1A1F),
        indicatorColor: claudePrimary.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(
              color: claudePrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: Color(0xFFADAEBD),
            fontSize: 12,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(
              color: claudePrimary,
              size: 24,
            );
          }
          return const IconThemeData(
            color: Color(0xFFADAEBD),
            size: 24,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2D2A2E),
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: claudePrimary,
        unselectedLabelColor: Color(0xFFADAEBD),
        indicatorColor: claudePrimary,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
} 