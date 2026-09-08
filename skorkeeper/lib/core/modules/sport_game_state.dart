import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_module_state.dart';
import 'sport_enums.dart';

part 'sport_game_state.freezed.dart';
part 'sport_game_state.g.dart';

// ─── SportPlayer ──────────────────────────────────────────────────────────────

/// An individual player within a sport team (in-depth mode only).
@freezed
abstract class SportPlayer with _$SportPlayer {
  const factory SportPlayer({
    /// UUID generated at setup.
    required String id,
    required String name,

    /// Optional jersey number string (1–3 digits).
    String? number,

    /// Per-player sport-specific stats keyed by stat name.
    ///
    /// Basketball: {points, rebounds, assists, steals, blocks, fouls}
    /// Football:   {passingYards, rushingYards, receivingYards, touchdowns}
    /// Soccer:     {goals, assists}
    /// Tennis:     {aces, doubleFaults, winners}
    /// Volleyball: {kills, blocks, aces}
    /// Hockey:     {goals, assists, penaltyMinutes}
    /// Lacrosse:   {goals, groundBalls, clears}
    @Default(<String, dynamic>{}) Map<String, dynamic> stats,
  }) = _SportPlayer;

  factory SportPlayer.fromJson(Map<String, dynamic> json) =>
      _$SportPlayerFromJson(json);
}

// ─── SportTeam ────────────────────────────────────────────────────────────────

/// A competing team within a sport game session.
@freezed
abstract class SportTeam with _$SportTeam {
  const factory SportTeam({
    /// 'home' or 'away'
    required String id,

    /// User-entered team name (1–40 characters).
    required String name,

    /// Current accumulated game score.
    @Default(0) int score,

    /// Player roster — null in basic mode; populated in in-depth mode.
    List<SportPlayer>? roster,

    /// Aggregated sport-specific team stats.
    ///
    /// Baseball:   {hits, errors, strikeouts, walks, earnedRuns, atBats,
    ///              inningScores: []}
    /// Basketball: {fieldGoalsMade, fieldGoalsAttempted, threesMade,
    ///              threesAttempted, ftMade, ftAttempted, quarterScores: []}
    /// Football:   {totalYards, touchdowns, firstDowns, fieldGoals, safeties,
    ///              quarterScores: []}
    /// Soccer:     {goals, halfScores: [], possessionSeconds}
    /// Tennis:     {setsWon, totalGamesWon, setScores: []}
    /// Volleyball: {setsWon, totalPoints, setScores: []}
    /// Hockey:     {goals, assists, penaltyMinutes, periodScores: [],
    ///              shotsOnGoal}
    /// Lacrosse:   {goals, assists, groundBalls, clearsSuccessful,
    ///              clearsFailed, quarterScores: []}
    @Default(<String, dynamic>{}) Map<String, dynamic> stats,
  }) = _SportTeam;

  factory SportTeam.fromJson(Map<String, dynamic> json) =>
      _$SportTeamFromJson(json);
}

// ─── SportEvent ───────────────────────────────────────────────────────────────

/// Immutable append-only log entry for every scored action during a game.
@freezed
abstract class SportEvent with _$SportEvent {
  const factory SportEvent({
    /// Unique identifier — '{sportType}_{wallClockMs}' or UUID.
    required String id,

    /// Elapsed game time in seconds when this event was recorded.
    required int gameTimeSeconds,

    /// Device wall-clock time (ms since epoch) for timeline ordering.
    required int wallClockMs,

    /// Sport-specific event type string.
    ///
    /// Baseball:   run | out | hit | strikeout | ball | strike | error | walk
    /// Basketball: 2pt | 3pt | ft_made | ft_missed | rebound | foul | turnover
    /// Football:   touchdown | extra_point | two_point_conv | field_goal |
    ///             safety | down_advance
    /// Soccer:     goal | possession_toggle | half_start | half_end
    /// Tennis:     point_won | game_won | set_won | tiebreak_point
    /// Volleyball: point_won | set_won | serving_change
    /// Hockey:     goal | primary_assist | secondary_assist | penalty_start |
    ///             penalty_end | period_end
    /// Lacrosse:   goal | ground_ball | clear_success | clear_fail
    required String eventType,

    /// 'home' or 'away'
    required String teamId,

    /// Null in basic mode.
    String? playerId,

    /// Score change caused by this event (0 for non-scoring events).
    @Default(0) int pointsDelta,

    /// Event-specific supplemental data.
    ///
    /// goal (Soccer/Hockey): {assistPlayerId?, assistPlayerName?, period}
    /// penalty_start (Hockey): {type, durationMinutes, playerId}
    /// primary/secondary_assist (Hockey): {goalEventId}
    /// possession_toggle (Soccer): {newPossessingTeam: 'home'|'away'}
    Map<String, dynamic>? metadata,
  }) = _SportEvent;

  factory SportEvent.fromJson(Map<String, dynamic> json) =>
      _$SportEventFromJson(json);
}

// ─── SportGameState ───────────────────────────────────────────────────────────

/// Complete, serialisable game state for any sport session.
///
/// Stored in [GameSessions.moduleStateJson] and loaded back into memory on
/// session resume. The [_schemaVersion] sentinel field allows future migrations.
@freezed
abstract class SportGameState with _$SportGameState implements GameModuleState {
  const factory SportGameState({
    /// Schema version sentinel — always `1` for this release.
    @Default(1) int schemaVersion,
    required SportType sportType,
    required TrackingMode trackingMode,
    required SportTeam homeTeam,
    required SportTeam awayTeam,

    /// Sport-specific format string.
    ///
    /// Baseball:   'nine_inning' | 'seven_inning' | 'scrimmage'
    /// Basketball: 'full' | 'halves' | 'scrimmage'
    /// Football:   'full' | 'two_minute_drill' | 'scrimmage'
    /// Soccer:     'full' | 'short' | 'scrimmage'
    /// Tennis:     'best_of_3' | 'best_of_5' | 'one_set' | 'pro_set'
    /// Volleyball: 'best_of_5' | 'best_of_3' | 'one_set'
    /// Hockey:     'full' | 'recreational' | 'scrimmage'
    /// Lacrosse:   'full' | 'short' | 'scrimmage'
    @Default('full') String gameFormat,
    @Default(GamePhase.notStarted) GamePhase gamePhase,

    /// Total elapsed game time in seconds.
    @Default(0) int elapsedSeconds,
    @Default(false) bool timerRunning,

    /// Append-only event log.
    @Default(<SportEvent>[]) List<SportEvent> events,

    /// Free-form game notes (mirrors [SportGameNotes.content] for quick access).
    String? notes,

    /// Sport-specific state fields embedded inline.
    ///
    /// Baseball:   {currentInning, currentHalf, outs, maxInnings}
    /// Basketball: {currentPeriod, periodCount}
    /// Football:   {currentPeriod, currentDown, yardsToGo, possessingTeamId}
    /// Soccer:     {currentHalf, possessingTeamId, homePossessionSeconds,
    ///              awayPossessionSeconds}
    /// Tennis:     {currentSet, homeGamesThisSet, awayGamesThisSet,
    ///              homePoints, awayPoints, isTiebreak, servingTeamId,
    ///              setScores}
    /// Volleyball: {currentSet, servingTeamId, setScores}
    /// Hockey:     {currentPeriod, isOvertime, isShootout, activePenalties}
    /// Lacrosse:   {currentQuarter}
    @Default(<String, dynamic>{}) Map<String, dynamic> sportSpecific,
  }) = _SportGameState;

  factory SportGameState.fromJson(Map<String, dynamic> json) =>
      _$SportGameStateFromJson(json);
}
