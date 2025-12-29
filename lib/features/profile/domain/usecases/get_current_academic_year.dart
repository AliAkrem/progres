import 'package:progres/features/profile/data/models/academic_year.dart';
import 'package:progres/features/profile/domain/repositories/student_repository.dart';

class GetCurrentAcademicYear {
  final StudentRepository repository;

  GetCurrentAcademicYear(this.repository);

  Future<AcademicYear> call() {
    return repository.getCurrentAcademicYear();
  }
}
