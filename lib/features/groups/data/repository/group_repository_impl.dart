import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/groups/data/models/group.dart';
import 'package:progres/features/groups/domain/repositories/group_repository.dart';

class StudentGroupsRepositoryImpl implements StudentGroupsRepository {
  final ApiClient _apiClient;

  StudentGroupsRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<StudentGroup>> getStudentGroups(int cardId) async {
    try {
      final response = await _apiClient.get('/infos/dia/$cardId/groups');

      final List<dynamic> groupsJson = response.data;
      return groupsJson
          .map((groupJson) => StudentGroup.fromJson(groupJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
