import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/enrollment/domain/repositories/enrollment_repository.dart';

class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final ApiClient _apiClient;

  EnrollmentRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<Enrollment>> getStudentEnrollments() async {
    try {
      final uuid = await _apiClient.getUuid();
      if (uuid == null) {
        throw Exception('UUID not found, please login again');
      }

      final response = await _apiClient.get('/infos/bac/$uuid/dias');

      final List<dynamic> enrollmentsJson = response.data;
      return enrollmentsJson
          .map((enrollmentJson) => Enrollment.fromJson(enrollmentJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
