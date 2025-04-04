import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/academics/data/models/course_session.dart';
import 'package:progres/features/academics/presentation/bloc/timeline_bloc.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final GlobalKey<WeekViewState> _weekViewKey = GlobalKey<WeekViewState>();
  late EventController _eventController;
  List<CourseSession>? _allSessions; // Store all sessions
  DateTime _currentWeekStart = DateTime.now(); // Track current week being displayed
  
  // Animation controllers
  bool _isWeekHeaderAnimating = false;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize current week start date (Saturday)
    _currentWeekStart = _getStartOfWeek(DateTime.now());
    
    // Load timeline if profile is loaded
    final profileState = context.read<ProfileBloc>().state;
    
    if (profileState is ProfileLoaded) {
      context.read<TimelineBloc>().add(
        LoadWeeklyTimetable(
          enrollmentId: profileState.detailedInfo.id,
        ),
      );
    }
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get controller from provider
    _eventController = CalendarControllerProvider.of(context).controller;
    
    // Debug print to verify startDay calculation
    final startDay = _getStartOfWeek(DateTime.now());
    print('Calculated current week start day: ${startDay.toString()}, weekday: ${startDay.weekday} (6=Saturday, 7=Sunday)');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Schedule'),
       
      ),
      body: BlocListener<TimelineBloc, TimelineState>(
        listener: (context, state) {
          if (state is TimelineLoaded) {
            _updateCalendarWithSessions(state.sessions);
          }
        },
        child: BlocBuilder<TimelineBloc, TimelineState>(
          builder: (context, state) {
            if (state is TimelineLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TimelineError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final profileState = context.read<ProfileBloc>().state;
                        if (profileState is ProfileLoaded) {
                          context.read<TimelineBloc>().add(
                            LoadWeeklyTimetable(
                              enrollmentId: profileState.detailedInfo.id,
                              forceReload: true,
                            ),
                          );
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            return Column(
              children: [
                // Legend for different course types
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Lecture',  AppTheme.accentGreen),
                      const SizedBox(width: 8),
                      _buildLegendItem('Tutorial', AppTheme.AppPrimary),
                      const SizedBox(width: 8),
                      _buildLegendItem('Practical', AppTheme.accentBlue ),
                    ],
                  ),
                ),
                // Calendar view
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      // Adjust width based on screen size with responsive scaling
                      width: _getOptimalViewWidth(context),
                      child: WeekView(
                        key: _weekViewKey,
                        minuteSlotSize: MinuteSlotSize.minutes60,
                        controller: _eventController,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        startDay: WeekDays.saturday,
                        startHour: 7,
                        endHour: 20,
                        showVerticalLines: true,
                        liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
                            // showTimeBackgroundView: true,
                            offset: 60,

                            // showTime: true,
                            color: Colors.red),
                        onHeaderTitleTap: null,
                        showHalfHours: true,
                        // hourIndicatorSettings: const HourIndicatorSettings(
                        //   offset: -60,
                        // ),
                        // Adjust height per minute for better mobile view
                        heightPerMinute: 1.3,
                        timeLineBuilder: (date) {
                          String formattedTime = DateFormat('HH:mm').format(date);
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              formattedTime,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                        showLiveTimeLineInAllDays: true,
                        timeLineStringBuilder: (date, {secondaryDate}) {
                          String formattedTime = DateFormat('HH:mm').format(date);
                          return formattedTime;
                        },
                        onDateTap: null,
                        halfHourIndicatorSettings:
                            const HourIndicatorSettings(color: Colors.transparent),
                        headerStyle: HeaderStyle(
                            rightIconConfig: null,
                            leftIconConfig: null,
                            decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor)),
                        pageViewPhysics: const NeverScrollableScrollPhysics(),
                        weekDays: const [
                          WeekDays.saturday,
                          WeekDays.sunday,
                          WeekDays.monday,
                          WeekDays.tuesday,
                          WeekDays.wednesday,
                          WeekDays.thursday,
                        ],
                        initialDay: _currentWeekStart,
                        minDay: DateTime.now().subtract(const Duration(days: 365)),
                        maxDay: DateTime.now().add(const Duration(days: 365)),
                        eventArranger: const SideEventArranger(),
                        // Add a smaller timeline width for mobile
                        timeLineWidth: 40,
                        // Custom day name builder for better mobile display
                        weekDayBuilder: (date) {
                          // Get weekday name in compact form
                          final weekdayNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          final weekdayName = weekdayNames[date.weekday];
                          
                          // Also show the day of month
                          final dayOfMonth = date.day.toString();
                          
                          return Container(
                            decoration: BoxDecoration(
                              color: date.day == DateTime.now().day ? 
                                  AppTheme.AppPrimary.withOpacity(0.1) : 
                                  Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: AppTheme.AppPrimary.withOpacity(0.2),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weekdayName,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: date.day == DateTime.now().day ? 
                                      AppTheme.AppPrimary : null,
                                  ),
                                ),
                                Text(
                                  dayOfMonth,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: date.day == DateTime.now().day ? 
                                      AppTheme.AppPrimary : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        onPageChange: (date, page) {
                          // Calculate the starting Saturday of this week
                          final newWeekStart = _getStartOfWeek(date);
                          if (newWeekStart != _currentWeekStart) {
                            _currentWeekStart = newWeekStart;
                            print('Week changed to: ${_currentWeekStart.toString()}');
                            
                            // Animate header briefly
                            setState(() {
                              _isWeekHeaderAnimating = true;
                            });
                            Future.delayed(const Duration(milliseconds: 300), () {
                              setState(() {
                                _isWeekHeaderAnimating = false;
                              });
                            });
                            
                            // Update calendar with events for the new week
                            if (_allSessions != null) {
                              _updateCalendarWithSessions(_allSessions!, _currentWeekStart);
                              
                              // Show feedback to user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Showing schedule for week of ${_formatDate(_currentWeekStart)}'),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        },
                        eventTileBuilder: (date, events, boundary, start, end) {
                          // Debug logging for what events are being built
                          print('Building tile for date: ${_formatDate(date)}, weekday: ${date.weekday}, events: ${events.length}');
                          
                          if (events.isEmpty) {
                            return const SizedBox();
                          }
                          
                          // For date debugging - print first few events
                          if (events.isNotEmpty) {
                            final session = events.first.event as CourseSession?;
                            if (session != null) {
                              print('  Event for jourId: ${session.jourId}, ${session.jourLibelleFr} -> ${session.matiere}');
                            }
                          }
                          
                          return _eventBuilder(events.first, boundary, start, end);
                        },
                        weekPageHeaderBuilder: (startDate, endDate) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            color: AppTheme.AppPrimary.withOpacity(_isWeekHeaderAnimating ? 0.3 : 0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${_formatDate(startDate)} - ${_formatDate(endDate)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _eventBuilder(CalendarEventData event, Rect boundary, DateTime start, DateTime end) {
    final courseSession = event.event as CourseSession?;
    
    // Determine color based on session type
    Color bgColor;
    if (courseSession?.ap == 'CM') {
      bgColor = AppTheme.accentGreen ;
    } else if (courseSession?.ap == 'TD') {
      bgColor =AppTheme.AppSecondary ;
    } else if (courseSession?.ap == 'TP') {
      bgColor = AppTheme.accentBlue ;
    } else {
      bgColor = Colors.grey.shade300;
    }
    
    // Get event duration in minutes for adaptive sizing
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
            color: Colors.black.withOpacity(0.1),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ],
          if (!isShortEvent && courseSession?.instructorName != null) ...[
            const SizedBox(height: 2),
            Text(
              courseSession!.instructorName!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (!isShortEvent && courseSession?.refLieuDesignation != null) ...[
            const SizedBox(height: 2),
            Text(
              courseSession!.refLieuDesignation!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
  
  void _updateCalendarWithSessions(List<CourseSession> sessions, [DateTime? weekStart]) {
    // Store all sessions for later use
    _allSessions = sessions;
    
    // Clear existing events
    _eventController.removeWhere((_) => true);
    
    final currentWeekStart = weekStart ?? _currentWeekStart;
    
    // Debug to verify the week start day is Saturday
    print('Updating calendar for week starting on: ${_formatDate(currentWeekStart)}, weekday: ${currentWeekStart.weekday} (6=Saturday)');
    
    // Counter for events added this week
    int eventsAddedThisWeek = 0;
    Map<int, int> eventsByJourId = {};
    
    // Add each session as an event
    for (final session in sessions) {
      // Get the day for this specific week
      final day = session.getDayDateTime(weekStart: currentWeekStart);
      
      // Increment counter for this jourId
      eventsByJourId[session.jourId] = (eventsByJourId[session.jourId] ?? 0) + 1;
      
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
      
      // Create event
      final event = CalendarEventData(
        date: startTime,
        startTime: startTime,
        endTime: endTime,
        title: session.matiere,
        description: '${session.sessionType} - ${session.refLieuDesignation ?? ""}',
        event: session, // Store the original session data for access in the builder
      );
      
      _eventController.add(event);
      eventsAddedThisWeek++;
    }
    
    // Show feedback if no events for this week
    if (eventsAddedThisWeek == 0 && mounted) {
      // Only show the message if we're coming from user interaction, not initial load
      if (weekStart != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No classes scheduled for this week'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    
    // Debug log
    print('Updated calendar with $eventsAddedThisWeek total sessions for week of ${_formatDate(currentWeekStart)}');
    print('Events by jourId: ${eventsByJourId.entries.map((e) => '${e.key}: ${e.value}').join(', ')}');
  }

  String _formatDate(DateTime date) {
    // Format as Day Month, Year (e.g., "12 Oct, 2023")
    return DateFormat('d MMM, yyyy').format(date);
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  // Get the date of the Saturday at or before the given date
  DateTime _getStartOfWeek(DateTime date) {
    // In Dart, weekday is 1-7 where 1 is Monday, 7 is Sunday, and 6 is Saturday
    // We want Saturday as the first day of the week
    int daysToSaturday;
    
    if (date.weekday == 6) { // Already Saturday
      daysToSaturday = 0;
    } else if (date.weekday == 7) { // Sunday
      daysToSaturday = 1; // Go back 1 day to get to Saturday
    } else { // Monday-Friday (1-5)
      daysToSaturday = date.weekday + 1; // Go back to get to the previous Saturday
    }
    
    return DateTime(date.year, date.month, date.day - daysToSaturday);
  }


  // Calculate optimal view width based on screen size
  double _getOptimalViewWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // For small screens, use a smaller multiplier to avoid excessive scrolling
    if (screenWidth < 360) {
      return screenWidth * 1.3;
    } else if (screenWidth < 480) {
      return screenWidth * 1.5;
    } else {
      // For tablets and larger screens, provide more space
      return screenWidth * 1.8;
    }
  }
} 