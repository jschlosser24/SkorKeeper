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
import 'basketball_state.dart';

class BasketballModule implements GameModule {
  const BasketballModule();

  @override
  String get gameTypeId => 'sport_basketball';

  @override
  String get displayName => 'Basketball';

  @override
  String get description => 'Live clock, quarter scoring, and shooting splits.';

  @override
  String get iconAsset => 'sports_basketball';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 2;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return SportModuleUtils.initialState(
      sportType: SportType.basketball,
      gameFormat: 'full',
      trackingMode: TrackingMode.basic,
      sportSpecific: BasketballStateHelper.initial(),
      homeStats: BasketballStateHelper.initialTeamStats(),
      awayStats: BasketballStateHelper.initialTeamStats(),
      players: players,
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    return SportGameState.fromJson(json);
  }

  @override
  SportGameState applyAction(GameModuleState state, ScoreAction action) {
    var gameState = state as SportGameState;
    if (action is SportGameEnded) {
      return gameState.copyWith(gamePhase: GamePhase.completed, timerRunning: false);
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
    if (action is BasketballTimerToggled) {
      return gameState.copyWith(
        timerRunning: !gameState.timerRunning,
        gamePhase: gameState.timerRunning ? GamePhase.paused : GamePhase.active,
      );
    }
    if (action is BasketballQuarterAdvanced) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final next = SportModuleUtils.asInt(sportSpecific['currentPeriod']) + 1;
      final periodCount = SportModuleUtils.asInt(sportSpecific['periodCount']);
      sportSpecific['currentPeriod'] = next;
      sportSpecific['remainingSeconds'] =
          SportModuleUtils.asInt(sportSpecific['periodDurationSeconds']);
      return gameState.copyWith(
        sportSpecific: sportSpecific,
        timerRunning: false,
        gamePhase: next > periodCount ? GamePhase.completed : GamePhase.periodBreak,
      );
    }
    if (action is BasketballTeamFoulRecorded) {
      gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
        return SportModuleUtils.incrementStat(team, 'fouls');
      });
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: 'foul',
        teamId: action.teamId,
      );
    }
    if (action is BasketballPossessionChanged) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      sportSpecific['possessionTeamId'] = action.teamId;
      return gameState.copyWith(sportSpecific: sportSpecific);
    }
    if (action is BasketballTimeoutUsed) {
      gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
        final stats = Map<String, dynamic>.from(team.stats);
        final remaining = SportModuleUtils.asInt(stats['timeoutsRemaining']);
        if (remaining > 0) {
          stats['timeoutsRemaining'] = remaining - 1;
        }
        return team.copyWith(stats: stats);
      });
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: 'timeout',
        teamId: action.teamId,
      );
    }
    if (action is SportScoreEdited) {
      return SportModuleUtils.applyScoreEdit(
        gameState,
        action.homeScore,
        action.awayScore,
      );
    }
    if (action is SportPeriodEdited) {
      return SportModuleUtils.applyPeriodEdit(
        gameState,
        'currentPeriod',
        action.period,
      );
    }
    if (action is SportClockEdited) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      sportSpecific['remainingSeconds'] = action.remainingSeconds;
      return gameState.copyWith(sportSpecific: sportSpecific);
    }
    if (action is BasketballTeamScored || action is BasketballPlayerScored) {
      final teamId = action is BasketballTeamScored ? action.teamId : (action as BasketballPlayerScored).teamId;
      final scoreType = action is BasketballTeamScored ? action.scoreType : (action as BasketballPlayerScored).scoreType;
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final period = SportModuleUtils.asInt(sportSpecific['currentPeriod']) - 1;
      var delta = 1;
      gameState = SportModuleUtils.updateTeam(gameState, teamId, (team) {
        var updated = team;
        final stats = Map<String, dynamic>.from(team.stats);
        switch (scoreType) {
          case '3pt':
            delta = 3;
            stats['fieldGoalsMade'] =
                SportModuleUtils.asInt(stats['fieldGoalsMade']) + 1;
            stats['fieldGoalsAttempted'] =
                SportModuleUtils.asInt(stats['fieldGoalsAttempted']) + 1;
            stats['threesMade'] =
                SportModuleUtils.asInt(stats['threesMade']) + 1;
            stats['threesAttempted'] =
                SportModuleUtils.asInt(stats['threesAttempted']) + 1;
            break;
          case '2pt':
            delta = 2;
            stats['fieldGoalsMade'] =
                SportModuleUtils.asInt(stats['fieldGoalsMade']) + 1;
            stats['fieldGoalsAttempted'] =
                SportModuleUtils.asInt(stats['fieldGoalsAttempted']) + 1;
            break;
          case 'ft':
            delta = 1;
            stats['ftMade'] = SportModuleUtils.asInt(stats['ftMade']) + 1;
            stats['ftAttempted'] =
                SportModuleUtils.asInt(stats['ftAttempted']) + 1;
            break;
        }
        updated = updated.copyWith(score: team.score + delta, stats: stats);
        updated = SportModuleUtils.incrementSegmentScore(
          updated,
          'quarterScores',
          period,
          delta,
        );
        if (action is BasketballPlayerScored) {
          updated = SportModuleUtils.incrementPlayerStat(
            updated,
            action.playerId,
            'points',
            by: delta,
          );
        }
        return updated;
      });
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: scoreType,
        teamId: teamId,
        pointsDelta: delta,
        playerId: action is BasketballPlayerScored ? action.playerId : null,
      );
    }
    if (action is BasketballPlayerStatRecorded) {
      gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
        return SportModuleUtils.incrementPlayerStat(
          team,
          action.playerId,
          action.statKey,
        );
      });
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: action.statKey,
        teamId: action.teamId,
        playerId: action.playerId,
      );
    }
    return gameState;
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
      config: {'hasTimer': true, 'periodCount': 4},
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
