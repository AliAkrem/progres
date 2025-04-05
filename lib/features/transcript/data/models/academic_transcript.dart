class AcademicTranscript {
  final double moyenne;
  final double moyenneSemestre;
  final double moyenneSn;
  final int creditAcquis;
  final int id;
  final String niveauLibelleLongAr;
  final String niveauLibelleLongLt;
  final String periodeLibelleAr;
  final String periodeLibelleFr;
  final List<TranscriptUnit> bilanUes;

  AcademicTranscript({
    required this.moyenne,
    required this.moyenneSemestre,
    required this.moyenneSn,
    required this.creditAcquis,
    required this.id,
    required this.niveauLibelleLongAr,
    required this.niveauLibelleLongLt,
    required this.periodeLibelleAr,
    required this.periodeLibelleFr,
    required this.bilanUes,
  });

  factory AcademicTranscript.fromJson(Map<String, dynamic> json) {
    return AcademicTranscript(
      moyenne: (json['moyenne'] as num).toDouble(),
      moyenneSemestre: (json['moyenneSemestre'] as num).toDouble(),
      moyenneSn: (json['moyenneSn'] as num).toDouble(),
      creditAcquis: json['creditAcquis'] as int,
      id: json['id'] as int,
      niveauLibelleLongAr: json['niveauLibelleLongAr'] as String,
      niveauLibelleLongLt: json['niveauLibelleLongLt'] as String,
      periodeLibelleAr: json['periodeLibelleAr'] as String,
      periodeLibelleFr: json['periodeLibelleFr'] as String,
      bilanUes: (json['bilanUes'] as List<dynamic>)
          .map((e) => TranscriptUnit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'moyenne': moyenne,
      'moyenneSemestre': moyenneSemestre,
      'moyenneSn': moyenneSn,
      'creditAcquis': creditAcquis,
      'id': id,
      'niveauLibelleLongAr': niveauLibelleLongAr,
      'niveauLibelleLongLt': niveauLibelleLongLt,
      'periodeLibelleAr': periodeLibelleAr,
      'periodeLibelleFr': periodeLibelleFr,
      'bilanUes': bilanUes.map((e) => e.toJson()).toList(),
    };
  }
}

class TranscriptUnit {
  final double moyenne;
  final int credit;
  final int creditAcquis;
  final int id_bilan_session;
  final String ueLibelleAr;
  final String ueLibelleFr;
  final String ueNatureLcAr;
  final String ueNatureLcFr;
  final List<TranscriptModuleComponent> bilanMcs;

  TranscriptUnit({
    required this.moyenne,
    required this.credit,
    required this.creditAcquis,
    required this.id_bilan_session,
    required this.ueLibelleAr,
    required this.ueLibelleFr,
    required this.ueNatureLcAr,
    required this.ueNatureLcFr,
    required this.bilanMcs,
  });

  factory TranscriptUnit.fromJson(Map<String, dynamic> json) {
    return TranscriptUnit(
      moyenne: (json['moyenne'] as num).toDouble(),
      credit: json['credit'] as int,
      creditAcquis: json['creditAcquis'] as int,
      id_bilan_session: json['id_bilan_session'] as int,
      ueLibelleAr: json['ueLibelleAr'] as String,
      ueLibelleFr: json['ueLibelleFr'] as String,
      ueNatureLcAr: json['ueNatureLcAr'] as String,
      ueNatureLcFr: json['ueNatureLcFr'] as String,
      bilanMcs: (json['bilanMcs'] as List<dynamic>)
          .map((e) => TranscriptModuleComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'moyenne': moyenne,
      'credit': credit,
      'creditAcquis': creditAcquis,
      'id_bilan_session': id_bilan_session,
      'ueLibelleAr': ueLibelleAr,
      'ueLibelleFr': ueLibelleFr,
      'ueNatureLcAr': ueNatureLcAr,
      'ueNatureLcFr': ueNatureLcFr,
      'bilanMcs': bilanMcs.map((e) => e.toJson()).toList(),
    };
  }
}

class TranscriptModuleComponent {
  final int coefficient;
  final int creditObtenu;
  final int id_bilan_ue;
  final String mcLibelleAr;
  final String mcLibelleFr;
  final double moyenneGenerale;

  TranscriptModuleComponent({
    required this.coefficient,
    required this.creditObtenu,
    required this.id_bilan_ue,
    required this.mcLibelleAr,
    required this.mcLibelleFr,
    required this.moyenneGenerale,
  });

  factory TranscriptModuleComponent.fromJson(Map<String, dynamic> json) {
    return TranscriptModuleComponent(
      coefficient: json['coefficient'] as int,
      creditObtenu: json['creditObtenu'] as int,
      id_bilan_ue: json['id_bilan_ue'] as int,
      mcLibelleAr: json['mcLibelleAr'] as String,
      mcLibelleFr: json['mcLibelleFr'] as String,
      moyenneGenerale: (json['moyenneGenerale'] as num).toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'coefficient': coefficient,
      'creditObtenu': creditObtenu,
      'id_bilan_ue': id_bilan_ue,
      'mcLibelleAr': mcLibelleAr,
      'mcLibelleFr': mcLibelleFr,
      'moyenneGenerale': moyenneGenerale,
    };
  }
} 