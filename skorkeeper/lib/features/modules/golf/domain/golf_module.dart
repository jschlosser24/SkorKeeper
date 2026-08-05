import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../../../../core/modules/scoring_layout_descriptor.dart';
import '../../../../core/modules/win_result.dart';
import 'golf_state.dart';

class GolfModule implements GameModule {
  const GolfModule({
    required this.gameTypeId,
    required this.displayName,
    required this.holeCount,
    required this.isMiniGolf,
  });

  @override
  final String gameTypeId;
  @override
  final String displayName;
  final int holeCount;
  final bool isMiniGolf;

  @override
  String get description => isMiniGolf
      ? 'Track mini golf hole-by-hole scores.'
      : 'Track golf scores with live relative-to-par feedback.';

  @override
  String get iconAsset =>
      '<svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="52" height="52" rx="16" fill="#E8E8E8"/><path d="M24 16v30" stroke="#0C2340" stroke-width="4"/><path d="M26 18h16l-5 8 5 8H26" fill="#0C2340"/></svg>';

  @override
  int get minPlayers => 1;

  @override
  int get maxPlayers => 8;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return GolfState(
      holeCount: holeCount,
      pars: List<int>.filled(holeCount, isMiniGolf ? 0 : 4),
      scores: {
        for (final player in players)
          player.id: List<int?>.filled(holeCount, null),
      },
      isMiniGolf: isMiniGolf,
      currentHole: 1,
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    try {
      return GolfState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    final current = state as GolfState;
    if (action is! GolfHoleScoreEntered) {
      return current;
    }
    final scores = {...current.scores};
    final playerScores = [...?scores[action.playerId]];
    if (action.hole - 1 < playerScores.length) {
      playerScores[action.hole - 1] = action.strokes;
      scores[action.playerId] = playerScores;
    }
    final nextHole = action.hole >= current.currentHole
        ? action.hole + 1
        : current.currentHole;
    return current.copyWith(
      scores: scores,
      currentHole: nextHole > current.holeCount ? current.holeCount : nextHole,
    );
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as GolfState;
    final entries = current.scores.entries.map((entry) {
      final total = entry.value.whereType<int>().fold<int>(
        0,
        (sum, value) => sum + value,
      );
      return LeaderboardEntry(
        playerId: entry.key,
        displayName: entry.key,
        colorHex: '#78BE20',
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
    final current = state as GolfState;
    final complete = current.scores.values.every(
      (scores) => scores.every((value) => value != null),
    );
    if (!complete) {
      return null;
    }
    final standings = leaderboard(current);
    return WinResult(
      winnerId: standings.first.playerId,
      winnerDisplayName: standings.first.displayName,
      winDescription: 'Lowest score wins',
      finalStandings: standings,
    );
  }

  @override
  ScoringLayoutDescriptor scoringLayout(GameModuleState state) {
    return const ScoringLayoutDescriptor(
      type: ScoringLayoutType.golfScorecard,
      config: <String, dynamic>{},
    );
  }

  @override
  ScoreValidationResult validateScore(
    GameModuleState state,
    String playerId,
    dynamic proposedValue,
  ) {
    final value = proposedValue is int
        ? proposedValue
        : int.tryParse(proposedValue.toString());
    if (value == null || value < 1) {
      return const ScoreValidationResult.invalid(
        reason: 'Enter at least 1 stroke.',
        shortCode: 'INVALID_STROKES',
      );
    }
    return const ScoreValidationResult.valid();
  }
}

class Golf9Module extends GolfModule {
  const Golf9Module()
    : super(
        gameTypeId: 'golf9',
        displayName: 'Golf',
        holeCount: 9,
        isMiniGolf: false,
      );
}

class Golf18Module extends GolfModule {
  const Golf18Module()
    : super(
        gameTypeId: 'golf18',
        displayName: 'Golf',
        holeCount: 18,
        isMiniGolf: false,
      );
}

class MiniGolfModule extends GolfModule {
  const MiniGolfModule({this.selectedHoleCount = 9})
    : super(
        gameTypeId: 'minigolf',
        displayName: 'Mini Golf',
        holeCount: selectedHoleCount,
        isMiniGolf: true,
      );

  final int selectedHoleCount;
}
