import 'dart:convert';

import 'package:drift/drift.dart' show Value;
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
import '../../../../ui/widgets/leaderboard_row.dart';
import '../../../../ui/widgets/numeric_keypad.dart';
import '../domain/dominoes_module.dart';
import '../domain/dominoes_state.dart';

class DominoesSessionScreen extends ConsumerWidget {
  const DominoesSessionScreen({required this.sessionId, super.key});

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
        final state = DominoesState.fromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        final redoStack = ref.watch(sessionRedoStackProvider(sessionId));
        return StreamBuilder<List<db.ScoreEntry>>(
          stream: database.sessionDao.watchScoreEntriesForSession(sessionId),
          builder: (context, entriesSnapshot) {
            final entries = _sortedEntries(
              entriesSnapshot.data ?? const <db.ScoreEntry>[],
            );
            final module = const DominoesModule();
            final standings = module.leaderboard(state).map((entry) {
              final player = players.firstWhere(
                (item) => item.id == entry.playerId,
                orElse: () => players.first,
              );
              return entry.copyWith(
                displayName: player.displayName,
                colorHex: player.colorHex,
              );
            }).toList();
            return Scaffold(
              appBar: AppBar(
                title: Text(session.sessionName ?? module.displayName),
                actions: [
                  IconButton(
                    tooltip: 'Help',
                    onPressed: () => _showHelp(context),
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
                            players,
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
                            players,
                            entries,
                            redoStack,
                          ),
                    icon: const Icon(Icons.redo),
                  ),
                  TextButton(
                    onPressed: () async {
                      final winnerId = standings.first.playerId;
                      final nextState = state.copyWith(
                        gameOver: true,
                        winnerId: winnerId,
                      );
                      final winner = players.firstWhere(
                        (player) => player.id == winnerId,
                        orElse: () => players.first,
                      );
                      await ref
                          .read(activeSessionsNotifierProvider.notifier)
                          .endSession(
                            session.id,
                            winner.displayName,
                            jsonEncode(nextState.toJson()),
                          );
                      if (context.mounted) {
                        context.go('/home/session/${session.id}/summary');
                      }
                    },
                    child: const Text('End Game'),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.grid_view_rounded),
                      title: Text('Round ${state.currentRound}'),
                      subtitle: const Text(
                        'Lowest pip count wins when you end the game.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final player in players)
                    Card(
                      child: ListTile(
                        title: Text(player.displayName),
                        subtitle: Text(
                          'Total pips ${state.playerTotals[player.id] ?? 0}',
                        ),
                        trailing: FilledButton(
                          onPressed: () => _enterPips(
                            context,
                            ref,
                            session.id,
                            state,
                            player.id,
                          ),
                          child: const Text('Add'),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  for (final entry in standings) LeaderboardRow(entry: entry),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<SessionPlayer> _parsePlayers(String json) {
    final raw = jsonDecode(json) as List<dynamic>;
    return raw
        .map((item) => SessionPlayer.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _enterPips(
    BuildContext context,
    WidgetRef ref,
    int sessionId,
    DominoesState state,
    String playerId,
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
          title: 'Round pips',
          onSubmitted: (value) async {
            final action = DominoesRoundScoreEntered(
              playerId: playerId,
              pips: value,
            );
            final nextState =
                const DominoesModule().applyAction(state, action)
                    as DominoesState;
            await ref
                .read(activeSessionsNotifierProvider.notifier)
                .recordScore(sessionId, action, jsonEncode(nextState.toJson()));
            ref.read(sessionRedoStackProvider(sessionId).notifier).state =
                const <db.ScoreEntry>[];
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  List<db.ScoreEntry> _sortedEntries(List<db.ScoreEntry> entries) {
    final sorted = [...entries]
      ..sort((a, b) {
        final recorded = a.recordedAt.compareTo(b.recordedAt);
        return recorded != 0 ? recorded : a.id.compareTo(b.id);
      });
    return sorted;
  }

  DominoesState _rebuildState(
    List<SessionPlayer> players,
    List<db.ScoreEntry> entries,
  ) {
    var nextState = DominoesState(
      currentRound: 1,
      playerTotals: {for (final player in players) player.id: 0},
      gameOver: false,
      playerOrder: players.map((player) => player.id).toList(),
    );
    for (final entry in entries) {
      nextState =
          const DominoesModule().applyAction(
                nextState,
                DominoesRoundScoreEntered(
                  playerId: entry.playerId,
                  pips: entry.value,
                ),
              )
              as DominoesState;
    }
    return nextState;
  }

  Future<void> _undoLastScore(
    BuildContext context,
    WidgetRef ref,
    db.AppDatabase database,
    db.GameSession session,
    DominoesState state,
    List<SessionPlayer> players,
    List<db.ScoreEntry> entries,
  ) async {
    final entry = entries.last;
    final nextState = _rebuildState(
      players,
      entries.take(entries.length - 1).toList(),
    );
    await database.transaction(() async {
      await database.sessionDao.deleteScoreEntry(entry.id);
      await database.sessionDao.updateModuleState(
        session.id,
        jsonEncode(
          nextState.copyWith(gameOver: false, winnerId: null).toJson(),
        ),
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

  Future<void> _redoLastScore(
    BuildContext context,
    WidgetRef ref,
    db.AppDatabase database,
    db.GameSession session,
    List<SessionPlayer> players,
    List<db.ScoreEntry> entries,
    List<db.ScoreEntry> redoStack,
  ) async {
    final entry = redoStack.first;
    final restoredEntries = _sortedEntries([
      ...entries,
      db.ScoreEntry(
        id: entry.id,
        sessionId: entry.sessionId,
        playerId: entry.playerId,
        roundNumber: entry.roundNumber,
        value: entry.value,
        notes: entry.notes,
        recordedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    ]);
    final nextState = _rebuildState(players, restoredEntries);
    await database.transaction(() async {
      await database.sessionDao.insertScoreEntry(
        db.ScoreEntriesCompanion.insert(
          sessionId: session.id,
          playerId: entry.playerId,
          roundNumber: entry.roundNumber,
          value: entry.value,
          notes: Value(entry.notes),
          recordedAt: DateTime.now().millisecondsSinceEpoch,
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
      ).showSnackBar(const SnackBar(content: Text('Score restored.')));
    }
  }

  void _showHelp(BuildContext context) {
    showRulesSheet(
      context,
      title: 'Dominoes rules',
      summary:
          'Track each round’s remaining pip count for every team or player.',
      bullets: const [
        'Match tiles by number to play out your hand.',
        'Add the pips left in a losing hand at the end of a round.',
        'The lowest total score wins when the game ends.',
      ],
    );
  }
}
