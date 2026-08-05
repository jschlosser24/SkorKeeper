import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/models/session_player.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../features/shared_session/rules_sheet.dart';
import '../../../../features/shared_session/session_redo_stack_provider.dart';
import '../../../../ui/widgets/numeric_keypad.dart';
import '../domain/custom_game_state.dart';

class CustomSessionScreen extends ConsumerWidget {
  const CustomSessionScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);
    return StreamBuilder<db.GameSession?>(
      stream: (database.select(
        database.gameSessions,
      )..where((tbl) => tbl.id.equals(sessionId))).watchSingleOrNull(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        Future<void> undoLastScore(
          BuildContext context,
          WidgetRef ref,
          db.AppDatabase database,
          db.GameSession session,
          CustomGameState state,
          List<db.ScoreEntry> entries,
        ) async {
          final entry = entries.last;
          await database.transaction(() async {
            await database.sessionDao.deleteScoreEntry(entry.id);
            await database.sessionDao.updateModuleState(
              session.id,
              jsonEncode(state.toJson()),
            );
          });
          ref.read(sessionRedoStackProvider(session.id).notifier).state = [
            entry,
            ...ref.read(sessionRedoStackProvider(session.id)),
          ];
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Last score undone.')));
          }
        }

        Future<void> redoLastScore(
          BuildContext context,
          WidgetRef ref,
          db.AppDatabase database,
          db.GameSession session,
          CustomGameState state,
          List<db.ScoreEntry> redoStack,
        ) async {
          final entry = redoStack.first;
          await database.transaction(() async {
            await database.sessionDao.insertScoreEntry(
              db.ScoreEntriesCompanion.insert(
                sessionId: session.id,
                playerId: entry.playerId,
                roundNumber: entry.roundNumber,
                value: entry.value,
                recordedAt: DateTime.now().millisecondsSinceEpoch,
              ),
            );
            await database.sessionDao.updateModuleState(
              session.id,
              jsonEncode(state.toJson()),
            );
          });
          ref.read(sessionRedoStackProvider(session.id).notifier).state = [
            ...redoStack.skip(1),
          ];
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Score restored.')));
          }
        }

        void showHelp(BuildContext context) {
          showRulesSheet(
            context,
            title: 'Custom scoring',
            summary:
                'Use this scorecard for any game that does not have a built-in tracker.',
            bullets: const [
              'Add rounds as needed and tap any score cell to enter or replace a value.',
              'Choose whether the highest total or lowest total wins when you set up the game.',
              'Use End Game when you are ready to lock in the current standings.',
            ],
          );
        }

        final session = snapshot.data;
        if (session == null) {
          return const Scaffold(
            body: Center(child: Text('Session unavailable.')),
          );
        }
        final players = _parsePlayers(session.participantsJson);
        final state = CustomGameState.fromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        return StreamBuilder<List<db.ScoreEntry>>(
          stream: database.sessionDao.watchScoreEntriesForSession(sessionId),
          builder: (context, entriesSnapshot) {
            final entries = _sortedEntries(
              entriesSnapshot.data ?? const <db.ScoreEntry>[],
            );
            final redoStack = ref.watch(sessionRedoStackProvider(sessionId));
            final cellScores = _buildCellScores(entries);
            final totals = _buildTotals(players, cellScores);
            final leaders = _leaders(players, totals, state.scoreDirection);
            final highestRecordedRound = cellScores.keys.isEmpty
                ? 0
                : cellScores.keys.reduce((a, b) => a > b ? a : b);
            final roundCount = [
              state.roundLabels.length,
              highestRecordedRound,
              1,
            ].reduce((a, b) => a > b ? a : b);

            return Scaffold(
              appBar: AppBar(
                title: Text(session.sessionName ?? state.gameName),
                actions: [
                  IconButton(
                    tooltip: 'Help',
                    onPressed: () => showHelp(context),
                    icon: const Icon(Icons.help_outline),
                  ),
                  IconButton(
                    tooltip: 'Undo last score',
                    onPressed: entries.isEmpty
                        ? null
                        : () => undoLastScore(
                            context,
                            ref,
                            database,
                            session,
                            state,
                            entries,
                          ),
                    icon: const Icon(Icons.undo),
                  ),
                  IconButton(
                    tooltip: 'Redo last score',
                    onPressed: redoStack.isEmpty
                        ? null
                        : () => redoLastScore(
                            context,
                            ref,
                            database,
                            session,
                            state,
                            redoStack,
                          ),
                    icon: const Icon(Icons.redo),
                  ),
                  TextButton(
                    onPressed: () => _endGame(
                      context,
                      ref,
                      session,
                      players,
                      totals,
                      state.scoreDirection,
                    ),
                    child: const Text('End Game'),
                  ),
                ],
              ),
              body: Column(
                children: [
                  // -- Leader + Add Round bar --------------------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left: leader info
                        Expanded(
                          child: Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.emoji_events_outlined,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildLeaderText(
                                      context,
                                      players,
                                      leaders,
                                      state.scoreDirection,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Right: Add Round button
                        SizedBox(
                          height: 48,
                          width: 130,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () =>
                                _addRound(ref, database, session, state),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Round'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // -- Score grid -------------------------------------
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          border: TableBorder.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                              ),
                              children: [
                                _headerCell(context, 'Round'),
                                for (final player in players)
                                  _headerCell(
                                    context,
                                    player.displayName,
                                    highlighted: leaders.contains(player.id),
                                  ),
                              ],
                            ),
                            for (var round = 1; round <= roundCount; round++)
                              TableRow(
                                children: [
                                  _bodyCell(
                                    context,
                                    state.roundLabels.length >= round
                                        ? state.roundLabels[round - 1]
                                        : 'Round $round',
                                    isHeader: true,
                                  ),
                                  for (final player in players)
                                    _InteractiveCell(
                                      highlighted: leaders.contains(player.id),
                                      onTap: () => _editScore(
                                        context,
                                        ref,
                                        sessionId,
                                        player.id,
                                        round,
                                        session.moduleStateJson,
                                      ),
                                      child: _bodyCell(
                                        context,
                                        cellScores[round]?[player.id]
                                                ?.toString() ??
                                            '-',
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // -- Totals footer ----------------------------------
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _totalTile(context, 'Totals'),
                            for (final player in players)
                              _totalTile(
                                context,
                                '${player.displayName}\n${totals[player.id] ?? 0}',
                                highlighted: leaders.contains(player.id),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLeaderText(
    BuildContext context,
    List<SessionPlayer> players,
    Set<String> leaders,
    ScoreDirection direction,
  ) {
    final leadingNames = players
        .where((p) => leaders.contains(p.id))
        .map((p) => p.displayName)
        .toList();
    final joinedNames = _joinNames(leadingNames);
    return Text(
      joinedNames.isEmpty
          ? 'Add scores to see the leader.'
          : leaders.length > 1
          ? '$joinedNames are tied for the lead.'
          : direction == ScoreDirection.highWins
          ? '$joinedNames leads.'
          : '$joinedNames has the low score.',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _joinNames(List<String> names) {
    if (names.isEmpty) {
      return '';
    }
    if (names.length == 1) {
      return names.first;
    }
    if (names.length == 2) {
      return '${names.first} and ${names.last}';
    }
    return '${names.sublist(0, names.length - 1).join(', ')}, and ${names.last}';
  }

  List<SessionPlayer> _parsePlayers(String participantsJson) {
    final raw = jsonDecode(participantsJson) as List<dynamic>;
    return raw
        .map((item) => SessionPlayer.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Map<int, Map<String, int>> _buildCellScores(List<db.ScoreEntry> entries) {
    final scores = <int, Map<String, int>>{};
    final sorted = [...entries]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    for (final entry in sorted) {
      scores.putIfAbsent(
        entry.roundNumber,
        () => <String, int>{},
      )[entry.playerId] = entry.value;
    }
    return scores;
  }

  List<db.ScoreEntry> _sortedEntries(List<db.ScoreEntry> entries) {
    final sorted = [...entries]
      ..sort((a, b) {
        final recorded = a.recordedAt.compareTo(b.recordedAt);
        return recorded != 0 ? recorded : a.id.compareTo(b.id);
      });
    return sorted;
  }

  Map<String, int> _buildTotals(
    List<SessionPlayer> players,
    Map<int, Map<String, int>> cellScores,
  ) {
    final totals = <String, int>{for (final player in players) player.id: 0};
    for (final roundScores in cellScores.values) {
      roundScores.forEach((playerId, value) {
        totals[playerId] = (totals[playerId] ?? 0) + value;
      });
    }
    return totals;
  }

  Set<String> _leaders(
    List<SessionPlayer> players,
    Map<String, int> totals,
    ScoreDirection direction,
  ) {
    if (players.isEmpty) return const <String>{};
    final values = players.map((p) => totals[p.id] ?? 0).toList();
    final best = direction == ScoreDirection.highWins
        ? values.reduce((a, b) => a > b ? a : b)
        : values.reduce((a, b) => a < b ? a : b);
    return players
        .where((p) => (totals[p.id] ?? 0) == best)
        .map((p) => p.id)
        .toSet();
  }

  Future<void> _editScore(
    BuildContext context,
    WidgetRef ref,
    int sessionId,
    String playerId,
    int round,
    String stateJson,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: NumericKeypad(
          title: 'Enter round $round score',
          allowNegative: true,
          onSubmitted: (value) async {
            final action = CustomRoundScoreEntered(
              playerId: playerId,
              value: value,
              roundNumber: round,
            );
            await ref
                .read(activeSessionsNotifierProvider.notifier)
                .recordScore(sessionId, action, stateJson);
            ref.read(sessionRedoStackProvider(sessionId).notifier).state =
                const <db.ScoreEntry>[];
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _addRound(
    WidgetRef ref,
    db.AppDatabase database,
    db.GameSession session,
    CustomGameState state,
  ) async {
    final labels = [
      ...state.roundLabels,
      'Round ${state.roundLabels.length + 1}',
    ];
    final updated = state.copyWith(roundLabels: labels);
    await database.sessionDao.updateModuleState(
      session.id,
      jsonEncode(updated.toJson()),
    );
  }

  Future<void> _endGame(
    BuildContext context,
    WidgetRef ref,
    db.GameSession session,
    List<SessionPlayer> players,
    Map<String, int> totals,
    ScoreDirection direction,
  ) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('End game?'),
            content: const Text('This will lock in the current totals.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('End Game'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    final sorted = [...players]
      ..sort((a, b) {
        final aScore = totals[a.id] ?? 0;
        final bScore = totals[b.id] ?? 0;
        return direction == ScoreDirection.highWins
            ? bScore.compareTo(aScore)
            : aScore.compareTo(bScore);
      });
    final winnerName = sorted.isEmpty ? 'No winner' : sorted.first.displayName;
    await ref
        .read(activeSessionsNotifierProvider.notifier)
        .endSession(session.id, winnerName, session.moduleStateJson);
    if (context.mounted) context.go('/home/session/${session.id}/summary');
  }

  Widget _headerCell(
    BuildContext context,
    String text, {
    bool highlighted = false,
  }) {
    final bg = highlighted
        ? Theme.of(context).colorScheme.primaryContainer
        : null;
    final textColor = highlighted
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onSurface;
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      color: bg,
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _bodyCell(BuildContext context, String text, {bool isHeader = false}) {
    return SizedBox(
      width: 120,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: isHeader
              ? Theme.of(context).textTheme.titleSmall
              : Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _totalTile(
    BuildContext context,
    String label, {
    bool highlighted = false,
  }) {
    final bg = highlighted
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surface;
    final textColor = highlighted
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onSurface;
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: textColor),
      ),
    );
  }
}

class _InteractiveCell extends StatelessWidget {
  const _InteractiveCell({
    required this.child,
    required this.onTap,
    required this.highlighted,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: highlighted
          ? Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.38)
          : Colors.transparent,
      child: InkWell(onTap: onTap, child: child),
    );
  }
}
