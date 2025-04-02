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
              separatorBuilder: (context, index) => const Divider(thickness: 0, color: Colors.transparent,),
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
            final assessment = typeAssessments[0];

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
                Padding(
                  padding: const EdgeInsets.only(left: 10),
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
           
            ],
          ),
        ),
      );
      
    });
    
    
    return typeWidgets;
  }
  

 
  // Helper method to get color based on grade
  Color _getGradeColor(double grade) {
    if (grade >= 10) return Colors.green;
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