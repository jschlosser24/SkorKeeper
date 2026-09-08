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
import 'hockey_state.dart';

class HockeyModule implements GameModule {
  const HockeyModule();

  @override
  String get gameTypeId => 'sport_hockey';

  @override
  String get displayName => 'Hockey';

  @override
  String get description => 'Goals, assists, penalties, and overtime tracking.';

  @override
  String get iconAsset => 'sports_hockey';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 2;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return SportModuleUtils.initialState(
      sportType: SportType.hockey,
      gameFormat: 'full',
      trackingMode: TrackingMode.inDepth,
      sportSpecific: HockeyStateHelper.initial(),
      homeStats: HockeyStateHelper.initialTeamStats(),
      awayStats: HockeyStateHelper.initialTeamStats(),
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
    if (action is HockeyPenaltyAssessed) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final penalties = SportModuleUtils.mapList(sportSpecific['activePenalties']);
      penalties.add({
        'teamId': action.teamId,
        'playerId': action.playerId,
        'type': action.penaltyType,
        'durationMinutes': action.durationMinutes,
        'startedAtSeconds': gameState.elapsedSeconds,
      });
      sportSpecific['activePenalties'] = penalties;
      gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
        return SportModuleUtils.incrementStat(
          team,
          'penaltyMinutes',
          by: action.durationMinutes,
        );
      });
      return SportModuleUtils.appendEvent(
        gameState.copyWith(sportSpecific: sportSpecific),
        eventType: 'penalty_start',
        teamId: action.teamId,
        playerId: action.playerId,
        metadata: {
          'type': action.penaltyType,
          'durationMinutes': action.durationMinutes,
        },
      );
    }
    if (action is HockeyGoalScored) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final period = SportModuleUtils.asInt(sportSpecific['currentPeriod']) - 1;
      gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
        var updated = team.copyWith(score: team.score + 1);
        updated = SportModuleUtils.incrementStat(updated, 'goals');
        updated = SportModuleUtils.incrementSegmentScore(
          updated,
          'periodScores',
          period,
          1,
        );
        updated = SportModuleUtils.incrementPlayerStat(
          updated,
          action.scorerPlayerId,
          'goals',
        );
        if (action.primaryAssistPlayerId != null) {
          updated = SportModuleUtils.incrementPlayerStat(
            updated,
            action.primaryAssistPlayerId!,
            'assists',
          );
        }
        if (action.secondaryAssistPlayerId != null) {
          updated = SportModuleUtils.incrementPlayerStat(
            updated,
            action.secondaryAssistPlayerId!,
            'assists',
          );
        }
        return updated;
      });
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: 'goal',
        teamId: action.teamId,
        pointsDelta: 1,
        playerId: action.scorerPlayerId,
        metadata: {
          'assistPlayerId': action.primaryAssistPlayerId,
          'secondaryAssistPlayerId': action.secondaryAssistPlayerId,
          'period': SportModuleUtils.asInt(sportSpecific['currentPeriod']),
        },
      );
    }
    if (action is HockeyPeriodAdvanced) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final currentPeriod = SportModuleUtils.asInt(sportSpecific['currentPeriod']);
      if (currentPeriod < 3) {
        sportSpecific['currentPeriod'] = currentPeriod + 1;
        sportSpecific['remainingSeconds'] =
            SportModuleUtils.asInt(sportSpecific['periodDurationSeconds']);
        return gameState.copyWith(
          sportSpecific: sportSpecific,
          gamePhase: GamePhase.periodBreak,
          timerRunning: false,
        );
      }
      if (!(sportSpecific['isOvertime'] as bool? ?? false)) {
        sportSpecific['isOvertime'] = true;
        sportSpecific['remainingSeconds'] =
            SportModuleUtils.asInt(sportSpecific['periodDurationSeconds']);
        return gameState.copyWith(
          sportSpecific: sportSpecific,
          gamePhase: GamePhase.periodBreak,
          timerRunning: false,
        );
      }
      if (!(sportSpecific['isShootout'] as bool? ?? false)) {
        sportSpecific['isShootout'] = true;
        sportSpecific['remainingSeconds'] =
            SportModuleUtils.asInt(sportSpecific['periodDurationSeconds']);
        return gameState.copyWith(
          sportSpecific: sportSpecific,
          gamePhase: GamePhase.periodBreak,
          timerRunning: false,
        );
      }
      return gameState.copyWith(gamePhase: GamePhase.completed, timerRunning: false);
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
      config: {'hasTimer': true, 'hasOvertime': true},
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
