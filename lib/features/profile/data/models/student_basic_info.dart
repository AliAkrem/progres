class StudentBasicInfo {
  final String dateNaissance;
  final int id;
  final String lieuNaissance;
  final String lieuNaissanceArabe;
  final String nomArabe;
  final String nomLatin;
  final String nss;
  final String prenomArabe;
  final String prenomLatin;

  StudentBasicInfo({
    required this.dateNaissance,
    required this.id,
    required this.lieuNaissance,
    required this.lieuNaissanceArabe,
    required this.nomArabe,
    required this.nomLatin,
    required this.nss,
    required this.prenomArabe,
    required this.prenomLatin,
  });

  factory StudentBasicInfo.fromJson(Map<String, dynamic> json) {
    return StudentBasicInfo(
      dateNaissance: json['dateNaissance'] as String,
      id: json['id'] as int,
      lieuNaissance: json['lieuNaissance'] as String,
      lieuNaissanceArabe: json['lieuNaissanceArabe'] as String,
      nomArabe: json['nomArabe'] as String,
      nomLatin: json['nomLatin'] as String,
      nss: json['nss'] as String,
      prenomArabe: json['prenomArabe'] as String,
      prenomLatin: json['prenomLatin'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateNaissance': dateNaissance,
      'id': id,
      'lieuNaissance': lieuNaissance,
      'lieuNaissanceArabe': lieuNaissanceArabe,
      'nomArabe': nomArabe,
      'nomLatin': nomLatin,
      'nss': nss,
      'prenomArabe': prenomArabe,
      'prenomLatin': prenomLatin,
    };
  }
}
