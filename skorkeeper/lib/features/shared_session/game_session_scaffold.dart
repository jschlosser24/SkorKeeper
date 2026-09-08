import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart' as db;
import '../../core/models/session_player.dart';
import '../../core/modules/game_module.dart';
import '../../core/modules/game_module_registry.dart';
import '../../core/modules/leaderboard_entry.dart';
import '../../core/modules/score_action.dart';
import '../../core/modules/score_validation_result.dart';
import '../../core/modules/scoring_layout_descriptor.dart';
import '../../core/providers/active_sessions_provider.dart';
import '../../core/providers/database_provider.dart';
import '../modules/custom/presentation/custom_session_screen.dart';
import '../modules/darts/presentation/darts_session_screen.dart';
import '../modules/bowling/presentation/bowling_session_screen.dart';
import '../modules/dominoes/presentation/dominoes_session_screen.dart';
import '../modules/farkle/presentation/farkle_session_screen.dart';
import '../modules/golf/presentation/golf_session_screen.dart';
import '../modules/uno/presentation/uno_session_screen.dart';
import '../modules/yahtzee/presentation/yahtzee_session_screen.dart';
import '../modules/cribbage/presentation/cribbage_session_screen.dart';
import '../../ui/widgets/leaderboard_row.dart';
import '../../ui/widgets/numeric_keypad.dart';
import '../../ui/widgets/player_chip.dart';
import '../../ui/widgets/score_cell.dart';

class GameSessionScaffold extends ConsumerStatefulWidget {
  const GameSessionScaffold({required this.sessionId, super.key});

  final int sessionId;

  @override
  ConsumerState<GameSessionScaffold> createState() =>
      _GameSessionScaffoldState();
}

class _GameSessionScaffoldState extends ConsumerState<GameSessionScaffold> {
  String? _selectedPlayerId;

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(appDatabaseProvider);
    return StreamBuilder<db.GameSession?>(
      stream: (database.select(
        database.gameSessions,
      )..where((tbl) => tbl.id.equals(widget.sessionId))).watchSingleOrNull(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final session = snapshot.data;
        if (session == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Session unavailable')),
            body: const Center(child: Text('This session no longer exists.')),
          );
        }
        if (session.gameType == 'custom') {
          return CustomSessionScreen(sessionId: widget.sessionId);
        }
        if (session.gameType.startsWith('darts')) {
          return DartsSessionScreen(sessionId: widget.sessionId);
        }
        if (session.gameType.startsWith('golf') ||
            session.gameType == 'minigolf') {
          return GolfSessionScreen(sessionId: widget.sessionId);
        }
        if (session.gameType == 'yahtzee') {
          return YahtzeeSessionScreen(sessionId: widget.sessionId);
        }
        if (session.gameType == 'cribbage') {
          return CribbageSessionScreen(sessionId: widget.sessionId);
        }
        if (session.gameType == 'bowling') {
          return BowlingSessionScreen(sessionId: widget.sessionId);
        }
        if (session.gameType == 'farkle') {
          return FarkleSessionScreen(sessionId: widget.sessionId);
        }
        if (session.gameType == 'uno') {
          return UnoSessionScreen(sessionId: widget.sessionId);
        }
        if (session.gameType == 'dominoes') {
          return DominoesSessionScreen(sessionId: widget.sessionId);
        }
        final module = GameModuleRegistry.get(session.gameType);
        if (module == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Unknown game')),
            body: Center(
              child: Text('No module registered for ' + session.gameType),
            ),
          );
        }
        final players = _parsePlayers(session.participantsJson);
        final state = module.stateFromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        if (state == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(session.sessionName ?? module.displayName),
            ),
            body: const Center(
              child: Text('Session state could not be recovered.'),
            ),
          );
        }
        final leaderboard = module.leaderboard(state);
        final selectedPlayer = _resolveSelectedPlayer(players);
        final layout = module.scoringLayout(state);
        return Scaffold(
          appBar: AppBar(
            title: Text(session.sessionName ?? module.displayName),
            actions: [
              TextButton(
                onPressed: () => _endGame(context, state, leaderboard),
                child: const Text('End Game'),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Live Leaderboard'),
                children: [
                  for (final entry in leaderboard) LeaderboardRow(entry: entry),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final player in players)
                    PlayerChip(
                      displayName: player.displayName,
                      colorHex: player.colorHex,
                      isSelected: player.id == selectedPlayer.id,
                      onTap: () =>
                          setState(() => _selectedPlayerId = player.id),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ScoreCell(
                label: 'Scoring player',
                value: selectedPlayer.displayName,
                isSelected: true,
              ),
              const SizedBox(height: 16),
              _buildScoringContent(
                context,
                layout,
                selectedPlayer,
                module,
                state,
              ),
            ],
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

  SessionPlayer _resolveSelectedPlayer(List<SessionPlayer> players) {
    return players.firstWhere(
      (player) => player.id == _selectedPlayerId,
      orElse: () {
        final fallback = players.first;
        _selectedPlayerId = fallback.id;
        return fallback;
      },
    );
  }

  Widget _buildScoringContent(
    BuildContext context,
    ScoringLayoutDescriptor layout,
    SessionPlayer selectedPlayer,
    GameModule module,
    dynamic state,
  ) {
    switch (layout.type) {
      case ScoringLayoutType.numericKeypad:
      case ScoringLayoutType.dartsKeypad:
      case ScoringLayoutType.yahtzeeScorecard:
      case ScoringLayoutType.golfScorecard:
      case ScoringLayoutType.cribbageBoard:
      case ScoringLayoutType.bowlingSheet:
      case ScoringLayoutType.livesCounter:
      case ScoringLayoutType.sportsBasic:
      case ScoringLayoutType.sportsInDepth:
        return NumericKeypad(
          title: 'Score for ' + selectedPlayer.displayName,
          onSubmitted: (value) =>
              _recordScore(context, module, state, selectedPlayer, value),
        );
    }
  }

  Future<void> _recordScore(
    BuildContext context,
    GameModule module,
    dynamic state,
    SessionPlayer selectedPlayer,
    int value,
  ) async {
    final validation = module.validateScore(state, selectedPlayer.id, value);
    if (validation is InvalidScore) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validation.reason)));
      return;
    }
    final action = CustomRoundScoreEntered(
      playerId: selectedPlayer.id,
      value: value,
      roundNumber: DateTime.now().millisecondsSinceEpoch,
    );
    final newState = module.applyAction(state, action);
    await ref
        .read(activeSessionsNotifierProvider.notifier)
        .recordScore(widget.sessionId, action, jsonEncode(newState.toJson()));
  }

  Future<void> _endGame(
    BuildContext context,
    dynamic state,
    List<LeaderboardEntry> leaderboard,
  ) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('End game?'),
            content: const Text('This will mark the current session complete.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('End Game'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) {
      return;
    }
    final winnerName = leaderboard.isEmpty
        ? 'No winner'
        : leaderboard.first.displayName;
    await ref
        .read(activeSessionsNotifierProvider.notifier)
        .endSession(widget.sessionId, winnerName, jsonEncode(state.toJson()));
    if (context.mounted) {
      context.go('/home/session/' + widget.sessionId.toString() + '/summary');
    }
  }
}
