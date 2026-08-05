import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/session_dao.dart';
import '../../../../core/models/session_player.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../features/shared_session/rules_sheet.dart';
import '../../../../features/shared_session/session_redo_stack_provider.dart';
import '../../../../ui/widgets/leaderboard_row.dart';
import '../../../../ui/widgets/numeric_keypad.dart';
import '../application/bowling_cubit.dart';
import '../domain/bowling_module.dart';
import '../domain/bowling_state.dart';
import 'bowling_sheet_widget.dart';

class BowlingSessionScreen extends ConsumerWidget {
  const BowlingSessionScreen({required this.sessionId, super.key});

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
        final state = BowlingState.fromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        final module = const BowlingModule();
        return BlocProvider(
          key: ValueKey<String>(session.moduleStateJson),
          create: (_) => BowlingCubit(
            sessionDao: database.sessionDao,
            sessionId: sessionId,
            module: module,
            initialState: state,
          ),
          child: _BowlingSessionBody(
            session: session,
            players: players,
            module: module,
            sessionDao: database.sessionDao,
          ),
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
}

class _BowlingSessionBody extends ConsumerWidget {
  const _BowlingSessionBody({
    required this.session,
    required this.players,
    required this.module,
    required this.sessionDao,
  });

  final db.GameSession session;
  final List<SessionPlayer> players;
  final BowlingModule module;
  final SessionDao sessionDao;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final redoStack = ref.watch(sessionRedoStackProvider(session.id));
    return StreamBuilder<List<db.ScoreEntry>>(
      stream: sessionDao.watchScoreEntriesForSession(session.id),
      builder: (context, entriesSnapshot) {
        final entries = _sortedEntries(
          entriesSnapshot.data ?? const <db.ScoreEntry>[],
        );
        return BlocBuilder<BowlingCubit, BowlingState>(
          builder: (context, state) {
            final currentPlayer = players[state.currentPlayerIndex];
            final leaderboard = module.leaderboard(state);
            final win = module.checkWinCondition(state);
            if (win != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await ref
                    .read(activeSessionsNotifierProvider.notifier)
                    .endSession(
                      session.id,
                      players
                          .firstWhere(
                            (player) => player.id == win.winnerId,
                            orElse: () => currentPlayer,
                          )
                          .displayName,
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
                    tooltip: 'Undo last frame score',
                    onPressed: entries.isEmpty
                        ? null
                        : () => _undoLastScore(
                            context,
                            ref,
                            session,
                            state,
                            entries,
                          ),
                    icon: const Icon(Icons.undo),
                  ),
                  IconButton(
                    tooltip: 'Redo last frame score',
                    onPressed: redoStack.isEmpty
                        ? null
                        : () => _redoLastScore(
                            context,
                            ref,
                            session,
                            entries,
                            redoStack,
                          ),
                    icon: const Icon(Icons.redo),
                  ),
                  TextButton(
                    onPressed: () async {
                      final winnerName = leaderboard.isEmpty
                          ? currentPlayer.displayName
                          : players
                                .firstWhere(
                                  (player) =>
                                      player.id == leaderboard.first.playerId,
                                  orElse: () => currentPlayer,
                                )
                                .displayName;
                      await ref
                          .read(activeSessionsNotifierProvider.notifier)
                          .endSession(
                            session.id,
                            winnerName,
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
                      leading: const Icon(Icons.sports_rounded),
                      title: Text(
                        '${currentPlayer.displayName} • Frame ${state.currentFrame}',
                      ),
                      subtitle: const Text(
                        'Record the next roll. Perfect game score: 300.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BowlingSheetWidget(players: players, state: state),
                  const SizedBox(height: 16),
                  for (final entry in leaderboard)
                    LeaderboardRow(
                      entry: entry.copyWith(
                        displayName: players
                            .firstWhere(
                              (player) => player.id == entry.playerId,
                              orElse: () => currentPlayer,
                            )
                            .displayName,
                        colorHex: players
                            .firstWhere(
                              (player) => player.id == entry.playerId,
                              orElse: () => currentPlayer,
                            )
                            .colorHex,
                      ),
                    ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _showRollSheet(context, ref),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Record Roll'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showRollSheet(BuildContext context, WidgetRef ref) async {
    final cubit = context.read<BowlingCubit>();
    final state = cubit.state;
    final canStrike = module.canUseStrikeShortcut(state);
    final sparePins = module.spareShortcutPins(state);

    Future<void> submitRoll(BuildContext ctx, int value) async {
      final error = await cubit.recordRoll(value);
      if (!ctx.mounted) {
        return;
      }
      if (error != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      ref.read(sessionRedoStackProvider(session.id).notifier).state =
          const <db.ScoreEntry>[];
      Navigator.of(ctx).pop();
    }

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canStrike || sparePins != null) ...[
              Row(
                children: [
                  if (canStrike)
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () => submitRoll(ctx, 10),
                        icon: const Icon(Icons.bolt),
                        label: const Text('Strike'),
                      ),
                    ),
                  if (canStrike && sparePins != null) const SizedBox(width: 12),
                  if (sparePins != null)
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () => submitRoll(ctx, sparePins),
                        icon: const Icon(Icons.done_all),
                        label: const Text('Spare'),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            NumericKeypad(
              title: 'Pins knocked down',
              onSubmitted: (value) => submitRoll(ctx, value),
            ),
          ],
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

  BowlingState _rebuildState(List<db.ScoreEntry> entries) {
    var nextState = BowlingState(
      currentPlayerIndex: 0,
      currentFrame: 1,
      frames: {for (final player in players) player.id: const <BowlingFrame>[]},
      playerOrder: players.map((player) => player.id).toList(),
    );
    for (final entry in entries) {
      nextState =
          module.applyAction(nextState, BowlingRollEntered(pins: entry.value))
              as BowlingState;
    }
    return nextState;
  }

  Future<void> _undoLastScore(
    BuildContext context,
    WidgetRef ref,
    db.GameSession session,
    BowlingState state,
    List<db.ScoreEntry> entries,
  ) async {
    final entry = entries.last;
    final nextState = _rebuildState(entries.take(entries.length - 1).toList());
    await sessionDao.transaction(() async {
      await sessionDao.deleteScoreEntry(entry.id);
      await sessionDao.updateModuleState(
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
      ).showSnackBar(const SnackBar(content: Text('Last roll undone.')));
    }
  }

  Future<void> _redoLastScore(
    BuildContext context,
    WidgetRef ref,
    db.GameSession session,
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
      _sortedEntries([...entries, restoredEntry]),
    );
    await sessionDao.transaction(() async {
      await sessionDao.insertScoreEntry(
        db.ScoreEntriesCompanion.insert(
          sessionId: session.id,
          playerId: entry.playerId,
          roundNumber: entry.roundNumber,
          value: entry.value,
          notes: Value(entry.notes),
          recordedAt: restoredEntry.recordedAt,
        ),
      );
      await sessionDao.updateModuleState(
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
      ).showSnackBar(const SnackBar(content: Text('Roll restored.')));
    }
  }

  void _showHelp(BuildContext context) {
    showRulesSheet(
      context,
      title: 'Bowling rules',
      summary:
          'Track 10 frames and let strike and spare bonuses build automatically.',
      bullets: const [
        'A strike (X) knocks down all 10 pins on the first roll of a frame.',
        'A spare (/) clears the remaining pins on the second roll of a frame.',
        'The highest total score after 10 frames wins.',
      ],
    );
  }
}
