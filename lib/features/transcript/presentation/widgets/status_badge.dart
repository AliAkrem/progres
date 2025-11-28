import 'package:flutter/material.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/l10n/app_localizations.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getDecisionColor(status);
    final icon = _getDecisionIcon(status);
    final formattedStatus = status
        .replaceAll('Admis(e)', AppLocalizations.of(context)!.passed)
        .replaceAll('Ajourné(e)', AppLocalizations.of(context)!.failed)
        .replaceAll('(session normale)', '')
        .trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            formattedStatus,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDecisionColor(String decision) {
    if (decision.contains('Admis')) {
      return AppTheme.accentGreen;
    } else if (decision.contains('Ajourné')) {
      return AppTheme.accentRed;
    } else {
      return AppTheme.accentYellow;
    }
  }

  IconData _getDecisionIcon(String decision) {
    if (decision.contains('Admis')) {
      return Icons.check_circle;
    } else if (decision.contains('Ajourné')) {
      return Icons.cancel;
    } else {
      return Icons.info;
    }
  }
}
