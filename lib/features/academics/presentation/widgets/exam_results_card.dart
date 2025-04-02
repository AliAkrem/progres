import 'package:flutter/material.dart';
import 'package:progres/features/academics/data/models/exam_result.dart';
import 'package:progres/config/theme/app_theme.dart';

class ExamResultsCard extends StatelessWidget {
  final List<ExamResult> examResults;

  const ExamResultsCard({
    super.key,
    required this.examResults,
  });

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

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.brightness == Brightness.light 
            ? AppTheme.claudeBorder 
            : const Color(0xFF3F3C34)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    'Course',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Coef',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Grade',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            

            // List of exam results
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: examResults.length,
              separatorBuilder: (context, index) => const Divider(height: 8, thickness: 0, color: Colors.transparent),
              itemBuilder: (context, index) {
                final result = examResults[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Name
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.mcLibelleFr,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: theme.textTheme.titleMedium?.color,
                              ),
                            ),
                            if (result.autorisationDemandeRecours && 
                                result.dateDebutDepotRecours != null &&
                                result.dateLimiteDepotRecours != null)
                              Row(
                                children: [
                                  Icon(
                                    result.recoursDemande == true 
                                        ? Icons.check_circle_outline 
                                        : Icons.info_outline,
                                    size: 14,
                                    color: result.recoursDemande == true 
                                        ? Colors.orange 
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    result.recoursDemande == true 
                                        ? 'Appeal Requested' 
                                        : 'Appeal Available',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: result.recoursDemande == true 
                                          ? Colors.orange 
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      // Coefficient
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${result.rattachementMcCoefficient}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          ),
                        ),
                      ),

                      // Grade
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: result.noteExamen != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                      ),
                    ],
                  ),
                );
              },
            ),

            // Summary section
            
          ],
        ),
      ),
    );
  }


  // Helper method to get color based on grade
  Color _getGradeColor(double grade) {
    if (grade >= 10) return AppTheme.accentGreen;
    return AppTheme.accentRed;
  }
} 