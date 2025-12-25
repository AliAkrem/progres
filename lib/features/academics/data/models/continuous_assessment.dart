import 'package:flutter/material.dart';
import 'package:progres/l10n/app_localizations.dart';

class ContinuousAssessment {
  final bool absent;
  final String apCode; // Assessment type code (PRJ, TD, TP)
  final bool requestAppealAuthorization;
  final int id;
  final int diaId;
  final String periodLabel;
  final String periodLabelAr;
  final double? note;
  final String? observation;
  final String subjectLabelAr;
  final String subjectLabelFr;
  final bool? appealGranted;
  final bool? appealRequested;

  ContinuousAssessment({
    required this.absent,
    required this.apCode,
    required this.requestAppealAuthorization,
    required this.id,
    required this.diaId,
    required this.periodLabel,
    required this.periodLabelAr,
    this.note,
    this.observation,
    required this.subjectLabelAr,
    required this.subjectLabelFr,
    this.appealGranted,
    this.appealRequested,
  });

  factory ContinuousAssessment.fromJson(Map<String, dynamic> json) {
    return ContinuousAssessment(
      absent: json['absent'] as bool,
      apCode: json['apCode'] as String,
      requestAppealAuthorization: json['autorisationDemandeRecours'] as bool,
      id: json['id'] as int,
      diaId: json['id_dia'] as int,
      periodLabel: json['llPeriode'] as String,
      periodLabelAr: json['llPeriodeAr'] as String,
      note: json['note'] != null ? (json['note'] as num).toDouble() : null,
      observation: json['observation'] as String?,
      subjectLabelAr: json['rattachementMcMcLibelleAr'] as String,
      subjectLabelFr: json['rattachementMcMcLibelleFr'] as String,
      appealGranted: json['recoursAccorde'] as bool?,
      appealRequested: json['recoursDemande'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'absent': absent,
      'apCode': apCode,
      'autorisationDemandeRecours': requestAppealAuthorization,
      'id': id,
      'id_dia': diaId,
      'llPeriode': periodLabel,
      'llPeriodeAr': periodLabelAr,
      'note': note,
      'observation': observation,
      'rattachementMcMcLibelleAr': subjectLabelAr,
      'rattachementMcMcLibelleFr': subjectLabelFr,
      'recoursAccorde': appealGranted,
      'recoursDemande': appealRequested,
    };
  }

  // Helper method to get the assessment type label
  String assessmentTypeLabel(BuildContext context) {
    switch (apCode) {
      case 'PRJ':
        return AppLocalizations.of(context)!.project;
      case 'TD':
        return AppLocalizations.of(context)!.tutorialWork;
      case 'TP':
        return AppLocalizations.of(context)!.practicalWork;
      default:
        return apCode;
    }
  }
}
