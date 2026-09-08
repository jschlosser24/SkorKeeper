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
import 'tennis_state.dart';

class TennisModule implements GameModule {
  const TennisModule();

  @override
  String get gameTypeId => 'sport_tennis';

  @override
  String get displayName => 'Tennis';

  @override
  String get description => 'Track points, games, sets, and tiebreaks.';

  @override
  String get iconAsset => 'sports_tennis';

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 2;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return SportModuleUtils.initialState(
      sportType: SportType.tennis,
      gameFormat: 'best_of_3',
      trackingMode: TrackingMode.basic,
      sportSpecific: TennisStateHelper.initial(),
      homeStats: TennisStateHelper.initialTeamStats(),
      awayStats: TennisStateHelper.initialTeamStats(),
      players: players,
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    return SportGameState.fromJson(json);
  }

  SportGameState _afterGameWon(SportGameState gameState, String teamId) {
    final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
    var homeGames = SportModuleUtils.asInt(sportSpecific['homeGamesThisSet']);
    var awayGames = SportModuleUtils.asInt(sportSpecific['awayGamesThisSet']);
    if (teamId == 'home') {
      homeGames++;
    } else {
      awayGames++;
    }
    sportSpecific['homeGamesThisSet'] = homeGames;
    sportSpecific['awayGamesThisSet'] = awayGames;
    sportSpecific['homePoints'] = 0;
    sportSpecific['awayPoints'] = 0;
    var updated = SportModuleUtils.updateTeam(gameState, teamId, (team) {
      return SportModuleUtils.incrementStat(team, 'totalGamesWon');
    });
    final setWon = (homeGames >= 6 || awayGames >= 6) &&
        (homeGames - awayGames).abs() >= 2;
    final tiebreak = homeGames == 6 && awayGames == 6;
    if (setWon) {
      updated = _afterSetWon(updated, teamId);
      sportSpecific['homeGamesThisSet'] = 0;
      sportSpecific['awayGamesThisSet'] = 0;
      sportSpecific['isTiebreak'] = false;
      sportSpecific['homeTiebreakPoints'] = 0;
      sportSpecific['awayTiebreakPoints'] = 0;
    } else {
      sportSpecific['isTiebreak'] = tiebreak;
    }
    return updated.copyWith(sportSpecific: sportSpecific);
  }

  SportGameState _afterSetWon(SportGameState gameState, String teamId) {
    final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
    final currentSet = SportModuleUtils.asInt(sportSpecific['currentSet']);
    final homeGames = SportModuleUtils.asInt(sportSpecific['homeGamesThisSet']);
    final awayGames = SportModuleUtils.asInt(sportSpecific['awayGamesThisSet']);
    final setScores = SportModuleUtils.mapList(sportSpecific['setScores']);
    setScores.add({'set': currentSet, 'home': homeGames, 'away': awayGames});
    sportSpecific['setScores'] = setScores;
    sportSpecific['currentSet'] = currentSet + 1;
    final updated = SportModuleUtils.updateTeam(gameState, teamId, (team) {
      final stats = Map<String, dynamic>.from(team.stats);
      stats['setsWon'] = SportModuleUtils.asInt(stats['setsWon']) + 1;
      stats['setScores'] = setScores;
      return team.copyWith(score: SportModuleUtils.asInt(stats['setsWon']), stats: stats);
    });
    final targetSets = SportModuleUtils.asInt(sportSpecific['targetSets']);
    final winnerSets = SportModuleUtils.asInt(
      SportModuleUtils.teamFor(updated, teamId).stats['setsWon'],
    );
    if (winnerSets >= targetSets) {
      return updated.copyWith(
        sportSpecific: sportSpecific,
        gamePhase: GamePhase.completed,
      );
    }
    return updated.copyWith(sportSpecific: sportSpecific);
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
    if (action is TennisPlayerShotRecorded) {
      gameState = SportModuleUtils.updateTeam(gameState, action.teamId, (team) {
        return SportModuleUtils.incrementPlayerStat(
          team,
          action.playerId,
          action.shotType,
        );
      });
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: action.shotType,
        teamId: action.teamId,
        playerId: action.playerId,
      );
    }
    if (action is TennisSetWon) {
      return _afterSetWon(gameState, action.teamId);
    }
    if (action is TennisGameWon) {
      return _afterGameWon(gameState, action.teamId);
    }
    if (action is TennisTiebreakPointWon) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      final homeKey = action.teamId == 'home'
          ? 'homeTiebreakPoints'
          : 'awayTiebreakPoints';
      sportSpecific[homeKey] = SportModuleUtils.asInt(sportSpecific[homeKey]) + 1;
      final homePoints = SportModuleUtils.asInt(sportSpecific['homeTiebreakPoints']);
      final awayPoints = SportModuleUtils.asInt(sportSpecific['awayTiebreakPoints']);
      gameState = gameState.copyWith(
        sportSpecific: sportSpecific,
        gamePhase: GamePhase.tiebreakActive,
      );
      if ((homePoints >= 7 || awayPoints >= 7) &&
          (homePoints - awayPoints).abs() >= 2) {
        return _afterSetWon(gameState, action.teamId);
      }
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: 'tiebreak_point',
        teamId: action.teamId,
      );
    }
    if (action is TennisPointWon) {
      final sportSpecific = SportModuleUtils.mapCopy(gameState.sportSpecific);
      if ((sportSpecific['isTiebreak'] as bool? ?? false)) {
        return applyAction(gameState, TennisTiebreakPointWon(teamId: action.teamId));
      }
      final homePoints = action.teamId == 'home'
          ? SportModuleUtils.asInt(sportSpecific['homePoints']) + 1
          : SportModuleUtils.asInt(sportSpecific['homePoints']);
      final awayPoints = action.teamId == 'away'
          ? SportModuleUtils.asInt(sportSpecific['awayPoints']) + 1
          : SportModuleUtils.asInt(sportSpecific['awayPoints']);
      sportSpecific['homePoints'] = homePoints;
      sportSpecific['awayPoints'] = awayPoints;
      gameState = gameState.copyWith(sportSpecific: sportSpecific);
      if ((homePoints >= 4 || awayPoints >= 4) &&
          (homePoints - awayPoints).abs() >= 2) {
        return _afterGameWon(gameState, action.teamId);
      }
      return SportModuleUtils.appendEvent(
        gameState,
        eventType: 'point_won',
        teamId: action.teamId,
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
      config: {'hasServingIndicator': true, 'supportsTiebreak': true},
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
