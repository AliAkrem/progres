import 'package:progres/features/academics/data/models/exam_result.dart';
import 'package:progres/features/academics/domain/repositories/academics_repository.dart';

class GetExamResults {
  final AcademicPerformanceRepository repository;

  GetExamResults(this.repository);

  Future<List<ExamResult>> call(int cardId) {
    return repository.getExamResults(cardId);
  }
}
