class AnnualTranscriptSummary {
  final int creditAcquis;
  final double moyenne;
  final String typeDecisionLibelleAr;
  final String typeDecisionLibelleFr;

  AnnualTranscriptSummary({
    required this.creditAcquis,
    required this.moyenne,
    required this.typeDecisionLibelleAr,
    required this.typeDecisionLibelleFr,
  });

  factory AnnualTranscriptSummary.fromJson(Map<String, dynamic> json) {
    return AnnualTranscriptSummary(
      creditAcquis: json['creditAcquis'] as int,
      moyenne: (json['moyenne'] as num).toDouble(),
      typeDecisionLibelleAr: json['typeDecisionLibelleAr'] as String,
      typeDecisionLibelleFr: json['typeDecisionLibelleFr'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creditAcquis': creditAcquis,
      'moyenne': moyenne,
      'typeDecisionLibelleAr': typeDecisionLibelleAr,
      'typeDecisionLibelleFr': typeDecisionLibelleFr,
    };
  }
}
