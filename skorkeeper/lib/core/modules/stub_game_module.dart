import '../models/session_player.dart';
import 'game_module.dart';
import 'game_module_state.dart';
import 'leaderboard_entry.dart';
import 'score_action.dart';
import 'score_validation_result.dart';
import 'scoring_layout_descriptor.dart';
import 'win_result.dart';

class StubScoreState extends GameModuleState {
  const StubScoreState({
    required this.players,
    required this.scores,
    this.roundNumber = 1,
    this.activePlayerIndex = 0,
  });

  final List<SessionPlayer> players;
  final Map<String, int> scores;
  final int roundNumber;
  final int activePlayerIndex;

  factory StubScoreState.fromJson(Map<String, dynamic> json) {
    final playerJson = (json['players'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    final players = playerJson.map(SessionPlayer.fromJson).toList();
    final scoreMap = <String, int>{};
    final rawScores = json['scores'];
    if (rawScores is Map) {
      rawScores.forEach((key, value) {
        scoreMap[key.toString()] = (value as num?)?.toInt() ?? 0;
      });
    }
    for (final player in players) {
      scoreMap.putIfAbsent(player.id, () => 0);
    }
    return StubScoreState(
      players: players,
      scores: scoreMap,
      roundNumber: (json['roundNumber'] as num?)?.toInt() ?? 1,
      activePlayerIndex: (json['activePlayerIndex'] as num?)?.toInt() ?? 0,
    );
  }

  StubScoreState copyWith({
    List<SessionPlayer>? players,
    Map<String, int>? scores,
    int? roundNumber,
    int? activePlayerIndex,
  }) {
    return StubScoreState(
      players: players ?? this.players,
      scores: scores ?? this.scores,
      roundNumber: roundNumber ?? this.roundNumber,
      activePlayerIndex: activePlayerIndex ?? this.activePlayerIndex,
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'players': players.map((player) => player.toJson()).toList(),
    'scores': scores,
    'roundNumber': roundNumber,
    'activePlayerIndex': activePlayerIndex,
  };
}

class StubGameModule implements GameModule {
  const StubGameModule({
    required this.gameTypeId,
    required this.displayName,
    required this.description,
    required this.iconAsset,
    this.minPlayers = 1,
    this.maxPlayers = 10,
    this.layoutType = ScoringLayoutType.numericKeypad,
    this.lowerScoreWins = false,
  });

  @override
  final String gameTypeId;

  @override
  final String displayName;

  @override
  final String description;

  @override
  final String iconAsset;

  @override
  final int minPlayers;

  @override
  final int maxPlayers;

  final ScoringLayoutType layoutType;
  final bool lowerScoreWins;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return StubScoreState(
      players: players,
      scores: <String, int>{for (final player in players) player.id: 0},
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    try {
      return StubScoreState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    final current = state as StubScoreState;
    final scores = Map<String, int>.from(current.scores);
    var roundNumber = current.roundNumber;
    var activePlayerIndex = current.activePlayerIndex;

    void addScore(String playerId, int delta, {int? round}) {
      scores[playerId] = (scores[playerId] ?? 0) + delta;
      if (round != null && round > roundNumber) {
        roundNumber = round;
      }
      if (current.players.isNotEmpty) {
        activePlayerIndex =
            (current.players.indexWhere((player) => player.id == playerId) +
                1) %
            current.players.length;
      }
    }

    if (action is CustomRoundScoreEntered) {
      addScore(action.playerId, action.value, round: action.roundNumber);
    } else if (action is GolfHoleScoreEntered) {
      addScore(action.playerId, action.strokes, round: action.hole);
    } else if (action is CribbagePointsScored) {
      addScore(action.playerId, action.points, round: current.roundNumber + 1);
    } else if (action is UnoRoundScoreEntered) {
      addScore(action.playerId, action.points, round: current.roundNumber + 1);
    } else if (action is DominoesRoundScoreEntered) {
      addScore(action.playerId, action.pips, round: current.roundNumber + 1);
    } else if (action is DartThrown && current.players.isNotEmpty) {
      final playerId = current.players[current.activePlayerIndex].id;
      addScore(
        playerId,
        action.score * action.multiplier,
        round: current.roundNumber + 1,
      );
    } else if (action is BowlingRollEntered && current.players.isNotEmpty) {
      final playerId = current.players[current.activePlayerIndex].id;
      addScore(playerId, action.pins, round: current.roundNumber + 1);
    } else if (action is FarkleBankScore && current.players.isNotEmpty) {
      final playerId = current.players[current.activePlayerIndex].id;
      addScore(playerId, action.turnScore, round: current.roundNumber + 1);
    } else if (action is YahtzeeScoreSelected) {
      addScore(action.playerId, 0, round: current.roundNumber + 1);
    }

    return current.copyWith(
      scores: scores,
      roundNumber: roundNumber,
      activePlayerIndex: activePlayerIndex,
    );
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as StubScoreState;
    final sorted = [...current.players]
      ..sort((a, b) {
        final aScore = current.scores[a.id] ?? 0;
        final bScore = current.scores[b.id] ?? 0;
        final scoreCompare = lowerScoreWins
            ? aScore.compareTo(bScore)
            : bScore.compareTo(aScore);
        if (scoreCompare != 0) {
          return scoreCompare;
        }
        return a.seatOrder.compareTo(b.seatOrder);
      });
    final entries = <LeaderboardEntry>[];
    int? previousScore;
    var previousRank = 0;
    for (var i = 0; i < sorted.length; i++) {
      final player = sorted[i];
      final score = current.scores[player.id] ?? 0;
      final rank = previousScore == null || score != previousScore
          ? i + 1
          : previousRank;
      previousScore = score;
      previousRank = rank;
      entries.add(
        LeaderboardEntry(
          playerId: player.id,
          displayName: player.displayName,
          colorHex: player.colorHex,
          rank: rank,
          scoreDisplay: score.toString(),
          sortKey: lowerScoreWins ? -score : score,
          isLeading: rank == 1,
        ),
      );
    }
    return entries;
  }

  @override
  WinResult? checkWinCondition(GameModuleState state) => null;

  @override
  ScoringLayoutDescriptor scoringLayout(GameModuleState state) {
    return ScoringLayoutDescriptor(
      type: layoutType,
      config: <String, dynamic>{
        'lowerScoreWins': lowerScoreWins,
        'title': displayName,
      },
    );
  }

  @override
  ScoreValidationResult validateScore(
    GameModuleState state,
    String playerId,
    dynamic proposedValue,
  ) {
    final current = state as StubScoreState;
    if (!current.scores.containsKey(playerId)) {
      return const ScoreValidationResult.invalid(
        reason: 'Player is not part of this session.',
        shortCode: 'unknown_player',
      );
    }
    final value = proposedValue is int
        ? proposedValue
        : int.tryParse(proposedValue.toString());
    if (value == null) {
      return const ScoreValidationResult.invalid(
        reason: 'Enter a whole number.',
        shortCode: 'invalid_number',
      );
    }
    return const ScoreValidationResult.valid();
  }
}
