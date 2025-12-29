import 'package:progres/features/profile/data/models/student_detailed_info.dart';
import 'package:progres/features/profile/domain/repositories/student_repository.dart';

class GetStudentDetailedInfo {
  final StudentRepository repository;

  GetStudentDetailedInfo(this.repository);

  Future<StudentDetailedInfo> call(int academicYearId) {
    return repository.getStudentDetailedInfo(academicYearId);
  }
}
