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
import 'lacrosse_state.dart';

class LacrosseModule implements GameModule {
  const LacrosseModule();

  @override
  String get gameTypeId => 'sport_lacrosse';

  @override
  String get displayName => 'Lacrosse';

  @override
  String get description => 'Goals, clears, ground balls, and quarter play.';

  @override
  String get iconAsset => 'sports';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 2;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return SportModuleUtils.initialState(
      sportType: SportType.lacrosse,
      gameFormat: 'full',
      trackingMode: TrackingMode.inDepth,
      sportSpecific: LacrosseStateHelper.initial(),
      homeStats: LacrosseStateHelper.initialTeamStats(),
      awayStats: LacrosseStateHelper.initialTeamStats(),
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
        'currentQuarter',
        action.period,
      );
    }
    if (action is SportClockEdited) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      sportSpecific['remainingSeconds'] = action.remainingSeconds;
      return gameState.copyWith(sportSpecific: sportSpecific);
    }
    if (action is LacrosseGoalScored) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final quarter = SportModuleUtils.asInt(sportSpecific['currentQuarter']) - 1;
      gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
        var updated = team.copyWith(score: team.score + 1);
        updated = SportModuleUtils.incrementStat(updated, 'goals');
        updated = SportModuleUtils.incrementSegmentScore(
          updated,
          'quarterScores',
          quarter,
          1,
        );
        updated = SportModuleUtils.incrementPlayerStat(
          updated,
          action.scorerPlayerId,
          'goals',
        );
        if (action.assistPlayerId != null) {
          updated = SportModuleUtils.incrementPlayerStat(
            updated,
            action.assistPlayerId!,
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
        metadata: {'assistPlayerId': action.assistPlayerId},
      );
    }
    if (action is LacrosseGroundBallWon) {
      gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
        var updated = SportModuleUtils.incrementStat(team, 'groundBalls');
        updated = SportModuleUtils.incrementPlayerStat(
          updated,
          action.playerId,
          'groundBalls',
        );
        return updated;
      });
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: 'ground_ball',
        teamId: action.teamId,
        playerId: action.playerId,
      );
    }
    if (action is LacrosseClearAttempted) {
      final key = action.successful ? 'clearsSuccessful' : 'clearsFailed';
      gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
        return SportModuleUtils.incrementStat(team, key);
      });
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: action.successful ? 'clear_success' : 'clear_fail',
        teamId: action.teamId,
      );
    }
    if (action is FootballQuarterAdvanced) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final next = SportModuleUtils.asInt(sportSpecific['currentQuarter']) + 1;
      sportSpecific['currentQuarter'] = next;
      sportSpecific['remainingSeconds'] =
          SportModuleUtils.asInt(sportSpecific['periodDurationSeconds']);
      return gameState.copyWith(
        sportSpecific: sportSpecific,
        timerRunning: false,
        gamePhase: next > 4 ? GamePhase.completed : GamePhase.periodBreak,
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
