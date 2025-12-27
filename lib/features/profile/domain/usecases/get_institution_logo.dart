import 'package:progres/features/profile/domain/repositories/student_repository.dart';

class GetInstitutionLogo {
  final StudentRepository repository;

  GetInstitutionLogo(this.repository);

  Future<String> call(int etablissementId) {
    return repository.getInstitutionLogo(etablissementId);
  }
}
