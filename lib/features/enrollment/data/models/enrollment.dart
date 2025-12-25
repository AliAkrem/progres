import 'package:flutter/material.dart';

class Enrollment {
  final String academicYearCode;
  final int academicYearId;
  final int id;
  final String? establishmentLabelAr;
  final String? establishmentLabelFr;
  final int levelId;
  final String? levelLabelLongAr;
  final String? levelLabelLongLat;
  final String? registrationNumber;
  final String? ofDomainLabel;
  final String? ofDomainLabelAr;
  final String? ofFieldLabel;
  final String? ofFieldLabelAr;
  final String? ofSpecialtyLabel;
  final String? ofSpecialtyLabelAr;
  final int trainingOfferId;
  final String? cycleLabel;
  final String? cycleLabelAr;
  final int statusId;

  Enrollment({
    required this.academicYearCode,
    required this.academicYearId,
    required this.id,
    this.establishmentLabelAr,
    this.establishmentLabelFr,
    required this.levelId,
    this.levelLabelLongAr,
    this.levelLabelLongLat,
    this.registrationNumber,
    this.ofDomainLabel,
    this.ofDomainLabelAr,
    this.ofFieldLabel,
    this.ofFieldLabelAr,
    this.ofSpecialtyLabel,
    this.ofSpecialtyLabelAr,
    required this.trainingOfferId,
    this.cycleLabel,
    this.cycleLabelAr,
    required this.statusId,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      academicYearCode: json['anneeAcademiqueCode'] as String,
      academicYearId: json['anneeAcademiqueId'] as int,
      id: json['id'] as int,
      establishmentLabelAr: json['llEtablissementArabe'] as String?,
      establishmentLabelFr: json['llEtablissementLatin'] as String?,
      levelId: json['niveauId'] as int,
      levelLabelLongAr: json['niveauLibelleLongAr'] as String?,
      levelLabelLongLat: json['niveauLibelleLongLt'] as String?,
      registrationNumber: json['numeroInscription'] as String?,
      ofDomainLabel: json['ofLlDomaine'] as String?,
      ofDomainLabelAr: json['ofLlDomaineArabe'] as String?,
      ofFieldLabel: json['ofLlFiliere'] as String?,
      ofFieldLabelAr: json['ofLlFiliereArabe'] as String?,
      ofSpecialtyLabel: json['ofLlSpecialite'] as String?,
      ofSpecialtyLabelAr: json['ofLlSpecialiteArabe'] as String?,
      trainingOfferId: json['ouvertureOffreFormationId'] as int,
      cycleLabel: json['refLibelleCycle'] as String?,
      cycleLabelAr: json['refLibelleCycleAr'] as String?,
      statusId: json['situationId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anneeAcademiqueCode': academicYearCode,
      'anneeAcademiqueId': academicYearId,
      'id': id,
      'llEtablissementArabe': establishmentLabelAr,
      'llEtablissementLatin': establishmentLabelFr,
      'niveauId': levelId,
      'niveauLibelleLongAr': levelLabelLongAr,
      'niveauLibelleLongLt': levelLabelLongLat,
      'numeroInscription': registrationNumber,
      'ofLlDomaine': ofDomainLabel,
      'ofLlDomaineArabe': ofDomainLabelAr,
      'ofLlFiliere': ofFieldLabel,
      'ofLlFiliereArabe': ofFieldLabelAr,
      'ofLlSpecialite': ofSpecialtyLabel,
      'ofLlSpecialiteArabe': ofSpecialtyLabelAr,
      'ouvertureOffreFormationId': trainingOfferId,
      'refLibelleCycle': cycleLabel,
      'refLibelleCycleAr': cycleLabelAr,
      'situationId': statusId,
    };
  }
}

class LocalizedEnrollment {
  final Enrollment enrollment;
  final Locale deviceLocale;
  LocalizedEnrollment({required this.deviceLocale, required this.enrollment});

  isAr() {
    return deviceLocale.languageCode == 'ar';
  }

  String get llEtablissement {
    return isAr()
        ? enrollment.establishmentLabelAr ?? ''
        : enrollment.establishmentLabelFr ?? '';
  }

  String get niveauLibelleLong {
    return isAr()
        ? enrollment.levelLabelLongAr ?? ''
        : enrollment.levelLabelLongLat ?? '';
  }

  String get ofLlDomaine {
    return isAr()
        ? enrollment.ofDomainLabelAr ?? ''
        : enrollment.ofDomainLabel ?? '';
  }

  String get ofLlFiliere {
    return isAr()
        ? enrollment.ofFieldLabelAr ?? ''
        : enrollment.ofFieldLabel ?? '';
  }

  String get ofLlSpecialite {
    return isAr()
        ? enrollment.ofSpecialtyLabelAr ?? ''
        : enrollment.ofSpecialtyLabel ?? '';
  }

  String get refLibelleCycle {
    return isAr()
        ? enrollment.cycleLabelAr ?? ''
        : enrollment.cycleLabel ?? '';
  }
}
