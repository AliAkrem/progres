import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/academics/data/models/continuous_assessment.dart';
import 'package:progres/features/academics/data/models/exam_result.dart';
import 'package:progres/features/profile/data/models/academic_period.dart';
import 'package:progres/features/profile/data/models/academic_year.dart';
import 'package:progres/features/profile/data/models/student_basic_info.dart';
import 'package:progres/features/profile/data/models/student_detailed_info.dart';
import 'package:progres/features/transcript/data/models/annual_transcript_summary.dart';

class StudentRepositoryImpl {
  final ApiClient _apiClient;

  StudentRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

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
      final response = await _apiClient.get('/infos/AnneeAcademiqueEncours');
      return AcademicYear.fromJson(response.data);
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
      final response =
          await _apiClient.get('/infos/logoEtablissement/$etablissementId');
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

  Future<List<ExamResult>> getExamResults(int cardId) async {
    try {
      final response = await _apiClient
          .get('/infos/planningSession/dia/$cardId/noteExamens');

      final List<dynamic> resultsJson = response.data;
      return resultsJson
          .map((resultJson) => ExamResult.fromJson(resultJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ContinuousAssessment>> getContinuousAssessments(
      int cardId) async {
    try {
      final response =
          await _apiClient.get('/infos/controleContinue/dia/$cardId/notesCC');

      final List<dynamic> assessmentsJson = response.data;
      return assessmentsJson
          .map(
              (assessmentJson) => ContinuousAssessment.fromJson(assessmentJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<AnnualTranscriptSummary> getAnnualTranscriptSummary(
      int enrollmentId) async {
    try {
      final uuid = await _apiClient.getUuid();
      if (uuid == null) {
        throw Exception('UUID not found, please login again');
      }

      final response = await _apiClient
          .get('/infos/bac/$uuid/dia/$enrollmentId/annuel/bilan');

      final List<dynamic> summaryJson = response.data;
      if (summaryJson.isEmpty) {
        throw Exception('No annual summary found');
      }

      return AnnualTranscriptSummary.fromJson(summaryJson.first);
    } catch (e) {
      rethrow;
    }
  }
}
