class StudentBasicInfo {
  final String dateOfBirth;
  final int id;
  final String placeOfBirth;
  final String placeOfBirthAr;
  final String lastNameAr;
  final String lastNameFr;
  final String nss;
  final String firstNameAr;
  final String firstNameFr;

  StudentBasicInfo({
    required this.dateOfBirth,
    required this.id,
    required this.placeOfBirth,
    required this.placeOfBirthAr,
    required this.lastNameAr,
    required this.lastNameFr,
    required this.nss,
    required this.firstNameAr,
    required this.firstNameFr,
  });

  factory StudentBasicInfo.fromJson(Map<String, dynamic> json) {
    return StudentBasicInfo(
      dateOfBirth: json['dateNaissance'] as String,
      id: json['id'] as int,
      placeOfBirth: json['lieuNaissance'] as String,
      placeOfBirthAr: json['lieuNaissanceArabe'] as String,
      lastNameAr: json['nomArabe'] as String,
      lastNameFr: json['nomLatin'] as String,
      nss: json['nss'] as String,
      firstNameAr: json['prenomArabe'] as String,
      firstNameFr: json['prenomLatin'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateNaissance': dateOfBirth,
      'id': id,
      'lieuNaissance': placeOfBirth,
      'lieuNaissanceArabe': placeOfBirthAr,
      'nomArabe': lastNameAr,
      'nomLatin': lastNameFr,
      'nss': nss,
      'prenomArabe': firstNameAr,
      'prenomLatin': firstNameFr,
    };
  }
}
