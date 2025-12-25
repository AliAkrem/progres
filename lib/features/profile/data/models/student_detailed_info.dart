class StudentDetailedInfo {
  final String academicYearCode;
  final int academicYearId;
  final int id;
  final String individualLastNameAr;
  final String individualLastNameFr;
  final String individualFirstNameAr;
  final String individualFirstNameFr;
  final int levelId;
  final String levelLabelLongAr;
  final String levelLabelLongLat;
  final String registrationNumber;
  final int trainingOfferId;
  final String photo;
  final String cycleLabel;
  final String cycleLabelAr;
  final int statusId;
  final bool transportPaid;

  StudentDetailedInfo({
    required this.academicYearCode,
    required this.academicYearId,
    required this.id,
    required this.individualLastNameAr,
    required this.individualLastNameFr,
    required this.individualFirstNameAr,
    required this.individualFirstNameFr,
    required this.levelId,
    required this.levelLabelLongAr,
    required this.levelLabelLongLat,
    required this.registrationNumber,
    required this.trainingOfferId,
    required this.photo,
    required this.cycleLabel,
    required this.cycleLabelAr,
    required this.statusId,
    required this.transportPaid,
  });

  factory StudentDetailedInfo.fromJson(Map<String, dynamic> json) {
    return StudentDetailedInfo(
      academicYearCode: json['anneeAcademiqueCode'] as String,
      academicYearId: json['anneeAcademiqueId'] as int,
      id: json['id'] as int,
      individualLastNameAr: json['individuNomArabe'] as String,
      individualLastNameFr: json['individuNomLatin'] as String,
      individualFirstNameAr: json['individuPrenomArabe'] as String,
      individualFirstNameFr: json['individuPrenomLatin'] as String,
      levelId: json['niveauId'] as int,
      levelLabelLongAr: json['niveauLibelleLongAr'] as String,
      levelLabelLongLat: json['niveauLibelleLongLt'] as String,
      registrationNumber: json['numeroInscription'] as String,
      trainingOfferId: json['ouvertureOffreFormationId'] as int,
      photo: json['photo'] as String,
      cycleLabel: json['refLibelleCycle'] as String,
      cycleLabelAr: json['refLibelleCycleAr'] as String,
      statusId: json['situationId'] as int,
      transportPaid: json['transportPaye'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anneeAcademiqueCode': academicYearCode,
      'anneeAcademiqueId': academicYearId,
      'id': id,
      'individuNomArabe': individualLastNameAr,
      'individuNomLatin': individualLastNameFr,
      'individuPrenomArabe': individualFirstNameAr,
      'individuPrenomLatin': individualFirstNameFr,
      'niveauId': levelId,
      'niveauLibelleLongAr': levelLabelLongAr,
      'niveauLibelleLongLt': levelLabelLongLat,
      'numeroInscription': registrationNumber,
      'ouvertureOffreFormationId': trainingOfferId,
      'photo': photo,
      'refLibelleCycle': cycleLabel,
      'refLibelleCycleAr': cycleLabelAr,
      'situationId': statusId,
      'transportPaye': transportPaid,
    };
  }
}
