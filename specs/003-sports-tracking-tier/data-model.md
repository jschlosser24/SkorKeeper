# Data Model: SkorKeeper Sports Monetization Tiers

**Feature**: 003-sports-tracking-tier | **Phase**: 1 — Design
**Date**: 2026-08-08

---

## Entities Overview

```
UserEntitlement (in-memory / RevenueCat)
    │
    ├── SportsPlan unlocks ──────────────────────────────────────────┐
    │   • Baseball, Basketball, Football, Soccer, Tennis, Volleyball │
    │   • Basic tracking mode                                        │
    │   • 100-game history limit                                     │
    │                                                                │
    └── SportsPro unlocks ───────────────────────────────────────────┤
        • All Plan sports + Hockey, Lacrosse                         │
        • In-depth tracking mode                                     │
        • Unlimited history                                          │
        • Export (PDF/CSV/JSON)                                      │
        • Advanced Analytics                                         │
        │                                                            │
        ▼                                                            ▼
SportGameSession ──── SportHistoryMeta ────── SportGameNotes
(GameSessions row)   (new table)              (new table)
        │
        └── moduleStateJson → SportGameState (Freezed)
                                    │
                                    ├── SportTeam (home)
                                    │       └── SportPlayer[] (in-depth only)
                                    ├── SportTeam (away)
                                    │       └── SportPlayer[] (in-depth only)
                                    └── SportEvent[]
                                            └── metadata: Map<String,dynamic>

SportExport (transient — file on device)
    └── built from SportGameSession + SportHistoryMeta
```

---

## Core Entities

### 1. UserEntitlement

**Source**: RevenueCat `CustomerInfo` (in-memory; cached on-device by SDK)
**Lifecycle**: Loaded on app launch via `PurchaseService`; refreshed on foreground resume

| Field | Type | Notes |
|---|---|---|
| `hasSportsPlan` | `bool` | `entitlements.active.containsKey('sports_plan')` |
| `hasSportsPro` | `bool` | `entitlements.active.containsKey('sports_pro')` |
| `planPurchaseDate` | `DateTime?` | From RevenueCat `EntitlementInfo.latestPurchaseDate` |
| `proPurchaseDate` | `DateTime?` | From RevenueCat `EntitlementInfo.latestPurchaseDate` |

**Key rules**:
- A user can own both tiers simultaneously; features stack (Pro ⊇ Plan)
- `hasSportsPro == true` implies Pro-exclusive features are accessible; Plan features are always accessible to Pro users
- Neither entitlement implies the other — they must be checked independently

---

### 2. SportGameSession

**Storage**: Existing `GameSessions` Drift table (no schema change to this table)

| Column | Dart type | Notes |
|---|---|---|
| `id` | `int` (autoincrement PK) | |
| `gameType` | `String` | Values: `sport_baseball`, `sport_basketball`, `sport_football`, `sport_soccer`, `sport_tennis`, `sport_volleyball`, `sport_hockey`, `sport_lacrosse` |
| `sessionName` | `String?` | Optional user-provided game name |
| `status` | `int` | 0=notStarted, 1=active, 2=paused, 3=completed |
| `startedAt` | `int` | Unix timestamp (ms) |
| `endedAt` | `int?` | Unix timestamp (ms); null until game completes |
| `participantsJson` | `String` | JSON array of two `SessionPlayer` objects: `[{id:'home', name:'...'}, {id:'away', name:'...'}]` |
| `moduleStateJson` | `String` | JSON-serialized `SportGameState` subtype |
| `winnerDisplayName` | `String?` | Winning team name; null for ties or incomplete games |

---

### 3. SportHistoryMeta *(NEW Drift table)*

**Purpose**: Augments `GameSessions` with sports-specific metadata needed for history limit enforcement, analytics queries, and export tracking.

**Table name**: `sport_history_meta`

| Column | Dart type | Notes |
|---|---|---|
| `id` | `int` (autoincrement PK) | |
| `sessionId` | `int` | FK → `game_sessions.id` (unique) |
| `sportType` | `String` | Mirrors `game_sessions.game_type`; denormalized for query efficiency |
| `trackingMode` | `String` | `'basic'` or `'in_depth'` |
| `tierRequired` | `String` | `'sports_plan'` or `'sports_pro'` |
| `exportedAt` | `int?` | Unix timestamp (ms) of last export; null if never exported |
| `exportFormats` | `String?` | Comma-separated export formats used: e.g. `'pdf,csv'` |

**Index**: `idx_sport_meta_tier` on `(tier_required)` — supports 100-game limit count query.

**Key constraint**: `sessionId` is UNIQUE (one meta row per sport game session).

---

### 4. SportGameNotes *(NEW Drift table)*

**Purpose**: Stores free-form game notes (FR-020). Separate table from `NotepadEntries` to keep sport notes scoped.

**Table name**: `sport_game_notes`

| Column | Dart type | Notes |
|---|---|---|
| `id` | `int` (autoincrement PK) | |
| `sessionId` | `int` | FK → `game_sessions.id` (unique) |
| `content` | `String` | Free-form note text; nullable allowed (empty string = no note) |
| `updatedAt` | `int` | Unix timestamp (ms) of last edit |

---

### 5. SportGameState *(Freezed — serialized to `moduleStateJson`)*

**Purpose**: The complete, serializable game state for any sport session. This is the in-memory game model during play.

```dart
@freezed
class SportGameState with _$SportGameState implements GameModuleState {
  const factory SportGameState({
    required SportType sportType,
    required TrackingMode trackingMode,
    required SportTeam homeTeam,
    required SportTeam awayTeam,
    required String gameFormat,        // 'full' | 'seven_inning' | 'scrimmage' (sport-specific)
    required GamePhase gamePhase,
    required int elapsedSeconds,       // total elapsed game time in seconds
    required bool timerRunning,
    required List<SportEvent> events,
    String? notes,                     // mirrors sport_game_notes.content for quick access
    // Sport-specific state fields embedded in JSON:
    // Baseball: currentInning, currentHalf (top/bottom), outs
    // Basketball/Football: currentPeriod
    // Soccer: currentHalf
    // Tennis: currentSet, currentGame, servingTeamId
    // Volleyball: currentSet, servingSide
    // Hockey: currentPeriod, isOvertime, isShootout
    required Map<String, dynamic> sportSpecific,  // holds above fields
  }) = _SportGameState;

  factory SportGameState.fromJson(Map<String, dynamic> json) =>
      _$SportGameStateFromJson(json);
}
```

**`sportSpecific` map contract per sport**: See [contracts/game-state-schema.md](./contracts/game-state-schema.md).

---

### 6. SportTeam *(Freezed — embedded in SportGameState)*

```dart
@freezed
class SportTeam with _$SportTeam {
  const factory SportTeam({
    required String id,           // 'home' or 'away'
    required String name,         // User-entered team name
    required int score,           // Current game score
    List<SportPlayer>? roster,    // null in basic mode; populated in in-depth mode
    required Map<String, dynamic> stats,  // Aggregated sport-specific stats
    // Baseball: {hits, errors, strikeouts, walks, earnedRuns, inningScores: []}
    // Basketball: {fieldGoalsMade, fieldGoalsAttempted, threesMade, ftMade, ftAttempted}
    // Football: {totalYards, touchdowns, firstDowns}
    // Soccer: {goals, possessionSeconds}
    // Tennis: {setsWon, games: []}
    // Volleyball: {setsWon, points: []}
    // Hockey: {goals, assists, penaltyMinutes}
    // Lacrosse: {goals, groundBalls, clears}
  }) = _SportTeam;

  factory SportTeam.fromJson(Map<String, dynamic> json) =>
      _$SportTeamFromJson(json);
}
```

---

### 7. SportPlayer *(Freezed — in-depth mode only; embedded in SportTeam.roster)*

```dart
@freezed
class SportPlayer with _$SportPlayer {
  const factory SportPlayer({
    required String id,           // UUID generated at setup
    required String name,
    String? number,               // Jersey number (optional)
    required Map<String, dynamic> stats,  // Per-player sport-specific stats
    // Basketball: {points, rebounds, assists, steals, blocks, fouls}
    // Football: {passingYards, rushingYards, receivingYards, touchdowns}
    // Soccer: {goals, assists, possession}
    // Tennis: {aces, doubleFaults, winners}
    // Volleyball: {kills, blocks, aces}
    // Hockey: {goals, assists, penaltyMinutes}
    // Lacrosse: {goals, groundBalls, clears}
  }) = _SportPlayer;

  factory SportPlayer.fromJson(Map<String, dynamic> json) =>
      _$SportPlayerFromJson(json);
}
```

---

### 8. SportEvent *(Freezed — in SportGameState.events)*

**Purpose**: Immutable append-only event log capturing every scored action during a game. Used for game timeline, export, and analytics.

```dart
@freezed
class SportEvent with _$SportEvent {
  const factory SportEvent({
    required String id,               // '{sportType}_{wallClockMs}' or UUID
    required int gameTimeSeconds,     // Elapsed game time when event occurred
    required int wallClockMs,         // Device wall-clock time (for timeline ordering)
    required String eventType,        // Sport-specific type string (see below)
    required String teamId,           // 'home' or 'away'
    String? playerId,                 // null in basic mode
    required int pointsDelta,         // Score change (0 for non-scoring events like outs)
    Map<String, dynamic>? metadata,   // Event-specific extra data
  }) = _SportEvent;

  factory SportEvent.fromJson(Map<String, dynamic> json) =>
      _$SportEventFromJson(json);
}
```

**Event type strings per sport**:
| Sport | Event Types |
|---|---|
| Baseball | `run`, `out`, `hit`, `strikeout`, `ball`, `strike`, `error`, `walk` |
| Basketball | `2pt`, `3pt`, `ft_made`, `ft_missed`, `rebound`, `foul`, `turnover` |
| Football | `touchdown`, `extra_point`, `two_point_conv`, `field_goal`, `safety`, `down_advance` |
| Soccer | `goal`, `possession_toggle`, `half_start`, `half_end` |
| Tennis | `point_won`, `game_won`, `set_won`, `tiebreak_point` |
| Volleyball | `point_won`, `set_won`, `serving_change` |
| Hockey | `goal`, `primary_assist`, `secondary_assist`, `penalty_start`, `penalty_end`, `period_end` |
| Lacrosse | `goal`, `ground_ball`, `clear_success`, `clear_fail` |

**`metadata` field contracts per event type**:
- `goal` (Soccer/Hockey): `{assistPlayerId?: String, assistPlayerName?: String, period: int}`
- `penalty_start` (Hockey): `{type: String, durationMinutes: int, playerId: String}`
- `primary_assist` / `secondary_assist` (Hockey): `{goalEventId: String}`
- `possession_toggle` (Soccer): `{newPossessingTeam: 'home'|'away'}`

---

### 9. SportExport *(Transient — not persisted as a table)*

```dart
@freezed
class SportExport with _$SportExport {
  const factory SportExport({
    required String exportId,          // UUID
    required ExportFormat format,      // pdf | csv | json
    required List<int> gameSessionIds, // IDs of included game_sessions
    required DateTime createdAt,
    String? filePath,                  // Temp file path after generation
    required ExportStatus status,      // pending | generating | complete | failed
    String? errorMessage,
  }) = _SportExport;
}
```

Export file is written to `(await getTemporaryDirectory()).path/SkorKeeper_Export_{timestamp}.{ext}` and shared via `share_plus`. Not persisted in DB after sharing.

---

## Enumerations

```dart
enum SportType {
  baseball, basketball, football, soccer, tennis, volleyball,
  hockey, lacrosse;

  // Tier requirement
  bool get requiresPro => this == hockey || this == lacrosse;
}

enum TrackingMode { basic, inDepth }

enum GamePhase {
  notStarted,
  active,
  paused,
  periodBreak,    // Between quarters/periods (Basketball, Football, Hockey)
  halftimeBreak,  // Halftime (Soccer, Football)
  tiebreakActive, // Tennis tiebreak or Hockey overtime/shootout
  completed;

  bool get isPlayable => this == active || this == tiebreakActive;
}

enum ExportFormat { pdf, csv, json }

enum ExportStatus { pending, generating, complete, failed }
```

---

## State Transition Diagrams

### GamePhase State Machine (All Sports)

```
                ┌─────────────┐
                │ notStarted  │◄── initial state
                └──────┬──────┘
                       │ startGame()
                       ▼
          ┌───────────────────────┐
   ┌─────►│        active         │◄─────┐
   │      └──┬──────────┬─────────┘      │
   │         │pause()   │ autoTransition  │
   │         ▼          ▼                │
   │     ┌────────┐  ┌───────────────┐   │
   │     │ paused │  │ periodBreak / │   │
   │     └────┬───┘  │ halftimeBreak │   │
   │          │      └───────┬───────┘   │
   │   resume()│             │resumeGame()│
   └───────────┘             └───────────┘
                       │ endGame() / winCondition
                       ▼
                ┌─────────────┐
                │  completed  │ (read-only from here)
                └─────────────┘

Special: active ──► tiebreakActive (Tennis tiebreak / Hockey OT)
         tiebreakActive ──► completed
```

### Baseball Inning Auto-Transition

```
outs = 0 ──► out recorded ──► outs = 1
outs = 1 ──► out recorded ──► outs = 2
outs = 2 ──► out recorded ──► outs = 3
  └── auto-transition:
      if currentHalf == 'top' → currentHalf = 'bottom', outs = 0
      if currentHalf == 'bottom' → currentInning++, currentHalf = 'top', outs = 0
      if currentInning > maxInnings → gamePhase = completed
```

---

## Validation Rules

| Entity | Rule | Error |
|---|---|---|
| `SportTeam.name` | Non-empty, 1–40 characters | `TEAM_NAME_REQUIRED` / `TEAM_NAME_TOO_LONG` |
| `SportPlayer.name` | Non-empty, 1–30 characters | `PLAYER_NAME_REQUIRED` |
| `SportPlayer.number` | If present: 1–3 digit string `[0-9]{1,3}` | `INVALID_JERSEY_NUMBER` |
| `SportGameState.gameFormat` | Must be one of the sport's valid formats | `INVALID_GAME_FORMAT` |
| `SportEvent.pointsDelta` | ≥0 for all event types | `NEGATIVE_POINTS_DELTA` |
| `SportGameNotes.content` | Max 2000 characters | `NOTES_TOO_LONG` |
| History count (Plan) | `SELECT COUNT(*) FROM sport_history_meta WHERE tier_required='sports_plan' AND sessionId IN (non-deleted sessions)` must be < 100 | `HISTORY_LIMIT_REACHED` |

---

## Database Schema Summary

```sql
-- Existing table (no changes):
game_sessions (id, game_type, session_name, status, started_at, ended_at, 
               participants_json, module_state_json, winner_display_name)

-- Existing table (no changes):
history_records (id, session_id, game_type, session_name, player_names,
                 winner_display_name, final_scores_json, played_at, duration_seconds)

-- NEW:
CREATE TABLE sport_history_meta (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL UNIQUE REFERENCES game_sessions(id),
  sport_type TEXT NOT NULL,
  tracking_mode TEXT NOT NULL,      -- 'basic' | 'in_depth'
  tier_required TEXT NOT NULL,      -- 'sports_plan' | 'sports_pro'
  exported_at INTEGER,              -- unix ms, nullable
  export_formats TEXT               -- nullable, comma-separated
);
CREATE INDEX idx_sport_meta_tier ON sport_history_meta (tier_required);

-- NEW:
CREATE TABLE sport_game_notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL UNIQUE REFERENCES game_sessions(id),
  content TEXT NOT NULL DEFAULT '',
  updated_at INTEGER NOT NULL
);
```
