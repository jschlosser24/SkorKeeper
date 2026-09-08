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
import 'soccer_state.dart';

class SoccerModule implements GameModule {
  const SoccerModule();

  @override
  String get gameTypeId => 'sport_soccer';

  @override
  String get displayName => 'Soccer';

  @override
  String get description => 'Track goals, halves, and possession.';

  @override
  String get iconAsset => 'sports_soccer';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 2;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return SportModuleUtils.initialState(
      sportType: SportType.soccer,
      gameFormat: 'full',
      trackingMode: TrackingMode.basic,
      sportSpecific: SoccerStateHelper.initial(),
      homeStats: SoccerStateHelper.initialTeamStats(),
      awayStats: SoccerStateHelper.initialTeamStats(),
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
    if (action is SoccerPossessionToggled) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      sportSpecific['possessingTeamId'] = action.newPossessingTeamId;
      return SportModuleUtils.appendEvent(
        gameState.copyWith(sportSpecific: sportSpecific),
        eventType: 'possession_toggle',
        teamId: action.newPossessingTeamId,
        metadata: {'newPossessingTeam': action.newPossessingTeamId},
      );
    }
    if (action is SoccerHalfAdvanced) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final current = SportModuleUtils.asInt(sportSpecific['currentHalf']);
      if (gameState.gamePhase == GamePhase.halftimeBreak) {
        sportSpecific['currentHalf'] = 2;
        return gameState.copyWith(
          sportSpecific: sportSpecific,
          gamePhase: GamePhase.active,
        );
      }
      if (current == 1) {
        return gameState.copyWith(
          gamePhase: GamePhase.halftimeBreak,
          timerRunning: false,
        );
      }
      return gameState.copyWith(
        sportSpecific: sportSpecific,
        gamePhase: GamePhase.completed,
        timerRunning: false,
      );
    }
    if (action is SoccerGoalScored || action is SoccerGoalWithAssist) {
      final teamId = action is SoccerGoalScored ? action.teamId : (action as SoccerGoalWithAssist).teamId;
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final halfIndex = SportModuleUtils.asInt(sportSpecific['currentHalf']) - 1;
      gameState = SportModuleUtils.updateTeam(gameState, teamId, (team) {
        var updated = team.copyWith(score: team.score + 1);
        updated = SportModuleUtils.incrementStat(updated, 'goals');
        updated = SportModuleUtils.incrementSegmentScore(
          updated,
          'halfScores',
          halfIndex,
          1,
        );
        if (action is SoccerGoalWithAssist) {
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
        }
        return updated;
      });
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: 'goal',
        teamId: teamId,
        pointsDelta: 1,
        playerId: action is SoccerGoalWithAssist ? action.scorerPlayerId : null,
        metadata: action is SoccerGoalWithAssist
            ? {
                'assistPlayerId': action.assistPlayerId,
                'period': SportModuleUtils.asInt(sportSpecific['currentHalf']),
              }
            : null,
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
      config: {'hasPossessionToggle': true, 'hasTimer': true},
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
