import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../../../../core/modules/scoring_layout_descriptor.dart';
import '../../../../core/modules/win_result.dart';
import 'farkle_state.dart';

class FarkleModule implements GameModule {
  const FarkleModule({this.targetScore = 10000});

  final int targetScore;

  @override
  String get gameTypeId => 'farkle';

  @override
  String get displayName => 'Farkle';

  @override
  String get description =>
      'Push your luck, then bank points before you farkle.';

  @override
  String get iconAsset =>
      '<svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><rect x="10" y="10" width="44" height="44" rx="10" fill="#FF6B35"/><circle cx="24" cy="24" r="4" fill="white"/><circle cx="40" cy="40" r="4" fill="white"/><circle cx="24" cy="40" r="4" fill="white"/><circle cx="40" cy="24" r="4" fill="white"/></svg>';

  @override
  int get minPlayers => 1;

  @override
  int get maxPlayers => 10;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return FarkleState(
      currentPlayerId: players.first.id,
      targetScore: targetScore,
      playerTotals: {for (final player in players) player.id: 0},
      currentTurnScore: 0,
      currentTurnDice: const [1, 1, 1, 1, 1, 1],
      diceBanked: 0,
      hasOpened: {for (final player in players) player.id: false},
      gameOver: false,
      playerOrder: players.map((player) => player.id).toList(),
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    try {
      return FarkleState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    final current = state as FarkleState;
    if (action is FarkleFarkled) {
      return current.copyWith(
        currentPlayerId: _nextPlayer(current),
        currentTurnScore: 0,
        currentTurnDice: const [1, 1, 1, 1, 1, 1],
        diceBanked: 0,
      );
    }
    if (action is! FarkleBankScore) {
      return current;
    }
    final totals = {...current.playerTotals};
    final hasOpened = {...current.hasOpened};
    if (action.turnScore >= 500) {
      totals[current.currentPlayerId] =
          (totals[current.currentPlayerId] ?? 0) + action.turnScore;
      hasOpened[current.currentPlayerId] = true;
    }
    final winner = totals.entries
        .where((entry) => entry.value >= current.targetScore)
        .map((entry) => entry.key)
        .cast<String?>()
        .firstWhere((value) => value != null, orElse: () => null);
    return current.copyWith(
      currentPlayerId: _nextPlayer(current),
      playerTotals: totals,
      hasOpened: hasOpened,
      currentTurnScore: 0,
      currentTurnDice: const [1, 1, 1, 1, 1, 1],
      diceBanked: 0,
      gameOver: winner != null,
      winnerId: winner,
    );
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as FarkleState;
    final entries = current.playerOrder.map((playerId) {
      final total = current.playerTotals[playerId] ?? 0;
      return LeaderboardEntry(
        playerId: playerId,
        displayName: playerId,
        colorHex: '#FF6B35',
        rank: 0,
        scoreDisplay: total.toString(),
        sortKey: total,
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
    final current = state as FarkleState;
    if (!current.gameOver || current.winnerId == null) {
      return null;
    }
    final standings = leaderboard(current);
    return WinResult(
      winnerId: current.winnerId!,
      winnerDisplayName: current.winnerId!,
      winDescription: 'First player to the target wins',
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
    final score = proposedValue is int
        ? proposedValue
        : int.tryParse(proposedValue.toString());
    if (score == null || score < 0) {
      return const ScoreValidationResult.invalid(
        reason: 'Enter a valid Farkle score.',
        shortCode: 'INVALID_FARKLE_SCORE',
      );
    }
    return const ScoreValidationResult.valid();
  }

  String _nextPlayer(FarkleState state) {
    final index = state.playerOrder.indexOf(state.currentPlayerId);
    return state.playerOrder[(index + 1) % state.playerOrder.length];
  }
}
