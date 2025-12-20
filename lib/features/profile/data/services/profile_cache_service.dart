import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCacheService {
  // Keys for SharedPreferences
  static const String _profileKeyPrefix = 'cached_profile_data';
  static const String _lastUpdatedKeyPrefix = 'last_updated_profile';
  static const String _currentYearKey = 'cached_year_id';

  // Get cache key for specific year
  String _getProfileKey(int yearId) => '${_profileKeyPrefix}_$yearId';
  String _getLastUpdatedKey(int yearId) => '${_lastUpdatedKeyPrefix}_$yearId';

  // Save profile data to cache with year ID
  Future<bool> cacheProfileData(
    Map<String, dynamic> profileData,
    int yearId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_getProfileKey(yearId), jsonEncode(profileData));
      await prefs.setString(
        _getLastUpdatedKey(yearId),
        DateTime.now().toIso8601String(),
      );
      await prefs.setInt(_currentYearKey, yearId);
      return true;
    } catch (e) {
      debugPrint('Error caching profile data: $e');
      return false;
    }
  }

  // Retrieve profile data from cache for specific year
  Future<Map<String, dynamic>?> getCachedProfileData(int yearId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileDataString = prefs.getString(_getProfileKey(yearId));

      if (profileDataString == null) return null;

      return jsonDecode(profileDataString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error retrieving cached profile data: $e');
      return null;
    }
  }

  // Get last update timestamp for profile data of specific year
  Future<DateTime?> getLastUpdated(int yearId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getString(_getLastUpdatedKey(yearId));
      if (timestamp == null) return null;

      return DateTime.parse(timestamp);
    } catch (e) {
      debugPrint('Error getting last updated time: $e');
      return null;
    }
  }

  // Clear profile data cache for specific year
  Future<bool> clearCache([int? yearId]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (yearId != null) {
        // Clear specific year cache
        await prefs.remove(_getProfileKey(yearId));
        await prefs.remove(_getLastUpdatedKey(yearId));
      } else {
        // Clear all profile caches
        final keys = prefs.getKeys();
        for (final key in keys) {
          if (key.startsWith(_profileKeyPrefix) ||
              key.startsWith(_lastUpdatedKeyPrefix)) {
            await prefs.remove(key);
          }
        }
        await prefs.remove(_currentYearKey);
      }
      return true;
    } catch (e) {
      debugPrint('Error clearing profile cache: $e');
      return false;
    }
  }
}
