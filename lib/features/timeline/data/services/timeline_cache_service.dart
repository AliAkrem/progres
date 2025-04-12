import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TimelineCacheService {
  // Keys for SharedPreferences
  static const String _timelineEventsKeyPrefix = 'cached_timeline_events_';
  static const String _lastUpdatedKeyPrefix = 'last_updated_timeline_';

  // Save timeline events to cache for specific day/week
  Future<bool> cacheTimelineEvents(
      String periodIdentifier, List<dynamic> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          '$_timelineEventsKeyPrefix$periodIdentifier', jsonEncode(events));
      await prefs.setString('$_lastUpdatedKeyPrefix$periodIdentifier',
          DateTime.now().toIso8601String());
      return true;
    } catch (e) {
      print('Error caching timeline events: $e');
      return false;
    }
  }

  // Retrieve timeline events from cache
  Future<List<dynamic>?> getCachedTimelineEvents(
      String periodIdentifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsString =
          prefs.getString('$_timelineEventsKeyPrefix$periodIdentifier');

      if (eventsString == null) return null;

      return jsonDecode(eventsString) as List<dynamic>;
    } catch (e) {
      print('Error retrieving cached timeline events: $e');
      return null;
    }
  }

  // Get last update timestamp for timeline data
  Future<DateTime?> getLastUpdated(String periodIdentifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_lastUpdatedKeyPrefix$periodIdentifier';

      final timestamp = prefs.getString(key);
      if (timestamp == null) return null;

      return DateTime.parse(timestamp);
    } catch (e) {
      print('Error getting last updated time: $e');
      return null;
    }
  }

  // Clear timeline cache
  Future<bool> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_timelineEventsKeyPrefix) ||
            key.startsWith(_lastUpdatedKeyPrefix)) {
          await prefs.remove(key);
        }
      }
      return true;
    } catch (e) {
      print('Error clearing timeline cache: $e');
      return false;
    }
  }
}
