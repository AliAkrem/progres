import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/subject/domain/repositories/subject_repository.dart';
import '../../data/models/course_coefficient.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final ApiClient _apiClient;

  SubjectRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<CourseCoefficient>> getCourseCoefficients(
    int ouvertureOffreFormationId,
    int niveauId,
  ) async {
    try {
      final response = await _apiClient.get(
        '/infos/offreFormation/$ouvertureOffreFormationId/niveau/$niveauId/Coefficients',
      );

      final List<dynamic> coefficientsJson = response.data;
      return coefficientsJson
          .map((coefficientJson) => CourseCoefficient.fromJson(coefficientJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
