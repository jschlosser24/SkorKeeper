import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../shared/player_selection_dialog.dart';
import '../../shared/sport_module_utils.dart';
import '../../shared/sport_notes_sheet.dart';
import '../application/soccer_game_notifier.dart';

class SoccerGameScreen extends ConsumerStatefulWidget {
  const SoccerGameScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  ConsumerState<SoccerGameScreen> createState() => _SoccerGameScreenState();
}

class _SoccerGameScreenState extends ConsumerState<SoccerGameScreen> {
  bool _shownHalftime = false;

  @override
  Widget build(BuildContext context) {
    final gameAsync = ref.watch(soccerGameNotifierProvider(widget.sessionId));
    return gameAsync.when(
      data: (state) {
        _showHalftimeIfNeeded(state);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Soccer'),
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
                        SportModuleUtils.formatClock(state.elapsedSeconds),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        SportModuleUtils.asInt(state.sportSpecific['currentHalf']) == 2
                            ? '2nd Half'
                            : '1st Half',
                      ),
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
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        label: 'Record goal',
                        button: true,
                        child: FilledButton(
                          onPressed: () => _recordGoal(state),
                          child: const Text('Goal'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => _dispatch(const SoccerHalfAdvanced()),
                        child: const Text('Advance Half'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () => _dispatch(
                    state.timerRunning ? const SportTimerPaused() : const SportTimerStarted(),
                  ),
                  child: Text(state.timerRunning ? 'Pause Timer' : 'Start Timer'),
                ),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () => _dispatch(const SportGameEnded()),
                  child: const Text('End Match'),
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

  Widget _score(SportTeam team) {
    return Column(
      children: [
        Text(team.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('${team.score}', style: const TextStyle(fontSize: 32)),
      ],
    );
  }

  Widget _summary(SportGameState state) {
    final events = state.events.where((event) => event.eventType == 'goal').toList();
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
                Text('${state.homeTeam.score} - ${state.awayTeam.score}', style: Theme.of(context).textTheme.headlineSmall),
                Expanded(child: Text(state.awayTeam.name, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            if (events.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Goal Timeline'),
              for (final event in events)
                ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 8,
                    backgroundColor:
                        event.teamId == 'home' ? Colors.blue : Colors.purple,
                  ),
                  title: Text(_playerName(state, event.teamId, event.playerId) ?? 'Team goal'),
                  subtitle: Text(SportModuleUtils.formatClock(event.gameTimeSeconds)),
                ),
              const SizedBox(height: 8),
              Text('Scorers', style: Theme.of(context).textTheme.titleMedium),
              ..._goalCounts(state).entries.map((entry) => Text('${entry.key}: ${entry.value}')),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, int> _goalCounts(SportGameState state) {
    final counts = <String, int>{};
    for (final event in state.events.where((event) => event.eventType == 'goal')) {
      final name = _playerName(state, event.teamId, event.playerId) ?? 'Team';
      counts[name] = (counts[name] ?? 0) + 1;
    }
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {for (final entry in entries) entry.key: entry.value};
  }

  String? _playerName(SportGameState state, String teamId, String? playerId) {
    if (playerId == null) {
      return null;
    }
    final roster = (teamId == 'home' ? state.homeTeam.roster : state.awayTeam.roster) ?? [];
    for (final player in roster) {
      if (player.id == playerId) {
        return player.name;
      }
    }
    return null;
  }

  void _showHalftimeIfNeeded(SportGameState state) {
    if (state.gamePhase != GamePhase.halftimeBreak || _shownHalftime) {
      return;
    }
    _shownHalftime = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Halftime', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('Ready for the second half?'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _dispatch(const SoccerHalfAdvanced());
                  _dispatch(const SportTimerStarted());
                },
                child: const Text('Start 2nd Half'),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _recordGoal(SportGameState state) async {
    if (state.trackingMode == TrackingMode.inDepth) {
      final teamId = await _selectTeam(state);
      if (!mounted) return;
      if (teamId == null) {
        return;
      }
      final roster = (teamId == 'home' ? state.homeTeam.roster : state.awayTeam.roster) ?? [];
      final scorerId = await showPlayerSelectionDialog(
        context,
        title: 'Select scorer',
        players: roster,
      );
      if (!mounted) return;
      if (scorerId == null) {
        return;
      }
      final assistId = await showPlayerSelectionDialog(
        context,
        title: 'Select assist (optional)',
        players: roster.where((player) => player.id != scorerId).toList(),
      );
      if (!mounted) return;
      await _dispatch(
        SoccerGoalWithAssist(
          teamId: teamId,
          scorerPlayerId: scorerId,
          assistPlayerId: assistId,
        ),
      );
      return;
    }
    final teamId = await _selectTeam(state);
    if (teamId != null) {
      await _dispatch(SoccerGoalScored(teamId: teamId));
    }
  }

  Future<String?> _selectTeam(SportGameState state) {
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

  Future<void> _dispatch(ScoreAction action) {
    return ref.read(soccerGameNotifierProvider(widget.sessionId).notifier).dispatch(action);
  }

  Future<void> _editNotes(SportGameState state) async {
    final notes = await showSportNotesSheet(context, initialValue: state.notes);
    if (notes != null) {
      await _dispatch(SportNoteUpdated(content: notes));
    }
  }
}
