import 'package:flutter/material.dart';

class ResultItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool compact;

  const ResultItem({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.symmetric(
          vertical: compact ? 10 : 16,
          horizontal: compact ? 12 : 16,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: compact ? 22 : 28,
            ),
            SizedBox(height: compact ? 8 : 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: compact ? 11 : 13,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            SizedBox(height: compact ? 4 : 8),
            Text(
              value,
              style: TextStyle(
                fontSize: compact ? 18 : 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 