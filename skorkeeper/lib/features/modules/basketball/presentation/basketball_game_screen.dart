import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../shared/player_selection_dialog.dart';
import '../../shared/sport_module_utils.dart';
import '../../shared/sport_notes_sheet.dart';
import '../../shared/sport_period_break_dialog.dart';
import '../../shared/sport_score_edit_dialog.dart';
import '../application/basketball_game_notifier.dart';

class BasketballGameScreen extends ConsumerStatefulWidget {
  const BasketballGameScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  ConsumerState<BasketballGameScreen> createState() => _BasketballGameScreenState();
}

class _BasketballGameScreenState extends ConsumerState<BasketballGameScreen> {
  int _shownBreakPeriod = 0;

  @override
  Widget build(BuildContext context) {
    final gameAsync = ref.watch(basketballGameNotifierProvider(widget.sessionId));
    return gameAsync.when(
      data: (state) {
        _showQuarterBreakIfNeeded(state);
        final possessionTeamId = SportModuleUtils.asString(
          state.sportSpecific['possessionTeamId'],
          fallback: 'home',
        );
        return Scaffold(
          appBar: AppBar(
            title: const Text('Basketball'),
            actions: [
              IconButton(
                onPressed: () => _editScore(state),
                icon: const Icon(Icons.edit),
                tooltip: 'Edit score / clock',
              ),
              IconButton(
                onPressed: () => _editNotes(state),
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
                      Text(
                        'Quarter ${SportModuleUtils.asInt(state.sportSpecific['currentPeriod'])}',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _teamScore(state.awayTeam),
                          _teamScore(state.homeTeam),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (state.gamePhase != GamePhase.completed) ...[
                const SizedBox(height: 12),
                _scoreButtons(state, state.homeTeam, 'home'),
                const SizedBox(height: 12),
                _scoreButtons(state, state.awayTeam, 'away'),
                const SizedBox(height: 16),
                _possessionAndTimeouts(state, possessionTeamId),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => _dispatch(
                          state.timerRunning
                              ? const SportTimerPaused()
                              : const SportTimerStarted(),
                        ),
                        child: Text(state.timerRunning ? 'Pause' : 'Resume'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => _dispatch(const BasketballQuarterAdvanced()),
                        child: const Text('End Quarter'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () => _dispatch(const SportGameEnded()),
                  child: const Text('End Game'),
                ),
              ],
              if (state.gamePhase == GamePhase.completed) ...[
                const SizedBox(height: 16),
                _summary(state),
              ],
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text(error.toString()))),
    );
  }

  Widget _teamScore(SportTeam team) {
    return Column(
      children: [
        Text(team.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('${team.score}', style: const TextStyle(fontSize: 36)),
      ],
    );
  }

  Widget _scoreButtons(SportGameState state, SportTeam team, String teamId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(team.name, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _scoreButton(state, teamId, '2pt', '2-Pointer')),
            const SizedBox(width: 8),
            Expanded(child: _scoreButton(state, teamId, '3pt', '3-Pointer')),
            const SizedBox(width: 8),
            Expanded(child: _scoreButton(state, teamId, 'ft', 'Free Throw')),
          ],
        ),
      ],
    );
  }

  Widget _scoreButton(SportGameState state, String teamId, String scoreType, String label) {
    return Semantics(
      label: 'Record $label for ${teamId == 'home' ? 'home team' : 'away team'}',
      button: true,
      child: FilledButton.tonal(
        onPressed: () => _recordScore(state, teamId, scoreType),
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }

  Future<void> _recordScore(SportGameState state, String teamId, String scoreType) async {
    final roster = SportModuleUtils.teamFor(state, teamId).roster;
    if (state.trackingMode == TrackingMode.inDepth && roster != null && roster.isNotEmpty) {
      final playerId = await showPlayerSelectionDialog(
        context,
        title: 'Who scored?',
        players: roster,
      );
      if (playerId == null) {
        return;
      }
      await _dispatch(
        BasketballPlayerScored(playerId: playerId, teamId: teamId, scoreType: scoreType),
      );
      return;
    }
    await _dispatch(BasketballTeamScored(teamId: teamId, scoreType: scoreType));
  }

  Future<void> _recordFoul(SportGameState state, String teamId) async {
    await _dispatch(BasketballTeamFoulRecorded(teamId: teamId));
    final roster = SportModuleUtils.teamFor(state, teamId).roster;
    if (!mounted) return;
    if (state.trackingMode == TrackingMode.inDepth && roster != null && roster.isNotEmpty) {
      final playerId = await showPlayerSelectionDialog(
        context,
        title: 'Who committed the foul?',
        players: roster,
      );
      if (playerId != null) {
        await _dispatch(
          BasketballPlayerStatRecorded(playerId: playerId, teamId: teamId, statKey: 'fouls'),
        );
      }
    }
  }

  Widget _possessionAndTimeouts(SportGameState state, String possessionTeamId) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Possession', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _dispatch(const BasketballPossessionChanged(teamId: 'home')),
                    child: Text(
                      possessionTeamId == 'home'
                          ? '● ${state.homeTeam.name}'
                          : state.homeTeam.name,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _dispatch(const BasketballPossessionChanged(teamId: 'away')),
                    child: Text(
                      possessionTeamId == 'away'
                          ? '● ${state.awayTeam.name}'
                          : state.awayTeam.name,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _recordFoul(state, 'home'),
                    child: Text('${state.homeTeam.name} Foul (${SportModuleUtils.asInt(state.homeTeam.stats['fouls'])})'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _recordFoul(state, 'away'),
                    child: Text('${state.awayTeam.name} Foul (${SportModuleUtils.asInt(state.awayTeam.stats['fouls'])})'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: SportModuleUtils.asInt(state.homeTeam.stats['timeoutsRemaining']) > 0
                        ? () => _dispatch(const BasketballTimeoutUsed(teamId: 'home'))
                        : null,
                    child: Text('Timeout (${SportModuleUtils.asInt(state.homeTeam.stats['timeoutsRemaining'])})'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: SportModuleUtils.asInt(state.awayTeam.stats['timeoutsRemaining']) > 0
                        ? () => _dispatch(const BasketballTimeoutUsed(teamId: 'away'))
                        : null,
                    child: Text('Timeout (${SportModuleUtils.asInt(state.awayTeam.stats['timeoutsRemaining'])})'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(SportGameState state) {
    final homeStats = state.homeTeam.stats;
    final awayStats = state.awayTeam.stats;
    final winner = state.homeTeam.score == state.awayTeam.score
        ? 'Tie'
        : (state.homeTeam.score > state.awayTeam.score
            ? state.homeTeam.name
            : state.awayTeam.name);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Final Summary', style: Theme.of(context).textTheme.titleLarge),
            Text('Winner: $winner'),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('Stat')),
                  DataColumn(label: Text(state.homeTeam.name)),
                  DataColumn(label: Text(state.awayTeam.name)),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('FG')),
                    DataCell(Text(_attemptLine(homeStats, 'fieldGoalsMade', 'fieldGoalsAttempted'))),
                    DataCell(Text(_attemptLine(awayStats, 'fieldGoalsMade', 'fieldGoalsAttempted'))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('3PT')),
                    DataCell(Text(_attemptLine(homeStats, 'threesMade', 'threesAttempted'))),
                    DataCell(Text(_attemptLine(awayStats, 'threesMade', 'threesAttempted'))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('FT')),
                    DataCell(Text(_attemptLine(homeStats, 'ftMade', 'ftAttempted'))),
                    DataCell(Text(_attemptLine(awayStats, 'ftMade', 'ftAttempted'))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Fouls')),
                    DataCell(Text('${SportModuleUtils.asInt(homeStats['fouls'])}')),
                    DataCell(Text('${SportModuleUtils.asInt(awayStats['fouls'])}')),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _quarterBreakdown(state),
            if ((state.homeTeam.roster?.isNotEmpty ?? false) ||
                (state.awayTeam.roster?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 12),
              _playerStats(state),
            ],
          ],
        ),
      ),
    );
  }

  Widget _playerStats(SportGameState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Player Stats', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        for (final team in [state.homeTeam, state.awayTeam])
          if (team.roster != null && team.roster!.isNotEmpty) ...[
            Text(team.name, style: Theme.of(context).textTheme.titleSmall),
            DataTable(
              columns: const [
                DataColumn(label: Text('Player')),
                DataColumn(label: Text('Pts')),
                DataColumn(label: Text('Fouls')),
              ],
              rows: [
                for (final player in team.roster!)
                  DataRow(
                    cells: [
                      DataCell(Text(player.number == null ? player.name : '#${player.number} ${player.name}')),
                      DataCell(Text('${SportModuleUtils.asInt(player.stats['points'])}')),
                      DataCell(Text('${SportModuleUtils.asInt(player.stats['fouls'])}')),
                    ],
                  ),
              ],
            ),
          ],
      ],
    );
  }

  Widget _quarterBreakdown(SportGameState state) {
    final homeScores = SportModuleUtils.intList(state.homeTeam.stats['quarterScores']);
    final awayScores = SportModuleUtils.intList(state.awayTeam.stats['quarterScores']);
    final count = [
      homeScores.length,
      awayScores.length,
      SportModuleUtils.asInt(state.sportSpecific['periodCount']),
    ].reduce((a, b) => a > b ? a : b);
    return DataTable(
      columns: [
        const DataColumn(label: Text('Team')),
        for (var i = 1; i <= count; i++) DataColumn(label: Text('Q$i')),
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Text(state.homeTeam.name)),
            for (var i = 0; i < count; i++)
              DataCell(Text(i < homeScores.length ? '${homeScores[i]}' : '0')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(state.awayTeam.name)),
            for (var i = 0; i < count; i++)
              DataCell(Text(i < awayScores.length ? '${awayScores[i]}' : '0')),
          ],
        ),
      ],
    );
  }

  String _attemptLine(Map<String, dynamic> stats, String madeKey, String attemptKey) {
    final made = SportModuleUtils.asInt(stats[madeKey]);
    final attempts = SportModuleUtils.asInt(stats[attemptKey]);
    final percentage = attempts == 0 ? 0.0 : made / attempts * 100;
    return '$made/$attempts (${percentage.toStringAsFixed(1)}%)';
  }

  void _showQuarterBreakIfNeeded(SportGameState state) {
    final currentPeriod = SportModuleUtils.asInt(state.sportSpecific['currentPeriod']);
    if (state.gamePhase != GamePhase.periodBreak || _shownBreakPeriod == currentPeriod) {
      return;
    }
    _shownBreakPeriod = currentPeriod;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      showSportPeriodEndDialog(
        context,
        title: 'Quarter break',
        message: 'Ready to start Quarter $currentPeriod?',
        actionLabel: 'Start Next Quarter',
        onAction: () => _dispatch(const SportTimerStarted()),
      );
    });
  }

  Future<void> _dispatch(ScoreAction action) {
    return ref
        .read(basketballGameNotifierProvider(widget.sessionId).notifier)
        .dispatch(action);
  }

  Future<void> _editNotes(SportGameState state) async {
    final notes = await showSportNotesSheet(context, initialValue: state.notes);
    if (notes != null) {
      await _dispatch(SportNoteUpdated(content: notes));
    }
  }

  Future<void> _editScore(SportGameState state) async {
    final result = await SportScoreEditDialog.show(
      context,
      homeName: state.homeTeam.name,
      awayName: state.awayTeam.name,
      homeScore: state.homeTeam.score,
      awayScore: state.awayTeam.score,
      period: SportModuleUtils.asInt(state.sportSpecific['currentPeriod']),
      periodLabel: 'Quarter',
      remainingSeconds: SportModuleUtils.asInt(state.sportSpecific['remainingSeconds']),
    );
    if (result == null || !mounted) {
      return;
    }
    final notifier = ref.read(basketballGameNotifierProvider(widget.sessionId).notifier);
    await notifier.editScore(result.homeScore, result.awayScore);
    if (result.period != null) {
      await notifier.editPeriod(result.period!);
    }
    if (result.remainingSeconds != null) {
      await notifier.editClock(result.remainingSeconds!);
    }
  }
}
