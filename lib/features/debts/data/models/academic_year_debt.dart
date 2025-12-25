import 'package:progres/features/debts/data/models/debt_course.dart';

class AcademicYearDebt {
  final String year;
  final int academicYearId;
  final int rank;
  final List<DebtCourse> debts;

  AcademicYearDebt({
    required this.year,
    required this.academicYearId,
    required this.rank,
    required this.debts,
  });

  factory AcademicYearDebt.fromJson(Map<String, dynamic> json) {
    return AcademicYearDebt(
      year: json['annee'] as String,
      academicYearId: json['id_annee_academique'] as int,
      rank: json['rang'] as int,
      debts: (json['dette'] as List<dynamic>)
          .map((e) => DebtCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'annee': year,
      'id_annee_academique': academicYearId,
      'rang': rank,
      'dette': debts.map((e) => e.toJson()).toList(),
    };
  }
}
