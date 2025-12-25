import 'package:progres/features/debts/data/models/academic_year_debt.dart';

abstract class DebtsRepository {
  Future<List<AcademicYearDebt>> getStudentDebts();
}
