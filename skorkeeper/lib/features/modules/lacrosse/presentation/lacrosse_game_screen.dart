import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../shared/player_selection_dialog.dart';
import '../../shared/sport_module_utils.dart';
import '../../shared/sport_notes_sheet.dart';
import '../../shared/sport_score_edit_dialog.dart';
import '../application/lacrosse_game_notifier.dart';

class LacrosseGameScreen extends ConsumerWidget {
  const LacrosseGameScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(lacrosseGameNotifierProvider(sessionId));
    return gameAsync.when(
      data: (state) => Scaffold(
        appBar: AppBar(
          title: const Text('Lacrosse'),
          actions: [
            IconButton(
              onPressed: () => _editScore(context, ref, state),
              icon: const Icon(Icons.edit),
              tooltip: 'Edit score / clock',
            ),
            IconButton(
              onPressed: () async {
                final notes = await showSportNotesSheet(
                  context,
                  initialValue: state.notes,
                );
                if (notes != null) {
                  await ref
                      .read(lacrosseGameNotifierProvider(sessionId).notifier)
                      .dispatch(SportNoteUpdated(content: notes));
                }
              },
              icon: const Icon(Icons.note_alt_outlined),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).padding.bottom,
          ),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      SportModuleUtils.formatClock(
                        SportModuleUtils.asInt(state.sportSpecific['remainingSeconds']),
                      ),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text('Quarter ${SportModuleUtils.asInt(state.sportSpecific['currentQuarter'])}'),
                    const SizedBox(height: 8),
                    Text('${state.homeTeam.name} ${state.homeTeam.score} - ${state.awayTeam.score} ${state.awayTeam.name}'),
                  ],
                ),
              ),
            ),
            if (state.gamePhase != GamePhase.completed) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _recordGoal(context, ref, state),
                      child: const Text('Goal + Assist'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _recordGroundBall(context, ref, state),
                      child: const Text('Ground Ball'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _dispatchClear(ref, 'home', true),
                      child: const Text('Home Clear'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _dispatchClear(ref, 'away', false),
                      child: const Text('Away Failed Clear'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(lacrosseGameNotifierProvider(sessionId).notifier)
                    .dispatch(
                      state.timerRunning
                          ? const SportTimerPaused()
                          : const SportTimerStarted(),
                    ),
                child: Text(state.timerRunning ? 'Pause Timer' : 'Start Timer'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(lacrosseGameNotifierProvider(sessionId).notifier)
                    .dispatch(const FootballQuarterAdvanced()),
                child: const Text('End Quarter'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(lacrosseGameNotifierProvider(sessionId).notifier)
                    .dispatch(const SportGameEnded()),
                child: const Text('End Game'),
              ),
            ],
            if (state.gamePhase == GamePhase.completed) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Summary'),
                      ..._playerLines(state),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text(error.toString()))),
    );
  }

  List<Widget> _playerLines(SportGameState state) {
    final widgets = <Widget>[];
    for (final team in [state.homeTeam, state.awayTeam]) {
      widgets.add(Text(team.name, style: const TextStyle(fontWeight: FontWeight.bold)));
      for (final player in team.roster ?? <SportPlayer>[]) {
        widgets.add(
          Text(
            '${player.name}: G ${SportModuleUtils.asInt(player.stats['goals'])} · GB ${SportModuleUtils.asInt(player.stats['groundBalls'])}',
          ),
        );
      }
    }
    return widgets;
  }

  Future<void> _recordGoal(
    BuildContext context,
    WidgetRef ref,
    SportGameState state,
  ) async {
    final teamId = await _pickTeam(context, state);
    if (!context.mounted) return;
    if (teamId == null) {
      return;
    }
    final roster = (teamId == 'home' ? state.homeTeam.roster : state.awayTeam.roster) ?? [];
    final scorerId = await showPlayerSelectionDialog(
      context,
      title: 'Select scorer',
      players: roster,
    );
    if (!context.mounted) return;
    if (scorerId == null) {
      return;
    }
    final assistId = await showPlayerSelectionDialog(
      context,
      title: 'Assist (optional)',
      players: roster.where((player) => player.id != scorerId).toList(),
    );
    if (!context.mounted) return;
    await ref.read(lacrosseGameNotifierProvider(sessionId).notifier).dispatch(
          LacrosseGoalScored(
            teamId: teamId,
            scorerPlayerId: scorerId,
            assistPlayerId: assistId,
          ),
        );
  }

  Future<void> _recordGroundBall(
    BuildContext context,
    WidgetRef ref,
    SportGameState state,
  ) async {
    final teamId = await _pickTeam(context, state);
    if (!context.mounted) return;
    if (teamId == null) {
      return;
    }
    final roster = (teamId == 'home' ? state.homeTeam.roster : state.awayTeam.roster) ?? [];
    final playerId = await showPlayerSelectionDialog(
      context,
      title: 'Select player',
      players: roster,
    );
    if (!context.mounted) return;
    if (playerId == null) {
      return;
    }
    await ref.read(lacrosseGameNotifierProvider(sessionId).notifier).dispatch(
          LacrosseGroundBallWon(teamId: teamId, playerId: playerId),
        );
  }

  Future<String?> _pickTeam(BuildContext context, SportGameState state) {
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              title: Text(state.homeTeam.name),
              onTap: () => Navigator.of(context).pop('home'),
            ),
            ListTile(
              title: Text(state.awayTeam.name),
              onTap: () => Navigator.of(context).pop('away'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editScore(
    BuildContext context,
    WidgetRef ref,
    SportGameState state,
  ) async {
    final result = await SportScoreEditDialog.show(
      context,
      homeName: state.homeTeam.name,
      awayName: state.awayTeam.name,
      homeScore: state.homeTeam.score,
      awayScore: state.awayTeam.score,
      period: SportModuleUtils.asInt(state.sportSpecific['currentQuarter']),
      periodLabel: 'Quarter',
      remainingSeconds: SportModuleUtils.asInt(state.sportSpecific['remainingSeconds']),
    );
    if (result == null || !context.mounted) {
      return;
    }
    final notifier = ref.read(lacrosseGameNotifierProvider(sessionId).notifier);
    await notifier.editScore(result.homeScore, result.awayScore);
    if (result.period != null) {
      await notifier.editPeriod(result.period!);
    }
    if (result.remainingSeconds != null) {
      await notifier.editClock(result.remainingSeconds!);
    }
  }

  Future<void> _dispatchClear(WidgetRef ref, String teamId, bool success) {
    return ref.read(lacrosseGameNotifierProvider(sessionId).notifier).dispatch(
          LacrosseClearAttempted(teamId: teamId, successful: success),
        );
  }
}
