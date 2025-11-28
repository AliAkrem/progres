import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:progres/l10n/app_localizations.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/timeline/data/models/course_session.dart';
import 'package:progres/features/timeline/presentation/blocs/timeline_bloc.dart';
import 'package:progres/features/timeline/presentation/widgets/error.dart';
import 'package:progres/features/timeline/presentation/widgets/timeline.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  late EventController _eventController;
  DateTime _currentWeekStart = DateTime.now();

  @override
  void initState() {
    super.initState();

    _currentWeekStart = _getStartOfWeek(DateTime.now());

    final profileState = context.read<ProfileBloc>().state;

    if (profileState is ProfileLoaded) {
      context.read<TimelineBloc>().add(
        LoadWeeklyTimetable(enrollmentId: profileState.detailedInfo.id),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _eventController = CalendarControllerProvider.of(context).controller;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.weeklySchedule)),
      body: BlocListener<TimelineBloc, TimelineState>(
        listener: (context, state) {
          if (state is TimelineLoaded) {
            _updateCalendarWithSessions(state.sessions);
          }
        },
        child: BlocBuilder<TimelineBloc, TimelineState>(
          builder: (context, state) {
            if (state is TimelineLoading) {
              return _buildLoadingState();
            } else if (state is TimelineError) {
              return buildErrorState(state, context);
            }

            return buildTimeline(context);
          },
        ),
      ),
    );
  }

  Center _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  void _updateCalendarWithSessions(
    List<CourseSession> sessions, [
    DateTime? weekStart,
  ]) {
    _eventController.removeWhere((_) => true);

    final currentWeekStart = weekStart ?? _currentWeekStart;

    // Counter for events added this week
    int eventsAddedThisWeek = 0;
    Map<int, int> eventsByJourId = {};

    // Add each session as an event
    for (final session in sessions) {
      // Get the day for this specific week
      final day = session.getDayDateTime(weekStart: currentWeekStart);

      // Increment counter for this jourId
      eventsByJourId[session.jourId] =
          (eventsByJourId[session.jourId] ?? 0) + 1;

      // Get start and end times
      final startParts = session.plageHoraireHeureDebut.split(':');
      final endParts = session.plageHoraireHeureFin.split(':');

      final startTime = DateTime(
        day.year,
        day.month,
        day.day,
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );

      final endTime = DateTime(
        day.year,
        day.month,
        day.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

      final event = CalendarEventData(
        date: startTime,
        startTime: startTime,
        endTime: endTime,
        title: session.matiere,
        description:
            '${session.sessionType} - ${session.refLieuDesignation ?? ""}',
        event: session,
      );

      _eventController.add(event);
      eventsAddedThisWeek++;
    }

    if (eventsAddedThisWeek == 0 && mounted) {
      if (weekStart != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.noClassesThisWeek),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  DateTime _getStartOfWeek(DateTime date) {
    int daysToSaturday;

    if (date.weekday == 6) {
      // Already Saturday
      daysToSaturday = 0;
    } else if (date.weekday == 7) {
      // Sunday
      daysToSaturday = 1; // Go back 1 day to get to Saturday
    } else {
      // Monday-Friday (1-5)
      daysToSaturday =
          date.weekday + 1; // Go back to get to the previous Saturday
    }

    return DateTime(date.year, date.month, date.day - daysToSaturday);
  }
}
