import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/academics/data/models/continuous_assessment.dart';
import 'package:progres/features/academics/data/models/exam_result.dart';

class AcademicPerformanceRepositoryImpl {
  final ApiClient _apiClient;

  AcademicPerformanceRepositoryImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<ExamResult>> getExamResults(int cardId) async {
    try {
      final response = await _apiClient.get(
        '/infos/planningSession/dia/$cardId/noteExamens',
      );

      final List<dynamic> resultsJson = response.data;
      return resultsJson
          .map((resultJson) => ExamResult.fromJson(resultJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ContinuousAssessment>> getContinuousAssessments(
    int cardId,
  ) async {
    try {
      final response = await _apiClient.get(
        '/infos/controleContinue/dia/$cardId/notesCC',
      );

      final List<dynamic> assessmentsJson = response.data;
      return assessmentsJson
          .map(
            (assessmentJson) => ContinuousAssessment.fromJson(assessmentJson),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
