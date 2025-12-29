import 'package:progres/features/profile/data/models/academic_period.dart';
import 'package:progres/features/profile/domain/repositories/student_repository.dart';

class GetAcademicPeriods {
  final StudentRepository repository;

  GetAcademicPeriods(this.repository);

  Future<List<AcademicPeriod>> call(int niveauId) {
    return repository.getAcademicPeriods(niveauId);
  }
}
