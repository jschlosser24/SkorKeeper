import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../../../../core/modules/scoring_layout_descriptor.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../../../core/modules/win_result.dart';
import '../../shared/sport_module_utils.dart';
import 'baseball_state.dart';

class BaseballModule implements GameModule {
  const BaseballModule();

  @override
  String get gameTypeId => 'sport_baseball';

  @override
  String get displayName => 'Baseball';

  @override
  String get description => 'Track innings, outs, runs, hits, and errors.';

  @override
  String get iconAsset => 'sports_baseball';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 2;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return SportModuleUtils.initialState(
      sportType: SportType.baseball,
      gameFormat: 'innings_9',
      trackingMode: TrackingMode.basic,
      sportSpecific: BaseballStateHelper.initial(),
      homeStats: BaseballStateHelper.initialTeamStats(),
      awayStats: BaseballStateHelper.initialTeamStats(),
      players: players,
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    return SportGameState.fromJson(json);
  }

  @override
  SportGameState applyAction(GameModuleState state, ScoreAction action) {
    final gameState = state as SportGameState;
    if (action is SportGameEnded) {
      return gameState.copyWith(gamePhase: GamePhase.completed);
    }
    if (action is SportTimerStarted) {
      return gameState.copyWith(timerRunning: true, gamePhase: GamePhase.active);
    }
    if (action is SportTimerPaused) {
      return gameState.copyWith(timerRunning: false, gamePhase: GamePhase.paused);
    }
    if (action is SportTimerReset) {
      return gameState.copyWith(elapsedSeconds: 0, timerRunning: false);
    }
    if (action is SportNoteUpdated) {
      return gameState.copyWith(notes: action.content);
    }
    if (action is BaseballPitchRecorded) {
      return _applyPitch(gameState, action);
    }
    if (action is BaseballPlateAppearanceRecorded) {
      return _applyPlateAppearance(
        gameState,
        SportModuleUtils.mapCopy(gameState.sportSpecific),
        teamId: action.teamId,
        result: action.result,
        rbi: action.rbi,
        playerId: action.playerId,
      );
    }
    if (action is BaseballErrorRecorded) {
      return _applyError(gameState, action);
    }
    if (action is BaseballBatterSet) {
      return _applyBatterSet(gameState, action);
    }
    return gameState;
  }

  /// Handles a single ball/strike; auto-resolves to a walk or strikeout once
  /// the count reaches 4 balls or 3 strikes, just like a real at-bat.
  SportGameState _applyPitch(SportGameState gameState, BaseballPitchRecorded action) {
    final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
    if (action.pitchType == 'ball') {
      final balls = SportModuleUtils.asInt(sportSpecific['balls']) + 1;
      if (balls >= 4) {
        return _applyPlateAppearance(
          gameState,
          sportSpecific,
          teamId: action.teamId,
          result: 'walk',
          rbi: 0,
          playerId: null,
        );
      }
      sportSpecific['balls'] = balls;
      return gameState.copyWith(sportSpecific: sportSpecific);
    }
    if (action.pitchType == 'strike') {
      final strikes = SportModuleUtils.asInt(sportSpecific['strikes']) + 1;
      if (strikes >= 3) {
        return _applyPlateAppearance(
          gameState,
          sportSpecific,
          teamId: action.teamId,
          result: 'strikeout',
          rbi: 0,
          playerId: null,
        );
      }
      sportSpecific['strikes'] = strikes;
      return gameState.copyWith(sportSpecific: sportSpecific);
    }
    return gameState;
  }

  /// Resolves a completed plate appearance: updates team/player stats, scores
  /// any RBI, resets the ball/strike count, and advances the batting order.
  /// Outs additionally advance the outs/half-inning/inning counters.
  SportGameState _applyPlateAppearance(
    SportGameState state,
    Map<String, dynamic> sportSpecific, {
    required String teamId,
    required String result,
    required int rbi,
    required String? playerId,
  }) {
    var gameState = state;
    final inningIndex = SportModuleUtils.asInt(sportSpecific['currentInning']) - 1;
    final isHit = BaseballStateHelper.hitResults.contains(result);
    final isOut = BaseballStateHelper.outResults.contains(result);
    gameState = SportModuleUtils.appendEvent(
      gameState,
      eventType: result,
      teamId: teamId,
      playerId: playerId,
      pointsDelta: rbi,
      metadata: rbi > 0 ? {'rbi': rbi} : null,
    );
    gameState = SportModuleUtils.updateTeam(gameState, teamId, (team) {
      var updated = team;
      switch (result) {
        case 'single':
        case 'double':
        case 'triple':
        case 'home_run':
          updated = SportModuleUtils.incrementStat(updated, 'hits');
          updated = SportModuleUtils.incrementStat(updated, 'atBats');
          updated = SportModuleUtils.incrementSegmentScore(
            updated,
            'inningHits',
            inningIndex,
            1,
          );
          break;
        case 'strikeout':
          updated = SportModuleUtils.incrementStat(updated, 'strikeouts');
          updated = SportModuleUtils.incrementStat(updated, 'atBats');
          break;
        case 'out':
          updated = SportModuleUtils.incrementStat(updated, 'atBats');
          break;
        case 'walk':
          updated = SportModuleUtils.incrementStat(updated, 'walks');
          break;
      }
      if (rbi > 0) {
        updated = updated.copyWith(score: updated.score + rbi);
        updated = SportModuleUtils.incrementStat(updated, 'rbi', by: rbi);
        updated = SportModuleUtils.incrementStat(updated, 'earnedRuns', by: rbi);
        updated = SportModuleUtils.incrementSegmentScore(
          updated,
          'inningScores',
          inningIndex,
          rbi,
        );
      }
      if (playerId != null) {
        updated = SportModuleUtils.incrementPlayerStat(updated, playerId, 'pa');
        if (isHit) {
          updated = SportModuleUtils.incrementPlayerStat(updated, playerId, 'h');
          if (result == 'home_run') {
            updated = SportModuleUtils.incrementPlayerStat(updated, playerId, 'hr');
          }
        }
        if (result == 'walk') {
          updated = SportModuleUtils.incrementPlayerStat(updated, playerId, 'bb');
        }
        if (result == 'strikeout') {
          updated = SportModuleUtils.incrementPlayerStat(updated, playerId, 'k');
        }
        if (rbi > 0) {
          updated = SportModuleUtils.incrementPlayerStat(updated, playerId, 'rbi', by: rbi);
        }
      }
      return updated;
    });
    final batterKey = teamId == 'home' ? 'homeBatterIndex' : 'awayBatterIndex';
    sportSpecific[batterKey] = SportModuleUtils.asInt(sportSpecific[batterKey]) + 1;
    sportSpecific['balls'] = 0;
    sportSpecific['strikes'] = 0;
    if (isOut) {
      final outs = SportModuleUtils.asInt(sportSpecific['outs']) + 1;
      if (outs >= 3) {
        sportSpecific['outs'] = 0;
        final currentHalf = SportModuleUtils.asString(
          sportSpecific['currentHalf'],
          fallback: 'top',
        );
        if (currentHalf == 'top') {
          sportSpecific['currentHalf'] = 'bottom';
        } else {
          sportSpecific['currentHalf'] = 'top';
          sportSpecific['currentInning'] =
              SportModuleUtils.asInt(sportSpecific['currentInning']) + 1;
          if (SportModuleUtils.asInt(sportSpecific['currentInning']) >
              SportModuleUtils.asInt(sportSpecific['maxInnings'])) {
            gameState = gameState.copyWith(gamePhase: GamePhase.completed);
          }
        }
      } else {
        sportSpecific['outs'] = outs;
      }
    }
    return gameState.copyWith(sportSpecific: sportSpecific);
  }

  SportGameState _applyError(SportGameState state, BaseballErrorRecorded action) {
    var gameState = state;
    final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
    final inningIndex = SportModuleUtils.asInt(sportSpecific['currentInning']) - 1;
    gameState = SportModuleUtils.appendEvent(
      gameState,
      eventType: 'error',
      teamId: action.teamId,
      playerId: action.playerId,
    );
    gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
      var updated = SportModuleUtils.incrementStat(team, 'errors');
      updated = SportModuleUtils.incrementSegmentScore(
        updated,
        'inningErrors',
        inningIndex,
        1,
      );
      if (action.playerId != null) {
        updated = SportModuleUtils.incrementPlayerStat(updated, action.playerId!, 'e');
      }
      return updated;
    });
    return gameState;
  }

  /// Directly sets the batting-order index for a team, allowing the user to
  /// pick a specific batter (e.g. after a substitution) instead of relying
  /// on the auto-advanced order.
  SportGameState _applyBatterSet(SportGameState state, BaseballBatterSet action) {
    final sportSpecific = SportModuleUtils.mapCopy(state.sportSpecific);
    final batterKey = action.teamId == 'home' ? 'homeBatterIndex' : 'awayBatterIndex';
    sportSpecific[batterKey] = action.batterIndex;
    return state.copyWith(sportSpecific: sportSpecific);
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    return SportModuleUtils.leaderboard(state as SportGameState);
  }

  @override
  WinResult? checkWinCondition(GameModuleState state) {
    return SportModuleUtils.resolveWinResult(state as SportGameState);
  }

  @override
  ScoringLayoutDescriptor scoringLayout(GameModuleState state) {
    return const ScoringLayoutDescriptor(
      type: ScoringLayoutType.sportsBasic,
      config: {'hasInningCounter': true, 'maxOuts': 3},
    );
  }

  @override
  ScoreValidationResult validateScore(
    GameModuleState state,
    String playerId,
    proposedValue,
  ) {
    return SportModuleUtils.alwaysValid();
  }
}
