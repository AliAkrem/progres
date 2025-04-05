class StudentGroup {
  final int id;
  final String nomGroupePedagogique;
  final String nomSection;
  final int periodeId;
  final String periodeLibelleLongLt;

  StudentGroup({
    required this.id,
    required this.nomGroupePedagogique,
    required this.nomSection,
    required this.periodeId,
    required this.periodeLibelleLongLt,
  });

  factory StudentGroup.fromJson(Map<String, dynamic> json) {
    return StudentGroup(
      id: json['id'] as int,
      nomGroupePedagogique: json['nomGroupePedagogique'] as String,
      nomSection: json['nomSection'] as String,
      periodeId: json['periodeId'] as int,
      periodeLibelleLongLt: json['periodeLibelleLongLt'] as String,
    );
  }
} 