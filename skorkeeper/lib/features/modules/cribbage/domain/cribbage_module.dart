import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../../../../core/modules/scoring_layout_descriptor.dart';
import '../../../../core/modules/win_result.dart';
import 'cribbage_state.dart';

class CribbageModule implements GameModule {
  const CribbageModule();

  @override
  String get gameTypeId => 'cribbage';

  @override
  String get displayName => 'Cribbage';

  @override
  String get description =>
      'Track peg positions for 2 or 3 cribbage teams with a classic board.';

  @override
  String get iconAsset =>
      '<svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><rect x="10" y="14" width="24" height="36" rx="6" fill="#221C35"/><rect x="30" y="10" width="24" height="36" rx="6" fill="#981D97"/><circle cx="40" cy="28" r="6" fill="white"/></svg>';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 3;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return CribbageState(
      variant: players.length == 3 ? 'three_team' : 'two_team',
      dealerId: players.first.id,
      pegPositions: {
        for (final player in players)
          player.id: const CribbagePegPosition(front: 0, rear: 0),
      },
      gameOver: false,
      handNumber: 1,
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    try {
      return CribbageState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    final current = state as CribbageState;
    if (action is! CribbagePointsScored) {
      return current;
    }
    final positions = {...current.pegPositions};
    final existing =
        positions[action.playerId] ??
        const CribbagePegPosition(front: 0, rear: 0);
    final updated = existing.copyWith(
      rear: existing.front,
      front: existing.front + action.points,
    );
    positions[action.playerId] = updated;
    final winner = positions.entries
        .where((entry) => entry.value.front >= 121)
        .map((entry) => entry.key)
        .cast<String?>()
        .firstWhere((value) => value != null, orElse: () => null);
    return current.copyWith(
      pegPositions: positions,
      gameOver: winner != null,
      winnerId: winner,
    );
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as CribbageState;
    final entries = current.pegPositions.entries.map((entry) {
      return LeaderboardEntry(
        playerId: entry.key,
        displayName: entry.key,
        colorHex: '#981D97',
        rank: 0,
        scoreDisplay: entry.value.front.toString(),
        sortKey: entry.value.front,
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
    final current = state as CribbageState;
    if (!current.gameOver || current.winnerId == null) {
      return null;
    }
    return WinResult(
      winnerId: current.winnerId!,
      winnerDisplayName: current.winnerId!,
      winDescription: 'Reached 121 points',
      finalStandings: leaderboard(current),
    );
  }

  @override
  ScoringLayoutDescriptor scoringLayout(GameModuleState state) {
    return const ScoringLayoutDescriptor(
      type: ScoringLayoutType.cribbageBoard,
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
        reason: 'Enter 0 or more points.',
        shortCode: 'INVALID_POINTS',
      );
    }
    return const ScoreValidationResult.valid();
  }
}
