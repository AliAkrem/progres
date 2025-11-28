import 'package:flutter/material.dart';
import 'package:progres/features/academics/data/models/continuous_assessment.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/l10n/app_localizations.dart';

class ContinuousAssessmentCard extends StatelessWidget {
  final List<ContinuousAssessment> assessments;

  const ContinuousAssessmentCard({super.key, required this.assessments});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (assessments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noAssessmentsYet,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      );
    }

    // Group assessments by course
    final Map<String, List<ContinuousAssessment>> groupedByCourse = {};
    for (var assessment in assessments) {
      if (!groupedByCourse.containsKey(assessment.rattachementMcMcLibelleFr)) {
        groupedByCourse[assessment.rattachementMcMcLibelleFr] = [];
      }
      groupedByCourse[assessment.rattachementMcMcLibelleFr]!.add(assessment);
    }

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.brightness == Brightness.light
              ? AppTheme.AppBorder
              : const Color(0xFF3F3C34),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupedByCourse.length,
              separatorBuilder: (context, index) =>
                  const Divider(thickness: 0, color: Colors.transparent),
              itemBuilder: (context, index) {
                final courseTitle = groupedByCourse.keys.elementAt(index);
                final courseAssessments = groupedByCourse[courseTitle]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        courseTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                    ),

                    // Group by assessment type (TP, TD, PRJ)
                    ...groupAssessmentsByType(
                      courseAssessments,
                      theme,
                      context,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  List<Widget> groupAssessmentsByType(
    List<ContinuousAssessment> courseAssessments,
    ThemeData theme,
    BuildContext context,
  ) {
    // Group by type (TP, TD, PRJ)
    final Map<String, List<ContinuousAssessment>> groupedByType = {};
    for (var assessment in courseAssessments) {
      final type = assessment.assessmentTypeLabel(context);
      if (!groupedByType.containsKey(type)) {
        groupedByType[type] = [];
      }
      groupedByType[type]!.add(assessment);
    }

    List<Widget> typeWidgets = [];

    groupedByType.forEach((type, typeAssessments) {
      // Add type header
      final assessment = typeAssessments[0];

      typeWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(type, context).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _getTypeColor(type, context)),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _getTypeColor(type, context),
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  indent: 8,
                  color: theme.brightness == Brightness.light
                      ? null
                      : const Color(0xFF3F3C34),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: assessment.note != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getGradeColor(assessment.note!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${assessment.note}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.notAvailable,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });

    return typeWidgets;
  }

  // Helper method to get color based on grade
  Color _getGradeColor(double grade) {
    if (grade >= 10) return AppTheme.accentGreen;
    return AppTheme.accentRed;
  }

  // Helper method to get color based on assessment type
  Color _getTypeColor(String type, BuildContext context) {
    var project = AppLocalizations.of(context)!.project;
    var tutorialWork = AppLocalizations.of(context)!.tutorialWork;
    var practicalWork = AppLocalizations.of(context)!.practicalWork;

    if (type == project) {
      return AppTheme.AppPrimary;
    } else if (type == tutorialWork) {
      return AppTheme.AppSecondary;
    } else if (type == practicalWork) {
      return AppTheme.accentBlue;
    } else {
      return AppTheme.AppTextSecondary;
    }
  }
}
