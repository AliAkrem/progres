import 'package:flutter/material.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/debts/data/models/debt_course.dart';
import 'package:progres/l10n/app_localizations.dart';

class DebtCourseCard extends StatelessWidget {
  final DebtCourse course;

  const DebtCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.brightness == Brightness.light
              ? AppTheme.AppBorder
              : const Color(0xFF3F3C34),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course name and level
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.subjectLabelFr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.AppPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppTheme.AppPrimary),
                            ),
                            child: Text(
                              course.levelLabelFr,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.AppPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppTheme.accentBlue),
                            ),
                            child: Text(
                              course.periodLabelFr,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.accentBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Final grade badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        course.debtAverage.toStringAsFixed(2),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.finalGrade,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Grade breakdown
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light
                    ? Colors.grey.shade50
                    : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.brightness == Brightness.light
                      ? AppTheme.AppBorder
                      : const Color(0xFF3F3C34),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.gradeBreakdown,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildGradeItem(
                        context,
                        AppLocalizations.of(context)!.continuousControl,
                        course.continuousAssessmentDebt,
                        Icons.assignment_outlined,
                      ),
                      _buildGradeItem(
                        context,
                        AppLocalizations.of(context)!.exam,
                        course.examDebt,
                        Icons.edit_note_outlined,
                      ),
                      _buildGradeItem(
                        context,
                        AppLocalizations.of(context)!.average,
                        course.average,
                        Icons.bar_chart_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeItem(
    BuildContext context,
    String label,
    double value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.AppTextSecondary),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentRed,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
