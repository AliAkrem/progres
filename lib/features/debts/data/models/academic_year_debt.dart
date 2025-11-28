import 'package:progres/features/debts/data/models/debt_course.dart';

class AcademicYearDebt {
  final String annee;
  final int idAnneeAcademique;
  final int rang;
  final List<DebtCourse> dette;

  AcademicYearDebt({
    required this.annee,
    required this.idAnneeAcademique,
    required this.rang,
    required this.dette,
  });

  factory AcademicYearDebt.fromJson(Map<String, dynamic> json) {
    return AcademicYearDebt(
      annee: json['annee'] as String,
      idAnneeAcademique: json['id_annee_academique'] as int,
      rang: json['rang'] as int,
      dette: (json['dette'] as List<dynamic>)
          .map((e) => DebtCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'annee': annee,
      'id_annee_academique': idAnneeAcademique,
      'rang': rang,
      'dette': dette.map((e) => e.toJson()).toList(),
    };
  }
}
