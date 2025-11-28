import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:progres/l10n/app_localizations.dart';

class ErrorLoadingSubjectState extends StatelessWidget {
  final String message;
  final int ouvertureOffreFormationId;
  final int niveauId;
  const ErrorLoadingSubjectState({
    super.key,
    required this.message,
    required this.ouvertureOffreFormationId,
    required this.niveauId,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.errorNoSubjects,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<SubjectBloc>().add(
                  LoadSubjectCoefficients(
                    ouvertureOffreFormationId: ouvertureOffreFormationId,
                    niveauId: niveauId,
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }
}
