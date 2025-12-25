class StudentDischarge {
  final bool departmentStatus;
  final bool facultyLibraryStatus;
  final bool centralLibraryStatus;
  final bool residenceStatus;
  final bool scholarshipStatus;

  StudentDischarge({
    this.departmentStatus = false,
    this.facultyLibraryStatus = false,
    this.centralLibraryStatus = false,
    this.residenceStatus = false,
    this.scholarshipStatus = false,
  });

  factory StudentDischarge.fromJson(Map<String, dynamic> json) {
    return StudentDischarge(
      departmentStatus: toBool((json['sitDep'])),
      facultyLibraryStatus: toBool(json['sitBf']),
      centralLibraryStatus: toBool(json['sitBc']),
      residenceStatus: toBool(json['sitRu']),
      scholarshipStatus: toBool(json['sitBrs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sitDep': departmentStatus,
      'sitBf': facultyLibraryStatus,
      'sitBc': centralLibraryStatus,
      'sitRu': residenceStatus,
      'sitBrs': scholarshipStatus,
    };
  }
}

bool toBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  return false; // default fallback
}
