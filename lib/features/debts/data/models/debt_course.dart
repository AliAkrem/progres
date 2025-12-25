class DebtCourse {
  final String subjectLabelFr;
  final String subjectLabelAr;
  final String levelLabelFr;
  final String levelLabelAr;
  final String periodLabelFr;
  final String periodLabelAr;
  final double average;
  final double debtAverage;
  final double continuousAssessment;
  final double continuousAssessmentDebt;
  final double exam;
  final double examDebt;

  DebtCourse({
    required this.subjectLabelFr,
    required this.subjectLabelAr,
    required this.levelLabelFr,
    required this.levelLabelAr,
    required this.periodLabelFr,
    required this.periodLabelAr,
    required this.average,
    required this.debtAverage,
    required this.continuousAssessment,
    required this.continuousAssessmentDebt,
    required this.exam,
    required this.examDebt,
  });

  factory DebtCourse.fromJson(Map<String, dynamic> json) {
    return DebtCourse(
      subjectLabelFr: json['mcFr'] as String,
      subjectLabelAr: json['mcAr'] as String,
      levelLabelFr: json['nfr'] as String,
      levelLabelAr: json['nar'] as String,
      periodLabelFr: json['pfr'] as String,
      periodLabelAr: json['par'] as String,
      average: (json['m'] as num).toDouble(),
      debtAverage: (json['md'] as num).toDouble(),
      continuousAssessment: (json['cc'] as num).toDouble(),
      continuousAssessmentDebt: (json['ccd'] as num).toDouble(),
      exam: (json['ex'] as num).toDouble(),
      examDebt: (json['exd'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mcFr': subjectLabelFr,
      'mcAr': subjectLabelAr,
      'nfr': levelLabelFr,
      'nar': levelLabelAr,
      'pfr': periodLabelFr,
      'par': periodLabelAr,
      'm': average,
      'md': debtAverage,
      'cc': continuousAssessment,
      'ccd': continuousAssessmentDebt,
      'ex': exam,
      'exd': examDebt,
    };
  }
}
