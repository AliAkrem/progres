import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

class ErrorState extends StatelessWidget {
  final StudentGroupsError state;
  final ProfileLoaded profileState;

  const ErrorState({
    super.key,
    required this.state,
    required this.profileState,
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
              GalleryLocalizations.of(context)!.somthingWentWrong,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<StudentGroupsBloc>().add(
                  LoadStudentGroups(cardId: profileState.detailedInfo.id),
                );
              },
              child: Text(GalleryLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }
}
