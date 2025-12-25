class AnnualTranscriptSummary {
  final int creditsAcquired;
  final double average;
  final String decisionTypeLabelAr;
  final String decisionTypeLabelFr;

  AnnualTranscriptSummary({
    required this.creditsAcquired,
    required this.average,
    required this.decisionTypeLabelAr,
    required this.decisionTypeLabelFr,
  });

  factory AnnualTranscriptSummary.fromJson(Map<String, dynamic> json) {
    return AnnualTranscriptSummary(
      creditsAcquired: json['creditAcquis'] as int,
      average: (json['moyenne'] as num).toDouble(),
      decisionTypeLabelAr: json['typeDecisionLibelleAr'] as String,
      decisionTypeLabelFr: json['typeDecisionLibelleFr'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creditAcquis': creditsAcquired,
      'moyenne': average,
      'typeDecisionLibelleAr': decisionTypeLabelAr,
      'typeDecisionLibelleFr': decisionTypeLabelFr,
    };
  }
}
