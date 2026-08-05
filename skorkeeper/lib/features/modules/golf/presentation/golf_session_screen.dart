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
import '../domain/golf_module.dart';
import '../domain/golf_state.dart';

class GolfSessionScreen extends ConsumerWidget {
  const GolfSessionScreen({required this.sessionId, super.key});

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
        final session = snapshot.data;
        if (session == null) {
          return const Scaffold(
            body: Center(child: Text('Session unavailable.')),
          );
        }
        final players = _parsePlayers(session.participantsJson);
        final state = GolfState.fromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        final module = state.isMiniGolf
            ? MiniGolfModule(selectedHoleCount: state.holeCount)
            : state.holeCount == 18
            ? const Golf18Module()
            : const Golf9Module();

        return StreamBuilder<List<db.ScoreEntry>>(
          stream: database.sessionDao.watchScoreEntriesForSession(sessionId),
          builder: (context, entriesSnapshot) {
            final entries = _sortedEntries(
              entriesSnapshot.data ?? const <db.ScoreEntry>[],
            );
            final redoStack = ref.watch(sessionRedoStackProvider(sessionId));
            final scores = _latestScores(players, state, entries);
            final totals = {
              for (final player in players)
                player.id: scores[player.id]!.whereType<int>().fold<int>(
                  0,
                  (s, v) => s + v,
                ),
            };
            final sorted = [
              ...players,
            ]..sort((a, b) => (totals[a.id] ?? 0).compareTo(totals[b.id] ?? 0));
            final leaderId = sorted.first.id;

            return Scaffold(
              appBar: AppBar(
                title: Text(session.sessionName ?? module.displayName),
                actions: [
                  IconButton(
                    tooltip: 'Help',
                    onPressed: () => _showHelp(context, state.isMiniGolf),
                    icon: const Icon(Icons.help_outline),
                  ),
                  IconButton(
                    tooltip: 'Undo last score',
                    onPressed: entries.isEmpty
                        ? null
                        : () => _undoLastScore(
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
                        : () => _redoLastScore(
                            context,
                            ref,
                            database,
                            session,
                            state,
                            entries,
                            redoStack,
                          ),
                    icon: const Icon(Icons.redo),
                  ),
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(activeSessionsNotifierProvider.notifier)
                          .endSession(
                            session.id,
                            sorted.first.displayName,
                            session.moduleStateJson,
                          );
                      if (context.mounted) {
                        context.go('/home/session/${session.id}/summary');
                      }
                    },
                    child: const Text('End Game'),
                  ),
                ],
              ),
              body: Column(
                children: [
                  // -- Leader banner --------------------------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        leading: Icon(
                          Icons.emoji_events_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text('Leader: ${sorted.first.displayName}'),
                        subtitle: Text(
                          'Current hole: ${state.currentHole} / ${state.holeCount}',
                        ),
                      ),
                    ),
                  ),

                  // -- Scorecard table ------------------------------
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          border: TableBorder.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            width: 1,
                          ),
                          children: [
                            // Header row
                            TableRow(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                              ),
                              children: [
                                _headerCell(context, 'Hole'),
                                if (!state.isMiniGolf)
                                  _headerCell(context, 'Par'),
                                for (final player in players)
                                  _headerCell(
                                    context,
                                    player.displayName,
                                    highlighted: player.id == leaderId,
                                  ),
                              ],
                            ),
                            // Hole rows
                            for (var hole = 1; hole <= state.holeCount; hole++)
                              TableRow(
                                decoration: BoxDecoration(
                                  color: hole == state.currentHole
                                      ? Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer
                                            .withValues(alpha: 0.3)
                                      : null,
                                ),
                                children: [
                                  _labelCell(
                                    context,
                                    '$hole',
                                    bold: hole == state.currentHole,
                                  ),
                                  if (!state.isMiniGolf)
                                    _labelCell(
                                      context,
                                      state.pars[hole - 1].toString(),
                                    ),
                                  for (final player in players)
                                    _TappableScoreCell(
                                      strokes: scores[player.id]![hole - 1],
                                      par: state.isMiniGolf
                                          ? null
                                          : state.pars[hole - 1],
                                      highlighted: player.id == leaderId,
                                      onTap: () => _editScore(
                                        context,
                                        ref,
                                        session.id,
                                        state,
                                        player.id,
                                        hole,
                                      ),
                                    ),
                                ],
                              ),
                            // Totals row
                            TableRow(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                              ),
                              children: [
                                _headerCell(context, 'Total'),
                                if (!state.isMiniGolf)
                                  _headerCell(
                                    context,
                                    '${state.pars.fold<int>(0, (s, p) => s + p)}',
                                  ),
                                for (final player in players)
                                  _headerCell(
                                    context,
                                    '${totals[player.id] ?? 0}',
                                    highlighted: player.id == leaderId,
                                  ),
                              ],
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

  List<SessionPlayer> _parsePlayers(String participantsJson) {
    final raw = jsonDecode(participantsJson) as List<dynamic>;
    return raw
        .map((item) => SessionPlayer.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Map<String, List<int?>> _latestScores(
    List<SessionPlayer> players,
    GolfState state,
    List<db.ScoreEntry> entries,
  ) {
    final scores = {
      for (final player in players)
        player.id: List<int?>.filled(state.holeCount, null),
    };
    final sorted = [...entries]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    for (final entry in sorted) {
      final idx = entry.roundNumber - 1;
      if (scores.containsKey(entry.playerId) &&
          idx >= 0 &&
          idx < state.holeCount) {
        scores[entry.playerId]![idx] = entry.value;
      }
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

  Future<void> _editScore(
    BuildContext context,
    WidgetRef ref,
    int sessionId,
    GolfState state,
    String playerId,
    int hole,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: NumericKeypad(
          title: 'Hole $hole strokes',
          onSubmitted: (value) async {
            final action = GolfHoleScoreEntered(
              playerId: playerId,
              hole: hole,
              strokes: value,
            );
            final nextState =
                const Golf9Module().applyAction(state, action) as GolfState;
            await ref
                .read(activeSessionsNotifierProvider.notifier)
                .recordScore(sessionId, action, jsonEncode(nextState.toJson()));
            ref.read(sessionRedoStackProvider(sessionId).notifier).state =
                const <db.ScoreEntry>[];
            if (ctx.mounted) Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }

  Widget _headerCell(
    BuildContext context,
    String text, {
    bool highlighted = false,
  }) {
    final bg = highlighted
        ? Theme.of(context).colorScheme.primaryContainer
        : null;
    final fg = highlighted
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onSurface;
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      color: bg,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: fg),
      ),
    );
  }

  Widget _labelCell(BuildContext context, String text, {bool bold = false}) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  GolfState _rebuildState(GolfState baseState, List<db.ScoreEntry> entries) {
    var nextState = baseState.copyWith(
      currentHole: 1,
      scores: {
        for (final entry in baseState.scores.entries)
          entry.key: List<int?>.filled(baseState.holeCount, null),
      },
    );
    final module = baseState.isMiniGolf
        ? MiniGolfModule(selectedHoleCount: baseState.holeCount)
        : GolfModule(
            gameTypeId: baseState.holeCount == 18 ? 'golf18' : 'golf9',
            displayName: 'Golf',
            holeCount: baseState.holeCount,
            isMiniGolf: false,
          );
    for (final entry in entries) {
      nextState =
          module.applyAction(
                nextState,
                GolfHoleScoreEntered(
                  playerId: entry.playerId,
                  hole: entry.roundNumber,
                  strokes: entry.value,
                ),
              )
              as GolfState;
    }
    return nextState;
  }

  Future<void> _undoLastScore(
    BuildContext context,
    WidgetRef ref,
    db.AppDatabase database,
    db.GameSession session,
    GolfState state,
    List<db.ScoreEntry> entries,
  ) async {
    final entry = entries.last;
    final nextState = _rebuildState(
      state,
      entries.take(entries.length - 1).toList(),
    );
    await database.transaction(() async {
      await database.sessionDao.deleteScoreEntry(entry.id);
      await database.sessionDao.updateModuleState(
        session.id,
        jsonEncode(nextState.toJson()),
      );
    });
    ref.read(sessionRedoStackProvider(session.id).notifier).state = [
      entry,
      ...ref.read(sessionRedoStackProvider(session.id)),
    ];
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Last hole score undone.')));
    }
  }

  Future<void> _redoLastScore(
    BuildContext context,
    WidgetRef ref,
    db.AppDatabase database,
    db.GameSession session,
    GolfState state,
    List<db.ScoreEntry> entries,
    List<db.ScoreEntry> redoStack,
  ) async {
    final entry = redoStack.first;
    final restoredEntry = db.ScoreEntry(
      id: entry.id,
      sessionId: entry.sessionId,
      playerId: entry.playerId,
      roundNumber: entry.roundNumber,
      value: entry.value,
      notes: entry.notes,
      recordedAt: DateTime.now().millisecondsSinceEpoch,
    );
    final restoredEntries = _sortedEntries([...entries, restoredEntry]);
    final nextState = _rebuildState(state, restoredEntries);
    await database.transaction(() async {
      await database.sessionDao.insertScoreEntry(
        db.ScoreEntriesCompanion.insert(
          sessionId: session.id,
          playerId: entry.playerId,
          roundNumber: entry.roundNumber,
          value: entry.value,
          recordedAt: restoredEntry.recordedAt,
        ),
      );
      await database.sessionDao.updateModuleState(
        session.id,
        jsonEncode(nextState.toJson()),
      );
    });
    ref.read(sessionRedoStackProvider(session.id).notifier).state = [
      ...redoStack.skip(1),
    ];
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Hole score restored.')));
    }
  }

  void _showHelp(BuildContext context, bool isMiniGolf) {
    showRulesSheet(
      context,
      title: isMiniGolf ? 'Mini golf rules' : 'Golf rules',
      summary: isMiniGolf
          ? 'Record each player’s strokes for every hole.'
          : 'Record strokes hole by hole and compare scores to par.',
      bullets: isMiniGolf
          ? const [
              'Count every stroke it takes to finish each hole.',
              'Add up all holes at the end of the round.',
              'The lowest total score wins.',
            ]
          : const [
              'Par is the expected number of strokes for a hole.',
              'Birdie = 1 under par, eagle = 2 under par, bogey = 1 over par.',
              'Lower total strokes across all holes wins.',
            ],
    );
  }
}

// -- Tappable score cell ------------------------------------------------------

class _TappableScoreCell extends StatelessWidget {
  const _TappableScoreCell({
    required this.strokes,
    required this.par,
    required this.highlighted,
    required this.onTap,
  });

  final int? strokes;
  final int? par;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final diff = (strokes != null && par != null) ? strokes! - par! : null;
    final label = diff == null
        ? null
        : diff <= -2
        ? 'Eagle'
        : diff == -1
        ? 'Birdie'
        : diff == 0
        ? 'Par'
        : diff == 1
        ? 'Bogey'
        : diff == 2
        ? 'Dbl Bogey'
        : '+$diff';
    final labelColor = diff == null
        ? null
        : diff <= -2
        ? Colors.amber.shade700
        : diff == -1
        ? Colors.green
        : diff == 0
        ? Theme.of(context).colorScheme.onSurface
        : diff == 1
        ? Colors.orange
        : Colors.red;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        color: highlighted
            ? Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.18)
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              strokes?.toString() ?? '-',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: strokes != null ? FontWeight.w600 : null,
              ),
            ),
            if (label != null) ...[
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: labelColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
