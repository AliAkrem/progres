import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progres/features/academics/data/models/academic_transcript.dart';
import 'package:progres/features/profile/data/models/enrollment.dart';
import 'package:progres/features/profile/data/models/annual_transcript_summary.dart';

class TranscriptCacheService {
  // Keys for SharedPreferences
  static const String _enrollmentsKey = 'cached_enrollments';
  static const String _transcriptsKeyPrefix = 'cached_transcripts_';
  static const String _annualSummaryKeyPrefix = 'cached_annual_summary_';
  static const String _lastUpdatedKeyPrefix = 'last_updated_';

  // Save enrollments to cache
  Future<bool> cacheEnrollments(List<Enrollment> enrollments) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enrollmentsJson = enrollments.map((e) => e.toJson()).toList();
      await prefs.setString(_enrollmentsKey, jsonEncode(enrollmentsJson));
      await prefs.setString('${_lastUpdatedKeyPrefix}enrollments', DateTime.now().toIso8601String());
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

  // Save transcripts for specific enrollment
  Future<bool> cacheTranscripts(int enrollmentId, List<AcademicTranscript> transcripts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final transcriptsJson = transcripts.map((t) => t.toJson()).toList();
      await prefs.setString('$_transcriptsKeyPrefix$enrollmentId', jsonEncode(transcriptsJson));
      await prefs.setString('${_lastUpdatedKeyPrefix}transcript_$enrollmentId', DateTime.now().toIso8601String());
      return true;
    } catch (e) {
      print('Error caching transcripts: $e');
      return false;
    }
  }

  // Retrieve transcripts for specific enrollment
  Future<List<AcademicTranscript>?> getCachedTranscripts(int enrollmentId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final transcriptsString = prefs.getString('$_transcriptsKeyPrefix$enrollmentId');
      
      if (transcriptsString == null) return null;
      
      final List<dynamic> decodedJson = jsonDecode(transcriptsString);
      return decodedJson.map((json) => AcademicTranscript.fromJson(json)).toList();
    } catch (e) {
      print('Error retrieving cached transcripts: $e');
      return null;
    }
  }

  // Save annual summary for specific enrollment
  Future<bool> cacheAnnualSummary(int enrollmentId, AnnualTranscriptSummary summary) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_annualSummaryKeyPrefix$enrollmentId', jsonEncode(summary.toJson()));
      await prefs.setString('${_lastUpdatedKeyPrefix}summary_$enrollmentId', DateTime.now().toIso8601String());
      return true;
    } catch (e) {
      print('Error caching annual summary: $e');
      return false;
    }
  }

  // Retrieve annual summary for specific enrollment
  Future<AnnualTranscriptSummary?> getCachedAnnualSummary(int enrollmentId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final summaryString = prefs.getString('$_annualSummaryKeyPrefix$enrollmentId');
      
      if (summaryString == null) return null;
      
      final decodedJson = jsonDecode(summaryString);
      return AnnualTranscriptSummary.fromJson(decodedJson);
    } catch (e) {
      print('Error retrieving cached annual summary: $e');
      return null;
    }
  }

  // Get last update timestamp for specific data
  Future<DateTime?> getLastUpdated(String dataType, {int? enrollmentId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = enrollmentId != null 
          ? '$_lastUpdatedKeyPrefix${dataType}_$enrollmentId' 
          : '$_lastUpdatedKeyPrefix$dataType';
      
      final timestamp = prefs.getString(key);
      if (timestamp == null) return null;
      
      return DateTime.parse(timestamp);
    } catch (e) {
      print('Error getting last updated time: $e');
      return null;
    }
  }

  // Clear all cached data
  Future<bool> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_transcriptsKeyPrefix) || 
            key.startsWith(_annualSummaryKeyPrefix) || 
            key.startsWith(_lastUpdatedKeyPrefix) ||
            key == _enrollmentsKey) {
          await prefs.remove(key);
        }
      }
      return true;
    } catch (e) {
      print('Error clearing cache: $e');
      return false;
    }
  }

  // Check if data is stale (older than specified duration)
  Future<bool> isDataStale(String dataType, {int? enrollmentId, Duration staleDuration = const Duration(hours: 12)}) async {
    final lastUpdated = await getLastUpdated(dataType, enrollmentId: enrollmentId);
    if (lastUpdated == null) return true;
    
    final now = DateTime.now();
    return now.difference(lastUpdated) > staleDuration;
  }
} 