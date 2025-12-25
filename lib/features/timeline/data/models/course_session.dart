import 'package:flutter/material.dart';
import 'package:progres/l10n/app_localizations.dart';

class CourseSession {
  final String ap;
  final String group;
  final int id;
  final int dayId;
  final String dayLabelAr;
  final String dayLabelFr;
  final String subject;
  final String subjectAr;
  final String? teacherLastNameAr;
  final String? teacherLastNameFr;
  final int periodId;
  final String timeSlotStartTime;
  final String timeSlotEndTime;
  final String timeSlotLabelFr;
  final String? teacherFirstNameAr;
  final String? teacherFirstNameFr;
  final String? locationDesignation;

  CourseSession({
    required this.ap,
    required this.group,
    required this.id,
    required this.dayId,
    required this.dayLabelAr,
    required this.dayLabelFr,
    required this.subject,
    required this.subjectAr,
    this.teacherLastNameAr,
    this.teacherLastNameFr,
    required this.periodId,
    required this.timeSlotStartTime,
    required this.timeSlotEndTime,
    required this.timeSlotLabelFr,
    this.teacherFirstNameAr,
    this.teacherFirstNameFr,
    this.locationDesignation,
  });

  factory CourseSession.fromJson(Map<String, dynamic> json) {
    return CourseSession(
      ap: json['ap'] as String,
      group: json['groupe'] as String,
      id: json['id'] as int,
      dayId: json['jourId'] as int,
      dayLabelAr: json['jourLibelleAr'] as String,
      dayLabelFr: json['jourLibelleFr'] as String,
      subject: json['matiere'] as String,
      subjectAr: json['matiereAr'] as String,
      teacherLastNameAr: json['nomEnseignantArabe'] as String?,
      teacherLastNameFr: json['nomEnseignantLatin'] as String?,
      periodId: json['periodeId'] as int,
      timeSlotStartTime: json['plageHoraireHeureDebut'] as String,
      timeSlotEndTime: json['plageHoraireHeureFin'] as String,
      timeSlotLabelFr: json['plageHoraireLibelleFr'] as String,
      teacherFirstNameAr: json['prenomEnseignantArabe'] as String?,
      teacherFirstNameFr: json['prenomEnseignantLatin'] as String?,
      locationDesignation: json['refLieuDesignation'] as String?,
    );
  }

  DateTime get startTime {
    final parts = timeSlotStartTime.split(':');
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  DateTime get endTime {
    final parts = timeSlotEndTime.split(':');
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  // Helper method to map dayId to a DateTime for the current week
  DateTime getDayDateTime({DateTime? weekStart}) {
    // Map dayId to correct weekday numbers based on the actual API data
    // According to the user, dayId 5 is Jeudi (Thursday)

    // This mapping directly maps dayId to the day offset from Saturday
    // Since we use Saturday as the first day (index 0) in our week view
    final Map<int, int> dayIdToDayOffset = {
      1: 1, // dayId 1 = Saturday (offset 0)
      2: 2, // dayId 2 = Sunday (offset 1)
      3: 3, // dayId 3 = Monday (offset 2)
      4: 4, // dayId 4 = Tuesday (offset 3)
      5: 5, // dayId 5 = Wednesday (offset 4)
      6: 6, // dayId 6 = Thursday (offset 5)
      7: 7, // dayId 7 = Friday (offset 6)
    };

    // Get the correct day offset from the dayId (default to 0 = Saturday if not found)
    final int dayOffset = dayIdToDayOffset[dayId] ?? 0;

    // If no weekStart is provided, use the current week's Saturday
    final DateTime saturday = weekStart ?? _getStartOfCurrentWeek();

    // Add the day offset to get to the correct day
    final result = saturday.add(Duration(days: dayOffset));

    // Print debug info for Sunday specifically
    if (dayId == 2) {
      // Sunday
      debugPrint(
        'SUNDAY EVENT: dayId $dayId ($dayLabelFr) mapped to ${_formatDate(result)} (weekday: ${result.weekday})',
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
    if (teacherLastNameFr != null && teacherFirstNameFr != null) {
      return '$teacherFirstNameFr $teacherLastNameFr';
    } else if (teacherLastNameFr != null) {
      return teacherLastNameFr;
    } else if (teacherFirstNameFr != null) {
      return teacherFirstNameFr;
    }
    return null;
  }

  @override
  String toString() {
    return 'CourseSession(dayId: $dayId, day: $dayLabelFr, subject: $subject, time: $timeSlotStartTime-$timeSlotEndTime)';
  }

  Map<String, dynamic> toJson() {
    return {
      'ap': ap,
      'groupe': group,
      'id': id,
      'jourId': dayId,
      'jourLibelleAr': dayLabelAr,
      'jourLibelleFr': dayLabelFr,
      'matiere': subject,
      'matiereAr': subjectAr,
      'nomEnseignantArabe': teacherLastNameAr,
      'nomEnseignantLatin': teacherLastNameFr,
      'periodeId': periodId,
      'plageHoraireHeureDebut': timeSlotStartTime,
      'plageHoraireHeureFin': timeSlotEndTime,
      'plageHoraireLibelleFr': timeSlotLabelFr,
      'prenomEnseignantArabe': teacherFirstNameAr,
      'prenomEnseignantLatin': teacherFirstNameFr,
      'refLieuDesignation': locationDesignation,
    };
  }
}
