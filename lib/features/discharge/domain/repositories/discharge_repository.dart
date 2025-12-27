import 'package:progres/features/discharge/data/models/discharge.dart';

abstract class StudentDischargeRepository {
  Future<StudentDischarge> getStudentDischarge();
}
