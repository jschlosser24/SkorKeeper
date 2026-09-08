# Contract: Sport ScoreAction Subclasses

**Feature**: 003-sports-tracking-tier | **Contract Type**: Internal Module Interface

---

## Overview

All sport-specific `ScoreAction` subclasses are appended to `lib/core/modules/score_action.dart`. This contract defines every action type per sport, categorized by tier (both / Pro-only in-depth).

---

## Baseball Actions

```dart
// Basic (both tiers)
class BaseballEventRecorded extends ScoreAction {
  const BaseballEventRecorded({
    required this.teamId,          // 'home' | 'away'
    required this.eventType,       // 'run'|'out'|'hit'|'strikeout'|'ball'|'strike'|'error'|'walk'
  });
  final String teamId;
  final String eventType;
}

class BaseballGameFormatSelected extends ScoreAction {
  const BaseballGameFormatSelected({required this.format});
  final String format; // 'nine_inning' | 'seven_inning' | 'scrimmage'
}
```

---

## Basketball Actions

```dart
// Basic (both tiers)
class BasketballTeamScored extends ScoreAction {
  const BasketballTeamScored({
    required this.teamId,          // 'home' | 'away'
    required this.pointType,       // '2pt' | '3pt' | 'ft'
  });
  final String teamId;
  final String pointType;
}

class BasketballTimerToggled extends ScoreAction {
  const BasketballTimerToggled({required this.startTimer});
  final bool startTimer;
}

class BasketballQuarterAdvanced extends ScoreAction {
  const BasketballQuarterAdvanced();
}

// In-depth (Sports Pro only)
class BasketballPlayerScored extends ScoreAction {
  const BasketballPlayerScored({
    required this.teamId,
    required this.playerId,
    required this.pointType,       // '2pt' | '3pt' | 'ft'
  });
  final String teamId;
  final String playerId;
  final String pointType;
}

class BasketballPlayerStatRecorded extends ScoreAction {
  const BasketballPlayerStatRecorded({
    required this.teamId,
    required this.playerId,
    required this.statType,        // 'rebound'|'assist'|'steal'|'block'|'foul'|'turnover'
  });
  final String teamId;
  final String playerId;
  final String statType;
}
```

---

## Football Actions

```dart
// Basic (both tiers)
class FootballTeamScored extends ScoreAction {
  const FootballTeamScored({
    required this.teamId,
    required this.scoreType,       // 'touchdown'|'extra_point'|'two_point'|'field_goal'|'safety'
  });
  final String teamId;
  final String scoreType;
}

class FootballDownAdvanced extends ScoreAction {
  const FootballDownAdvanced({required this.teamId, required this.yardsGained});
  final String teamId;
  final int yardsGained;
}

class FootballQuarterAdvanced extends ScoreAction {
  const FootballQuarterAdvanced();
}

// In-depth (Sports Pro only)
class FootballPlayerStatRecorded extends ScoreAction {
  const FootballPlayerStatRecorded({
    required this.teamId,
    required this.playerId,
    required this.statType,        // 'passing_yards'|'rushing_yards'|'receiving_yards'|'touchdown'|'tackle'
    required this.value,
  });
  final String teamId;
  final String playerId;
  final String statType;
  final int value;
}
```

---

## Soccer Actions

```dart
// Basic (both tiers)
class SoccerGoalScored extends ScoreAction {
  const SoccerGoalScored({required this.teamId, this.playerId});
  final String teamId;
  final String? playerId;          // null in basic mode; required in in-depth
}

class SoccerPossessionToggled extends ScoreAction {
  const SoccerPossessionToggled({required this.newPossessingTeam});
  final String newPossessingTeam;  // 'home' | 'away'
}

class SoccerHalfAdvanced extends ScoreAction {
  const SoccerHalfAdvanced();
}

// In-depth (Sports Pro only)
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
```

---

## Tennis Actions

```dart
// Basic (both tiers — Tennis is "basic and advanced" per spec)
class TennisPointWon extends ScoreAction {
  const TennisPointWon({required this.teamId});
  final String teamId;
}

class TennisGameWon extends ScoreAction {
  const TennisGameWon({required this.teamId});
  final String teamId;
}

class TennisSetWon extends ScoreAction {
  const TennisSetWon({required this.teamId});
  final String teamId;
}

class TennisTiebreakPointWon extends ScoreAction {
  const TennisTiebreakPointWon({required this.teamId});
  final String teamId;
}

// In-depth (Sports Pro only)
class TennisPlayerShotRecorded extends ScoreAction {
  const TennisPlayerShotRecorded({
    required this.teamId,
    required this.playerId,
    required this.shotType,        // 'ace'|'double_fault'|'winner'|'forced_error'|'unforced_error'
  });
  final String teamId;
  final String playerId;
  final String shotType;
}
```

---

## Volleyball Actions

```dart
// Basic (both tiers)
class VolleyballPointWon extends ScoreAction {
  const VolleyballPointWon({required this.teamId});
  final String teamId;
}

class VolleyballSetWon extends ScoreAction {
  const VolleyballSetWon({required this.teamId});
  final String teamId;
}

class VolleyballServingChanged extends ScoreAction {
  const VolleyballServingChanged({required this.servingTeamId});
  final String servingTeamId;
}

// In-depth (Sports Pro only)
class VolleyballPlayerStatRecorded extends ScoreAction {
  const VolleyballPlayerStatRecorded({
    required this.teamId,
    required this.playerId,
    required this.statType,        // 'kill'|'block'|'ace'|'dig'|'error'
  });
  final String teamId;
  final String playerId;
  final String statType;
}
```

---

## Hockey Actions (Sports Pro Only)

```dart
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

class HockeyPenaltyAssessed extends ScoreAction {
  const HockeyPenaltyAssessed({
    required this.teamId,
    required this.playerId,
    required this.penaltyType,     // 'minor'|'major'|'misconduct'|'game_misconduct'
    required this.durationMinutes, // 2 or 5
  });
  final String teamId;
  final String playerId;
  final String penaltyType;
  final int durationMinutes;
}

class HockeyPeriodAdvanced extends ScoreAction {
  const HockeyPeriodAdvanced({required this.nextPhase});
  final String nextPhase; // 'period_2'|'period_3'|'overtime'|'shootout'|'completed'
}
```

---

## Lacrosse Actions (Sports Pro Only)

```dart
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

class LacrosseGroundBallWon extends ScoreAction {
  const LacrosseGroundBallWon({required this.teamId, required this.playerId});
  final String teamId;
  final String playerId;
}

class LacrosseClearAttempted extends ScoreAction {
  const LacrosseClearAttempted({required this.teamId, required this.success});
  final String teamId;
  final bool success;
}
```

---

## Game Control Actions (All Sports)

```dart
class SportTimerStarted extends ScoreAction {
  const SportTimerStarted();
}

class SportTimerPaused extends ScoreAction {
  const SportTimerPaused();
}

class SportTimerReset extends ScoreAction {
  const SportTimerReset();
}

class SportGameEnded extends ScoreAction {
  const SportGameEnded();
}

class SportNoteUpdated extends ScoreAction {
  const SportNoteUpdated({required this.content});
  final String content;
}
```
