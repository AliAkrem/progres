import 'package:progres/features/profile/domain/repositories/student_repository.dart';

class GetStudentProfileImage {
  final StudentRepository repository;

  GetStudentProfileImage(this.repository);

  Future<String> call() {
    return repository.getStudentProfileImage();
  }
}
