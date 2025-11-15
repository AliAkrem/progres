class ExamResult {
  final bool autorisationDemandeRecours;
  final String? dateDebutDepotRecours;
  final String? dateLimiteDepotRecours;
  final int id;
  final int idPeriode;
  final int idDia;
  final String mcLibelleAr;
  final String mcLibelleFr;
  final double? noteExamen;
  final int planningSessionId;
  final String planningSessionIntitule;
  final int rattachementMcCoefficient;
  final int rattachementMcId;
  final bool? recoursAccorde;
  final bool? recoursDemande;

  ExamResult({
    required this.autorisationDemandeRecours,
    this.dateDebutDepotRecours,
    this.dateLimiteDepotRecours,
    required this.id,
    required this.idPeriode,
    required this.idDia,
    required this.mcLibelleAr,
    required this.mcLibelleFr,
    this.noteExamen,
    required this.planningSessionId,
    required this.planningSessionIntitule,
    required this.rattachementMcCoefficient,
    required this.rattachementMcId,
    this.recoursAccorde,
    this.recoursDemande,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      autorisationDemandeRecours: json['autorisationDemandeRecours'] as bool,
      dateDebutDepotRecours: json['dateDebutDepotRecours'] as String?,
      dateLimiteDepotRecours: json['dateLimiteDepotRecours'] as String?,
      id: json['id'] as int,
      idPeriode: json['idPeriode'] as int,
      idDia: json['id_dia'] as int,
      mcLibelleAr: json['mcLibelleAr'] as String,
      mcLibelleFr: json['mcLibelleFr'] as String,
      noteExamen: json['noteExamen'] != null
          ? (json['noteExamen'] as num).toDouble()
          : null,
      planningSessionId: json['planningSessionId'] as int,
      planningSessionIntitule: json['planningSessionIntitule'] as String,
      rattachementMcCoefficient: json['rattachementMcCoefficient'] as int,
      rattachementMcId: json['rattachementMcId'] as int,
      recoursAccorde: json['recoursAccorde'] as bool?,
      recoursDemande: json['recoursDemande'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autorisationDemandeRecours': autorisationDemandeRecours,
      'dateDebutDepotRecours': dateDebutDepotRecours,
      'dateLimiteDepotRecours': dateLimiteDepotRecours,
      'id': id,
      'idPeriode': idPeriode,
      'id_dia': idDia,
      'mcLibelleAr': mcLibelleAr,
      'mcLibelleFr': mcLibelleFr,
      'noteExamen': noteExamen,
      'planningSessionId': planningSessionId,
      'planningSessionIntitule': planningSessionIntitule,
      'rattachementMcCoefficient': rattachementMcCoefficient,
      'rattachementMcId': rattachementMcId,
      'recoursAccorde': recoursAccorde,
      'recoursDemande': recoursDemande,
    };
  }
}
