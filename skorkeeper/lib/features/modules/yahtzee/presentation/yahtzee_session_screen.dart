import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/models/session_player.dart';
import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../features/shared_session/rules_sheet.dart';
import '../application/yahtzee_cubit.dart';
import '../domain/yahtzee_module.dart';
import '../domain/yahtzee_state.dart';
import 'yahtzee_dice_widget.dart';
import 'yahtzee_scorecard_widget.dart';

class YahtzeeSessionScreen extends ConsumerWidget {
  const YahtzeeSessionScreen({required this.sessionId, super.key});

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
        final state = YahtzeeState.fromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        final module = const YahtzeeModule();
        return BlocProvider(
          key: ValueKey<String>(session.moduleStateJson),
          create: (_) => YahtzeeCubit(
            sessionDao: database.sessionDao,
            sessionId: sessionId,
            module: module,
            initialState: state,
          ),
          child: _YahtzeeSessionBody(
            session: session,
            players: players,
            module: module,
          ),
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

class _YahtzeeSessionBody extends ConsumerWidget {
  const _YahtzeeSessionBody({
    required this.session,
    required this.players,
    required this.module,
  });

  final db.GameSession session;
  final List<SessionPlayer> players;
  final YahtzeeModule module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocBuilder<YahtzeeCubit, YahtzeeState>(
      builder: (context, state) {
        final currentPlayerId = state.playerOrder[state.currentPlayerIndex];
        final currentPlayer = players.firstWhere(
          (player) => player.id == currentPlayerId,
          orElse: () => players.first,
        );
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
                onPressed: () => _showRules(context),
                icon: const Icon(Icons.help_outline),
              ),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(activeSessionsNotifierProvider.notifier)
                      .endSession(
                        session.id,
                        currentPlayer.displayName,
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
                  leading: const Icon(Icons.person),
                  title: Text(currentPlayer.displayName),
                  subtitle: Text(
                    state.useRealDice
                        ? 'Using real dice — tap a category to enter score'
                        : 'Roll ${state.currentRollNumber} of 3',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!state.useRealDice) ...[
                // Joker banner: show when player has rolled a Yahtzee and box is already filled.
                if (state.currentRollNumber > 0 &&
                    state.diceValues.toSet().length == 1 &&
                    (state.scorecards[state.playerOrder[state.currentPlayerIndex]]
                            ?.yahtzee ==
                        50))
                  const Card(
                    color: Color(0xFFFFF8E1),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Text('🎲', style: TextStyle(fontSize: 22)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Yahtzee Bonus! +100',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFE65100),
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'Joker rules apply — pick any open category.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF795548),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                YahtzeeDiceWidget(
                  values: state.diceValues,
                  held: state.diceHeld,
                  heldAtRoll: context.read<YahtzeeCubit>().diceHeldAtRoll,
                  rollsUsed: state.currentRollNumber,
                  onRoll: () => context.read<YahtzeeCubit>().rollDice(),
                  onToggleHold: (index) =>
                      context.read<YahtzeeCubit>().toggleHold(index),
                ),
                const SizedBox(height: 16),
              ],
              YahtzeeScorecardWidget(
                players: players,
                state: state,
                module: module,
                onSelectCategory: (
                  playerId,
                  category, {
                  manualScore,
                  yahtzeeBonus,
                }) =>
                    context.read<YahtzeeCubit>().selectCategory(
                      playerId,
                      category,
                      manualScore: manualScore,
                      yahtzeeBonus: yahtzeeBonus ?? false,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRules(BuildContext context) {
    showRulesSheet(
      context,
      title: 'Yahtzee rules',
      summary:
          'Roll up to three times each turn and score exactly one category.',
      bullets: const [
        'Choose from upper categories, of-a-kind categories, straights, full house, chance, and Yahtzee.',
        'The upper bonus adds 35 points when your upper section reaches 63.',
        'Highest total score after every category is filled wins.',
      ],
    );
  }
}
