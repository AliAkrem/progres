import 'package:progres/features/enrollment/data/models/enrollment.dart';

abstract class EnrollmentRepository {
  Future<List<Enrollment>> getStudentEnrollments();
}
