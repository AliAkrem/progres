class DebtCourse {
  final String mcFr;
  final String mcAr;
  final String nfr;
  final String nar;
  final String pfr;
  final String par;
  final double m;
  final double md;
  final double cc;
  final double ccd;
  final double ex;
  final double exd;

  DebtCourse({
    required this.mcFr,
    required this.mcAr,
    required this.nfr,
    required this.nar,
    required this.pfr,
    required this.par,
    required this.m,
    required this.md,
    required this.cc,
    required this.ccd,
    required this.ex,
    required this.exd,
  });

  factory DebtCourse.fromJson(Map<String, dynamic> json) {
    return DebtCourse(
      mcFr: json['mcFr'] as String,
      mcAr: json['mcAr'] as String,
      nfr: json['nfr'] as String,
      nar: json['nar'] as String,
      pfr: json['pfr'] as String,
      par: json['par'] as String,
      m: (json['m'] as num).toDouble(),
      md: (json['md'] as num).toDouble(),
      cc: (json['cc'] as num).toDouble(),
      ccd: (json['ccd'] as num).toDouble(),
      ex: (json['ex'] as num).toDouble(),
      exd: (json['exd'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mcFr': mcFr,
      'mcAr': mcAr,
      'nfr': nfr,
      'nar': nar,
      'pfr': pfr,
      'par': par,
      'm': m,
      'md': md,
      'cc': cc,
      'ccd': ccd,
      'ex': ex,
      'exd': exd,
    };
  }
}
