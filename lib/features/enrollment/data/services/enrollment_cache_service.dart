import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';

class EnrollmentCacheService {
  // Keys for SharedPreferences
  static const String _enrollmentsKey = 'cached_enrollments';
  static const String _lastUpdatedKeyPrefix = 'last_updated_';

  // Save enrollments to cache
  Future<bool> cacheEnrollments(List<Enrollment> enrollments) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enrollmentsJson = enrollments.map((e) => e.toJson()).toList();
      await prefs.setString(_enrollmentsKey, jsonEncode(enrollmentsJson));
      await prefs.setString('${_lastUpdatedKeyPrefix}enrollments',
          DateTime.now().toIso8601String());
      return true;
    } catch (e) {
      print('Error caching enrollments: $e');
      return false;
    }
  }

  // Retrieve enrollments from cache
  Future<List<Enrollment>?> getCachedEnrollments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enrollmentsString = prefs.getString(_enrollmentsKey);

      if (enrollmentsString == null) return null;

      final List<dynamic> decodedJson = jsonDecode(enrollmentsString);
      return decodedJson.map((json) => Enrollment.fromJson(json)).toList();
    } catch (e) {
      print('Error retrieving cached enrollments: $e');
      return null;
    }
  }

  // Get last update timestamp for enrollment data
  Future<DateTime?> getLastUpdated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const key = '${_lastUpdatedKeyPrefix}enrollments';

      final timestamp = prefs.getString(key);
      if (timestamp == null) return null;

      return DateTime.parse(timestamp);
    } catch (e) {
      print('Error getting last updated time: $e');
      return null;
    }
  }

  // Clear enrollment cache
  Future<bool> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_enrollmentsKey);
      await prefs.remove('${_lastUpdatedKeyPrefix}enrollments');
      return true;
    } catch (e) {
      print('Error clearing enrollment cache: $e');
      return false;
    }
  }

  // Check if data is stale (older than specified duration)
  Future<bool> isDataStale(
      {Duration staleDuration = const Duration(hours: 12)}) async {
    final lastUpdated = await getLastUpdated();
    if (lastUpdated == null) return true;

    final now = DateTime.now();
    return now.difference(lastUpdated) > staleDuration;
  }
}
