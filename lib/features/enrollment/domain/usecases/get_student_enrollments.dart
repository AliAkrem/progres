import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/enrollment/domain/repositories/enrollment_repository.dart';

class GetStudentEnrollments {
  final EnrollmentRepository repository;

  GetStudentEnrollments(this.repository);

  Future<List<Enrollment>> call() {
    return repository.getStudentEnrollments();
  }
}
