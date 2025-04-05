class Enrollment {
  final String anneeAcademiqueCode;
  final int anneeAcademiqueId;
  final int id;
  final String? llEtablissementArabe;
  final String? llEtablissementLatin;
  final int niveauId;
  final String? niveauLibelleLongAr;
  final String? niveauLibelleLongLt;
  final String? numeroInscription;
  final String? ofLlDomaine;
  final String? ofLlDomaineArabe;
  final String? ofLlFiliere;
  final String? ofLlFiliereArabe;
  final String? ofLlSpecialite;
  final String? ofLlSpecialiteArabe;
  final int ouvertureOffreFormationId;
  final String? refLibelleCycle;
  final String? refLibelleCycleAr;
  final int situationId;

  Enrollment({
    required this.anneeAcademiqueCode,
    required this.anneeAcademiqueId,
    required this.id,
    this.llEtablissementArabe,
    this.llEtablissementLatin,
    required this.niveauId,
    this.niveauLibelleLongAr,
    this.niveauLibelleLongLt,
    this.numeroInscription,
    this.ofLlDomaine,
    this.ofLlDomaineArabe,
    this.ofLlFiliere,
    this.ofLlFiliereArabe,
    this.ofLlSpecialite,
    this.ofLlSpecialiteArabe,
    required this.ouvertureOffreFormationId,
    this.refLibelleCycle,
    this.refLibelleCycleAr,
    required this.situationId,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      anneeAcademiqueCode: json['anneeAcademiqueCode'] as String,
      anneeAcademiqueId: json['anneeAcademiqueId'] as int,
      id: json['id'] as int,
      llEtablissementArabe: json['llEtablissementArabe'] as String?,
      llEtablissementLatin: json['llEtablissementLatin'] as String?,
      niveauId: json['niveauId'] as int,
      niveauLibelleLongAr: json['niveauLibelleLongAr'] as String?,
      niveauLibelleLongLt: json['niveauLibelleLongLt'] as String?,
      numeroInscription: json['numeroInscription'] as String?,
      ofLlDomaine: json['ofLlDomaine'] as String?,
      ofLlDomaineArabe: json['ofLlDomaineArabe'] as String?,
      ofLlFiliere: json['ofLlFiliere'] as String?,
      ofLlFiliereArabe: json['ofLlFiliereArabe'] as String?,
      ofLlSpecialite: json['ofLlSpecialite'] as String?,
      ofLlSpecialiteArabe: json['ofLlSpecialiteArabe'] as String?,
      ouvertureOffreFormationId: json['ouvertureOffreFormationId'] as int,
      refLibelleCycle: json['refLibelleCycle'] as String?,
      refLibelleCycleAr: json['refLibelleCycleAr'] as String?,
      situationId: json['situationId'] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'anneeAcademiqueCode': anneeAcademiqueCode,
      'anneeAcademiqueId': anneeAcademiqueId,
      'id': id,
      'llEtablissementArabe': llEtablissementArabe,
      'llEtablissementLatin': llEtablissementLatin,
      'niveauId': niveauId,
      'niveauLibelleLongAr': niveauLibelleLongAr,
      'niveauLibelleLongLt': niveauLibelleLongLt,
      'numeroInscription': numeroInscription,
      'ofLlDomaine': ofLlDomaine,
      'ofLlDomaineArabe': ofLlDomaineArabe,
      'ofLlFiliere': ofLlFiliere,
      'ofLlFiliereArabe': ofLlFiliereArabe,
      'ofLlSpecialite': ofLlSpecialite,
      'ofLlSpecialiteArabe': ofLlSpecialiteArabe,
      'ouvertureOffreFormationId': ouvertureOffreFormationId,
      'refLibelleCycle': refLibelleCycle,
      'refLibelleCycleAr': refLibelleCycleAr,
      'situationId': situationId,
    };
  }
} 