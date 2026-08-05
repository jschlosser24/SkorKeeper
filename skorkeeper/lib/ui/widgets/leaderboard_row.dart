import 'package:flutter/material.dart';

import '../../core/modules/leaderboard_entry.dart';

class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({required this.entry, super.key});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _parseColor(entry.colorHex);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: entry.isLeading
              ? theme.colorScheme.tertiary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: entry.isLeading
                ? theme.colorScheme.tertiary
                : theme.colorScheme.primaryContainer,
            foregroundColor: entry.isLeading
                ? theme.colorScheme.onTertiary
                : theme.colorScheme.onPrimaryContainer,
            child: Text(entry.rank.toString()),
          ),
          const SizedBox(width: 12),
          CircleAvatar(radius: 10, backgroundColor: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${_ordinal(entry.rank)} • ${entry.displayName}',
              style: theme.textTheme.titleMedium,
            ),
          ),
          Text(entry.scoreDisplay, style: theme.textTheme.titleMedium),
          if (entry.isLeading) ...[
            const SizedBox(width: 8),
            Icon(Icons.emoji_events_rounded, color: theme.colorScheme.tertiary),
          ],
        ],
      ),
    );
  }

  static Color _parseColor(String value) {
    final normalized = value.replaceAll('#', '');
    return Color(int.parse('FF' + normalized, radix: 16));
  }

  static String _ordinal(int rank) {
    final mod100 = rank % 100;
    if (mod100 >= 11 && mod100 <= 13) {
      return '${rank}th';
    }
    switch (rank % 10) {
      case 1:
        return '${rank}st';
      case 2:
        return '${rank}nd';
      case 3:
        return '${rank}rd';
      default:
        return '${rank}th';
    }
  }
}
