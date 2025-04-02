class CourseCoefficient {
  final double coefficientControleContinu;
  final double coefficientControleIntermediaire;
  final double coefficientExamen;
  final String mcLibelleAr;
  final String mcLibelleFr;
  final String periodeLibelleAr;
  final String periodeLibelleFr;

  CourseCoefficient({
    required this.coefficientControleContinu,
    required this.coefficientControleIntermediaire,
    required this.coefficientExamen,
    required this.mcLibelleAr,
    required this.mcLibelleFr,
    required this.periodeLibelleAr,
    required this.periodeLibelleFr,
  });

  factory CourseCoefficient.fromJson(Map<String, dynamic> json) {
    return CourseCoefficient(
      coefficientControleContinu: _parseDouble(json['coefficientControleContinu']),
      coefficientControleIntermediaire: _parseDouble(json['coefficientControleIntermediaire']),
      coefficientExamen: _parseDouble(json['coefficientExamen']),
      mcLibelleAr: json['mcLibelleAr'] as String,
      mcLibelleFr: json['mcLibelleFr'] as String,
      periodeLibelleAr: json['periodeLibelleAr'] as String,
      periodeLibelleFr: json['periodeLibelleFr'] as String,
    );
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