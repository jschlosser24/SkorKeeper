import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../shared/player_selection_dialog.dart';
import '../../shared/sport_module_utils.dart';
import '../../shared/sport_notes_sheet.dart';
import '../application/tennis_game_notifier.dart';

class TennisGameScreen extends ConsumerWidget {
  const TennisGameScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(tennisGameNotifierProvider(sessionId));
    return gameAsync.when(
      data: (state) => Scaffold(
        appBar: AppBar(
          title: const Text('Tennis'),
          actions: [
            IconButton(
              onPressed: () async {
                final notes = await showSportNotesSheet(
                  context,
                  initialValue: state.notes,
                );
                if (notes != null) {
                  await ref
                      .read(tennisGameNotifierProvider(sessionId).notifier)
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
                    Text(
                      'Game score: ${SportModuleUtils.asInt(state.sportSpecific['homeGamesThisSet'])} - ${SportModuleUtils.asInt(state.sportSpecific['awayGamesThisSet'])}',
                    ),
                    Text(
                      '${state.homeTeam.name}: ${_pointLabel(state, 'home')}  •  ${state.awayTeam.name}: ${_pointLabel(state, 'away')}',
                    ),
                    if (state.gamePhase == GamePhase.tiebreakActive)
                      const Text('Tiebreak Active'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    label: 'Record point for home team',
                    button: true,
                    child: FilledButton.tonal(
                      onPressed: () => _recordPoint(context, ref, state, 'home'),
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                      child: Text(state.homeTeam.name),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    label: 'Record point for away team',
                    button: true,
                    child: FilledButton.tonal(
                      onPressed: () => _recordPoint(context, ref, state, 'away'),
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                      child: Text(state.awayTeam.name),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (state.gamePhase != GamePhase.completed)
              FilledButton.tonal(
                onPressed: () => ref
                    .read(tennisGameNotifierProvider(sessionId).notifier)
                    .dispatch(const SportGameEnded()),
                child: const Text('End Match'),
              ),
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
    final winner = homeSets > awaySets
        ? state.homeTeam.name
        : awaySets > homeSets
            ? state.awayTeam.name
            : 'Tie';
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
            const SizedBox(height: 4),
            Center(child: Text('Winner: $winner', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
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
                      const Padding(padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8), child: Text('Games', style: TextStyle(fontWeight: FontWeight.bold))),
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
                DataColumn(label: Text('Points Won')),
              ],
              rows: [
                for (final player in team.roster!)
                  DataRow(
                    cells: [
                      DataCell(Text(player.number == null ? player.name : '#${player.number} ${player.name}')),
                      DataCell(Text('${SportModuleUtils.asInt(player.stats['pointsWon'])}')),
                    ],
                  ),
              ],
            ),
          ],
      ],
    );
  }

  Future<void> _recordPoint(
    BuildContext context,
    WidgetRef ref,
    SportGameState state,
    String teamId,
  ) async {
    final notifier = ref.read(tennisGameNotifierProvider(sessionId).notifier);
    await notifier.dispatch(TennisPointWon(teamId: teamId));
    final roster = SportModuleUtils.teamFor(state, teamId).roster;
    if (!context.mounted) return;
    if (state.trackingMode == TrackingMode.inDepth && roster != null && roster.isNotEmpty) {
      final playerId = await showPlayerSelectionDialog(
        context,
        title: 'Who won the point?',
        players: roster,
      );
      if (playerId != null) {
        await notifier.dispatch(
          TennisPlayerShotRecorded(playerId: playerId, teamId: teamId, shotType: 'pointsWon'),
        );
      }
    }
  }

  String _pointLabel(SportGameState state, String teamId) {
    final points = SportModuleUtils.asInt(
      state.sportSpecific[teamId == 'home' ? 'homePoints' : 'awayPoints'],
    );
    final other = SportModuleUtils.asInt(
      state.sportSpecific[teamId == 'home' ? 'awayPoints' : 'homePoints'],
    );
    if ((state.sportSpecific['isTiebreak'] as bool? ?? false)) {
      return '${SportModuleUtils.asInt(state.sportSpecific[teamId == 'home' ? 'homeTiebreakPoints' : 'awayTiebreakPoints'])}';
    }
    if (points >= 3 && other >= 3) {
      if (points == other) {
        return 'Deuce';
      }
      return points > other ? 'Ad' : '40';
    }
    const labels = ['0', '15', '30', '40'];
    return labels[points.clamp(0, 3)];
  }
}
