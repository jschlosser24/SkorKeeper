import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../../../../core/modules/scoring_layout_descriptor.dart';
import '../../../../core/modules/win_result.dart';
import 'uno_state.dart';

class UnoModule implements GameModule {
  const UnoModule({this.targetScore = 500});

  final int targetScore;

  @override
  String get gameTypeId => 'uno';

  @override
  String get displayName => 'UNO Penalty Tracker';

  @override
  String get description => 'Track round penalties until one player survives.';

  @override
  String get iconAsset =>
      '<svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><rect x="10" y="14" width="24" height="36" rx="6" fill="#221C35"/><rect x="30" y="10" width="24" height="36" rx="6" fill="#981D97"/><circle cx="40" cy="28" r="6" fill="white"/></svg>';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 10;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return UnoState(
      currentRound: 1,
      targetScore: targetScore,
      playerTotals: {for (final player in players) player.id: 0},
      eliminatedPlayerIds: const [],
      gameOver: false,
      playerOrder: players.map((player) => player.id).toList(),
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    try {
      return UnoState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    final current = state as UnoState;
    if (action is! UnoRoundScoreEntered) {
      return current;
    }
    final totals = {...current.playerTotals};
    totals[action.playerId] = (totals[action.playerId] ?? 0) + action.points;
    final eliminated = {...current.eliminatedPlayerIds};
    if ((totals[action.playerId] ?? 0) >= current.targetScore) {
      eliminated.add(action.playerId);
    }
    final remaining = current.playerOrder
        .where((playerId) => !eliminated.contains(playerId))
        .toList();
    return current.copyWith(
      currentRound: current.currentRound + 1,
      playerTotals: totals,
      eliminatedPlayerIds: eliminated.toList(),
      gameOver: remaining.length == 1,
      winnerId: remaining.length == 1 ? remaining.first : null,
    );
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as UnoState;
    final entries = current.playerOrder.map((playerId) {
      final total = current.playerTotals[playerId] ?? 0;
      final eliminated = current.eliminatedPlayerIds.contains(playerId);
      return LeaderboardEntry(
        playerId: playerId,
        displayName: playerId,
        colorHex: eliminated ? '#9ea2a2' : '#981D97',
        rank: 0,
        scoreDisplay: eliminated ? '$total • Out' : '$total',
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
    final current = state as UnoState;
    if (!current.gameOver || current.winnerId == null) {
      return null;
    }
    final standings = leaderboard(current);
    return WinResult(
      winnerId: current.winnerId!,
      winnerDisplayName: current.winnerId!,
      winDescription: 'Last player under the target wins',
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
    final points = proposedValue is int
        ? proposedValue
        : int.tryParse(proposedValue.toString());
    if (points == null || points < 0) {
      return const ScoreValidationResult.invalid(
        reason: 'Penalty points must be 0 or higher.',
        shortCode: 'INVALID_UNO_POINTS',
      );
    }
    return const ScoreValidationResult.valid();
  }
}
