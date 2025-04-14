import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/timeline/data/models/course_session.dart';

Widget eventBuilder(
  CalendarEventData event,
  Rect boundary,
  DateTime start,
  DateTime end,
) {
  final courseSession = event.event as CourseSession?;

  Color bgColor;
  if (courseSession?.ap == 'CM') {
    bgColor = AppTheme.accentGreen;
  } else if (courseSession?.ap == 'TD') {
    bgColor = AppTheme.AppSecondary;
  } else if (courseSession?.ap == 'TP') {
    bgColor = AppTheme.accentBlue;
  } else {
    bgColor = Colors.grey.shade300;
  }

  int durationMinutes = end.difference(start).inMinutes;
  bool isShortEvent = durationMinutes <= 60;

  return Container(
    width: boundary.width,
    height: boundary.height,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(6),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    margin: const EdgeInsets.all(1),
    padding: const EdgeInsets.all(4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 11,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (!isShortEvent && courseSession?.sessionType != null) ...[
          const SizedBox(height: 2),
          Text(
            courseSession!.sessionType,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
        if (!isShortEvent && courseSession?.instructorName != null) ...[
          const SizedBox(height: 2),
          Text(
            courseSession!.instructorName!,
            style: const TextStyle(color: Colors.white, fontSize: 9),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (!isShortEvent && courseSession?.refLieuDesignation != null) ...[
          const SizedBox(height: 2),
          Text(
            courseSession!.refLieuDesignation!,
            style: const TextStyle(color: Colors.white, fontSize: 9),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    ),
  );
}
