import 'package:progres/features/academics/data/models/continuous_assessment.dart';
import 'package:progres/features/academics/data/models/exam_result.dart';

abstract class AcademicPerformanceRepository {
  Future<List<ExamResult>> getExamResults(int cardId);
  Future<List<ContinuousAssessment>> getContinuousAssessments(int cardId);
}
