class StudentDischarge {
  final bool sitDep;
  final bool sitBf;
  final bool sitBc;
  final bool sitRu;
  final bool sitBr;

  StudentDischarge({
    this.sitDep = false,
    this.sitBf = false,
    this.sitBc = false,
    this.sitRu = false,
    this.sitBr = false,
  });

  factory StudentDischarge.fromJson(Map<String, dynamic> json) {
    return StudentDischarge(
      sitBc: (json['sitBc'] as int?) == 1,
      sitBr:
          (json['sitBrs'] as int?) == 1, // Note: API uses 'sitBrs' not 'sitBr'
      sitDep: (json['sitDep'] as int?) == 1,
      sitBf: (json['sitBf'] as int?) == 1,
      sitRu: (json['sitRu'] as int?) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sitDep': sitDep,
      'sitBf': sitBf,
      'sitBc': sitBc,
      'sitRu': sitRu,
      'sitBr': sitBr,
    };
  }
}
