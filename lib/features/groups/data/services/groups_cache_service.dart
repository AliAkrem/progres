import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progres/features/groups/data/models/group.dart';

class GroupsCacheService {
  // Keys for SharedPreferences
  static const String _groupsKey = 'cached_groups';
  static const String _lastUpdatedKeyPrefix = 'last_updated_';

  // Save groups to cache
  Future<bool> cacheGroups(List<StudentGroup> groups) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final groupsJson = groups.map((g) => g.toJson()).toList();
      await prefs.setString(_groupsKey, jsonEncode(groupsJson));
      await prefs.setString(
        '${_lastUpdatedKeyPrefix}groups',
        DateTime.now().toIso8601String(),
      );
      return true;
    } catch (e) {
      debugPrint('Error caching groups: $e');
      return false;
    }
  }

  // Retrieve groups from cache
  Future<List<StudentGroup>?> getCachedGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final groupsString = prefs.getString(_groupsKey);

      if (groupsString == null) return null;

      final List<dynamic> decodedJson = jsonDecode(groupsString);
      return decodedJson.map((json) => StudentGroup.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error retrieving cached groups: $e');
      return null;
    }
  }

  // Get last update timestamp for groups data
  Future<DateTime?> getLastUpdated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const key = '${_lastUpdatedKeyPrefix}groups';

      final timestamp = prefs.getString(key);
      if (timestamp == null) return null;

      return DateTime.parse(timestamp);
    } catch (e) {
      debugPrint('Error getting last updated time: $e');
      return null;
    }
  }

  // Clear groups cache
  Future<bool> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_groupsKey);
      await prefs.remove('${_lastUpdatedKeyPrefix}groups');
      return true;
    } catch (e) {
      debugPrint('Error clearing groups cache: $e');
      return false;
    }
  }
}
