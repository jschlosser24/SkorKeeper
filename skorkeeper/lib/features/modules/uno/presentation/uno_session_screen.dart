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
import '../domain/uno_module.dart';
import '../domain/uno_state.dart';

class UnoSessionScreen extends ConsumerWidget {
  const UnoSessionScreen({required this.sessionId, super.key});

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
        final state = UnoState.fromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        final redoStack = ref.watch(sessionRedoStackProvider(sessionId));
        return StreamBuilder<List<db.ScoreEntry>>(
          stream: database.sessionDao.watchScoreEntriesForSession(sessionId),
          builder: (context, entriesSnapshot) {
            final entries = _sortedEntries(
              entriesSnapshot.data ?? const <db.ScoreEntry>[],
            );
            final module = UnoModule(targetScore: state.targetScore);
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
            if (state.gameOver && state.winnerId != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                final winner = players.firstWhere(
                  (player) => player.id == state.winnerId,
                  orElse: () => players.first,
                );
                await ref
                    .read(activeSessionsNotifierProvider.notifier)
                    .endSession(
                      session.id,
                      winner.displayName,
                      jsonEncode(state.toJson()),
                    );
                if (context.mounted) {
                  context.go('/home/session/${session.id}/summary');
                }
              });
            }
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
                            state,
                            entries,
                            redoStack,
                          ),
                    icon: const Icon(Icons.redo),
                  ),
                  TextButton(
                    onPressed: () async {
                      final winner = standings.first.displayName;
                      await ref
                          .read(activeSessionsNotifierProvider.notifier)
                          .endSession(
                            session.id,
                            winner,
                            jsonEncode(state.toJson()),
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
                      leading: const Icon(Icons.style_rounded),
                      title: Text('Round ${state.currentRound}'),
                      subtitle: Text(
                        'Highest score is eliminated at ${state.targetScore}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final player in players)
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(player.displayName.characters.first),
                        ),
                        title: Text(player.displayName),
                        subtitle: Text(
                          'Total ${state.playerTotals[player.id] ?? 0}'
                          '${state.eliminatedPlayerIds.contains(player.id) ? ' • Out' : ''}',
                        ),
                        trailing: FilledButton(
                          onPressed:
                              state.eliminatedPlayerIds.contains(player.id)
                              ? null
                              : () => _enterPenalty(
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

  Future<void> _enterPenalty(
    BuildContext context,
    WidgetRef ref,
    int sessionId,
    UnoState state,
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
          title: 'Penalty points',
          onSubmitted: (value) async {
            final action = UnoRoundScoreEntered(
              playerId: playerId,
              points: value,
            );
            final nextState =
                UnoModule(
                      targetScore: state.targetScore,
                    ).applyAction(state, action)
                    as UnoState;
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

  UnoState _rebuildState(UnoState baseState, List<db.ScoreEntry> entries) {
    var nextState = UnoState(
      currentRound: 1,
      targetScore: baseState.targetScore,
      playerTotals: {for (final playerId in baseState.playerOrder) playerId: 0},
      eliminatedPlayerIds: const <String>[],
      gameOver: false,
      playerOrder: [...baseState.playerOrder],
    );
    final module = UnoModule(targetScore: baseState.targetScore);
    for (final entry in entries) {
      nextState =
          module.applyAction(
                nextState,
                UnoRoundScoreEntered(
                  playerId: entry.playerId,
                  points: entry.value,
                ),
              )
              as UnoState;
    }
    return nextState;
  }

  Future<void> _undoLastScore(
    BuildContext context,
    WidgetRef ref,
    db.AppDatabase database,
    db.GameSession session,
    UnoState state,
    List<SessionPlayer> players,
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
    UnoState state,
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
    final nextState = _rebuildState(
      state,
      _sortedEntries([...entries, restoredEntry]),
    );
    await database.transaction(() async {
      await database.sessionDao.insertScoreEntry(
        db.ScoreEntriesCompanion.insert(
          sessionId: session.id,
          playerId: entry.playerId,
          roundNumber: entry.roundNumber,
          value: entry.value,
          notes: Value(entry.notes),
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
      ).showSnackBar(const SnackBar(content: Text('Score restored.')));
    }
  }

  void _showHelp(BuildContext context) {
    showRulesSheet(
      context,
      title: 'UNO rules',
      summary:
          'Track penalty points after each hand until one player stays under the target.',
      bullets: const [
        'Play a card that matches the current color, number, or symbol.',
        'The first player to 0 cards wins the hand.',
        'Add up the cards left in every losing hand as penalty points.',
      ],
    );
  }
}
