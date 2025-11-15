import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const Duration cacheExpiry = Duration(
    hours: 24,
  ); // Cache valid for 24h

  final SharedPreferences _prefs;

  CacheManager._(this._prefs);

  static Future<CacheManager> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return CacheManager._(prefs);
  }

  String _cacheKey(String key) => 'cache_\$key';

  String _timestampKey(String key) => 'cache_timestamp_\$key';

  Future<void> saveCache(String key, dynamic data) async {
    final jsonString = jsonEncode(data);
    await _prefs.setString(_cacheKey(key), jsonString);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await _prefs.setInt(_timestampKey(key), timestamp);
  }

  dynamic getCache(String key) {
    final jsonString = _prefs.getString(_cacheKey(key));
    if (jsonString == null) return null;

    final timestamp = _prefs.getInt(_timestampKey(key));
    if (timestamp == null) return null;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (DateTime.now().difference(cacheTime) > cacheExpiry) {
      // Cache expired
      removeCache(key);
      return null;
    }

    try {
      return jsonDecode(jsonString);
    } catch (_) {
      removeCache(key);
      return null;
    }
  }

  Future<void> removeCache(String key) async {
    await _prefs.remove(_cacheKey(key));
    await _prefs.remove(_timestampKey(key));
  }
}
