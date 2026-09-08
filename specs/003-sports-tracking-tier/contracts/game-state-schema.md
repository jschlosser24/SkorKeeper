# Contract: SportGameState JSON Schema

**Feature**: 003-sports-tracking-tier | **Contract Type**: Internal Serialization

---

## Overview

`SportGameState` is serialized to JSON and stored in `game_sessions.module_state_json`. This contract defines the JSON structure for each sport. All fields are required unless marked optional (`?`).

---

## Base Structure (all sports)

```json
{
  "sportType": "basketball",
  "trackingMode": "basic",
  "gameFormat": "full",
  "gamePhase": "active",
  "elapsedSeconds": 420,
  "timerRunning": true,
  "homeTeam": { ... },
  "awayTeam": { ... },
  "events": [ ... ],
  "notes": "Optional game notes",
  "sportSpecific": { ... }
}
```

| Field | Type | Values |
|---|---|---|
| `sportType` | string | `baseball` \| `basketball` \| `football` \| `soccer` \| `tennis` \| `volleyball` \| `hockey` \| `lacrosse` |
| `trackingMode` | string | `basic` \| `in_depth` |
| `gameFormat` | string | Sport-specific (see below) |
| `gamePhase` | string | `not_started` \| `active` \| `paused` \| `period_break` \| `halftime_break` \| `tiebreak_active` \| `completed` |
| `elapsedSeconds` | int | ≥0; total elapsed game time at last save |
| `timerRunning` | bool | Always `false` in persisted state (timer is not running between sessions) |
| `homeTeam` | object | `SportTeam` — see below |
| `awayTeam` | object | `SportTeam` — see below |
| `events` | array | `SportEvent[]` — see below |
| `notes` | string? | User-entered free-form notes |
| `sportSpecific` | object | Sport-specific state — see per-sport sections |

---

## SportTeam Object

```json
{
  "id": "home",
  "name": "Wildcats",
  "score": 7,
  "stats": { ... },
  "roster": null
}
```

| Field | Type | Notes |
|---|---|---|
| `id` | string | `"home"` or `"away"` |
| `name` | string | 1–40 characters |
| `score` | int | ≥0; current game score |
| `stats` | object | Sport-specific stats (see per-sport) |
| `roster` | array \| null | `SportPlayer[]` in in-depth mode; `null` in basic mode |

---

## SportPlayer Object (in-depth mode only)

```json
{
  "id": "player_abc123",
  "name": "Smith",
  "number": "23",
  "stats": { ... }
}
```

---

## SportEvent Object

```json
{
  "id": "sport_baseball_1723060800000",
  "gameTimeSeconds": 0,
  "wallClockMs": 1723060800000,
  "eventType": "hit",
  "teamId": "home",
  "playerId": null,
  "pointsDelta": 0,
  "metadata": null
}
```

---

## `sportSpecific` Map Per Sport

### Baseball

```json
"sportSpecific": {
  "currentInning": 3,
  "currentHalf": "top",
  "outs": 1,
  "maxInnings": 9
}
```

| Field | Type | Values |
|---|---|---|
| `currentInning` | int | 1–maxInnings |
| `currentHalf` | string | `"top"` \| `"bottom"` |
| `outs` | int | 0–3 |
| `maxInnings` | int | `9` \| `7` \| `null` (scrimmage = no limit) |

**`gameFormat` values**: `nine_inning` \| `seven_inning` \| `scrimmage`

**`stats` object (per team)**:
```json
{
  "hits": 10,
  "errors": 1,
  "strikeouts": 8,
  "walks": 3,
  "earnedRuns": 7,
  "atBats": 32,
  "inningScores": [0, 2, 0, 1, 0, 3, 0, 0, 1]
}
```

---

### Basketball

```json
"sportSpecific": {
  "currentPeriod": 2,
  "periodCount": 4
}
```

**`gameFormat` values**: `full` (4 quarters) \| `halves` (2 halves) \| `scrimmage`

**`stats` object (per team)**:
```json
{
  "fieldGoalsMade": 12,
  "fieldGoalsAttempted": 28,
  "threesMade": 4,
  "threesAttempted": 10,
  "ftMade": 8,
  "ftAttempted": 10,
  "quarterScores": [22, 18, 24, 24]
}
```

---

### Football

```json
"sportSpecific": {
  "currentPeriod": 2,
  "currentDown": 3,
  "yardsToGo": 7,
  "possessingTeamId": "home"
}
```

**`gameFormat` values**: `full` (4 quarters) \| `two_minute_drill` \| `scrimmage`

**`stats` object (per team)**:
```json
{
  "totalYards": 342,
  "touchdowns": 3,
  "fieldGoals": 1,
  "safeties": 0,
  "firstDowns": 18,
  "quarterScores": [7, 7, 0, 10]
}
```

---

### Soccer

```json
"sportSpecific": {
  "currentHalf": 1,
  "possessingTeamId": "away",
  "homePossessionSeconds": 1320,
  "awayPossessionSeconds": 1680
}
```

**`gameFormat` values**: `full` (2 halves × 45 min) \| `short` (2 halves × 25 min) \| `scrimmage`

**`stats` object (per team)**:
```json
{
  "goals": 2,
  "halfScores": [1, 1],
  "possessionSeconds": 1320
}
```

---

### Tennis

```json
"sportSpecific": {
  "currentSet": 2,
  "homeGamesThisSet": 3,
  "awayGamesThisSet": 4,
  "homePoints": 2,
  "awayPoints": 3,
  "isTiebreak": false,
  "servingTeamId": "away",
  "setScores": [
    {"home": 6, "away": 4},
    {"home": 3, "away": 4}
  ]
}
```

**Tennis score display**: Points map `[0,1,2,3,4] → ["0","15","30","40","Ad"]`; deuce detected when both teams at index 3.

**`gameFormat` values**: `best_of_3` \| `best_of_5` \| `one_set` \| `pro_set`

**`stats` object (per team)**:
```json
{
  "setsWon": 1,
  "totalGamesWon": 9,
  "setScores": [{"home": 6, "away": 4}]
}
```

---

### Volleyball

```json
"sportSpecific": {
  "currentSet": 3,
  "servingTeamId": "home",
  "setScores": [
    {"home": 25, "away": 23},
    {"home": 19, "away": 25},
    {"home": 14, "away": 12}
  ]
}
```

**`gameFormat` values**: `best_of_5` \| `best_of_3` \| `one_set`

**`stats` object (per team)**:
```json
{
  "setsWon": 1,
  "totalPoints": 58,
  "setScores": [{"home": 25, "away": 23}]
}
```

---

### Hockey (Sports Pro Only)

```json
"sportSpecific": {
  "currentPeriod": 2,
  "isOvertime": false,
  "isShootout": false,
  "activePenalties": [
    {
      "teamId": "away",
      "playerId": "player_xyz",
      "type": "minor",
      "durationMinutes": 2,
      "startedAtSeconds": 1240
    }
  ]
}
```

**`gameFormat` values**: `full` (3 periods × 20 min) \| `recreational` (3 periods × 15 min) \| `scrimmage`

**`stats` object (per team)**:
```json
{
  "goals": 3,
  "assists": 4,
  "penaltyMinutes": 6,
  "periodScores": [1, 1, 1],
  "shotsOnGoal": 28
}
```

---

### Lacrosse (Sports Pro Only)

```json
"sportSpecific": {
  "currentQuarter": 2
}
```

**`gameFormat` values**: `full` (4 quarters × 15 min) \| `short` (4 quarters × 10 min) \| `scrimmage`

**`stats` object (per team)**:
```json
{
  "goals": 8,
  "assists": 5,
  "groundBalls": 14,
  "clearsSuccessful": 9,
  "clearsFailed": 2,
  "quarterScores": [2, 3, 1, 2]
}
```

---

## Schema Versioning

A `_schemaVersion` field is reserved for future migration purposes:

```json
{
  "_schemaVersion": 1,
  "sportType": "baseball",
  ...
}
```

`_schemaVersion` defaults to `1` for all v1 game states. The `stateFromJson()` method checks this field to apply migrations in future versions. Missing `_schemaVersion` is treated as `1`.
