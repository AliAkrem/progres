import 'package:flutter/material.dart';
import 'package:progres/features/academics/data/models/exam_result.dart';
import 'package:progres/config/theme/app_theme.dart';

class ExamResultsCard extends StatelessWidget {
  final List<ExamResult> examResults;

  const ExamResultsCard({super.key, required this.examResults});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (examResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Center(
          child: Text(
            'No exam results available yet',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      );
    }

    // Group exam results by course
    final Map<String, List<ExamResult>> groupedByCourse = {};
    for (var result in examResults) {
      if (!groupedByCourse.containsKey(result.mcLibelleFr)) {
        groupedByCourse[result.mcLibelleFr] = [];
      }
      groupedByCourse[result.mcLibelleFr]!.add(result);
    }

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color:
              theme.brightness == Brightness.light
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
              separatorBuilder:
                  (context, index) => const Divider(
                    thickness: 0,
                    color: Colors.transparent,
                    height: 24,
                  ),
              itemBuilder: (context, index) {
                final courseTitle = groupedByCourse.keys.elementAt(index);
                final courseResults = groupedByCourse[courseTitle]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course title
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

                    // Display exam results for this course
                    ...courseResults
                        .map((result) => _buildExamResultRow(result, theme))
                        .toList(),

                    // Appeal information if available
                    if (courseResults.any(
                      (result) =>
                          result.autorisationDemandeRecours &&
                          result.dateDebutDepotRecours != null &&
                          result.dateLimiteDepotRecours != null,
                    ))
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              courseResults.first.recoursDemande == true
                                  ? Icons.check_circle_outline
                                  : Icons.info_outline,
                              size: 14,
                              color:
                                  courseResults.first.recoursDemande == true
                                      ? Colors.orange
                                      : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              courseResults.first.recoursDemande == true
                                  ? 'Appeal Requested'
                                  : 'Appeal Available',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    courseResults.first.recoursDemande == true
                                        ? Colors.orange
                                        : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildExamResultRow(ExamResult result, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Row(
        children: [
          // Exam type label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppTheme.accentGreen),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Exam",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.accentGreen,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    // color: AppTheme.accentGreen.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Coef: ${result.rattachementMcCoefficient}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accentGreen,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider line
          Expanded(
            child: Divider(
              indent: 8,
              color:
                  theme.brightness == Brightness.light
                      ? null
                      : const Color(0xFF3F3C34),
            ),
          ),

          // Grade
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child:
                result.noteExamen != null
                    ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getGradeColor(result.noteExamen!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${result.noteExamen}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    )
                    : Text(
                      'N/A',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // Helper method to get color based on grade
  Color _getGradeColor(double grade) {
    if (grade >= 10) return AppTheme.accentGreen;
    return AppTheme.accentRed;
  }
}
