class AcademicPeriod {
  final String code;
  final int id;
  final String libelleLongAr;
  final String libelleLongArCycle;
  final String libelleLongArNiveau;
  final String libelleLongFrCycle;
  final String libelleLongFrNiveau;
  final String libelleLongLt;
  final int rang;

  AcademicPeriod({
    required this.code,
    required this.id,
    required this.libelleLongAr,
    required this.libelleLongArCycle,
    required this.libelleLongArNiveau,
    required this.libelleLongFrCycle,
    required this.libelleLongFrNiveau,
    required this.libelleLongLt,
    required this.rang,
  });

  factory AcademicPeriod.fromJson(Map<String, dynamic> json) {
    return AcademicPeriod(
      code: json['code'] as String,
      id: json['id'] as int,
      libelleLongAr: json['libelleLongAr'] as String,
      libelleLongArCycle: json['libelleLongArCycle'] as String,
      libelleLongArNiveau: json['libelleLongArNiveau'] as String,
      libelleLongFrCycle: json['libelleLongFrCycle'] as String,
      libelleLongFrNiveau: json['libelleLongFrNiveau'] as String,
      libelleLongLt: json['libelleLongLt'] as String,
      rang: json['rang'] as int,
    );
  }
} 