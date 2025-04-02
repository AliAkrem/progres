import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String themeKey = 'app_theme';

  // Save theme mode to shared preferences
  static Future<bool> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(themeKey, themeMode.toString());
  }

  // Load theme mode from shared preferences
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(themeKey);
    
    if (themeString == null) {
      return ThemeMode.system;
    }
    
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        return ThemeMode.system;
    }
  }
} 