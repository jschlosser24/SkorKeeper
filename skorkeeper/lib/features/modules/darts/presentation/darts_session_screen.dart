import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/models/session_player.dart';
import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/audio_provider.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../../../features/shared_session/rules_sheet.dart';
import '../application/darts_bloc.dart';
import '../domain/darts_301_module.dart';
import '../domain/darts_501_module.dart';
import '../domain/darts_701_module.dart';
import '../domain/darts_around_the_clock_module.dart';
import '../domain/darts_cricket_module.dart';
import '../domain/darts_cut_throat_module.dart';
import '../domain/darts_game_state.dart';
import '../domain/darts_halve_it_module.dart';
import '../domain/darts_killer_module.dart';
import '../domain/darts_module_base.dart';
import '../domain/darts_shanghai_module.dart';
import 'cricket_scoreboard_widget.dart';
import 'darts_keypad_widget.dart';

class DartsSessionScreen extends ConsumerWidget {
  const DartsSessionScreen({required this.sessionId, super.key});

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
        final state = DartsGameState.fromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        final module = _moduleForState(state);
        return BlocProvider(
          key: ValueKey<String>(session.moduleStateJson),
          create: (_) => DartsBloc(
            sessionDao: database.sessionDao,
            sessionId: sessionId,
            module: module,
            initialState: state,
          ),
          child: _DartsSessionView(session: session, module: module),
        );
      },
    );
  }

  DartsModuleBase _moduleForState(DartsGameState state) {
    switch (state.gameVariant) {
      case DartsVariant.v301:
        return Darts301Module(
          doubleIn: state.doubleIn,
          doubleOut: state.doubleOut,
        );
      case DartsVariant.v701:
        return Darts701Module(
          doubleIn: state.doubleIn,
          doubleOut: state.doubleOut,
        );
      case DartsVariant.cricket:
        return const DartsCricketModule();
      case DartsVariant.cutThroatCricket:
        return const DartsCutThroatModule();
      case DartsVariant.aroundTheClock:
        return const DartsAroundTheClockModule();
      case DartsVariant.shanghai:
        return const DartsShanghaiModule();
      case DartsVariant.killer:
        return const DartsKillerModule();
      case DartsVariant.halveIt:
        return const DartsHalveItModule();
      case DartsVariant.v501:
        return Darts501Module(
          doubleIn: state.doubleIn,
          doubleOut: state.doubleOut,
        );
    }
  }
}

class _DartsSessionView extends ConsumerWidget {
  const _DartsSessionView({required this.session, required this.module});

  final db.GameSession session;
  final DartsModuleBase module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = _parsePlayers(session.participantsJson);
    return BlocConsumer<DartsBloc, DartsState>(
      listener: (context, state) async {
        if (state.lastBust) {
          final prefs = ref.read(preferencesNotifierProvider).valueOrNull;
          if (prefs?.hapticEnabled ?? true) {
            HapticFeedback.heavyImpact();
          }
          final audio = await ref.read(audioServiceProvider.future);
          await audio.playBust();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bust! Score reverts for the turn.'),
              ),
            );
          }
        }
      },
      builder: (context, blocState) {
        final gameState = blocState.gameState;
        final currentPlayer = players.firstWhere(
          (player) => player.id == gameState.currentPlayerId,
          orElse: () => players.first,
        );
        final current = gameState.playerStates[currentPlayer.id]!;
        if (gameState.gameOver && gameState.winnerId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await ref
                .read(activeSessionsNotifierProvider.notifier)
                .endSession(
                  session.id,
                  players
                      .firstWhere(
                        (player) => player.id == gameState.winnerId,
                        orElse: () => players.first,
                      )
                      .displayName,
                  jsonEncode(gameState.toJson()),
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
                onPressed: () => _showHelp(context, gameState.gameVariant),
                icon: const Icon(Icons.help_outline),
              ),
              IconButton(
                tooltip: 'Undo last dart',
                onPressed: () =>
                    context.read<DartsBloc>().add(const UndoLastDart()),
                icon: const Icon(Icons.undo),
              ),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(activeSessionsNotifierProvider.notifier)
                      .endSession(
                        session.id,
                        currentPlayer.displayName,
                        jsonEncode(gameState.toJson()),
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: blocState.lastBust
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      currentPlayer.displayName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _headlineForState(gameState, current),
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Throw ${gameState.currentThrowInTurn} of 3',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Cricket/Cut-throat scoreboard
              if (gameState.gameVariant == DartsVariant.cricket ||
                  gameState.gameVariant == DartsVariant.cutThroatCricket) ...[
                CricketScoreboardWidget(state: gameState, players: players),
                const SizedBox(height: 16),
              ],
              // Stat cards for non-cricket variants
              if (gameState.gameVariant != DartsVariant.cricket &&
                  gameState.gameVariant != DartsVariant.cutThroatCricket)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final player in players)
                      _StatCard(
                        title: player.displayName,
                        lines: _statLines(gameState, player.id),
                      ),
                  ],
                ),
              if (_checkoutSuggestion(gameState, current).isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.lightbulb_outline),
                    title: const Text('Checkout suggestion'),
                    subtitle: Text(_checkoutSuggestion(gameState, current)),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              DartsKeypadWidget(
                previewBuilder: (score, multiplier) {
                  final preview = score * multiplier;
                  if (gameState.gameVariant == DartsVariant.v301 ||
                      gameState.gameVariant == DartsVariant.v501 ||
                      gameState.gameVariant == DartsVariant.v701) {
                    return 'Throw $preview → ${(current.scoreRemaining - preview).clamp(-999, current.scoreRemaining)} remaining';
                  }
                  if (gameState.gameVariant == DartsVariant.aroundTheClock) {
                    final target =
                        gameState.variantProgress?[gameState.currentPlayerId] ??
                        1;
                    final matchesTarget = target <= 20
                        ? score == target
                        : target == 21 && score == 25;
                    return matchesTarget
                        ? 'Advance to ${target == 21 ? 'finish' : 'target ${target + 1}'}'
                        : 'Hit ${target > 20 ? 'Bull' : target} to advance';
                  }
                  if (gameState.gameVariant == DartsVariant.shanghai) {
                    final target = gameState.currentRound ?? 1;
                    if (score != target) {
                      return 'Target $target only scores this round';
                    }
                    return 'Throw $preview → +$preview points';
                  }
                  return 'Throw $preview points';
                },
                onConfirmThrow: (score, multiplier) async {
                  context.read<DartsBloc>().add(
                    DartThrownEvent(score: score, multiplier: multiplier),
                  );
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () =>
                    context.read<DartsBloc>().add(const EndTurnEvent()),
                icon: const Icon(Icons.skip_next),
                label: const Text('End Turn'),
              ),
            ],
          ),
        );
      },
    );
  }

  static List<SessionPlayer> _parsePlayers(String participantsJson) {
    final raw = jsonDecode(participantsJson) as List<dynamic>;
    return raw
        .map((item) => SessionPlayer.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  String _headlineForState(DartsGameState state, DartsPlayerState current) {
    switch (state.gameVariant) {
      case DartsVariant.cricket:
      case DartsVariant.cutThroatCricket:
        return '${state.cricketPoints?[state.currentPlayerId] ?? 0} pts';
      case DartsVariant.aroundTheClock:
        final target = state.variantProgress?[state.currentPlayerId] ?? 1;
        return target > 20 ? 'Bullseye' : 'Target $target';
      case DartsVariant.shanghai:
        final round = state.currentRound ?? 1;
        return 'Round $round • Target $round';
      case DartsVariant.killer:
        return 'Lives ${state.killerLives?[state.currentPlayerId] ?? 0}';
      default:
        return current.scoreRemaining.toString();
    }
  }

  String _displayScore(DartsGameState state, String playerId) {
    switch (state.gameVariant) {
      case DartsVariant.cricket:
      case DartsVariant.cutThroatCricket:
        return '${state.cricketPoints?[playerId] ?? 0}';
      case DartsVariant.aroundTheClock:
        return 'Target ${state.variantProgress?[playerId] ?? 1}';
      case DartsVariant.killer:
        return '${state.killerLives?[playerId] ?? 0} lives';
      case DartsVariant.shanghai:
      case DartsVariant.halveIt:
        return '${state.variantScores?[playerId] ?? 0}';
      default:
        return '${state.playerStates[playerId]?.scoreRemaining ?? 0}';
    }
  }

  List<String> _statLines(DartsGameState state, String playerId) {
    final playerState = state.playerStates[playerId];
    final dartsThrown = playerState?.dartsThrown ?? 0;
    switch (state.gameVariant) {
      case DartsVariant.aroundTheClock:
        final nextTarget = state.variantProgress?[playerId] ?? 1;
        final completed = (nextTarget - 1).clamp(0, 21);
        return [
          'Next: ${nextTarget > 20 ? 'Bull' : nextTarget}',
          'Completed: $completed/21',
          'Darts: $dartsThrown',
        ];
      case DartsVariant.shanghai:
        final score = state.variantScores?[playerId] ?? 0;
        final round = state.currentRound ?? 1;
        return [
          'Score: $score pts',
          'Round: $round • Target $round',
          'Darts: $dartsThrown',
        ];
      case DartsVariant.killer:
        return [
          'Lives: ${state.killerLives?[playerId] ?? 0}',
          'Status: ${(state.killerStatus?[playerId] ?? false) ? 'Killer' : 'Surviving'}',
          'Darts: $dartsThrown',
        ];
      case DartsVariant.halveIt:
        return [
          'Score: ${state.variantScores?[playerId] ?? 0}',
          'Round: ${state.currentRound ?? 1}',
          'Avg: ${module.averagePerDart(state, playerId).toStringAsFixed(1)}',
        ];
      case DartsVariant.cricket:
      case DartsVariant.cutThroatCricket:
        return const [];
      default:
        return [
          'Score: ${_displayScore(state, playerId)}',
          'Darts: $dartsThrown',
          'Avg: ${module.averagePerDart(state, playerId).toStringAsFixed(1)}',
        ];
    }
  }

  String _checkoutSuggestion(DartsGameState state, DartsPlayerState current) {
    if (!(state.gameVariant == DartsVariant.v301 ||
        state.gameVariant == DartsVariant.v501 ||
        state.gameVariant == DartsVariant.v701)) {
      return '';
    }
    final remaining = current.scoreRemaining;
    if (remaining > 170 || remaining <= 1) {
      return '';
    }
    const suggestions = <int, String>{
      170: 'T20, T20, Bull',
      167: 'T20, T19, Bull',
      164: 'T20, T18, Bull',
      161: 'T20, T17, Bull',
      100: 'T20, D20',
      80: 'T20, D10',
      60: '20, D20',
      50: '10, D20',
      40: 'D20',
      32: 'D16',
      24: 'D12',
      16: 'D8',
    };
    return suggestions[remaining] ?? 'Work toward a double finish.';
  }

  void _showHelp(BuildContext context, DartsVariant variant) {
    switch (variant) {
      case DartsVariant.v301:
      case DartsVariant.v501:
      case DartsVariant.v701:
        showRulesSheet(
          context,
          title: '${variant.name.substring(1)} rules',
          summary:
              'Start at ${variant.name.substring(1)} and count down to exactly 0.',
          bullets: const [
            'Subtract each throw from your remaining score.',
            'The first player to reach exactly 0 wins.',
            'If you go below 0 or finish incorrectly, the turn busts and reverts.',
          ],
        );
        return;
      case DartsVariant.cricket:
        showRulesSheet(
          context,
          title: 'Cricket rules',
          summary: 'Close 15–20 and bullseye before your opponents.',
          bullets: const [
            'Hit 15, 16, 17, 18, 19, 20, and bull three times to close each target.',
            'Extra hits score points until every opponent closes that target.',
            'Win by closing everything and leading on points.',
          ],
        );
        return;
      case DartsVariant.cutThroatCricket:
        showRulesSheet(
          context,
          title: 'Cut-throat cricket rules',
          summary:
              'Close numbers like Cricket, but score on your opponents instead of for yourself.',
          bullets: const [
            'Close 15–20 and bull with three marks each.',
            'Extra hits add points to opponents who have not closed that target.',
            'Lowest score wins after all targets are closed.',
          ],
        );
        return;
      case DartsVariant.aroundTheClock:
        showRulesSheet(
          context,
          title: 'Around the Clock rules',
          summary:
              'Hit numbers in order from 1 through 20, then finish on bull.',
          bullets: const [
            'Only the current target number advances you.',
            'Keep going in order until you finish the full sequence.',
            'First player to complete the course wins.',
          ],
        );
        return;
      case DartsVariant.shanghai:
        showRulesSheet(
          context,
          title: 'Shanghai rules',
          summary:
              'Each round has one target number, starting at 1 and moving upward.',
          bullets: const [
            'Only the round’s target number scores.',
            'A Shanghai is a single, double, and triple of the target in one round.',
            'A Shanghai wins instantly.',
          ],
        );
        return;
      case DartsVariant.killer:
        showRulesSheet(
          context,
          title: 'Killer rules',
          summary:
              'Earn killer status, then knock out opponents by taking their lives.',
          bullets: const [
            'Players first hit their assigned target to become killers.',
            'Once you are a killer, hits can remove opponent lives.',
            'Last player with lives remaining wins.',
          ],
        );
        return;
      case DartsVariant.halveIt:
        showRulesSheet(
          context,
          title: 'Halve It rules',
          summary: 'Score on the round target or your running total is halved.',
          bullets: const [
            'Each round has a required number or section to hit.',
            'Missing the target halves your score.',
            'Highest score at the end wins.',
          ],
        );
        return;
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(line),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
