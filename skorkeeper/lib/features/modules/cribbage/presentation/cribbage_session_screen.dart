import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../application/cribbage_cubit.dart';
import '../domain/cribbage_module.dart';
import '../domain/cribbage_state.dart';
import 'cribbage_board_widget.dart';

class CribbageSessionScreen extends ConsumerWidget {
  const CribbageSessionScreen({required this.sessionId, super.key});

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
        final state = CribbageState.fromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        return BlocProvider(
          key: ValueKey<String>(session.moduleStateJson),
          create: (_) => CribbageCubit(
            sessionDao: database.sessionDao,
            sessionId: sessionId,
            module: const CribbageModule(),
            initialState: state,
          ),
          child: _CribbageBody(session: session, players: players),
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
}

class _CribbageBody extends ConsumerWidget {
  const _CribbageBody({required this.session, required this.players});

  final db.GameSession session;
  final List<SessionPlayer> players;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);
    final redoStack = ref.watch(sessionRedoStackProvider(session.id));
    return StreamBuilder<List<db.ScoreEntry>>(
      stream: database.sessionDao.watchScoreEntriesForSession(session.id),
      builder: (context, entriesSnapshot) {
        final entries = _sortedEntries(
          entriesSnapshot.data ?? const <db.ScoreEntry>[],
        );
        return BlocBuilder<CribbageCubit, CribbageState>(
          builder: (context, state) {
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
            final colorMap = {
              for (final player in players)
                player.id: _parseColor(player.colorHex),
            };
            return Scaffold(
              appBar: AppBar(
                title: Text(session.sessionName ?? 'Cribbage'),
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
                      final leader = players.firstWhere(
                        (player) =>
                            player.id == (state.winnerId ?? players.first.id),
                        orElse: () => players.first,
                      );
                      await ref
                          .read(activeSessionsNotifierProvider.notifier)
                          .endSession(
                            session.id,
                            leader.displayName,
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
                  CribbageBoardWidget(
                    positions: state.pegPositions,
                    colors: colorMap,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: Text(
                        'Dealer: ${players.firstWhere((player) => player.id == state.dealerId).displayName}',
                      ),
                      subtitle: Text('Hand ${state.handNumber}'),
                      trailing: FilledButton(
                        onPressed: () =>
                            context.read<CribbageCubit>().advanceDealer(),
                        child: const Text('Next Dealer'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final player in players)
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _parseColor(player.colorHex),
                        ),
                        title: Text(player.displayName),
                        subtitle: Text(
                          'Front ${state.pegPositions[player.id]?.front ?? 0} • Rear ${state.pegPositions[player.id]?.rear ?? 0}',
                        ),
                        trailing: FilledButton(
                          onPressed: () =>
                              _scorePoints(context, ref, player.id),
                          child: const Text('Score'),
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

  Future<void> _scorePoints(
    BuildContext context,
    WidgetRef ref,
    String playerId,
  ) async {
    final cubit = context.read<CribbageCubit>();
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
          title: 'Points scored',
          onSubmitted: (value) async {
            await cubit.scorePoints(playerId, value);
            ref.read(sessionRedoStackProvider(session.id).notifier).state =
                const <db.ScoreEntry>[];
            if (ctx.mounted) {
              Navigator.of(ctx).pop();
            }
          },
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    final normalized = hex.replaceAll('#', '');
    return Color(int.parse('FF$normalized', radix: 16));
  }

  List<db.ScoreEntry> _sortedEntries(List<db.ScoreEntry> entries) {
    final sorted = [...entries]
      ..sort((a, b) {
        final recorded = a.recordedAt.compareTo(b.recordedAt);
        return recorded != 0 ? recorded : a.id.compareTo(b.id);
      });
    return sorted;
  }

  CribbageState _rebuildState(
    CribbageState currentState,
    List<db.ScoreEntry> entries,
  ) {
    final playerOrder = players.map((player) => player.id).toList();
    var nextState = CribbageState(
      variant: players.length == 3 ? 'three_team' : 'two_team',
      dealerId: currentState.dealerId,
      pegPositions: {
        for (final playerId in playerOrder)
          playerId: const CribbagePegPosition(front: 0, rear: 0),
      },
      gameOver: false,
      winnerId: null,
      handNumber: 1,
    );
    for (final entry in entries) {
      nextState =
          const CribbageModule().applyAction(
                nextState,
                CribbagePointsScored(
                  playerId: entry.playerId,
                  points: entry.value,
                ),
              )
              as CribbageState;
    }
    return nextState.copyWith(
      dealerId: currentState.dealerId,
      handNumber: currentState.handNumber,
    );
  }

  Future<void> _undoLastScore(
    BuildContext context,
    WidgetRef ref,
    db.AppDatabase database,
    db.GameSession session,
    CribbageState state,
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
      ).showSnackBar(const SnackBar(content: Text('Last score undone.')));
    }
  }

  Future<void> _redoLastScore(
    BuildContext context,
    WidgetRef ref,
    db.AppDatabase database,
    db.GameSession session,
    CribbageState state,
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
      title: 'Cribbage rules',
      summary:
          'Race around the board to 121 while tracking pegging and hand scoring.',
      bullets: const [
        'A team wins by reaching 121 points first.',
        'Peg points during play for combinations like 15s, pairs, and runs.',
        'After pegging, score each hand and the crib before moving the dealer.',
      ],
    );
  }
}
