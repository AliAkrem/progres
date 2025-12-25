class AcademicTranscript {
  final double average;
  final double semesterAverage;
  final double averageSn;
  final int creditsAcquired;
  final int id;
  final String levelLabelLongAr;
  final String levelLabelLongLat;
  final String periodLabelAr;
  final String periodLabelFr;
  final List<TranscriptUnit> unitAssessments;

  AcademicTranscript({
    required this.average,
    required this.semesterAverage,
    required this.averageSn,
    required this.creditsAcquired,
    required this.id,
    required this.levelLabelLongAr,
    required this.levelLabelLongLat,
    required this.periodLabelAr,
    required this.periodLabelFr,
    required this.unitAssessments,
  });

  factory AcademicTranscript.fromJson(Map<String, dynamic> json) {
    return AcademicTranscript(
      average: (json['moyenne'] as num).toDouble(),
      semesterAverage: (json['moyenneSemestre'] as num).toDouble(),
      averageSn: (json['moyenneSn'] as num).toDouble(),
      creditsAcquired: json['creditAcquis'] as int,
      id: json['id'] as int,
      levelLabelLongAr: json['niveauLibelleLongAr'] as String,
      levelLabelLongLat: json['niveauLibelleLongLt'] as String,
      periodLabelAr: json['periodeLibelleAr'] as String,
      periodLabelFr: json['periodeLibelleFr'] as String,
      unitAssessments: (json['bilanUes'] as List<dynamic>)
          .map((e) => TranscriptUnit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moyenne': average,
      'moyenneSemestre': semesterAverage,
      'moyenneSn': averageSn,
      'creditAcquis': creditsAcquired,
      'id': id,
      'niveauLibelleLongAr': levelLabelLongAr,
      'niveauLibelleLongLt': levelLabelLongLat,
      'periodeLibelleAr': periodLabelAr,
      'periodeLibelleFr': periodLabelFr,
      'bilanUes': unitAssessments.map((e) => e.toJson()).toList(),
    };
  }
}

class TranscriptUnit {
  final double average;
  final int credit;
  final int creditsAcquired;
  final int sessionAssessmentId;
  final String unitLabelAr;
  final String unitLabelFr;
  final String unitNatureLabelAr;
  final String unitNatureLabelFr;
  final List<TranscriptModuleComponent> moduleAssessments;

  TranscriptUnit({
    required this.average,
    required this.credit,
    required this.creditsAcquired,
    required this.sessionAssessmentId,
    required this.unitLabelAr,
    required this.unitLabelFr,
    required this.unitNatureLabelAr,
    required this.unitNatureLabelFr,
    required this.moduleAssessments,
  });

  factory TranscriptUnit.fromJson(Map<String, dynamic> json) {
    return TranscriptUnit(
      average: (json['moyenne'] as num).toDouble(),
      credit: json['credit'] as int,
      creditsAcquired: json['creditAcquis'] as int,
      sessionAssessmentId: json['id_bilan_session'] as int,
      unitLabelAr: json['ueLibelleAr'] as String,
      unitLabelFr: json['ueLibelleFr'] as String,
      unitNatureLabelAr: json['ueNatureLcAr'] as String,
      unitNatureLabelFr: json['ueNatureLcFr'] as String,
      moduleAssessments: (json['bilanMcs'] as List<dynamic>)
          .map(
            (e) =>
                TranscriptModuleComponent.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moyenne': average,
      'credit': credit,
      'creditAcquis': creditsAcquired,
      'id_bilan_session': sessionAssessmentId,
      'ueLibelleAr': unitLabelAr,
      'ueLibelleFr': unitLabelFr,
      'ueNatureLcAr': unitNatureLabelAr,
      'ueNatureLcFr': unitNatureLabelFr,
      'bilanMcs': moduleAssessments.map((e) => e.toJson()).toList(),
    };
  }
}

class TranscriptModuleComponent {
  final int coefficient;
  final int creditsObtained;
  final int unitAssessmentId;
  final String subjectLabelAr;
  final String subjectLabelFr;
  final double generalAverage;

  TranscriptModuleComponent({
    required this.coefficient,
    required this.creditsObtained,
    required this.unitAssessmentId,
    required this.subjectLabelAr,
    required this.subjectLabelFr,
    required this.generalAverage,
  });

  factory TranscriptModuleComponent.fromJson(Map<String, dynamic> json) {
    return TranscriptModuleComponent(
      coefficient: json['coefficient'] as int,
      creditsObtained: json['creditObtenu'] as int,
      unitAssessmentId: json['id_bilan_ue'] as int,
      subjectLabelAr: json['mcLibelleAr'] as String,
      subjectLabelFr: json['mcLibelleFr'] as String,
      generalAverage: (json['moyenneGenerale'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coefficient': coefficient,
      'creditObtenu': creditsObtained,
      'id_bilan_ue': unitAssessmentId,
      'mcLibelleAr': subjectLabelAr,
      'mcLibelleFr': subjectLabelFr,
      'moyenneGenerale': generalAverage,
    };
  }
}
