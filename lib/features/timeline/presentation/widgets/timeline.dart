import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/timeline/presentation/widgets/week_view.dart';
import 'package:progres/l10n/gallery_localizations.dart';

Widget buildTimeline(BuildContext context) {
  final GlobalKey<WeekViewState> weekViewKey = GlobalKey<WeekViewState>();

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: _buildTimelineMap(context),
      ),
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            width: _getOptimalViewWidth(context),
            child: buildWeekView(
              context: context,
              weekViewKey: weekViewKey,
              eventController: null,
              currentWeekStart: DateTime.now(),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildTimelineMap(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildLegendItem(
        AppLocalizations.of(context)!.lecture,
        AppTheme.accentGreen,
      ),
      const SizedBox(width: 8),
      _buildLegendItem(
        AppLocalizations.of(context)!.tutorial,
        AppTheme.AppPrimary,
      ),
      const SizedBox(width: 8),
      _buildLegendItem(
        AppLocalizations.of(context)!.practical,
        AppTheme.accentBlue,
      ),
    ],
  );
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
      Text(label, style: const TextStyle(fontSize: 11)),
    ],
  );
}

double _getOptimalViewWidth(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth < 360) {
    return screenWidth * 1.3;
  } else if (screenWidth < 480) {
    return screenWidth * 1.5;
  } else {
    return screenWidth * 1.8;
  }
}
