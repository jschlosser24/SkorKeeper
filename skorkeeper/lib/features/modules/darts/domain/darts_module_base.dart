import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../../../../core/modules/scoring_layout_descriptor.dart';
import '../../../../core/modules/win_result.dart';
import 'darts_game_state.dart';

abstract class DartsModuleBase implements GameModule {
  const DartsModuleBase({
    required this.variant,
    required this.gameTypeId,
    required this.displayName,
    required this.description,
    this.startingScore = 0,
    this.minPlayers = 1,
    this.maxPlayers = 8,
    this.defaultDoubleIn = false,
    this.defaultDoubleOut = false,
  });

  final DartsVariant variant;
  @override
  final String gameTypeId;
  @override
  final String displayName;
  @override
  final String description;
  final int startingScore;
  @override
  final int minPlayers;
  @override
  final int maxPlayers;
  final bool defaultDoubleIn;
  final bool defaultDoubleOut;

  @override
  String get iconAsset => _dartIcon;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    final ids = players.map((player) => player.id).toList();
    return DartsGameState(
      gameVariant: variant,
      doubleIn: defaultDoubleIn,
      doubleOut: defaultDoubleOut,
      playerStates: {
        for (final player in players)
          player.id: DartsPlayerState(
            scoreRemaining: startingScore,
            dartsThrown: 0,
            scoresThisLeg: const <int>[],
            hasOpened: !defaultDoubleIn,
          ),
      },
      currentPlayerId: ids.first,
      currentThrowInTurn: 1,
      throwsThisTurn: const <int>[],
      legsWon: {for (final id in ids) id: 0},
      setsWon: {for (final id in ids) id: 0},
      cricketMarks: null,
      cricketPoints: null,
      gameOver: false,
      winnerId: null,
      variantScores: {for (final id in ids) id: 0},
      variantProgress: {for (final id in ids) id: 1},
      killerTargets: null,
      killerLives: null,
      killerStatus: null,
      currentRound: 1,
      currentTarget: 1,
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    try {
      return DartsGameState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final dartsState = state as DartsGameState;
    return computeLeaderboard(dartsState);
  }

  List<LeaderboardEntry> computeLeaderboard(DartsGameState state) {
    final entries = state.playerStates.entries.map((entry) {
      final playerId = entry.key;
      final score =
          state.gameVariant == DartsVariant.cricket ||
              state.gameVariant == DartsVariant.cutThroatCricket
          ? (state.cricketPoints?[playerId] ?? 0)
          : state.gameVariant == DartsVariant.killer
          ? (state.killerLives?[playerId] ?? 0)
          : state.gameVariant == DartsVariant.aroundTheClock
          ? ((state.variantProgress?[playerId] ?? 1) - 1)
          : (state.variantScores?[playerId] ?? entry.value.scoreRemaining);
      return LeaderboardEntry(
        playerId: playerId,
        displayName: playerId,
        colorHex: '#236192',
        rank: 0,
        scoreDisplay:
            state.gameVariant == DartsVariant.v301 ||
                state.gameVariant == DartsVariant.v501 ||
                state.gameVariant == DartsVariant.v701
            ? entry.value.scoreRemaining.toString()
            : score.toString(),
        sortKey: score,
        isLeading: false,
      );
    }).toList();
    final sorted = [...entries]
      ..sort((a, b) {
        if (_isX01(state.gameVariant)) {
          return (state.playerStates[a.playerId]!.scoreRemaining).compareTo(
            state.playerStates[b.playerId]!.scoreRemaining,
          );
        }
        return b.sortKey.compareTo(a.sortKey);
      });
    for (var i = 0; i < sorted.length; i++) {
      sorted[i] = sorted[i].copyWith(rank: i + 1, isLeading: i == 0);
    }
    return sorted;
  }

  double averagePerDart(DartsGameState state, String playerId) {
    final player = state.playerStates[playerId];
    if (player == null || player.dartsThrown == 0) {
      return 0;
    }
    final scored = _isX01(state.gameVariant)
        ? startingScore - player.scoreRemaining
        : state.variantScores?[playerId] ?? 0;
    return scored / player.dartsThrown;
  }

  @override
  ScoringLayoutDescriptor scoringLayout(GameModuleState state) {
    return const ScoringLayoutDescriptor(
      type: ScoringLayoutType.dartsKeypad,
      config: <String, dynamic>{},
    );
  }

  @override
  ScoreValidationResult validateScore(
    GameModuleState state,
    String playerId,
    dynamic proposedValue,
  ) {
    if (proposedValue is! DartThrown) {
      return const ScoreValidationResult.invalid(
        reason: 'Invalid dart throw.',
        shortCode: 'INVALID_THROW',
      );
    }
    if (proposedValue.score == 0) {
      return const ScoreValidationResult.valid();
    }
    final isValidBase =
        (proposedValue.score >= 1 && proposedValue.score <= 20) ||
        proposedValue.score == 25;
    if (!isValidBase) {
      return const ScoreValidationResult.invalid(
        reason: 'Choose 1-20 or bull.',
        shortCode: 'INVALID_VALUE',
      );
    }
    if (proposedValue.multiplier < 1 || proposedValue.multiplier > 3) {
      return const ScoreValidationResult.invalid(
        reason: 'Choose a multiplier between 1 and 3.',
        shortCode: 'INVALID_MULTIPLIER',
      );
    }
    if (proposedValue.score == 25 && proposedValue.multiplier == 3) {
      return const ScoreValidationResult.invalid(
        reason: 'Bull cannot be tripled.',
        shortCode: 'INVALID_BULL',
      );
    }
    return const ScoreValidationResult.valid();
  }

  DartsGameState advanceTurn(DartsGameState state) {
    final ids = state.playerStates.keys.toList();
    final currentIndex = ids.indexOf(state.currentPlayerId);
    final nextPlayerId = ids[(currentIndex + 1) % ids.length];
    final nextRound = nextPlayerId == ids.first
        ? (state.currentRound ?? 1) + 1
        : (state.currentRound ?? 1);
    return state.copyWith(
      currentPlayerId: nextPlayerId,
      currentThrowInTurn: 1,
      throwsThisTurn: const <int>[],
      currentRound: nextRound,
      currentTarget: nextRound,
    );
  }

  DartsGameState applyX01Throw(DartsGameState state, DartThrown action) {
    if (state.gameOver) {
      return state;
    }
    final player = state.playerStates[state.currentPlayerId]!;
    final turnScored = state.throwsThisTurn.fold<int>(
      0,
      (sum, item) => sum + item,
    );
    final turnStartScore = player.scoreRemaining + turnScored;
    final total = action.score * action.multiplier;
    var hasOpened = player.hasOpened;
    var newRemaining = player.scoreRemaining;

    if (!hasOpened) {
      if (action.multiplier == 2 && action.score > 0) {
        hasOpened = true;
        newRemaining -= total;
      }
    } else {
      newRemaining -= total;
    }

    final bust =
        hasOpened &&
        (newRemaining < 0 ||
            (state.doubleOut && newRemaining == 1) ||
            (newRemaining == 0 && state.doubleOut && action.multiplier != 2));
    final validWin =
        hasOpened &&
        newRemaining == 0 &&
        (!state.doubleOut || action.multiplier == 2);

    final updatedPlayer = player.copyWith(
      dartsThrown: player.dartsThrown + 1,
      hasOpened: hasOpened,
      scoreRemaining: bust ? turnStartScore : newRemaining,
      scoresThisLeg: [...player.scoresThisLeg, total],
    );
    var updated = state.copyWith(
      playerStates: {
        ...state.playerStates,
        state.currentPlayerId: updatedPlayer,
      },
      throwsThisTurn: [...state.throwsThisTurn, total],
      currentThrowInTurn: state.currentThrowInTurn + 1,
    );

    if (validWin) {
      return updated.copyWith(gameOver: true, winnerId: state.currentPlayerId);
    }
    if (bust || updated.currentThrowInTurn > 3) {
      return advanceTurn(
        updated.copyWith(
          playerStates: {
            ...updated.playerStates,
            state.currentPlayerId: updatedPlayer.copyWith(
              scoreRemaining: bust ? turnStartScore : newRemaining,
            ),
          },
          throwsThisTurn: const <int>[],
          currentThrowInTurn: 1,
        ),
      );
    }
    return updated;
  }

  @override
  WinResult? checkWinCondition(GameModuleState state) {
    final dartsState = state as DartsGameState;
    if (!dartsState.gameOver || dartsState.winnerId == null) {
      return null;
    }
    return WinResult(
      winnerId: dartsState.winnerId!,
      winnerDisplayName: dartsState.winnerId!,
      winDescription: 'Won ${displayName.toLowerCase()}',
      finalStandings: computeLeaderboard(dartsState),
    );
  }

  bool isValidDouble(DartThrown action) =>
      action.multiplier == 2 && action.score > 0;

  static bool _isX01(DartsVariant variant) =>
      variant == DartsVariant.v301 ||
      variant == DartsVariant.v501 ||
      variant == DartsVariant.v701;
}

const _dartIcon =
    '<svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="52" height="52" rx="16" fill="#0C2340"/><path d="M18 46 42 22l4 4-24 24-8 2z" fill="#78BE20"/><circle cx="45" cy="19" r="5" fill="#981D97"/></svg>';
