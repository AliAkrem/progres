import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcademicsCacheService {
  // Keys for SharedPreferences
  static const String _academicsDataKeyPrefix = 'cached_academics_data_';
  static const String _lastUpdatedKeyPrefix = 'last_updated_academics_';

  // Save academics data to cache for specific identifier (e.g., semester, year)
  Future<bool> cacheAcademicsData(String identifier, List<dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '$_academicsDataKeyPrefix$identifier',
        jsonEncode(data),
      );
      await prefs.setString(
        '$_lastUpdatedKeyPrefix$identifier',
        DateTime.now().toIso8601String(),
      );
      return true;
    } catch (e) {
      debugPrint('Error caching academics data: $e');
      return false;
    }
  }

  // Retrieve academics data from cache
  Future<List<dynamic>?> getCachedAcademicsData(String identifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString('$_academicsDataKeyPrefix$identifier');

      if (dataString == null) return null;

      return jsonDecode(dataString) as List<dynamic>;
    } catch (e) {
      debugPrint('Error retrieving cached academics data: $e');
      return null;
    }
  }

  // Get last update timestamp for academics data
  Future<DateTime?> getLastUpdated(String identifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_lastUpdatedKeyPrefix$identifier';

      final timestamp = prefs.getString(key);
      if (timestamp == null) return null;

      return DateTime.parse(timestamp);
    } catch (e) {
      debugPrint('Error getting last updated time: $e');
      return null;
    }
  }

  // Clear academics cache
  Future<bool> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_academicsDataKeyPrefix) ||
            key.startsWith(_lastUpdatedKeyPrefix)) {
          await prefs.remove(key);
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error clearing academics cache: $e');
      return false;
    }
  }

  // Check if data is stale (older than specified duration)
  Future<bool> isDataStale(
    String identifier, {
    Duration staleDuration = const Duration(hours: 2),
  }) async {
    final lastUpdated = await getLastUpdated(identifier);
    if (lastUpdated == null) return true;

    final now = DateTime.now();
    return now.difference(lastUpdated) > staleDuration;
  }
}
