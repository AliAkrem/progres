import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/debts/data/models/academic_year_debt.dart';

class DebtsRepositoryImpl {
  final ApiClient _apiClient;

  DebtsRepositoryImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<AcademicYearDebt>> getStudentDebts() async {
    try {
      final uuid = await _apiClient.getUuid();
      if (uuid == null) {
        throw Exception('UUID not found, please login again');
      }
      final response = await _apiClient.get('/infos/dettes/$uuid');
      if (response.data == null) {
        return [];
      }
      final List<dynamic> debtsJson = response.data;
      return debtsJson
          .map((debtJson) => AcademicYearDebt.fromJson(debtJson))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
