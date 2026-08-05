import 'package:flutter/material.dart';

class PlayerChip extends StatelessWidget {
  const PlayerChip({
    required this.displayName,
    required this.colorHex,
    super.key,
    this.isSelected = false,
    this.onTap,
  });

  final String displayName;
  final String colorHex;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _parseColor(colorHex);
    final initial = displayName.isEmpty ? '?' : displayName.characters.first;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isSelected ? 0.2 : 0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: color,
              child: Text(
                initial,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                displayName,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _parseColor(String value) {
    final normalized = value.replaceAll('#', '');
    return Color(int.parse('FF' + normalized, radix: 16));
  }
}
