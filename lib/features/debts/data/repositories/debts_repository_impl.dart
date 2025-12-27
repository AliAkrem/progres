import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/debts/data/models/academic_year_debt.dart';
import 'package:progres/features/debts/domain/repositories/debts_repository.dart';

class DebtsRepositoryImpl implements DebtsRepository {
  final ApiClient _apiClient;

  DebtsRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
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
      final debts = debtsJson
          .map((debtJson) => AcademicYearDebt.fromJson(debtJson))
          .toList();
      debts.sort((a, b) => b.academicYearId.compareTo(a.academicYearId));
      return debts;
    } catch (e) {
      rethrow;
    }
  }
}
