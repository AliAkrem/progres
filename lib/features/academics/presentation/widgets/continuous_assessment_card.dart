import 'package:flutter/material.dart';
import 'package:progres/features/academics/data/models/continuous_assessment.dart';

class ContinuousAssessmentCard extends StatelessWidget {
  final List<ContinuousAssessment> assessments;

  const ContinuousAssessmentCard({
    super.key,
    required this.assessments,
  });

  @override
  Widget build(BuildContext context) {
    if (assessments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Center(
          child: Text(
            'No continuous assessments available yet',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
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
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
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
              separatorBuilder: (context, index) => const Divider(thickness: 1),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    
                    // Group by assessment type (TP, TD, PRJ)
                    ...groupAssessmentsByType(courseAssessments),
                    
                    // Course average
                    _buildCourseAverage(courseAssessments),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            
            // Overall summary
            _buildOverallSummary(assessments),
          ],
        ),
      ),
    );
  }
  
  List<Widget> groupAssessmentsByType(List<ContinuousAssessment> courseAssessments) {
    // Group by type (TP, TD, PRJ)
    final Map<String, List<ContinuousAssessment>> groupedByType = {};
    for (var assessment in courseAssessments) {
      final type = assessment.assessmentTypeLabel;
      if (!groupedByType.containsKey(type)) {
        groupedByType[type] = [];
      }
      groupedByType[type]!.add(assessment);
    }
    
    List<Widget> typeWidgets = [];
    
    groupedByType.forEach((type, typeAssessments) {
      // Add type header
      typeWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _getTypeColor(type)),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _getTypeColor(type),
                    fontSize: 12,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  indent: 8,
                ),
              ),
            ],
          ),
        ),
      );
      
      // Add assessments of this type
      typeWidgets.add(
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: typeAssessments.length,
          itemBuilder: (context, index) {
            final assessment = typeAssessments[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                assessment.llPeriode,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (assessment.absent)
                                const Text(
                                  'Absent',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              if (assessment.observation != null && assessment.observation!.isNotEmpty)
                                Text(
                                  assessment.observation!,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        '1.0', // Coefficient placeholder - update if model has this
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: assessment.note != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                          : const Text(
                              'N/A',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
    
    return typeWidgets;
  }
  
  Widget _buildCourseAverage(List<ContinuousAssessment> courseAssessments) {
    // Calculate course average
    double totalWeightedGrade = 0;
    double totalCoefficients = 0;
    int gradeCount = 0;
    
    for (var assessment in courseAssessments) {
      if (assessment.note != null) {
        totalWeightedGrade += assessment.note!;  // Assuming coefficient is 1.0
        totalCoefficients += 1.0;  // Assuming coefficient is 1.0
        gradeCount++;
      }
    }
    
    if (gradeCount > 0 && totalCoefficients > 0) {
      final average = totalWeightedGrade / totalCoefficients;
      
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Course average: ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getGradeColor(average),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                average.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
  
  Widget _buildOverallSummary(List<ContinuousAssessment> allAssessments) {
    // Calculate overall average
    double totalWeightedGrade = 0;
    double totalCoefficients = 0;
    int gradeCount = 0;
    int totalAssessments = allAssessments.length;
    
    for (var assessment in allAssessments) {
      if (assessment.note != null) {
        totalWeightedGrade += assessment.note!;  // Assuming coefficient is 1.0
        totalCoefficients += 1.0;  // Assuming coefficient is 1.0
        gradeCount++;
      }
    }
    
    if (gradeCount > 0 && totalCoefficients > 0) {
      final average = totalWeightedGrade / totalCoefficients;
      
      return SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Average',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '$gradeCount/$totalAssessments grades available',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getGradeColor(average),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                average.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Text(
        'Not enough data to calculate average',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      );
    }
  }

  // Helper method to get color based on grade
  Color _getGradeColor(double grade) {
    if (grade >= 14) return Colors.green;
    if (grade >= 10) return Colors.blue;
    if (grade >= 7) return Colors.orange;
    return Colors.red;
  }
  
  // Helper method to get color based on assessment type
  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'PROJECT':
        return Colors.purple;
      case 'TUTORIAL WORK':
        return Colors.teal;
      case 'PRACTICAL WORK':
        return Colors.indigo;
      default:
        return Colors.blueGrey;
    }
  }
} 