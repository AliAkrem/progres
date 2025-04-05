import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/timeline/data/models/course_session.dart';

class TimeLineRepositoryImpl {
  final ApiClient _apiClient;

  TimeLineRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<CourseSession>> getWeeklyTimetable(int enrollmentId) async {
    try {
      final response =
          await _apiClient.get('/infos/seanceEmploi/inscription/$enrollmentId');

      final List<dynamic> sessionsJson = response.data;
      return sessionsJson
          .map((sessionJson) => CourseSession.fromJson(sessionJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
