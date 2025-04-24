class StudentDetailedInfo {
  final String anneeAcademiqueCode;
  final int anneeAcademiqueId;
  final int id;
  final String individuNomArabe;
  final String individuNomLatin;
  final String individuPrenomArabe;
  final String individuPrenomLatin;
  final int niveauId;
  final String niveauLibelleLongAr;
  final String niveauLibelleLongLt;
  final String numeroInscription;
  final int ouvertureOffreFormationId;
  final String photo;
  final String refLibelleCycle;
  final String refLibelleCycleAr;
  final int situationId;
  final bool transportPaye;

  StudentDetailedInfo({
    required this.anneeAcademiqueCode,
    required this.anneeAcademiqueId,
    required this.id,
    required this.individuNomArabe,
    required this.individuNomLatin,
    required this.individuPrenomArabe,
    required this.individuPrenomLatin,
    required this.niveauId,
    required this.niveauLibelleLongAr,
    required this.niveauLibelleLongLt,
    required this.numeroInscription,
    required this.ouvertureOffreFormationId,
    required this.photo,
    required this.refLibelleCycle,
    required this.refLibelleCycleAr,
    required this.situationId,
    required this.transportPaye,
  });

  factory StudentDetailedInfo.fromJson(Map<String, dynamic> json) {
    return StudentDetailedInfo(
      anneeAcademiqueCode: json['anneeAcademiqueCode'] as String,
      anneeAcademiqueId: json['anneeAcademiqueId'] as int,
      id: json['id'] as int,
      individuNomArabe: json['individuNomArabe'] as String,
      individuNomLatin: json['individuNomLatin'] as String,
      individuPrenomArabe: json['individuPrenomArabe'] as String,
      individuPrenomLatin: json['individuPrenomLatin'] as String,
      niveauId: json['niveauId'] as int,
      niveauLibelleLongAr: json['niveauLibelleLongAr'] as String,
      niveauLibelleLongLt: json['niveauLibelleLongLt'] as String,
      numeroInscription: json['numeroInscription'] as String,
      ouvertureOffreFormationId: json['ouvertureOffreFormationId'] as int,
      photo: json['photo'] as String,
      refLibelleCycle: json['refLibelleCycle'] as String,
      refLibelleCycleAr: json['refLibelleCycleAr'] as String,
      situationId: json['situationId'] as int,
      transportPaye: json['transportPaye'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anneeAcademiqueCode': anneeAcademiqueCode,
      'anneeAcademiqueId': anneeAcademiqueId,
      'id': id,
      'individuNomArabe': individuNomArabe,
      'individuNomLatin': individuNomLatin,
      'individuPrenomArabe': individuPrenomArabe,
      'individuPrenomLatin': individuPrenomLatin,
      'niveauId': niveauId,
      'niveauLibelleLongAr': niveauLibelleLongAr,
      'niveauLibelleLongLt': niveauLibelleLongLt,
      'numeroInscription': numeroInscription,
      'ouvertureOffreFormationId': ouvertureOffreFormationId,
      'photo': photo,
      'refLibelleCycle': refLibelleCycle,
      'refLibelleCycleAr': refLibelleCycleAr,
      'situationId': situationId,
      'transportPaye': transportPaye,
    };
  }
}
