import 'package:progres/features/discharge/data/models/discharge.dart';
import 'package:progres/features/discharge/domain/repositories/discharge_repository.dart';

class GetStudentDischarge {
  final StudentDischargeRepository repository;

  GetStudentDischarge(this.repository);

  Future<StudentDischarge> call() {
    return repository.getStudentDischarge();
  }
}
