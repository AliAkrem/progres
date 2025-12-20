import 'package:progres/core/network/api_client.dart';
import 'package:progres/core/services/year_selection_service.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/profile/data/models/academic_period.dart';
import 'package:progres/features/profile/data/models/academic_year.dart';
import 'package:progres/features/profile/data/models/student_basic_info.dart';
import 'package:progres/features/profile/data/models/student_detailed_info.dart';

class StudentRepositoryImpl {
  final ApiClient _apiClient;
  final YearSelectionService _yearSelectionService;

  StudentRepositoryImpl({
    ApiClient? apiClient,
    YearSelectionService? yearSelectionService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _yearSelectionService = yearSelectionService ?? YearSelectionService();

  Future<StudentBasicInfo> getStudentBasicInfo() async {
    try {
      final uuid = await _apiClient.getUuid();
      if (uuid == null) {
        throw Exception('UUID not found, please login again');
      }

      final response = await _apiClient.get('/infos/bac/$uuid/individu');
      return StudentBasicInfo.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AcademicYear> getCurrentAcademicYear() async {
    try {
      // Check if student has manually selected a year
      final selectedYearId = await _yearSelectionService.getSelectedYearId();
      final selectedYearCode = await _yearSelectionService.getSelectedYearCode();

      if (selectedYearId != null && selectedYearCode != null) {
        // Return the manually selected year
        return AcademicYear(id: selectedYearId, code: selectedYearCode);
      }

      // If no manual selection, proceed with automatic logic
      final uuid = await _apiClient.getUuid();
      if (uuid == null) {
        throw Exception('UUID not found, please login again');
      }

      final enrollmentRes = await _apiClient.get('/infos/bac/$uuid/dias');

      final List<dynamic> enrollmentsJson = enrollmentRes.data;
      final enrollments = enrollmentsJson
          .map((enrollmentJson) => Enrollment.fromJson(enrollmentJson))
          .toList();

      final currentYearRes = await _apiClient.get(
        '/infos/AnneeAcademiqueEncours',
      );

      final currentAcademicYear = AcademicYear.fromJson(currentYearRes.data);

      // Find the biggest year ID from enrollments
      int maxEnrollmentYearId = 0;
      String maxEnrollmentCode = "";
      for (var enrollment in enrollments) {
        if (enrollment.anneeAcademiqueId > maxEnrollmentYearId) {
          maxEnrollmentYearId = enrollment.anneeAcademiqueId;
          maxEnrollmentCode = enrollment.anneeAcademiqueCode;
        }
      }

      // If current year is bigger than the biggest enrollment year,
      // it means student has graduated or left college, so fall back to max enrollment year
      if (currentAcademicYear.id > maxEnrollmentYearId) {
        return currentAcademicYear.copyWith(
          id: maxEnrollmentYearId,
          code: maxEnrollmentCode,
        );
      }

      return currentAcademicYear;
    } catch (e) {
      rethrow;
    }
  }

  Future<StudentDetailedInfo> getStudentDetailedInfo(int academicYearId) async {
    try {
      final uuid = await _apiClient.getUuid();
      if (uuid == null) {
        throw Exception('UUID not found, please login again');
      }

      final response = await _apiClient.get(
        '/infos/bac/$uuid/anneeAcademique/$academicYearId/dia',
      );
      return StudentDetailedInfo.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getStudentProfileImage() async {
    try {
      final uuid = await _apiClient.getUuid();
      if (uuid == null) {
        throw Exception('UUID not found, please login again');
      }

      final response = await _apiClient.get('/infos/image/$uuid');
      return response.data as String;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getInstitutionLogo(int etablissementId) async {
    try {
      final response = await _apiClient.get(
        '/infos/logoEtablissement/$etablissementId',
      );
      return response.data as String;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AcademicPeriod>> getAcademicPeriods(int niveauId) async {
    try {
      final response = await _apiClient.get('/infos/niveau/$niveauId/periodes');

      final List<dynamic> periodsJson = response.data;
      return periodsJson
          .map((periodJson) => AcademicPeriod.fromJson(periodJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
