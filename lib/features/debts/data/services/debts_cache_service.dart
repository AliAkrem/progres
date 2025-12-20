import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progres/features/debts/data/models/academic_year_debt.dart';

class DebtsCacheService {
  // Keys for SharedPreferences
  static const String _debtsKey = 'cached_debts';
  static const String _lastUpdatedKey = 'last_updated_debts';

  // Save debts
  Future<bool> cacheDebts(List<AcademicYearDebt> debts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final debtsJson = debts.map((d) => d.toJson()).toList();
      await prefs.setString(_debtsKey, jsonEncode(debtsJson));
      await prefs.setString(_lastUpdatedKey, DateTime.now().toIso8601String());
      return true;
    } catch (e) {
      debugPrint('Error caching debts: $e');
      return false;
    }
  }

  // Retrieve debts
  Future<List<AcademicYearDebt>?> getCachedDebts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final debtsString = prefs.getString(_debtsKey);

      if (debtsString == null) return null;

      final List<dynamic> decodedJson = jsonDecode(debtsString);
      return decodedJson
          .map((json) => AcademicYearDebt.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error retrieving cached debts: $e');
      return null;
    }
  }

  // Get last update timestamp
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

  // Clear all debts cached data
  Future<bool> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_debtsKey);
      await prefs.remove(_lastUpdatedKey);
      return true;
    } catch (e) {
      debugPrint('Error clearing cache: $e');
      return false;
    }
  }

  // Check if data is stale (older than specified duration)
  Future<bool> isDataStale({
    Duration staleDuration = const Duration(hours: 12),
  }) async {
    final lastUpdated = await getLastUpdated();
    if (lastUpdated == null) return true;

    final now = DateTime.now();
    return now.difference(lastUpdated) > staleDuration;
  }
}
