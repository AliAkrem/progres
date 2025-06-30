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
      sitDep: toBool((json['sitDep'])),
      sitBf: toBool(json['sitBf']),
      sitBc: toBool(json['sitBc']),
      sitRu: toBool(json['sitRu']),
      sitBrs: toBool(json['sitBrs']),
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

bool toBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  return false; // default fallback
}
