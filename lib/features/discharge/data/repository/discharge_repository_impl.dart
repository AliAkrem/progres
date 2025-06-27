import 'package:progres/features/discharge/data/models/dischage.dart';
import 'package:progres/features/discharge/data/services/discharge_api_client.dart';

class StudentDischargeRepositoryImpl {
  final DischargeApiClient _apiClient;

  StudentDischargeRepositoryImpl({DischargeApiClient? apiClient})
    : _apiClient = apiClient ?? DischargeApiClient();

  Future<StudentDischarge> getStudentDischarge() async {
    try {
      final uuid = await _apiClient.getUuid();
      final response = await _apiClient.get('/$uuid/qitus');

      final List<dynamic> dischargeJson = response.data;

      if (dischargeJson.isEmpty) {
        throw DischargeNotRequiredException(
          'Discharge is not required for this student',
        );
      }

      return StudentDischarge.fromJson(dischargeJson[0]);
    } catch (e) {
      rethrow;
    }
  }
}

class DischargeNotRequiredException implements Exception {
  final String message;
  DischargeNotRequiredException(this.message);

  @override
  String toString() => message;
}
