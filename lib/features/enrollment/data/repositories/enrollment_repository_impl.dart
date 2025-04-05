import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/enrollment/data/repositories/enrollment_repository.dart';

class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final ApiClient _apiClient;

  EnrollmentRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<List<Enrollment>> getStudentEnrollments() async {
    try {
      final response = await _apiClient.get('/student/enrollments');

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['data'] != null) {
          final List<dynamic> enrollmentsJson = jsonData['data'];
          return enrollmentsJson
              .map((json) => Enrollment.fromJson(json))
              .toList();
        }
      }

      throw Exception('Failed to load enrollments: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching enrollments: $e');
    }
  }
}
