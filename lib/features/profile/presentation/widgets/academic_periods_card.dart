import 'package:flutter/material.dart';
import 'package:progres/features/profile/data/models/academic_period.dart';

class AcademicPeriodsCard extends StatelessWidget {
  final List<AcademicPeriod> periods;

  const AcademicPeriodsCard({
    super.key,
    required this.periods,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Academic Periods',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: periods.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final period = periods[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${period.code} - ${period.libelleLongLt}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    period.libelleLongFrNiveau,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  trailing: CircleAvatar(
                    radius: 14,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${period.rang}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 