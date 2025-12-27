import 'package.progres/features/academics/data/models/continuous_assessment.dart';
import 'package.progres/features/academics/domain/repositories/academics_repository.dart';

class GetContinuousAssessments {
  final AcademicPerformanceRepository repository;

  GetContinuousAssessments(this.repository);

  Future<List<ContinuousAssessment>> call(int cardId) {
    return repository.getContinuousAssessments(cardId);
  }
}
