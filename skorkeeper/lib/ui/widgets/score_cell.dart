import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScoreCell extends StatelessWidget {
  const ScoreCell({
    required this.label,
    required this.value,
    super.key,
    this.onTap,
    this.onConfirm,
    this.isSelected = false,
    this.semanticsLabel,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final VoidCallback? onConfirm;
  final bool isSelected;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: onTap != null || onConfirm != null,
      label: semanticsLabel ?? '$label, $value',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Text(value, style: theme.textTheme.headlineMedium),
                if (onConfirm != null) ...[
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: onConfirm,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Confirm'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().scale(
      duration: 180.ms,
      begin: const Offset(0.98, 0.98),
      end: const Offset(1, 1),
    );
  }
}
