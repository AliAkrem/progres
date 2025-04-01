import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/profile/data/models/academic_year.dart';
import 'package:progres/features/profile/data/models/student_basic_info.dart';
import 'package:progres/features/profile/data/models/student_detailed_info.dart';

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
} 