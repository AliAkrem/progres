import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progres/features/subject/data/models/course_coefficient.dart';

class SubjectCacheService {
  // Keys for SharedPreferences
  static const String _subjectKey = 'cached_subject_coefficients';
  static const String _lastUpdatedKeyPrefix = 'last_updated_';

  // Create a cache key based on parameters
  String _getCacheKey(int ouvertureOffreFormationId, int niveauId) {
    return '${_subjectKey}_${ouvertureOffreFormationId}_$niveauId';
  }

  String _getLastUpdatedKey(int ouvertureOffreFormationId, int niveauId) {
    return '${_lastUpdatedKeyPrefix}subject_${ouvertureOffreFormationId}_$niveauId';
  }

  // Save course coefficients to cache
  Future<bool> cacheSubjectCoefficients(
    List<CourseCoefficient> coefficients,
    int ouvertureOffreFormationId,
    int niveauId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(ouvertureOffreFormationId, niveauId);
      final lastUpdatedKey =
          _getLastUpdatedKey(ouvertureOffreFormationId, niveauId);

      final coefficientsJson = coefficients.map((c) => c.toJson()).toList();
      await prefs.setString(cacheKey, jsonEncode(coefficientsJson));
      await prefs.setString(lastUpdatedKey, DateTime.now().toIso8601String());
      return true;
    } catch (e) {
      print('Error caching subject coefficients: $e');
      return false;
    }
  }

  // Retrieve course coefficients from cache
  Future<List<CourseCoefficient>?> getCachedSubjectCoefficients(
    int ouvertureOffreFormationId,
    int niveauId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(ouvertureOffreFormationId, niveauId);
      final coefficientsString = prefs.getString(cacheKey);

      if (coefficientsString == null) return null;

      final List<dynamic> decodedJson = jsonDecode(coefficientsString);
      return decodedJson
          .map((json) => CourseCoefficient.fromJson(json))
          .toList();
    } catch (e) {
      print('Error retrieving cached subject coefficients: $e');
      return null;
    }
  }

  // Get last update timestamp for subject coefficients data
  Future<DateTime?> getLastUpdated(
    int ouvertureOffreFormationId,
    int niveauId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getLastUpdatedKey(ouvertureOffreFormationId, niveauId);

      final timestamp = prefs.getString(key);
      if (timestamp == null) return null;

      return DateTime.parse(timestamp);
    } catch (e) {
      print('Error getting last updated time: $e');
      return null;
    }
  }

  // Clear specific subject coefficients cache
  Future<bool> clearSpecificCache(
    int ouvertureOffreFormationId,
    int niveauId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(ouvertureOffreFormationId, niveauId);
      final lastUpdatedKey =
          _getLastUpdatedKey(ouvertureOffreFormationId, niveauId);

      await prefs.remove(cacheKey);
      await prefs.remove(lastUpdatedKey);
      return true;
    } catch (e) {
      print('Error clearing specific subject cache: $e');
      return false;
    }
  }

  // Clear all subject caches
  Future<bool> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();

      for (final key in allKeys) {
        if (key.startsWith(_subjectKey) ||
            key.startsWith('${_lastUpdatedKeyPrefix}subject_')) {
          await prefs.remove(key);
        }
      }
      return true;
    } catch (e) {
      print('Error clearing all subject caches: $e');
      return false;
    }
  }
}
