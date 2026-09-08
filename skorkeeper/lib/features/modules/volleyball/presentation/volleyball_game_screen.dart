import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../shared/player_selection_dialog.dart';
import '../../shared/sport_module_utils.dart';
import '../../shared/sport_notes_sheet.dart';
import '../application/volleyball_game_notifier.dart';

class VolleyballGameScreen extends ConsumerWidget {
  const VolleyballGameScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(volleyballGameNotifierProvider(sessionId));
    return gameAsync.when(
      data: (state) => Scaffold(
        appBar: AppBar(
          title: const Text('Volleyball'),
          actions: [
            IconButton(
              onPressed: () async {
                final notes = await showSportNotesSheet(
                  context,
                  initialValue: state.notes,
                );
                if (notes != null) {
                  await ref
                      .read(volleyballGameNotifierProvider(sessionId).notifier)
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
                      'Set ${SportModuleUtils.asInt(state.sportSpecific['currentSet'])}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Set score: ${SportModuleUtils.asInt(state.homeTeam.stats['setsWon'])} - ${SportModuleUtils.asInt(state.awayTeam.stats['setsWon'])}',
                    ),
                    Text('${state.homeTeam.name} ${state.homeTeam.score} - ${state.awayTeam.score} ${state.awayTeam.name}'),
                    const SizedBox(height: 8),
                    Text(
                      'Serving: ${SportModuleUtils.asString(state.sportSpecific['servingTeamId']) == 'home' ? state.homeTeam.name : state.awayTeam.name}',
                    ),
                  ],
                ),
              ),
            ),
            if (state.gamePhase != GamePhase.completed) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _pointButton(context, ref, state, 'home', state.homeTeam.name)),
                  const SizedBox(width: 12),
                  Expanded(child: _pointButton(context, ref, state, 'away', state.awayTeam.name)),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(volleyballGameNotifierProvider(sessionId).notifier)
                    .dispatch(
                      VolleyballServingChanged(
                        newServingTeamId:
                            SportModuleUtils.asString(
                                      state.sportSpecific['servingTeamId'],
                                    ) ==
                                    'home'
                                ? 'away'
                                : 'home',
                      ),
                    ),
                child: const Text('Rotate Serve'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(volleyballGameNotifierProvider(sessionId).notifier)
                    .dispatch(const SportGameEnded()),
                child: const Text('End Match'),
              ),
            ],
            if (state.gamePhase == GamePhase.completed) ...[
              const SizedBox(height: 16),
              _matchSummary(context, state),
            ],
          ],
        ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text(error.toString()))),
    );
  }

  Widget _matchSummary(BuildContext context, SportGameState state) {
    final setScores = SportModuleUtils.mapList(state.sportSpecific['setScores']);
    final homeSets = SportModuleUtils.asInt(state.homeTeam.stats['setsWon']);
    final awaySets = SportModuleUtils.asInt(state.awayTeam.stats['setsWon']);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Match Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text(state.homeTeam.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                Text('$homeSets - $awaySets', style: Theme.of(context).textTheme.headlineSmall),
                Expanded(child: Text(state.awayTeam.name, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            if (setScores.isNotEmpty) ...[
              const Divider(height: 24),
              Text('Set Scores', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                },
                children: [
                  TableRow(
                    children: [
                      const Padding(padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8), child: Text('Set', style: TextStyle(fontWeight: FontWeight.bold))),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8), child: Text('Game', style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), child: Text(state.homeTeam.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      Padding(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), child: Text(state.awayTeam.name, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                  for (final s in setScores)
                    TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Text('${SportModuleUtils.asInt(s['set'])}')),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Text('${SportModuleUtils.asInt(s['home'])} - ${SportModuleUtils.asInt(s['away'])}')),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Text('${SportModuleUtils.asInt(s['home'])}')),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), child: Text('${SportModuleUtils.asInt(s['away'])}', textAlign: TextAlign.end)),
                      ],
                    ),
                ],
              ),
            ],
            if ((state.homeTeam.roster?.isNotEmpty ?? false) ||
                (state.awayTeam.roster?.isNotEmpty ?? false)) ...[
              const Divider(height: 24),
              _playerStats(context, state),
            ],
          ],
        ),
      ),
    );
  }

  Widget _playerStats(BuildContext context, SportGameState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Player Stats', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        for (final team in [state.homeTeam, state.awayTeam])
          if (team.roster != null && team.roster!.isNotEmpty) ...[
            Text(team.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            DataTable(
              columns: const [
                DataColumn(label: Text('Player')),
                DataColumn(label: Text('Pts')),
              ],
              rows: [
                for (final player in team.roster!)
                  DataRow(
                    cells: [
                      DataCell(Text(player.number == null ? player.name : '#${player.number} ${player.name}')),
                      DataCell(Text('${SportModuleUtils.asInt(player.stats['points'])}')),
                    ],
                  ),
              ],
            ),
          ],
      ],
    );
  }

  Widget _pointButton(BuildContext context, WidgetRef ref, SportGameState state, String teamId, String label) {
    return Semantics(
      label: 'Record point for ${teamId == 'home' ? 'home team' : 'away team'}',
      button: true,
      child: FilledButton.tonal(
        onPressed: () => _recordPoint(context, ref, state, teamId),
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
        child: Text(label),
      ),
    );
  }

  Future<void> _recordPoint(
    BuildContext context,
    WidgetRef ref,
    SportGameState state,
    String teamId,
  ) async {
    final notifier = ref.read(volleyballGameNotifierProvider(sessionId).notifier);
    await notifier.dispatch(VolleyballPointWon(teamId: teamId));
    final roster = SportModuleUtils.teamFor(state, teamId).roster;
    if (!context.mounted) return;
    if (state.trackingMode == TrackingMode.inDepth && roster != null && roster.isNotEmpty) {
      final playerId = await showPlayerSelectionDialog(
        context,
        title: 'Who scored the point?',
        players: roster,
      );
      if (playerId != null) {
        await notifier.dispatch(
          VolleyballPlayerStatRecorded(playerId: playerId, teamId: teamId, statKey: 'points'),
        );
      }
    }
  }
}
