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
import 'volleyball_state.dart';

class VolleyballModule implements GameModule {
  const VolleyballModule();

  @override
  String get gameTypeId => 'sport_volleyball';

  @override
  String get displayName => 'Volleyball';

  @override
  String get description => 'Rally scoring with set tracking and serving.';

  @override
  String get iconAsset => 'sports_volleyball';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 2;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return SportModuleUtils.initialState(
      sportType: SportType.volleyball,
      gameFormat: 'best_of_5',
      trackingMode: TrackingMode.basic,
      sportSpecific: VolleyballStateHelper.initial(),
      homeStats: VolleyballStateHelper.initialTeamStats(),
      awayStats: VolleyballStateHelper.initialTeamStats(),
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
    if (action is VolleyballServingChanged) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      sportSpecific['servingTeamId'] = action.newServingTeamId;
      return gameState.copyWith(sportSpecific: sportSpecific);
    }
    if (action is VolleyballPlayerStatRecorded) {
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
    if (action is VolleyballPointWon || action is VolleyballSetWon) {
      final teamId =
          action is VolleyballPointWon ? action.teamId : (action as VolleyballSetWon).teamId;
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final receivingTeamWon =
          SportModuleUtils.asString(sportSpecific['servingTeamId']) != teamId;
      if (receivingTeamWon) {
        sportSpecific['servingTeamId'] = teamId;
      }
      if (action is VolleyballPointWon) {
        gameState = SportModuleUtils.updateTeam(gameState, teamId, (team) {
          final updated = team.copyWith(score: team.score + 1);
          return SportModuleUtils.incrementStat(updated, 'totalPoints');
        });
      }
      final homeScore = gameState.homeTeam.score;
      final awayScore = gameState.awayTeam.score;
      final currentSet = SportModuleUtils.asInt(sportSpecific['currentSet']);
      final targetPoints = SportModuleUtils.asInt(sportSpecific['pointsToWin'] ?? 25);
      final finalSetBonus = currentSet == SportModuleUtils.asInt(sportSpecific['targetSets']) * 2 - 1;
      final effectiveTarget = finalSetBonus && targetPoints > 15 ? 15 : targetPoints;
      final teamScore = teamId == 'home' ? homeScore : awayScore;
      final opponentScore = teamId == 'home' ? awayScore : homeScore;
      if (action is VolleyballSetWon ||
          (teamScore >= effectiveTarget && (teamScore - opponentScore) >= 2)) {
        final setScores = SportModuleUtils.mapList(sportSpecific['setScores']);
        setScores.add({'set': currentSet, 'home': homeScore, 'away': awayScore});
        sportSpecific['setScores'] = setScores;
        sportSpecific['currentSet'] = currentSet + 1;
        gameState = SportModuleUtils.updateTeam(gameState, teamId, (team) {
          final stats = Map<String, dynamic>.from(team.stats);
          stats['setsWon'] = SportModuleUtils.asInt(stats['setsWon']) + 1;
          stats['setScores'] = setScores;
          return team.copyWith(score: 0, stats: stats);
        });
        gameState = gameState.copyWith(
          homeTeam: gameState.homeTeam.copyWith(score: 0),
          awayTeam: gameState.awayTeam.copyWith(score: 0),
        );
        final winnerSets = SportModuleUtils.asInt(
          SportModuleUtils.teamFor(gameState, teamId).stats['setsWon'],
        );
        if (winnerSets >= SportModuleUtils.asInt(sportSpecific['targetSets'])) {
          gameState = gameState.copyWith(gamePhase: GamePhase.completed);
        }
      }
      return SportModuleUtils.appendEvent(
        gameState.copyWith(sportSpecific: sportSpecific),
        eventType: action is VolleyballSetWon ? 'set_won' : 'point_won',
        teamId: teamId,
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
      config: {'hasServingIndicator': true},
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
