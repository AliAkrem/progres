class StudentGroup {
  final int id;
  final String pedagogicalGroupName;
  final String sectionName;
  final int periodId;
  final String periodLabelLongLat;

  StudentGroup({
    required this.id,
    required this.pedagogicalGroupName,
    required this.sectionName,
    required this.periodId,
    required this.periodLabelLongLat,
  });

  factory StudentGroup.fromJson(Map<String, dynamic> json) {
    return StudentGroup(
      id: json['id'] as int,
      pedagogicalGroupName: json['nomGroupePedagogique'] as String,
      sectionName: json['nomSection'] as String,
      periodId: json['periodeId'] as int,
      periodLabelLongLat: json['periodeLibelleLongLt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomGroupePedagogique': pedagogicalGroupName,
      'nomSection': sectionName,
      'periodeId': periodId,
      'periodeLibelleLongLt': periodLabelLongLat,
    };
  }
}
