import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../shared/player_selection_dialog.dart';
import '../../shared/sport_module_utils.dart';
import '../../shared/sport_notes_sheet.dart';
import '../application/baseball_game_notifier.dart';
import '../domain/baseball_state.dart';

class BaseballGameScreen extends ConsumerStatefulWidget {
  const BaseballGameScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  ConsumerState<BaseballGameScreen> createState() => _BaseballGameScreenState();
}

class _BaseballGameScreenState extends ConsumerState<BaseballGameScreen> {
  @override
  Widget build(BuildContext context) {
    final gameAsync = ref.watch(baseballGameNotifierProvider(widget.sessionId));
    return gameAsync.when(
      data: (state) => Scaffold(
        appBar: AppBar(
          title: const Text('Baseball'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back to Home',
            onPressed: () => context.go('/home'),
          ),
          actions: [
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
                      '${_halfLabel(state)} of ${SportModuleUtils.ordinal(_inning(state))}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.circle,
                            size: 14,
                            color: index < _outs(state)
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _scoreboard(state),
                    const SizedBox(height: 12),
                    _liveLineScore(state),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (state.gamePhase.isPlayable) _atBatCard(context, state),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => _dispatch(const SportGameEnded()),
              child: const Text('End Game'),
            ),
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

  // ─── At-bat / scorebook entry ────────────────────────────────────────────

  Widget _atBatCard(BuildContext context, SportGameState state) {
    final half = _half(state);
    final battingTeamId = BaseballStateHelper.battingTeamId(half);
    final battingTeam = SportModuleUtils.teamFor(state, battingTeamId);
    final batter = _currentBatter(state, battingTeamId);
    final batterIndex = _batterIndex(state, battingTeamId);
    final balls = SportModuleUtils.asInt(state.sportSpecific['balls']);
    final strikes = SportModuleUtils.asInt(state.sportSpecific['strikes']);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('At Bat: ${battingTeam.name}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              batter != null
                  ? 'Batting: ${batter.name}${batter.number != null ? ' (#${batter.number})' : ''}'
                  : 'Batting: Batter ${batterIndex + 1}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if ((battingTeam.roster ?? const []).isNotEmpty) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _showBattingOrder(context, state, battingTeamId),
                  icon: const Icon(Icons.reorder),
                  label: const Text('Batting Order'),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text('Count: $balls-$strikes (Balls-Strikes)'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _recordPitch(state, 'ball'),
                    child: const Text('Ball'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _recordPitch(state, 'strike'),
                    child: const Text('Strike'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _paButton(context, state, 'Single', 'single'),
                _paButton(context, state, 'Double', 'double'),
                _paButton(context, state, 'Triple', 'triple'),
                _paButton(context, state, 'Home Run', 'home_run'),
                _paButton(context, state, 'Walk', 'walk'),
                _paButton(context, state, 'Strikeout', 'strikeout'),
                _paButton(context, state, 'Out', 'out'),
                _errorButton(context, state),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paButton(BuildContext context, SportGameState state, String label, String result) {
    return Semantics(
      label: 'Record $label',
      button: true,
      child: FilledButton.tonal(
        onPressed: () => _recordPlateAppearance(context, state, result),
        child: Text(label),
      ),
    );
  }

  Widget _errorButton(BuildContext context, SportGameState state) {
    return Semantics(
      label: 'Record fielding error',
      button: true,
      child: FilledButton.tonal(
        onPressed: () => _recordError(context, state),
        child: const Text('Error'),
      ),
    );
  }

  Future<void> _recordPitch(SportGameState state, String pitchType) {
    final teamId = BaseballStateHelper.battingTeamId(_half(state));
    return _dispatch(BaseballPitchRecorded(teamId: teamId, pitchType: pitchType));
  }

  Future<void> _recordPlateAppearance(
    BuildContext context,
    SportGameState state,
    String result,
  ) async {
    final teamId = BaseballStateHelper.battingTeamId(_half(state));
    final batter = _currentBatter(state, teamId);
    var rbi = 0;
    if (result != 'strikeout') {
      final selected = await _showRbiDialog(context, suggested: result == 'home_run' ? 1 : 0);
      if (selected == null) {
        return;
      }
      rbi = selected;
    }
    if (!context.mounted) {
      return;
    }
    await _dispatch(
      BaseballPlateAppearanceRecorded(
        teamId: teamId,
        result: result,
        rbi: rbi,
        playerId: batter?.id,
      ),
    );
  }

  Future<int?> _showRbiDialog(BuildContext context, {int suggested = 0}) {
    var value = suggested;
    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
            title: const Text('Runs scored on this play?'),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: value > 0 ? () => setDialogState(() => value--) : null,
                ),
                Text('$value', style: const TextStyle(fontSize: 24)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: value < 4 ? () => setDialogState(() => value++) : null,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(value),
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _recordError(BuildContext context, SportGameState state) async {
    final fieldingTeamId = BaseballStateHelper.fieldingTeamId(_half(state));
    final teamId = await _pickTeam(context, state, fieldingTeamId: fieldingTeamId);
    if (!context.mounted || teamId == null) {
      return;
    }
    final roster = SportModuleUtils.teamFor(state, teamId).roster ?? const [];
    String? playerId;
    if (roster.isNotEmpty) {
      playerId = await showPlayerSelectionDialog(
        context,
        title: 'Player charged with error (optional)',
        players: roster,
      );
    }
    if (!context.mounted) {
      return;
    }
    await _dispatch(BaseballErrorRecorded(teamId: teamId, playerId: playerId));
  }

  // ─── Batting order ───────────────────────────────────────────────────────

  Future<void> _showBattingOrder(
    BuildContext context,
    SportGameState state,
    String teamId,
  ) async {
    final roster = SportModuleUtils.teamFor(state, teamId).roster ?? const [];
    if (roster.isEmpty) {
      return;
    }
    final currentIndex = _batterIndex(state, teamId) % roster.length;
    final selectedIndex = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            const ListTile(title: Text('Select batter')),
            for (var i = 0; i < roster.length; i++)
              ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(roster[i].name),
                subtitle: roster[i].number != null ? Text('#${roster[i].number}') : null,
                trailing: i == currentIndex ? const Icon(Icons.check) : null,
                selected: i == currentIndex,
                onTap: () => Navigator.of(context).pop(i),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted || selectedIndex == null || selectedIndex == currentIndex) {
      return;
    }
    await _dispatch(BaseballBatterSet(teamId: teamId, batterIndex: selectedIndex));
  }

  Future<String?> _pickTeam(
    BuildContext context,
    SportGameState state, {
    required String fieldingTeamId,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            const ListTile(title: Text('Charge error to which team?')),
            ListTile(
              title: Text(state.homeTeam.name),
              subtitle: fieldingTeamId == 'home' ? const Text('Currently fielding') : null,
              onTap: () => Navigator.of(context).pop('home'),
            ),
            ListTile(
              title: Text(state.awayTeam.name),
              subtitle: fieldingTeamId == 'away' ? const Text('Currently fielding') : null,
              onTap: () => Navigator.of(context).pop('away'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Scoreboard / line score ─────────────────────────────────────────────

  Widget _scoreboard(SportGameState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _teamScore(state.awayTeam),
        _teamScore(state.homeTeam),
      ],
    );
  }

  Widget _teamScore(SportTeam team) {
    return Column(
      children: [
        Text(team.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('${team.score}', style: const TextStyle(fontSize: 28)),
      ],
    );
  }

  Widget _liveLineScore(SportGameState state) {
    final awayScores = SportModuleUtils.intList(state.awayTeam.stats['inningScores']);
    final homeScores = SportModuleUtils.intList(state.homeTeam.stats['inningScores']);
    final columns = [_inning(state), awayScores.length, homeScores.length, 1]
        .reduce((a, b) => a > b ? a : b);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        headingRowHeight: 32,
        dataRowMinHeight: 32,
        dataRowMaxHeight: 32,
        columns: [
          const DataColumn(label: Text('Team')),
          for (var i = 1; i <= columns; i++) DataColumn(label: Text('$i')),
          const DataColumn(label: Text('R')),
          const DataColumn(label: Text('H')),
          const DataColumn(label: Text('E')),
        ],
        rows: [
          _lineRow(state.awayTeam, awayScores, columns),
          _lineRow(state.homeTeam, homeScores, columns),
        ],
      ),
    );
  }

  DataRow _lineRow(SportTeam team, List<int> scores, int columns) {
    return DataRow(
      cells: [
        DataCell(Text(team.name)),
        for (var i = 0; i < columns; i++)
          DataCell(Text(i < scores.length ? '${scores[i]}' : '0')),
        DataCell(Text('${team.score}', style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text('${SportModuleUtils.asInt(team.stats['hits'])}')),
        DataCell(Text('${SportModuleUtils.asInt(team.stats['errors'])}')),
      ],
    );
  }

  // ─── Game summary ────────────────────────────────────────────────────────

  Widget _summary(BuildContext context, SportGameState state) {
    final awayScores = SportModuleUtils.intList(state.awayTeam.stats['inningScores']);
    final homeScores = SportModuleUtils.intList(state.homeTeam.stats['inningScores']);
    final awayHits = SportModuleUtils.intList(state.awayTeam.stats['inningHits']);
    final homeHits = SportModuleUtils.intList(state.homeTeam.stats['inningHits']);
    final awayErrors = SportModuleUtils.intList(state.awayTeam.stats['inningErrors']);
    final homeErrors = SportModuleUtils.intList(state.homeTeam.stats['inningErrors']);
    final columns = [
      awayScores.length,
      homeScores.length,
      awayHits.length,
      homeHits.length,
      awayErrors.length,
      homeErrors.length,
      1,
    ].reduce((a, b) => a > b ? a : b);
    final homePitching = _pitchingStats(state, 'home');
    final awayPitching = _pitchingStats(state, 'away');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Game Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Line Score', style: Theme.of(context).textTheme.titleMedium),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('Team')),
                  for (var inning = 1; inning <= columns; inning++)
                    DataColumn(label: Text('$inning')),
                  const DataColumn(label: Text('R')),
                  const DataColumn(label: Text('H')),
                  const DataColumn(label: Text('E')),
                ],
                rows: [
                  _summaryRow(state.awayTeam, awayScores, columns),
                  _summaryRow(state.homeTeam, homeScores, columns),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Inning-by-Inning Detail', style: Theme.of(context).textTheme.titleMedium),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('Inning')),
                  for (var inning = 1; inning <= columns; inning++)
                    DataColumn(label: Text('$inning')),
                ],
                rows: [
                  _detailRow('${state.awayTeam.name} R', awayScores, columns),
                  _detailRow('${state.awayTeam.name} H', awayHits, columns),
                  _detailRow('${state.awayTeam.name} E', awayErrors, columns),
                  _detailRow('${state.homeTeam.name} R', homeScores, columns),
                  _detailRow('${state.homeTeam.name} H', homeHits, columns),
                  _detailRow('${state.homeTeam.name} E', homeErrors, columns),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Final: ${state.awayTeam.name} ${state.awayTeam.score} - '
              '${state.homeTeam.score} ${state.homeTeam.name}',
            ),
            const SizedBox(height: 16),
            _playerStatsTable(context, state.homeTeam),
            const SizedBox(height: 12),
            _playerStatsTable(context, state.awayTeam),
            const SizedBox(height: 16),
            Text('Pitching Summary', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '${state.homeTeam.name}: IP ${homePitching['inningsPitched']} · '
              'R ${homePitching['runsAllowed']} · H ${homePitching['hitsAllowed']} · '
              'BB ${homePitching['walksAllowed']} · K ${homePitching['strikeouts']} · '
              'ERA ${(homePitching['era'] as double).toStringAsFixed(2)}',
            ),
            Text(
              '${state.awayTeam.name}: IP ${awayPitching['inningsPitched']} · '
              'R ${awayPitching['runsAllowed']} · H ${awayPitching['hitsAllowed']} · '
              'BB ${awayPitching['walksAllowed']} · K ${awayPitching['strikeouts']} · '
              'ERA ${(awayPitching['era'] as double).toStringAsFixed(2)}',
            ),
          ],
        ),
      ),
    );
  }

  DataRow _summaryRow(SportTeam team, List<int> scores, int columns) {
    return DataRow(
      cells: [
        DataCell(Text(team.name)),
        for (var inning = 0; inning < columns; inning++)
          DataCell(Text(inning < scores.length ? '${scores[inning]}' : '0')),
        DataCell(Text('${team.score}')),
        DataCell(Text('${SportModuleUtils.asInt(team.stats['hits'])}')),
        DataCell(Text('${SportModuleUtils.asInt(team.stats['errors'])}')),
      ],
    );
  }

  DataRow _detailRow(String label, List<int> values, int columns) {
    return DataRow(
      cells: [
        DataCell(Text(label)),
        for (var inning = 0; inning < columns; inning++)
          DataCell(Text(inning < values.length ? '${values[inning]}' : '0')),
      ],
    );
  }

  Widget _playerStatsTable(BuildContext context, SportTeam team) {
    final roster = team.roster;
    if (roster == null || roster.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${team.name} Batting', style: Theme.of(context).textTheme.titleMedium),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Player')),
              DataColumn(label: Text('PA')),
              DataColumn(label: Text('H')),
              DataColumn(label: Text('HR')),
              DataColumn(label: Text('RBI')),
              DataColumn(label: Text('BB')),
              DataColumn(label: Text('K')),
            ],
            rows: [
              for (final player in roster)
                DataRow(
                  cells: [
                    DataCell(Text(player.name)),
                    DataCell(Text('${SportModuleUtils.asInt(player.stats['pa'])}')),
                    DataCell(Text('${SportModuleUtils.asInt(player.stats['h'])}')),
                    DataCell(Text('${SportModuleUtils.asInt(player.stats['hr'])}')),
                    DataCell(Text('${SportModuleUtils.asInt(player.stats['rbi'])}')),
                    DataCell(Text('${SportModuleUtils.asInt(player.stats['bb'])}')),
                    DataCell(Text('${SportModuleUtils.asInt(player.stats['k'])}')),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Derives a "pitching-ish" line for [fieldingTeamId] from the opposing
  /// team's batting stats and event log (no separate pitching stats are
  /// tracked, so this is the best approximation available from current data).
  Map<String, dynamic> _pitchingStats(SportGameState state, String fieldingTeamId) {
    final battingTeamId = fieldingTeamId == 'home' ? 'away' : 'home';
    final battingTeam = SportModuleUtils.teamFor(state, battingTeamId);
    final outsRecorded = state.events
        .where((event) =>
            event.teamId == battingTeamId &&
            (event.eventType == 'out' || event.eventType == 'strikeout'))
        .length;
    final wholeInnings = outsRecorded ~/ 3;
    final remainderOuts = outsRecorded % 3;
    final inningsPitchedValue = wholeInnings + remainderOuts / 3.0;
    final runsAllowed = battingTeam.score;
    final era = inningsPitchedValue <= 0 ? 0.0 : runsAllowed / inningsPitchedValue * 9;
    return {
      'inningsPitched': '$wholeInnings.$remainderOuts',
      'runsAllowed': runsAllowed,
      'hitsAllowed': SportModuleUtils.asInt(battingTeam.stats['hits']),
      'walksAllowed': SportModuleUtils.asInt(battingTeam.stats['walks']),
      'strikeouts': SportModuleUtils.asInt(battingTeam.stats['strikeouts']),
      'era': era,
    };
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  int _inning(SportGameState state) => SportModuleUtils.asInt(state.sportSpecific['currentInning']);
  int _outs(SportGameState state) => SportModuleUtils.asInt(state.sportSpecific['outs']);
  String _half(SportGameState state) =>
      SportModuleUtils.asString(state.sportSpecific['currentHalf'], fallback: 'top');
  String _halfLabel(SportGameState state) => _half(state) == 'bottom' ? 'Bottom' : 'Top';

  int _batterIndex(SportGameState state, String teamId) {
    final key = teamId == 'home' ? 'homeBatterIndex' : 'awayBatterIndex';
    return SportModuleUtils.asInt(state.sportSpecific[key]);
  }

  SportPlayer? _currentBatter(SportGameState state, String teamId) {
    final roster = SportModuleUtils.teamFor(state, teamId).roster;
    if (roster == null || roster.isEmpty) {
      return null;
    }
    final index = _batterIndex(state, teamId) % roster.length;
    return roster[index];
  }

  Future<void> _dispatch(ScoreAction action) {
    return ref.read(baseballGameNotifierProvider(widget.sessionId).notifier).dispatch(action);
  }

  Future<void> _editNotes(SportGameState state) async {
    final notes = await showSportNotesSheet(context, initialValue: state.notes);
    if (notes != null) {
      await _dispatch(SportNoteUpdated(content: notes));
    }
  }
}
