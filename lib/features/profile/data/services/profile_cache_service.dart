import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCacheService {
  // Keys for SharedPreferences
  static const String _profileKey = 'cached_profile_data';
  static const String _lastUpdatedKey = 'last_updated_profile';

  // Save profile data to cache
  Future<bool> cacheProfileData(Map<String, dynamic> profileData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileKey, jsonEncode(profileData));
      await prefs.setString(_lastUpdatedKey, DateTime.now().toIso8601String());
      return true;
    } catch (e) {
      debugPrint('Error caching profile data: $e');
      return false;
    }
  }

  // Retrieve profile data from cache
  Future<Map<String, dynamic>?> getCachedProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileDataString = prefs.getString(_profileKey);

      if (profileDataString == null) return null;

      return jsonDecode(profileDataString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error retrieving cached profile data: $e');
      return null;
    }
  }

  // Get last update timestamp for profile data
  Future<DateTime?> getLastUpdated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getString(_lastUpdatedKey);
      if (timestamp == null) return null;

      return DateTime.parse(timestamp);
    } catch (e) {
      debugPrint('Error getting last updated time: $e');
      return null;
    }
  }

  // Clear profile data cache
  Future<bool> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
      await prefs.remove(_lastUpdatedKey);
      return true;
    } catch (e) {
      debugPrint('Error clearing profile cache: $e');
      return false;
    }
  }
}
