import 'package:progres/features/profile/data/models/academic_period.dart';
import 'package:progres/features/profile/data/models/academic_year.dart';
import 'package:progres/features/profile/data/models/student_basic_info.dart';
import 'package:progres/features/profile/data/models/student_detailed_info.dart';

abstract class StudentRepository {
  Future<StudentBasicInfo> getStudentBasicInfo();
  Future<AcademicYear> getCurrentAcademicYear();
  Future<StudentDetailedInfo> getStudentDetailedInfo(int academicYearId);
  Future<String> getStudentProfileImage();
  Future<String> getInstitutionLogo(int etablissementId);
  Future<List<AcademicPeriod>> getAcademicPeriods(int niveauId);
}
