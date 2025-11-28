import 'package:flutter/material.dart';
import 'package:progres/l10n/app_localizations.dart';

class CourseSession {
  final String ap;
  final String groupe;
  final int id;
  final int jourId;
  final String jourLibelleAr;
  final String jourLibelleFr;
  final String matiere;
  final String matiereAr;
  final String? nomEnseignantArabe;
  final String? nomEnseignantLatin;
  final int periodeId;
  final String plageHoraireHeureDebut;
  final String plageHoraireHeureFin;
  final String plageHoraireLibelleFr;
  final String? prenomEnseignantArabe;
  final String? prenomEnseignantLatin;
  final String? refLieuDesignation;

  CourseSession({
    required this.ap,
    required this.groupe,
    required this.id,
    required this.jourId,
    required this.jourLibelleAr,
    required this.jourLibelleFr,
    required this.matiere,
    required this.matiereAr,
    this.nomEnseignantArabe,
    this.nomEnseignantLatin,
    required this.periodeId,
    required this.plageHoraireHeureDebut,
    required this.plageHoraireHeureFin,
    required this.plageHoraireLibelleFr,
    this.prenomEnseignantArabe,
    this.prenomEnseignantLatin,
    this.refLieuDesignation,
  });

  factory CourseSession.fromJson(Map<String, dynamic> json) {
    return CourseSession(
      ap: json['ap'] as String,
      groupe: json['groupe'] as String,
      id: json['id'] as int,
      jourId: json['jourId'] as int,
      jourLibelleAr: json['jourLibelleAr'] as String,
      jourLibelleFr: json['jourLibelleFr'] as String,
      matiere: json['matiere'] as String,
      matiereAr: json['matiereAr'] as String,
      nomEnseignantArabe: json['nomEnseignantArabe'] as String?,
      nomEnseignantLatin: json['nomEnseignantLatin'] as String?,
      periodeId: json['periodeId'] as int,
      plageHoraireHeureDebut: json['plageHoraireHeureDebut'] as String,
      plageHoraireHeureFin: json['plageHoraireHeureFin'] as String,
      plageHoraireLibelleFr: json['plageHoraireLibelleFr'] as String,
      prenomEnseignantArabe: json['prenomEnseignantArabe'] as String?,
      prenomEnseignantLatin: json['prenomEnseignantLatin'] as String?,
      refLieuDesignation: json['refLieuDesignation'] as String?,
    );
  }

  DateTime get startTime {
    final parts = plageHoraireHeureDebut.split(':');
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  DateTime get endTime {
    final parts = plageHoraireHeureFin.split(':');
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  // Helper method to map jourId to a DateTime for the current week
  DateTime getDayDateTime({DateTime? weekStart}) {
    // Map jourId to correct weekday numbers based on the actual API data
    // According to the user, jourId 5 is Jeudi (Thursday)

    // This mapping directly maps jourId to the day offset from Saturday
    // Since we use Saturday as the first day (index 0) in our week view
    final Map<int, int> jourIdToDayOffset = {
      1: 1, // jourId 1 = Saturday (offset 0)
      2: 2, // jourId 2 = Sunday (offset 1)
      3: 3, // jourId 3 = Monday (offset 2)
      4: 4, // jourId 4 = Tuesday (offset 3)
      5: 5, // jourId 5 = Wednesday (offset 4)
      6: 6, // jourId 6 = Thursday (offset 5)
      7: 7, // jourId 7 = Friday (offset 6)
    };

    // Get the correct day offset from the jourId (default to 0 = Saturday if not found)
    final int dayOffset = jourIdToDayOffset[jourId] ?? 0;

    // If no weekStart is provided, use the current week's Saturday
    final DateTime saturday = weekStart ?? _getStartOfCurrentWeek();

    // Add the day offset to get to the correct day
    final result = saturday.add(Duration(days: dayOffset));

    // Print debug info for Sunday specifically
    if (jourId == 2) {
      // Sunday
      debugPrint(
        'SUNDAY EVENT: jourId $jourId ($jourLibelleFr) mapped to ${_formatDate(result)} (weekday: ${result.weekday})',
      );
    }

    return result;
  }

  // Helper method to format dates for debugging
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Get the start of the current week (Saturday)
  DateTime _getStartOfCurrentWeek() {
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1-7 where 1 is Monday, 7 is Sunday

    // Calculate days to subtract to get to the most recent Saturday
    // Saturday is weekday 6 in Dart
    int daysToSaturday;

    if (currentWeekday == 6) {
      // Already Saturday
      daysToSaturday = 0;
    } else if (currentWeekday == 7) {
      // Sunday
      daysToSaturday = 1; // Go back 1 day to Saturday
    } else {
      // Monday to Friday (1-5)
      daysToSaturday = currentWeekday + 1; // 2 for Monday, etc.
    }

    return DateTime(now.year, now.month, now.day - daysToSaturday);
  }

  // Get the type of class session
  String sessionType(BuildContext context) {
    switch (ap) {
      case 'CM':
        return AppLocalizations.of(context)!.lecture;
      case 'TD':
        return AppLocalizations.of(context)!.tutorial;
      case 'TP':
        return AppLocalizations.of(context)!.practical;
      default:
        return ap;
    }
  }

  // Get instructor full name
  String? get instructorName {
    if (nomEnseignantLatin != null && prenomEnseignantLatin != null) {
      return '$prenomEnseignantLatin $nomEnseignantLatin';
    } else if (nomEnseignantLatin != null) {
      return nomEnseignantLatin;
    } else if (prenomEnseignantLatin != null) {
      return prenomEnseignantLatin;
    }
    return null;
  }

  @override
  String toString() {
    return 'CourseSession(jourId: $jourId, day: $jourLibelleFr, matiere: $matiere, time: $plageHoraireHeureDebut-$plageHoraireHeureFin)';
  }

  Map<String, dynamic> toJson() {
    return {
      'ap': ap,
      'groupe': groupe,
      'id': id,
      'jourId': jourId,
      'jourLibelleAr': jourLibelleAr,
      'jourLibelleFr': jourLibelleFr,
      'matiere': matiere,
      'matiereAr': matiereAr,
      'nomEnseignantArabe': nomEnseignantArabe,
      'nomEnseignantLatin': nomEnseignantLatin,
      'periodeId': periodeId,
      'plageHoraireHeureDebut': plageHoraireHeureDebut,
      'plageHoraireHeureFin': plageHoraireHeureFin,
      'plageHoraireLibelleFr': plageHoraireLibelleFr,
      'prenomEnseignantArabe': prenomEnseignantArabe,
      'prenomEnseignantLatin': prenomEnseignantLatin,
      'refLieuDesignation': refLieuDesignation,
    };
  }
}
