import 'package:flutter/material.dart';

import '../../../../core/models/session_player.dart';
import '../domain/darts_game_state.dart';

/// A visual cricket scoreboard that mirrors a real dart board layout.
/// Shows targets (15–20 + Bull) in the centre with marks/scores on each side.
class CricketScoreboardWidget extends StatelessWidget {
  const CricketScoreboardWidget({
    required this.state,
    required this.players,
    super.key,
  });

  final DartsGameState state;
  final List<SessionPlayer> players;

  static const _targets = <int>[20, 19, 18, 17, 16, 15, 25];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTwo = players.length == 2;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row
            Row(
              children: [
                if (isTwo) _playerHeader(context, players[0]),
                if (!isTwo) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final p in players.take(
                            players.length ~/ 2 + players.length % 2,
                          ))
                            _playerHeader(context, p),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 4),
                SizedBox(
                  width: 48,
                  child: Center(
                    child: Text(
                      'Target',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                if (isTwo)
                  _playerHeader(context, players[1])
                else
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final p in players.skip(
                            players.length ~/ 2 + players.length % 2,
                          ))
                            _playerHeader(context, p),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 10),
            // Target rows
            for (final target in _targets) ...[
              _buildTargetRow(context, target, players, isTwo),
              if (target != 25) const Divider(height: 8, thickness: 0.5),
            ],
            const Divider(height: 10),
            // Points row
            _buildPointsRow(context, players, isTwo),
          ],
        ),
      ),
    );
  }

  Widget _playerHeader(BuildContext context, SessionPlayer player) {
    final isCurrent = player.id == state.currentPlayerId;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: isCurrent
            ? BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(6),
              )
            : null,
        child: Text(
          player.displayName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildTargetRow(
    BuildContext context,
    int target,
    List<SessionPlayer> players,
    bool isTwo,
  ) {
    final label = target == 25 ? 'BULL' : target.toString();
    final leftPlayers = isTwo
        ? [players[0]]
        : players.take(players.length ~/ 2 + players.length % 2).toList();
    final rightPlayers = isTwo
        ? [players[1]]
        : players.skip(players.length ~/ 2 + players.length % 2).toList();

    return Row(
      children: [
        // Left players' marks
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (final p in leftPlayers)
                Expanded(
                  child: _marksWidget(
                    context,
                    state.cricketMarks?[p.id]?[target.toString()] ?? 0,
                    rightAlign: true,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        // Centre target label
        Container(
          width: 48,
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: _isAllClosed(target, players)
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _isAllClosed(target, players)
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Right players' marks
        Expanded(
          child: Row(
            children: [
              for (final p in rightPlayers)
                Expanded(
                  child: _marksWidget(
                    context,
                    state.cricketMarks?[p.id]?[target.toString()] ?? 0,
                    rightAlign: false,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  bool _isAllClosed(int target, List<SessionPlayer> players) {
    return players.every(
      (p) => (state.cricketMarks?[p.id]?[target.toString()] ?? 0) >= 3,
    );
  }

  Widget _marksWidget(
    BuildContext context,
    int marks, {
    required bool rightAlign,
  }) {
    final closed = marks >= 3;
    final color = closed
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;

    return Align(
      alignment: rightAlign ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        _marksDisplay(marks),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: -1,
        ),
      ),
    );
  }

  String _marksDisplay(int marks) {
    switch (marks) {
      case 0:
        return '';
      case 1:
        return '/';
      case 2:
        return 'X';
      case 3:
      default:
        return '⊗';
    }
  }

  Widget _buildPointsRow(
    BuildContext context,
    List<SessionPlayer> players,
    bool isTwo,
  ) {
    final leftPlayers = isTwo
        ? [players[0]]
        : players.take(players.length ~/ 2 + players.length % 2).toList();
    final rightPlayers = isTwo
        ? [players[1]]
        : players.skip(players.length ~/ 2 + players.length % 2).toList();

    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (final p in leftPlayers)
                Expanded(
                  child: Text(
                    '${state.cricketPoints?[p.id] ?? 0}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 48,
          child: Text(
            'PTS',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Row(
            children: [
              for (final p in rightPlayers)
                Expanded(
                  child: Text(
                    '${state.cricketPoints?[p.id] ?? 0}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
