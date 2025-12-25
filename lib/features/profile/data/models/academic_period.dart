class AcademicPeriod {
  final String code;
  final int id;
  final String labelLongAr;
  final String cycleLabelLongAr;
  final String levelLabelLongAr;
  final String cycleLabelLongFr;
  final String levelLabelLongFr;
  final String labelLongLat;
  final int rank;

  AcademicPeriod({
    required this.code,
    required this.id,
    required this.labelLongAr,
    required this.cycleLabelLongAr,
    required this.levelLabelLongAr,
    required this.cycleLabelLongFr,
    required this.levelLabelLongFr,
    required this.labelLongLat,
    required this.rank,
  });

  factory AcademicPeriod.fromJson(Map<String, dynamic> json) {
    return AcademicPeriod(
      code: json['code'] as String,
      id: json['id'] as int,
      labelLongAr: json['libelleLongAr'] as String,
      cycleLabelLongAr: json['libelleLongArCycle'] as String,
      levelLabelLongAr: json['libelleLongArNiveau'] as String,
      cycleLabelLongFr: json['libelleLongFrCycle'] as String,
      levelLabelLongFr: json['libelleLongFrNiveau'] as String,
      labelLongLat: json['libelleLongLt'] as String,
      rank: json['rang'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'id': id,
      'libelleLongAr': labelLongAr,
      'libelleLongArCycle': cycleLabelLongAr,
      'libelleLongArNiveau': levelLabelLongAr,
      'libelleLongFrCycle': cycleLabelLongFr,
      'libelleLongFrNiveau': levelLabelLongFr,
      'libelleLongLt': labelLongLat,
      'rang': rank,
    };
  }
}
