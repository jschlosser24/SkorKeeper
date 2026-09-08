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
import '../application/football_game_notifier.dart';

class FootballGameScreen extends ConsumerStatefulWidget {
  const FootballGameScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  ConsumerState<FootballGameScreen> createState() => _FootballGameScreenState();
}

class _FootballGameScreenState extends ConsumerState<FootballGameScreen> {
  int _shownBreakQuarter = 0;
  final _yardsGainedController = TextEditingController();

  @override
  void dispose() {
    _yardsGainedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameAsync = ref.watch(footballGameNotifierProvider(widget.sessionId));
    return gameAsync.when(
      data: (state) {
        _showQuarterBreakIfNeeded(state);
        final down = SportModuleUtils.asInt(state.sportSpecific['currentDown']);
        final yardsToGo = SportModuleUtils.asInt(
          state.sportSpecific['yardsToGo'],
        );
        return Scaffold(
          appBar: AppBar(
            title: const Text('Football'),
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
                          SportModuleUtils.asInt(
                            state.sportSpecific['remainingSeconds'],
                          ),
                        ),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        'Quarter ${SportModuleUtils.asInt(state.sportSpecific['currentPeriod'])}',
                      ),
                      const SizedBox(height: 8),
                      Text('${SportModuleUtils.ordinal(down)} & $yardsToGo'),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _score(state.awayTeam),
                          _score(state.homeTeam),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (state.gamePhase != GamePhase.completed) ...[
                const SizedBox(height: 12),
                _scoringRow(state, state.homeTeam.name, 'home'),
                const SizedBox(height: 12),
                _scoringRow(state, state.awayTeam.name, 'away'),
                const SizedBox(height: 12),
                _downControls(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => _dispatch(
                          state.timerRunning
                              ? const SportTimerPaused()
                              : const SportTimerStarted(),
                        ),
                        child: Text(
                          state.timerRunning ? 'Pause Timer' : 'Start Timer',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () =>
                            _dispatch(const FootballQuarterAdvanced()),
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
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text(error.toString()))),
    );
  }

  Widget _score(SportTeam team) {
    return Column(
      children: [
        Text(team.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('${team.score}', style: const TextStyle(fontSize: 32)),
      ],
    );
  }

  Widget _scoringRow(SportGameState state, String label, String teamId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _scoreButton(state, teamId, 'touchdown', 'TD'),
            _scoreButton(state, teamId, 'extra_point', 'XP'),
            _scoreButton(state, teamId, 'two_point_conv', '2PT'),
            _scoreButton(state, teamId, 'field_goal', 'FG'),
            _scoreButton(state, teamId, 'safety', 'Safety'),
          ],
        ),
      ],
    );
  }

  Widget _scoreButton(SportGameState state, String teamId, String scoreType, String label) {
    return Semantics(
      label:
          'Record $label for ${teamId == 'home' ? 'home team' : 'away team'}',
      button: true,
      child: FilledButton.tonal(
        onPressed: () => _recordScore(state, teamId, scoreType),
        style: FilledButton.styleFrom(minimumSize: const Size(72, 48)),
        child: Text(label),
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
        FootballPlayerScored(playerId: playerId, teamId: teamId, scoreType: scoreType),
      );
      return;
    }
    await _dispatch(FootballTeamScored(teamId: teamId, scoreType: scoreType));
  }

  Widget _downControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Down Controls',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _yardsGainedController,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Yards Gained',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.tonal(
                  onPressed: _recordPlay,
                  child: const Text('Record Play'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () => _dispatch(const FootballDownSet(down: 1)),
                  child: const Text('1st'),
                ),
                FilledButton.tonal(
                  onPressed: () => _dispatch(const FootballDownSet(down: 2)),
                  child: const Text('2nd'),
                ),
                FilledButton.tonal(
                  onPressed: () => _dispatch(const FootballDownSet(down: 3)),
                  child: const Text('3rd'),
                ),
                FilledButton.tonal(
                  onPressed: () => _dispatch(const FootballDownSet(down: 4)),
                  child: const Text('4th'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(SportGameState state) {
    final homeScores = SportModuleUtils.intList(
      state.homeTeam.stats['quarterScores'],
    );
    final awayScores = SportModuleUtils.intList(
      state.awayTeam.stats['quarterScores'],
    );
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
                DataColumn(label: Text('Q1')),
                DataColumn(label: Text('Q2')),
                DataColumn(label: Text('Q3')),
                DataColumn(label: Text('Q4')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(state.homeTeam.name)),
                    for (var i = 0; i < 4; i++)
                      DataCell(
                        Text(i < homeScores.length ? '${homeScores[i]}' : '0'),
                      ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(state.awayTeam.name)),
                    for (var i = 0; i < 4; i++)
                      DataCell(
                        Text(i < awayScores.length ? '${awayScores[i]}' : '0'),
                      ),
                  ],
                ),
              ],
            ),
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

  void _showQuarterBreakIfNeeded(SportGameState state) {
    final currentQuarter = SportModuleUtils.asInt(
      state.sportSpecific['currentPeriod'],
    );
    if (state.gamePhase != GamePhase.periodBreak ||
        _shownBreakQuarter == currentQuarter) {
      return;
    }
    _shownBreakQuarter = currentQuarter;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      showSportPeriodEndDialog(
        context,
        title: 'Quarter break',
        message: 'Ready to start Quarter $currentQuarter?',
        actionLabel: 'Start Next Quarter',
        onAction: () => _dispatch(const SportTimerStarted()),
      );
    });
  }

  Future<void> _dispatch(ScoreAction action) {
    return ref
        .read(footballGameNotifierProvider(widget.sessionId).notifier)
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
      remainingSeconds: SportModuleUtils.asInt(
        state.sportSpecific['remainingSeconds'],
      ),
    );
    if (result == null || !mounted) {
      return;
    }
    final notifier = ref.read(
      footballGameNotifierProvider(widget.sessionId).notifier,
    );
    await notifier.editScore(result.homeScore, result.awayScore);
    if (result.period != null) {
      await notifier.editPeriod(result.period!);
    }
    if (result.remainingSeconds != null) {
      await notifier.editClock(result.remainingSeconds!);
    }
  }

  Future<void> _recordPlay() async {
    final yardsGained = int.tryParse(_yardsGainedController.text.trim()) ?? 0;
    _yardsGainedController.clear();
    FocusScope.of(context).unfocus();
    await _dispatch(FootballDownAdvanced(yardsGained: yardsGained));
  }
}
