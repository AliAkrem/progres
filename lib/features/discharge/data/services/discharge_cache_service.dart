import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progres/features/discharge/data/models/dischage.dart';

class DischargeCacheService {
  // Keys for SharedPreferences
  static const String _dischargeKey = 'cached_discharge';
  static const String _lastUpdatedKeyPrefix = 'last_updated_';

  // Save discharge to cache
  Future<bool> cacheDischarge(StudentDischarge discharge) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dischargeJson = discharge.toJson();
      await prefs.setString(_dischargeKey, jsonEncode(dischargeJson));
      await prefs.setString(
        '${_lastUpdatedKeyPrefix}discharge',
        DateTime.now().toIso8601String(),
      );
      return true;
    } catch (e) {
      print('Error caching discharge: $e');
      return false;
    }
  }

  // Retrieve discharge from cache
  Future<StudentDischarge?> getCachedDischarge() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dischargeString = prefs.getString(_dischargeKey);

      if (dischargeString == null) return null;

      final Map<String, dynamic> decodedJson = jsonDecode(dischargeString);
      return StudentDischarge.fromJson(decodedJson);
    } catch (e) {
      print('Error retrieving cached discharge: $e');
      return null;
    }
  }

  // Get last update timestamp for discharge data
  Future<DateTime?> getLastUpdated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const key = '${_lastUpdatedKeyPrefix}discharge';

      final timestamp = prefs.getString(key);
      if (timestamp == null) return null;

      return DateTime.parse(timestamp);
    } catch (e) {
      print('Error getting last updated time: $e');
      return null;
    }
  }

  // Clear discharge cache
  Future<bool> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_dischargeKey);
      await prefs.remove('${_lastUpdatedKeyPrefix}discharge');
      return true;
    } catch (e) {
      print('Error clearing discharge cache: $e');
      return false;
    }
  }
}
