import 'package:flutter/material.dart';
import 'package:progres/l10n/app_localizations.dart';

class AssessmentTypeRow extends StatelessWidget {
  final String type;
  final double coefficient;
  final Color typeColor;
  final ThemeData theme;

  const AssessmentTypeRow({
    Key? key,
    required this.type,
    required this.coefficient,
    required this.typeColor,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (coefficient * 100).toInt();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: typeColor),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: typeColor,
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
            child: coefficient > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$percentage%',
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
    );
  }
}
