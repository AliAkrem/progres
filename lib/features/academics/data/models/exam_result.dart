class ExamResult {
  final bool requestAppealAuthorization;
  final String? appealStartDate;
  final String? appealEndDate;
  final int id;
  final int periodId;
  final int diaId;
  final String subjectLabelAr;
  final String subjectLabelFr;
  final double? examMark;
  final int planningSessionId;
  final String sessionLabel;
  final int subjectCoefficient;
  final int subjectId;
  final bool? appealGranted;
  final bool? appealRequested;

  ExamResult({
    required this.requestAppealAuthorization,
    this.appealStartDate,
    this.appealEndDate,
    required this.id,
    required this.periodId,
    required this.diaId,
    required this.subjectLabelAr,
    required this.subjectLabelFr,
    this.examMark,
    required this.planningSessionId,
    required this.sessionLabel,
    required this.subjectCoefficient,
    required this.subjectId,
    this.appealGranted,
    this.appealRequested,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      requestAppealAuthorization: json['autorisationDemandeRecours'] as bool,
      appealStartDate: json['dateDebutDepotRecours'] as String?,
      appealEndDate: json['dateLimiteDepotRecours'] as String?,
      id: json['id'] as int,
      periodId: json['idPeriode'] as int,
      diaId: json['id_dia'] as int,
      subjectLabelAr: json['mcLibelleAr'] as String,
      subjectLabelFr: json['mcLibelleFr'] as String,
      examMark: json['noteExamen'] != null
          ? (json['noteExamen'] as num).toDouble()
          : null,
      planningSessionId: json['planningSessionId'] as int,
      sessionLabel: json['planningSessionIntitule'] as String,
      subjectCoefficient: json['rattachementMcCoefficient'] as int,
      subjectId: json['rattachementMcId'] as int,
      appealGranted: json['recoursAccorde'] as bool?,
      appealRequested: json['recoursDemande'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autorisationDemandeRecours': requestAppealAuthorization,
      'dateDebutDepotRecours': appealStartDate,
      'dateLimiteDepotRecours': appealEndDate,
      'id': id,
      'idPeriode': periodId,
      'id_dia': diaId,
      'mcLibelleAr': subjectLabelAr,
      'mcLibelleFr': subjectLabelFr,
      'noteExamen': examMark,
      'planningSessionId': planningSessionId,
      'planningSessionIntitule': sessionLabel,
      'rattachementMcCoefficient': subjectCoefficient,
      'rattachementMcId': subjectId,
      'recoursAccorde': appealGranted,
      'recoursDemande': appealRequested,
    };
  }
}
