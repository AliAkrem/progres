import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/discharge/presentation/bloc/discharge_bloc.dart';
import 'package:progres/l10n/gallery_localizations.dart';

class ErrorState extends StatelessWidget {
  final StudentDischargeError state;

  const ErrorState({super.key, required this.state});

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
              AppLocalizations.of(context)!.somthingWentWrong,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<StudentDischargeBloc>().add(
                  LoadStudentDischarge(),
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
