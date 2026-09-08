sealed class ScoreAction {
  const ScoreAction();
}

class CustomRoundScoreEntered extends ScoreAction {
  const CustomRoundScoreEntered({
    required this.playerId,
    required this.value,
    required this.roundNumber,
  });

  final String playerId;
  final int value;
  final int roundNumber;
}

class DartThrown extends ScoreAction {
  const DartThrown({required this.score, required this.multiplier});

  final int score;
  final int multiplier;
}

class YahtzeeScoreSelected extends ScoreAction {
  const YahtzeeScoreSelected({
    required this.playerId,
    required this.category,
    this.manualScore,
    this.yahtzeeBonus = false,
  });

  final String playerId;
  final dynamic category;

  /// When set, bypasses dice-based computation and uses this score directly.
  final int? manualScore;

  /// True when the player rolled a Yahtzee bonus (already has 50 in Yahtzee box).
  final bool yahtzeeBonus;
}

class GolfHoleScoreEntered extends ScoreAction {
  const GolfHoleScoreEntered({
    required this.playerId,
    required this.hole,
    required this.strokes,
  });

  final String playerId;
  final int hole;
  final int strokes;
}

class CribbagePointsScored extends ScoreAction {
  const CribbagePointsScored({required this.playerId, required this.points});

  final String playerId;
  final int points;
}

class BowlingRollEntered extends ScoreAction {
  const BowlingRollEntered({required this.pins});

  final int pins;
}

class FarkleBankScore extends ScoreAction {
  const FarkleBankScore({required this.turnScore});

  final int turnScore;
}

class FarkleFarkled extends ScoreAction {
  const FarkleFarkled();
}

class UnoRoundScoreEntered extends ScoreAction {
  const UnoRoundScoreEntered({required this.playerId, required this.points});

  final String playerId;
  final int points;
}

class DominoesRoundScoreEntered extends ScoreAction {
  const DominoesRoundScoreEntered({required this.playerId, required this.pips});

  final String playerId;
  final int pips;
}

// ─── Baseball ─────────────────────────────────────────────────────────────────

/// Records a single in-game event for a baseball team (run, out, hit, etc.).
class BaseballEventRecorded extends ScoreAction {
  const BaseballEventRecorded({required this.teamId, required this.eventType});

  /// 'home' or 'away'
  final String teamId;

  /// One of: 'run', 'out', 'hit', 'strikeout', 'ball', 'strike', 'error', 'walk'
  final String eventType;
}

/// Selects the game format for a baseball session.
class BaseballGameFormatSelected extends ScoreAction {
  const BaseballGameFormatSelected({required this.format});

  /// 'innings_1' through 'innings_9', or 'scrimmage'
  final String format;
}

/// Records a single pitch (ball or strike) thrown to the current batter.
class BaseballPitchRecorded extends ScoreAction {
  const BaseballPitchRecorded({required this.teamId, required this.pitchType});

  /// 'home' or 'away' — the team currently batting.
  final String teamId;

  /// 'ball' or 'strike'
  final String pitchType;
}

/// Records the outcome of a completed plate appearance for the current batter.
///
/// Advances the batting order, updates team/player stats, and — for outs —
/// advances the outs/half-inning/inning counters just like a paper scorebook.
class BaseballPlateAppearanceRecorded extends ScoreAction {
  const BaseballPlateAppearanceRecorded({
    required this.teamId,
    required this.result,
    this.rbi = 0,
    this.playerId,
  });

  /// 'home' or 'away' — the team currently batting.
  final String teamId;

  /// One of: 'single', 'double', 'triple', 'home_run', 'walk', 'strikeout', 'out'
  final String result;

  /// Runs batted in on this play (0 when none scored).
  final int rbi;

  /// Batting lineup player id, when a lineup has been entered for this team.
  final String? playerId;
}

/// Records a fielding error charged to a team (and optionally a player).
class BaseballErrorRecorded extends ScoreAction {
  const BaseballErrorRecorded({required this.teamId, this.playerId});

  /// 'home' or 'away' — the team charged with the error.
  final String teamId;

  /// Fielding lineup player id, when a lineup has been entered for this team.
  final String? playerId;
}

/// Manually sets the current batter for a team to a specific spot in the
/// lineup — used when the user picks a batter from the batting order (e.g.
/// after a substitution or to correct the auto-advanced order).
class BaseballBatterSet extends ScoreAction {
  const BaseballBatterSet({required this.teamId, required this.batterIndex});

  /// 'home' or 'away' — the team whose batter is being set.
  final String teamId;

  /// Zero-based index into that team's roster/batting order.
  final int batterIndex;
}

// ─── Basketball ───────────────────────────────────────────────────────────────

/// Records points scored by a team (basic mode).
class BasketballTeamScored extends ScoreAction {
  const BasketballTeamScored({required this.teamId, required this.scoreType});

  /// 'home' or 'away'
  final String teamId;

  /// '2pt', '3pt', or 'ft'
  final String scoreType;
}

/// Starts or pauses the game timer.
class BasketballTimerToggled extends ScoreAction {
  const BasketballTimerToggled();
}

/// Advances to the next quarter/period.
class BasketballQuarterAdvanced extends ScoreAction {
  const BasketballQuarterAdvanced();
}

/// Attributes a scoring play to a specific player (in-depth mode).
class BasketballPlayerScored extends ScoreAction {
  const BasketballPlayerScored({
    required this.playerId,
    required this.teamId,
    required this.scoreType,
  });

  final String playerId;
  final String teamId;

  /// '2pt', '3pt', or 'ft'
  final String scoreType;
}

/// Records a non-scoring player stat (rebound, foul, steal, etc.).
class BasketballPlayerStatRecorded extends ScoreAction {
  const BasketballPlayerStatRecorded({
    required this.playerId,
    required this.teamId,
    required this.statKey,
  });

  final String playerId;
  final String teamId;

  /// 'rebound', 'foul', 'steal', 'block', 'turnover'
  final String statKey;
}

/// Records a team foul (not attributed to a specific player).
class BasketballTeamFoulRecorded extends ScoreAction {
  const BasketballTeamFoulRecorded({required this.teamId});

  final String teamId;
}

/// Changes which team currently has possession (possession arrow).
class BasketballPossessionChanged extends ScoreAction {
  const BasketballPossessionChanged({required this.teamId});

  final String teamId;
}

/// Records that a team used one of its remaining timeouts.
class BasketballTimeoutUsed extends ScoreAction {
  const BasketballTimeoutUsed({required this.teamId});

  final String teamId;
}

// ─── Football ─────────────────────────────────────────────────────────────────

/// Records a scoring play for a team.
class FootballTeamScored extends ScoreAction {
  const FootballTeamScored({required this.teamId, required this.scoreType});

  final String teamId;

  /// 'touchdown', 'extra_point', 'two_point_conv', 'field_goal', 'safety'
  final String scoreType;
}

/// Advances the current down.
class FootballDownAdvanced extends ScoreAction {
  const FootballDownAdvanced({required this.yardsGained});

  final int yardsGained;
}

/// Manually corrects the current down (1st/2nd/3rd/4th) without affecting yardage.
class FootballDownSet extends ScoreAction {
  const FootballDownSet({required this.down});

  final int down;
}

/// Advances to the next quarter.
class FootballQuarterAdvanced extends ScoreAction {
  const FootballQuarterAdvanced();
}

/// Attributes a scoring play to a specific player (in-depth mode).
class FootballPlayerScored extends ScoreAction {
  const FootballPlayerScored({
    required this.playerId,
    required this.teamId,
    required this.scoreType,
  });

  final String playerId;
  final String teamId;

  /// 'touchdown', 'extra_point', 'two_point_conv', 'field_goal', 'safety'
  final String scoreType;
}

/// Records a player-level stat in in-depth mode.
class FootballPlayerStatRecorded extends ScoreAction {
  const FootballPlayerStatRecorded({
    required this.playerId,
    required this.teamId,
    required this.statKey,
    required this.value,
  });

  final String playerId;
  final String teamId;

  /// 'passingYards', 'rushingYards', 'receivingYards', 'touchdown'
  final String statKey;
  final int value;
}

// ─── Soccer ───────────────────────────────────────────────────────────────────

/// Records a goal for a team (basic mode).
class SoccerGoalScored extends ScoreAction {
  const SoccerGoalScored({required this.teamId});

  final String teamId;
}

/// Toggles ball possession between teams.
class SoccerPossessionToggled extends ScoreAction {
  const SoccerPossessionToggled({required this.newPossessingTeamId});

  final String newPossessingTeamId;
}

/// Advances from first half → halftime → second half → full time.
class SoccerHalfAdvanced extends ScoreAction {
  const SoccerHalfAdvanced();
}

/// Records a goal with optional assist attribution (in-depth mode).
class SoccerGoalWithAssist extends ScoreAction {
  const SoccerGoalWithAssist({
    required this.teamId,
    required this.scorerPlayerId,
    this.assistPlayerId,
  });

  final String teamId;
  final String scorerPlayerId;
  final String? assistPlayerId;
}

// ─── Tennis ───────────────────────────────────────────────────────────────────

/// Records a point won by a team/player.
class TennisPointWon extends ScoreAction {
  const TennisPointWon({required this.teamId});

  final String teamId;
}

/// Records a game won (auto-derived, but can be dispatched explicitly).
class TennisGameWon extends ScoreAction {
  const TennisGameWon({required this.teamId});

  final String teamId;
}

/// Records a set won.
class TennisSetWon extends ScoreAction {
  const TennisSetWon({required this.teamId});

  final String teamId;
}

/// Records a point in a tiebreak.
class TennisTiebreakPointWon extends ScoreAction {
  const TennisTiebreakPointWon({required this.teamId});

  final String teamId;
}

/// Records a shot type in in-depth mode.
class TennisPlayerShotRecorded extends ScoreAction {
  const TennisPlayerShotRecorded({
    required this.playerId,
    required this.teamId,
    required this.shotType,
  });

  final String playerId;
  final String teamId;

  /// 'ace', 'double_fault', 'winner', 'forced_error', 'unforced_error'
  final String shotType;
}

// ─── Volleyball ───────────────────────────────────────────────────────────────

/// Records a point won (rally scoring).
class VolleyballPointWon extends ScoreAction {
  const VolleyballPointWon({required this.teamId});

  final String teamId;
}

/// Records a set won.
class VolleyballSetWon extends ScoreAction {
  const VolleyballSetWon({required this.teamId});

  final String teamId;
}

/// Records a serve change.
class VolleyballServingChanged extends ScoreAction {
  const VolleyballServingChanged({required this.newServingTeamId});

  final String newServingTeamId;
}

/// Records an in-depth player stat.
class VolleyballPlayerStatRecorded extends ScoreAction {
  const VolleyballPlayerStatRecorded({
    required this.playerId,
    required this.teamId,
    required this.statKey,
  });

  final String playerId;
  final String teamId;

  /// 'kill', 'block', 'ace', 'dig', 'error'
  final String statKey;
}

// ─── Hockey ───────────────────────────────────────────────────────────────────

/// Records a goal with optional primary/secondary assist.
class HockeyGoalScored extends ScoreAction {
  const HockeyGoalScored({
    required this.teamId,
    required this.scorerPlayerId,
    this.primaryAssistPlayerId,
    this.secondaryAssistPlayerId,
  });

  final String teamId;
  final String scorerPlayerId;
  final String? primaryAssistPlayerId;
  final String? secondaryAssistPlayerId;
}

/// Assesses a penalty on a player.
class HockeyPenaltyAssessed extends ScoreAction {
  const HockeyPenaltyAssessed({
    required this.teamId,
    required this.playerId,
    required this.penaltyType,
    required this.durationMinutes,
  });

  final String teamId;
  final String playerId;
  final String penaltyType;
  final int durationMinutes;
}

/// Advances to the next period (or overtime/shootout).
class HockeyPeriodAdvanced extends ScoreAction {
  const HockeyPeriodAdvanced();
}

// ─── Lacrosse ─────────────────────────────────────────────────────────────────

/// Records a goal with optional assist.
class LacrosseGoalScored extends ScoreAction {
  const LacrosseGoalScored({
    required this.teamId,
    required this.scorerPlayerId,
    this.assistPlayerId,
  });

  final String teamId;
  final String scorerPlayerId;
  final String? assistPlayerId;
}

/// Records a ground ball won by a player.
class LacrosseGroundBallWon extends ScoreAction {
  const LacrosseGroundBallWon({required this.teamId, required this.playerId});

  final String teamId;
  final String playerId;
}

/// Records a clear attempt.
class LacrosseClearAttempted extends ScoreAction {
  const LacrosseClearAttempted({
    required this.teamId,
    required this.successful,
  });

  final String teamId;
  final bool successful;
}

// ─── Shared Sport Actions ─────────────────────────────────────────────────────

/// Starts the game timer.
class SportTimerStarted extends ScoreAction {
  const SportTimerStarted();
}

/// Pauses the game timer.
class SportTimerPaused extends ScoreAction {
  const SportTimerPaused();
}

/// Resets the game timer to zero.
class SportTimerReset extends ScoreAction {
  const SportTimerReset();
}

/// Finalizes the game and transitions to [GamePhase.completed].
class SportGameEnded extends ScoreAction {
  const SportGameEnded();
}

/// Updates the free-form notes for the current game session.
class SportNoteUpdated extends ScoreAction {
  const SportNoteUpdated({required this.content});

  final String content;
}

/// Manually overrides the home/away team scores (correction after a
/// misrecorded play). Shared across all non-baseball sport modules.
class SportScoreEdited extends ScoreAction {
  const SportScoreEdited({required this.homeScore, required this.awayScore});

  final int homeScore;
  final int awayScore;
}

/// Manually overrides the current period/quarter/half/set number. Shared
/// across all non-baseball sport modules.
class SportPeriodEdited extends ScoreAction {
  const SportPeriodEdited({required this.period});

  final int period;
}

/// Manually overrides the remaining countdown clock time, in seconds.
/// Used by sports with a countdown period clock (basketball, football,
/// hockey, lacrosse).
class SportClockEdited extends ScoreAction {
  const SportClockEdited({required this.remainingSeconds});

  final int remainingSeconds;
}
