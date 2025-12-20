class AcademicYear {
  final int id;
  final String code;

  AcademicYear({required this.id, required this.code});

  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(id: json['id'] as int, code: json['code'] as String);
  }

  AcademicYear copyWith({int? id, String? code}) {
    return AcademicYear(id: id ?? this.id, code: code ?? this.code);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'code': code};
  }
}
