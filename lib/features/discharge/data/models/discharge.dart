class StudentDischarge {
  final bool sitDep;
  final bool sitBf;
  final bool sitBc;
  final bool sitRu;
  final bool sitBrs;

  StudentDischarge({
    this.sitDep = false,
    this.sitBf = false,
    this.sitBc = false,
    this.sitRu = false,
    this.sitBrs = false,
  });

  factory StudentDischarge.fromJson(Map<String, dynamic> json) {
    return StudentDischarge(
      sitBc: (json['sitBc'] as int?) == 1,
      sitBrs: (json['sitBrs'] as int?) == 1,
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
      'sitBrs': sitBrs,
    };
  }
}
