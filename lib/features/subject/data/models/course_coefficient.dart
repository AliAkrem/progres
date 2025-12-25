import 'package:flutter/material.dart';

class CourseCoefficient {
  final double continuousAssessmentCoefficient;
  final double intermediaryAssessmentCoefficient;
  final double examCoefficient;
  final String subjectLabelAr;
  final String subjectLabelFr;
  final String periodLabelAr;
  final String periodLabelFr;

  CourseCoefficient({
    required this.continuousAssessmentCoefficient,
    required this.intermediaryAssessmentCoefficient,
    required this.examCoefficient,
    required this.subjectLabelAr,
    required this.subjectLabelFr,
    required this.periodLabelAr,
    required this.periodLabelFr,
  });

  factory CourseCoefficient.fromJson(Map<String, dynamic> json) {
    return CourseCoefficient(
      continuousAssessmentCoefficient: _parseDouble(
        json['coefficientControleContinu'],
      ),
      intermediaryAssessmentCoefficient: _parseDouble(
        json['coefficientControleIntermediaire'],
      ),
      examCoefficient: _parseDouble(json['coefficientExamen']),
      subjectLabelAr: json['mcLibelleAr'] as String,
      subjectLabelFr: json['mcLibelleFr'] as String,
      periodLabelAr: json['periodeLibelleAr'] as String,
      periodLabelFr: json['periodeLibelleFr'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coefficientControleContinu': continuousAssessmentCoefficient,
      'coefficientControleIntermediaire': intermediaryAssessmentCoefficient,
      'coefficientExamen': examCoefficient,
      'mcLibelleAr': subjectLabelAr,
      'mcLibelleFr': subjectLabelFr,
      'periodeLibelleAr': periodLabelAr,
      'periodeLibelleFr': periodLabelFr,
    };
  }

  // Helper function to handle both int and double values
  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    }
    return 0.0; // Default fallback
  }
}

class LocalizedCourseCoefficient {
  final CourseCoefficient courseCoefficient;
  final Locale deviceLocal;

  LocalizedCourseCoefficient({
    required this.courseCoefficient,
    required this.deviceLocal,
  });

  isAr() {
    return deviceLocal.languageCode.startsWith('ar');
  }

  String get subjectLabel {
    return isAr()
        ? courseCoefficient.subjectLabelAr
        : courseCoefficient.subjectLabelFr;
  }

  String get periodLabel {
    return isAr()
        ? courseCoefficient.periodLabelAr
        : courseCoefficient.periodLabelFr;
  }
}
