import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../shared/player_selection_dialog.dart';
import '../../shared/sport_module_utils.dart';
import '../../shared/sport_notes_sheet.dart';
import '../../shared/sport_score_edit_dialog.dart';
import '../application/hockey_game_notifier.dart';

class HockeyGameScreen extends ConsumerWidget {
  const HockeyGameScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(hockeyGameNotifierProvider(sessionId));
    return gameAsync.when(
      data: (state) => Scaffold(
        appBar: AppBar(
          title: const Text('Hockey'),
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
                      .read(hockeyGameNotifierProvider(sessionId).notifier)
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
                    Text('Period ${SportModuleUtils.asInt(state.sportSpecific['currentPeriod'])}'),
                    if (state.sportSpecific['isOvertime'] == true) const Text('Overtime'),
                    if (state.sportSpecific['isShootout'] == true) const Text('Shootout'),
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
                      child: const Text('Goal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _recordPenalty(context, ref, state),
                      child: const Text('Penalty'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(hockeyGameNotifierProvider(sessionId).notifier)
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
                    .read(hockeyGameNotifierProvider(sessionId).notifier)
                    .dispatch(const HockeyPeriodAdvanced()),
                child: const Text('End Period'),
              ),
              const SizedBox(height: 12),
              if (SportModuleUtils.mapList(state.sportSpecific['activePenalties']).isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Active penalties', style: Theme.of(context).textTheme.titleMedium),
                        for (final penalty
                            in SportModuleUtils.mapList(state.sportSpecific['activePenalties']))
                          Text(
                            '${penalty['teamId']} · ${penalty['type']} · ${penalty['durationMinutes']} min',
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(hockeyGameNotifierProvider(sessionId).notifier)
                    .dispatch(const SportGameEnded()),
                child: const Text('End Game'),
              ),
            ],
            if (state.gamePhase == GamePhase.completed) ...[
              const SizedBox(height: 16),
              _summary(context, state),
            ],
          ],
        ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text(error.toString()))),
    );
  }

  Widget _summary(BuildContext context, SportGameState state) {
    final periodScoresHome = SportModuleUtils.intList(state.homeTeam.stats['periodScores']);
    final periodScoresAway = SportModuleUtils.intList(state.awayTeam.stats['periodScores']);
    final goals = state.events.where((event) => event.eventType == 'goal');
    final penalties = state.events.where((event) => event.eventType == 'penalty_start');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Game Summary', style: Theme.of(context).textTheme.titleLarge),
            DataTable(
              columns: const [
                DataColumn(label: Text('Team')),
                DataColumn(label: Text('P1')),
                DataColumn(label: Text('P2')),
                DataColumn(label: Text('P3')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(state.homeTeam.name)),
                    for (var i = 0; i < 3; i++)
                      DataCell(Text(i < periodScoresHome.length ? '${periodScoresHome[i]}' : '0')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(state.awayTeam.name)),
                    for (var i = 0; i < 3; i++)
                      DataCell(Text(i < periodScoresAway.length ? '${periodScoresAway[i]}' : '0')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Goals'),
            for (final goal in goals)
              Text(
                '${goal.teamId} · ${_playerName(state, goal.teamId, goal.playerId)} · ${SportModuleUtils.formatClock(goal.gameTimeSeconds)}',
              ),
            const SizedBox(height: 8),
            const Text('Penalty Log'),
            for (final penalty in penalties)
              Text('${penalty.teamId} · ${penalty.metadata?['type']} · ${penalty.metadata?['durationMinutes']} min'),
          ],
        ),
      ),
    );
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
    final scorer = await showPlayerSelectionDialog(
      context,
      title: 'Select scorer',
      players: roster,
    );
    if (!context.mounted) return;
    if (scorer == null) {
      return;
    }
    final primary = await showPlayerSelectionDialog(
      context,
      title: 'Primary assist (optional)',
      players: roster.where((player) => player.id != scorer).toList(),
    );
    if (!context.mounted) return;
    final secondary = await showPlayerSelectionDialog(
      context,
      title: 'Secondary assist (optional)',
      players: roster.where((player) => player.id != scorer && player.id != primary).toList(),
    );
    if (!context.mounted) return;
    await ref.read(hockeyGameNotifierProvider(sessionId).notifier).dispatch(
          HockeyGoalScored(
            teamId: teamId,
            scorerPlayerId: scorer,
            primaryAssistPlayerId: primary,
            secondaryAssistPlayerId: secondary,
          ),
        );
  }

  Future<void> _recordPenalty(
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
    await ref.read(hockeyGameNotifierProvider(sessionId).notifier).dispatch(
          HockeyPenaltyAssessed(
            teamId: teamId,
            playerId: playerId,
            penaltyType: 'Minor',
            durationMinutes: 2,
          ),
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
      period: SportModuleUtils.asInt(state.sportSpecific['currentPeriod']),
      periodLabel: 'Period',
      remainingSeconds: SportModuleUtils.asInt(state.sportSpecific['remainingSeconds']),
    );
    if (result == null || !context.mounted) {
      return;
    }
    final notifier = ref.read(hockeyGameNotifierProvider(sessionId).notifier);
    await notifier.editScore(result.homeScore, result.awayScore);
    if (result.period != null) {
      await notifier.editPeriod(result.period!);
    }
    if (result.remainingSeconds != null) {
      await notifier.editClock(result.remainingSeconds!);
    }
  }

  String _playerName(SportGameState state, String teamId, String? playerId) {
    final roster = (teamId == 'home' ? state.homeTeam.roster : state.awayTeam.roster) ?? [];
    for (final player in roster) {
      if (player.id == playerId) {
        return player.name;
      }
    }
    return 'Unknown';
  }
}
