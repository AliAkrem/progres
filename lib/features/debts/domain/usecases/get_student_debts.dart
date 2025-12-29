import 'package:progres/features/debts/data/models/academic_year_debt.dart';
import 'package:progres/features/debts/domain/repositories/debts_repository.dart';

class GetStudentDebts {
  final DebtsRepository repository;

  GetStudentDebts(this.repository);

  Future<List<AcademicYearDebt>> call() {
    return repository.getStudentDebts();
  }
}
