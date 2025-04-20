import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/timeline/presentation/widgets/event.dart';

WeekView<Object?> buildWeekView({
  required BuildContext context,
  required Key weekViewKey,
  EventController<Object?>? eventController,
  DateTime? currentWeekStart,
}) {
  return WeekView(
    key: weekViewKey,
    minuteSlotSize: MinuteSlotSize.minutes60,
    controller: eventController,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    startDay: WeekDays.saturday,
    startHour: 7,
    endHour: 20,
    showVerticalLines: true,
    liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
      offset: 60,
      color: Colors.red,
    ),
    onHeaderTitleTap: null,
    showHalfHours: true,
    heightPerMinute: 1.3,
    timeLineBuilder: (date) {
      String formattedTime = DateFormat('HH:mm').format(date);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(formattedTime, style: const TextStyle(fontSize: 10)),
      );
    },
    showLiveTimeLineInAllDays: true,
    timeLineStringBuilder: (date, {secondaryDate}) {
      String formattedTime = DateFormat('HH:mm').format(date);
      return formattedTime;
    },
    onDateTap: null,
    halfHourIndicatorSettings: const HourIndicatorSettings(
      color: Colors.transparent,
    ),
    headerStyle: HeaderStyle(
      rightIconConfig: null,
      leftIconConfig: null,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    ),
    pageViewPhysics: const NeverScrollableScrollPhysics(),
    weekDays: const [
      WeekDays.saturday,
      WeekDays.sunday,
      WeekDays.monday,
      WeekDays.tuesday,
      WeekDays.wednesday,
      WeekDays.thursday,
    ],
    initialDay: currentWeekStart,
    minDay: DateTime.now().subtract(const Duration(days: 365)),
    maxDay: DateTime.now().add(const Duration(days: 365)),
    eventArranger: const SideEventArranger(),
    // Add a smaller timeline width for mobile
    timeLineWidth: 40,
    // Custom day name builder for better mobile display
    weekDayBuilder: (date) {
      // Get weekday name in compact form
      final weekdayNames = [
        '',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ];
      final weekdayName = weekdayNames[date.weekday];

      // Also show the day of month
      final dayOfMonth = date.day.toString();

      return Container(
        decoration: BoxDecoration(
          color:
              date.day == DateTime.now().day
                  ? AppTheme.AppPrimary.withValues(alpha: 0.1)
                  : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: AppTheme.AppPrimary.withValues(alpha: 0.2),
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
                color:
                    date.day == DateTime.now().day ? AppTheme.AppPrimary : null,
              ),
            ),
            Text(
              dayOfMonth,
              style: TextStyle(
                fontSize: 9,
                color:
                    date.day == DateTime.now().day ? AppTheme.AppPrimary : null,
              ),
            ),
          ],
        ),
      );
    },

    eventTileBuilder: (date, events, boundary, start, end) {
      if (events.isEmpty) {
        return const SizedBox();
      }

      return eventBuilder(events.first, boundary, start, end, context);
    },
    weekPageHeaderBuilder: (startDate, endDate) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 4),
        color: AppTheme.AppPrimary.withValues(alpha: 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_formatDate(startDate)} - ${_formatDate(endDate)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      );
    },
  );
}

String _formatDate(DateTime date) {
  // Format as Day Month, Year (e.g., "12 Oct, 2023")
  return DateFormat('d MMM, yyyy').format(date);
}
