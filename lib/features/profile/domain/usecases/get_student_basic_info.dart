import 'package.progres/features/profile/data/models/student_basic_info.dart';
import 'package.progres/features/profile/domain/repositories/student_repository.dart';

class GetStudentBasicInfo {
  final StudentRepository repository;

  GetStudentBasicInfo(this.repository);

  Future<StudentBasicInfo> call() {
    return repository.getStudentBasicInfo();
  }
}
