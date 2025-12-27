import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/timeline/data/models/course_session.dart';
import 'package:progres/features/timeline/domain/repositories/timeline_repository.dart';

class TimeLineRepositoryImpl implements TimeLineRepository {
  final ApiClient _apiClient;

  TimeLineRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<CourseSession>> getWeeklyTimetable(int enrollmentId) async {
    try {
      final response = await _apiClient.get(
        '/infos/seanceEmploi/inscription/$enrollmentId',
      );

      final List<dynamic> sessionsJson = response.data;
      return sessionsJson
          .map((sessionJson) => CourseSession.fromJson(sessionJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
