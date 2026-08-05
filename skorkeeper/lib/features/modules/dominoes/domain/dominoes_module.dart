import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../../../../core/modules/scoring_layout_descriptor.dart';
import '../../../../core/modules/win_result.dart';
import 'dominoes_state.dart';

class DominoesModule implements GameModule {
  const DominoesModule();

  @override
  String get gameTypeId => 'dominoes';

  @override
  String get displayName => 'Dominoes';

  @override
  String get description => 'Track pip counts round by round.';

  @override
  String get iconAsset =>
      '<svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><rect x="10" y="18" width="44" height="28" rx="8" fill="#00C0A0"/><path d="M32 18v28" stroke="white" stroke-width="3"/><circle cx="23" cy="27" r="3" fill="white"/><circle cx="41" cy="27" r="3" fill="white"/><circle cx="23" cy="37" r="3" fill="white"/><circle cx="41" cy="37" r="3" fill="white"/></svg>';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 8;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return DominoesState(
      currentRound: 1,
      playerTotals: {for (final player in players) player.id: 0},
      gameOver: false,
      playerOrder: players.map((player) => player.id).toList(),
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    try {
      return DominoesState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    final current = state as DominoesState;
    if (action is! DominoesRoundScoreEntered) {
      return current;
    }
    final totals = {...current.playerTotals};
    totals[action.playerId] = (totals[action.playerId] ?? 0) + action.pips;
    return current.copyWith(
      playerTotals: totals,
      currentRound: current.currentRound + 1,
    );
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as DominoesState;
    final entries = current.playerOrder.map((playerId) {
      final total = current.playerTotals[playerId] ?? 0;
      return LeaderboardEntry(
        playerId: playerId,
        displayName: playerId,
        colorHex: '#00C0A0',
        rank: 0,
        scoreDisplay: total.toString(),
        sortKey: -total,
        isLeading: false,
      );
    }).toList()..sort((a, b) => b.sortKey.compareTo(a.sortKey));
    for (var i = 0; i < entries.length; i++) {
      entries[i] = entries[i].copyWith(rank: i + 1, isLeading: i == 0);
    }
    return entries;
  }

  @override
  WinResult? checkWinCondition(GameModuleState state) {
    final current = state as DominoesState;
    if (!current.gameOver || current.winnerId == null) {
      return null;
    }
    final standings = leaderboard(current);
    return WinResult(
      winnerId: current.winnerId!,
      winnerDisplayName: current.winnerId!,
      winDescription: 'Lowest pip count wins',
      finalStandings: standings,
    );
  }

  @override
  ScoringLayoutDescriptor scoringLayout(GameModuleState state) {
    return const ScoringLayoutDescriptor(
      type: ScoringLayoutType.numericKeypad,
      config: <String, dynamic>{},
    );
  }

  @override
  ScoreValidationResult validateScore(
    GameModuleState state,
    String playerId,
    dynamic proposedValue,
  ) {
    final pips = proposedValue is int
        ? proposedValue
        : int.tryParse(proposedValue.toString());
    if (pips == null || pips < 0) {
      return const ScoreValidationResult.invalid(
        reason: 'Pip counts must be 0 or higher.',
        shortCode: 'INVALID_PIPS',
      );
    }
    return const ScoreValidationResult.valid();
  }
}
