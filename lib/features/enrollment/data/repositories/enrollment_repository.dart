import 'package:progres/features/enrollment/data/models/enrollment.dart';

abstract class EnrollmentRepository {
  /// Get all enrollments for the current student
  Future<List<Enrollment>> getStudentEnrollments();
} 