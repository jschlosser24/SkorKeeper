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
import 'football_state.dart';

class FootballModule implements GameModule {
  const FootballModule();

  @override
  String get gameTypeId => 'sport_football';

  @override
  String get displayName => 'Football';

  @override
  String get description => 'Track scoring plays, downs, and quarters.';

  @override
  String get iconAsset => 'sports_football';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 2;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return SportModuleUtils.initialState(
      sportType: SportType.football,
      gameFormat: 'full',
      trackingMode: TrackingMode.basic,
      sportSpecific: FootballStateHelper.initial(),
      homeStats: FootballStateHelper.initialTeamStats(),
      awayStats: FootballStateHelper.initialTeamStats(),
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
      return gameState.copyWith(
        gamePhase: GamePhase.completed,
        timerRunning: false,
      );
    }
    if (action is SportTimerStarted) {
      return gameState.copyWith(
        timerRunning: true,
        gamePhase: GamePhase.active,
      );
    }
    if (action is SportTimerPaused) {
      return gameState.copyWith(
        timerRunning: false,
        gamePhase: GamePhase.paused,
      );
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
    if (action is FootballTeamScored || action is FootballPlayerScored) {
      final teamId = action is FootballTeamScored ? action.teamId : (action as FootballPlayerScored).teamId;
      final scoreType = action is FootballTeamScored ? action.scoreType : (action as FootballPlayerScored).scoreType;
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final periodIndex =
          SportModuleUtils.asInt(sportSpecific['currentPeriod']) - 1;
      var delta = 0;
      gameState = SportModuleUtils.updateTeam(gameState, teamId, (team) {
        var updated = team;
        switch (scoreType) {
          case 'touchdown':
            delta = 6;
            updated = SportModuleUtils.incrementStat(updated, 'touchdowns');
            break;
          case 'extra_point':
            delta = 1;
            break;
          case 'two_point_conv':
            delta = 2;
            break;
          case 'field_goal':
            delta = 3;
            updated = SportModuleUtils.incrementStat(updated, 'fieldGoals');
            break;
          case 'safety':
            delta = 2;
            updated = SportModuleUtils.incrementStat(updated, 'safeties');
            break;
        }
        updated = updated.copyWith(score: team.score + delta);
        updated = SportModuleUtils.incrementSegmentScore(
          updated,
          'quarterScores',
          periodIndex,
          delta,
        );
        if (action is FootballPlayerScored) {
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
        playerId: action is FootballPlayerScored ? action.playerId : null,
      );
    }
    if (action is FootballDownAdvanced) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final currentDown = SportModuleUtils.asInt(sportSpecific['currentDown']);
      final yardsToGo = SportModuleUtils.asInt(sportSpecific['yardsToGo']);
      if (action.yardsGained >= yardsToGo) {
        sportSpecific['currentDown'] = 1;
        sportSpecific['yardsToGo'] = 10;
        final teamId = SportModuleUtils.asString(
          sportSpecific['possessingTeamId'],
          fallback: 'home',
        );
        gameState = SportModuleUtils.updateTeam(gameState, teamId, (team) {
          return SportModuleUtils.incrementStat(team, 'firstDowns');
        });
      } else if (currentDown >= 4) {
        sportSpecific['currentDown'] = 1;
        sportSpecific['yardsToGo'] = 10;
        sportSpecific['possessingTeamId'] =
            SportModuleUtils.asString(sportSpecific['possessingTeamId']) ==
                'home'
            ? 'away'
            : 'home';
      } else {
        sportSpecific['currentDown'] = currentDown + 1;
        sportSpecific['yardsToGo'] = yardsToGo - action.yardsGained;
      }
      return SportModuleUtils.appendEvent(
        gameState.copyWith(sportSpecific: sportSpecific),
        eventType: 'down_advance',
        teamId: SportModuleUtils.asString(
          sportSpecific['possessingTeamId'],
          fallback: 'home',
        ),
        metadata: {'yardsGained': action.yardsGained},
      );
    }
    if (action is FootballDownSet) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      sportSpecific['currentDown'] = action.down.clamp(1, 4);
      return gameState.copyWith(sportSpecific: sportSpecific);
    }
    if (action is FootballQuarterAdvanced) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final next = SportModuleUtils.asInt(sportSpecific['currentPeriod']) + 1;
      final periodCount = SportModuleUtils.asInt(sportSpecific['periodCount']);
      sportSpecific['currentPeriod'] = next;
      sportSpecific['remainingSeconds'] = SportModuleUtils.asInt(
        sportSpecific['periodDurationSeconds'],
      );
      return gameState.copyWith(
        sportSpecific: sportSpecific,
        timerRunning: false,
        gamePhase: next > periodCount
            ? GamePhase.completed
            : GamePhase.periodBreak,
      );
    }
    if (action is FootballPlayerStatRecorded) {
      gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
        return SportModuleUtils.incrementPlayerStat(
          team,
          action.playerId,
          action.statKey,
          by: action.value,
        );
      });
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: action.statKey,
        teamId: action.teamId,
        playerId: action.playerId,
        metadata: {'value': action.value},
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
      config: {'hasTimer': true, 'periodCount': 4, 'hasDownTracking': true},
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
