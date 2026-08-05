# Data Model: SkorKeeper

**Branch**: `001-skorkeeper-app` | **Phase**: 1 — Design
**Spec**: `specs/001-skorkeeper-app/spec.md` | **Research**: `specs/001-skorkeeper-app/research.md`

---

## Overview

SkorKeeper's data model has two storage layers:

1. **Drift (SQLite)** — structured relational data: game sessions, score entries, history records, notepads, tally counters.
2. **shared_preferences** — scalar user settings: theme mode, palette choice, sound/haptic flags.

All game-module-specific state (e.g., Darts remaining score per player, Yahtzee category locks) is stored as a JSON blob (`module_state_json`) in the `game_sessions` table. Each module owns and validates its own state blob shape.

---

## Core Entities

### 1. `GameSession`

A single instance of play for a given game type. Persisted as soon as the user confirms setup (before any scores are entered), guaranteeing the session survives app closure from the first moment.

**Drift Table**: `game_sessions`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `INTEGER` | PK, autoincrement | Stable session identifier |
| `game_type` | `TEXT` | NOT NULL | e.g. `'custom'`, `'darts_501'`, `'darts_cricket'`, `'yahtzee'`, `'golf_9'`, `'golf_18'`, `'minigolf'`, `'cribbage'`, `'bowling'`, `'farkle'`, `'uno'`, `'dominoes'` |
| `session_name` | `TEXT` | nullable | User-supplied display name |
| `status` | `INTEGER` | NOT NULL, enum | `0` = active, `1` = completed |
| `started_at` | `INTEGER` | NOT NULL | Unix timestamp (ms) |
| `ended_at` | `INTEGER` | nullable | Set on "End Game" action |
| `participants_json` | `TEXT` | NOT NULL | JSON-encoded `List<SessionPlayer>` |
| `module_state_json` | `TEXT` | NOT NULL | Game-module-specific state blob (see per-module schema below) |
| `winner_display_name` | `TEXT` | nullable | Set on session completion for fast History display |

**Indexes**: `(status)`, `(game_type, status)`, `(started_at DESC)`

**Validation rules**:
- `game_type` must be one of the known type constants; validated on insert.
- `participants_json` must deserialize to a non-empty list (1–10 players for most modules; 1–6 for Yahtzee; 2–4 for Cribbage).
- `module_state_json` must parse without error; validated by each module's `stateFromJson()` factory.
- `ended_at` must be ≥ `started_at` when set.

**State transitions**:
```
created (status=active)
    │
    │  score entries recorded, auto-saved
    │
    ▼
active (status=active)
    │
    │  user taps "End Game" → win determined → summary screen shown
    │
    ▼
completed (status=completed)
    │
    │  (session becomes a HistoryRecord — read-only, deletable)
```

---

### 2. `SessionPlayer`

A named participant embedded in `participants_json` within a `GameSession`. Not stored as a separate Drift table — lives inside the session JSON to keep queries simple and avoid join complexity for a mobile-first app.

**JSON Schema** (within `participants_json`):

```json
{
  "id": "p1",
  "display_name": "Alice",
  "color_hex": "#78BE20",
  "seat_order": 0
}
```

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `String` | NOT NULL, unique within session | Stable reference key for score entries (e.g., `"p1"`…`"p10"`) |
| `display_name` | `String` | NOT NULL, 1–30 chars | Shown on scoreboards, history |
| `color_hex` | `String` | NOT NULL | Hex color for player indicator chips (6-char `#RRGGBB`) |
| `seat_order` | `int` | NOT NULL, 0-indexed | Turn order |

**Validation rules**:
- `display_name` must be non-empty and ≤ 30 characters.
- `color_hex` must match `^#[0-9A-Fa-f]{6}$`.
- All `seat_order` values within a session must be unique and contiguous from 0.
- Max 10 players per session (6 for Yahtzee, 4 for Cribbage primary variant).

**Default player colors** (cycle in order): `#236192`, `#78BE20`, `#981D97`, `#9ea2a2`, `#0C2340`, `#FF6B35`, `#FFD700`, `#00C0A0`, `#E84855`, `#8338EC`

---

### 3. `ScoreEntry`

A single recorded score event for one player in one round. Stored per scoring module that uses explicit round-by-round entries (Custom, Golf, Farkle, Dominoes, UNO). Modules that track state as a blob (Darts, Yahtzee, Bowling, Cribbage) encode their scoring inside `module_state_json` instead.

**Drift Table**: `score_entries`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `INTEGER` | PK, autoincrement | |
| `session_id` | `INTEGER` | NOT NULL, FK → `game_sessions.id` | Cascade delete |
| `player_id` | `TEXT` | NOT NULL | References `SessionPlayer.id` |
| `round_number` | `INTEGER` | NOT NULL, ≥ 1 | 1-based round index |
| `value` | `INTEGER` | NOT NULL | Score value for this entry (can be negative for penalty systems like UNO) |
| `notes` | `TEXT` | nullable | Optional annotation |
| `recorded_at` | `INTEGER` | NOT NULL | Unix timestamp (ms) |

**Indexes**: `(session_id)`, `(session_id, player_id)`, `(session_id, round_number)`

**Validation rules**:
- `round_number` must be ≥ 1.
- For Custom scoring: no range constraint on `value` (supports negative penalty systems).
- For Golf: `value` must be ≥ 1 (strokes; 0 is not valid).
- For Mini Golf: `value` must be ≥ 1.
- `player_id` must reference a player in the parent session's `participants_json`.

---

### 4. `HistoryRecord`

An immutable snapshot created when a session transitions to `completed`. While `game_sessions` with `status=completed` technically serves as history, a dedicated table enables efficient querying (by game type, player name) without deserializing `module_state_json` for every row.

**Drift Table**: `history_records`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `INTEGER` | PK, autoincrement | |
| `session_id` | `INTEGER` | NOT NULL, unique, FK → `game_sessions.id` | One-to-one with session |
| `game_type` | `TEXT` | NOT NULL | Denormalized for fast filtering |
| `session_name` | `TEXT` | nullable | Denormalized for display |
| `player_names` | `TEXT` | NOT NULL | Comma-separated list for full-text search (FR-032) |
| `winner_display_name` | `TEXT` | nullable | |
| `final_scores_json` | `TEXT` | NOT NULL | `List<{playerId, displayName, score}>` snapshot |
| `played_at` | `INTEGER` | NOT NULL | = `game_sessions.started_at` |
| `duration_seconds` | `INTEGER` | nullable | `ended_at - started_at` |

**Indexes**: `(game_type)`, `(played_at DESC)`, `(player_names)` (for LIKE search, FR-032)

---

### 5. `NotepadEntry`

Persisted free-text notes from the Notepad tool.

**Drift Table**: `notepad_entries`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `INTEGER` | PK, autoincrement | |
| `title` | `TEXT` | NOT NULL, default `'Note'` | User-supplied name |
| `body` | `TEXT` | NOT NULL, default `''` | Free text content |
| `updated_at` | `INTEGER` | NOT NULL | Unix timestamp (ms) |

---

### 6. `TallyCounter`

Named counters from the Tally Counter tool.

**Drift Table**: `tally_counters`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `INTEGER` | PK, autoincrement | |
| `name` | `TEXT` | NOT NULL, default `'Counter'` | Display label |
| `value` | `INTEGER` | NOT NULL, default `0` | Current count |
| `updated_at` | `INTEGER` | NOT NULL | Unix timestamp (ms) |

---

### 7. `UserPreferences` (shared_preferences keys)

Stored in `shared_preferences` as typed key-value pairs.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `theme_mode` | `String` | `'system'` | `'system'` \| `'light'` \| `'dark'` |
| `use_alternate_palette` | `bool` | `false` | `false` = Timberwolves, `true` = Prince |
| `sound_enabled` | `bool` | `true` | Play sound effects |
| `haptic_enabled` | `bool` | `true` | Haptic feedback on interactions |
| `shake_to_roll_enabled` | `bool` | `true` | Shake gesture for dice roller |
| `shake_sensitivity` | `double` | `15.0` | m/s² threshold for shake detection |
| `default_player_names` | `String` (JSON) | `'[]'` | `List<String>` for quick player setup |

---

## Module-Specific State Schemas (`module_state_json`)

Each game module owns its state blob. Schemas are documented as JSON; Dart equivalents use `@freezed` classes with `toJson()`/`fromJson()`.

### Custom / Freeform

```json
{
  "game_name": "Crazy Eights",
  "round_labels": ["Round 1", "Round 2"],
  "score_direction": "high_wins"
}
```

Scoring is stored in `score_entries` table. `score_direction`: `"high_wins"` | `"low_wins"`.

---

### Darts

```json
{
  "game_variant": "501",
  "double_in": false,
  "double_out": true,
  "players": [
    {
      "player_id": "p1",
      "score_remaining": 340,
      "darts_thrown": 9,
      "scores_this_leg": [60, 57, 44],
      "has_opened": true
    }
  ],
  "current_player_id": "p1",
  "current_throw_in_turn": 0,
  "throws_this_turn": [],
  "legs_won": { "p1": 0, "p2": 0 },
  "sets_won": { "p1": 0, "p2": 0 },
  "game_over": false,
  "winner_id": null
}
```

`game_variant`: `"301"` | `"501"` | `"701"` | `"cricket"` | `"cut_throat_cricket"` | `"around_the_clock"` | `"shanghai"` | `"killer"` | `"halve_it"`

**Cricket-specific addition**:
```json
{
  "cricket_marks": {
    "p1": { "15": 3, "16": 2, "17": 0, "18": 0, "19": 0, "20": 0, "bull": 1 },
    "p2": { "15": 0, "16": 0, "17": 0, "18": 0, "19": 0, "20": 0, "bull": 0 }
  },
  "cricket_points": { "p1": 0, "p2": 45 }
}
```

**State transitions (01 games)**:
```
WAITING_FOR_THROW
    → BUST (score goes below 0; revert, next player)
    → CHECKOUT (score hits exactly 0 with valid double-out)
    → GAME_OVER
```

---

### Yahtzee

```json
{
  "current_player_index": 0,
  "current_roll_number": 1,
  "dice_values": [3, 5, 2, 6, 1],
  "dice_held": [false, false, true, false, false],
  "scorecards": {
    "p1": {
      "ones": null, "twos": null, "threes": 6, "fours": null, "fives": null, "sixes": null,
      "three_of_a_kind": null, "four_of_a_kind": null, "full_house": null,
      "small_straight": null, "large_straight": null, "yahtzee": null, "chance": null,
      "yahtzee_bonus_count": 0
    }
  }
}
```

`null` = category not yet scored. A non-null value is final and locked.

**Scoring rules enforced**:
- Upper section bonus: +35 if `ones+twos+threes+fours+fives+sixes ≥ 63`.
- Yahtzee bonus: +100 per additional Yahtzee after the first is scored.
- Full house = exactly 25. Small straight = exactly 30. Large straight = exactly 40.

---

### Golf

```json
{
  "hole_count": 9,
  "pars": [4, 3, 5, 4, 4, 3, 4, 5, 4],
  "scores": {
    "p1": [null, null, 3, 4, 5, null, null, null, null],
    "p2": [null, null, 4, 3, 4, null, null, null, null]
  },
  "is_mini_golf": false
}
```

`null` = hole not yet played. `is_mini_golf: true` means `pars` is an empty array (no par tracking).

**Score terminology** (computed from `score - par`):
- −2: Eagle, −1: Birdie, 0: Par, +1: Bogey, +2: Double Bogey, +3: Triple Bogey

---

### Cribbage

```json
{
  "variant": "two_player",
  "dealer_id": "p1",
  "peg_positions": {
    "p1": { "front": 24, "rear": 12 },
    "p2": { "front": 31, "rear": 20 }
  },
  "game_over": false,
  "winner_id": null,
  "hand_number": 3
}
```

Winning condition: `front` peg reaches or passes 121. Pegs snake: 0→60 up one column, 61→120 down the other, 121 = winning hole.

**Two-peg system**: `rear` = previous peg position (left behind), `front` = current peg position (always ahead of rear by the last score amount). Pegs are only advanced forward.

---

### Bowling

```json
{
  "current_player_index": 0,
  "current_frame": 1,
  "frames": {
    "p1": [
      { "frame": 1, "rolls": [7, 3], "frame_type": "spare", "cumulative_score": null },
      { "frame": 2, "rolls": [10], "frame_type": "strike", "cumulative_score": null },
      { "frame": 3, "rolls": [6, 2], "frame_type": "open", "cumulative_score": null }
    ]
  }
}
```

`cumulative_score: null` until all bonus rolls for that frame are available. Frame 10 has up to 3 rolls.

**Frame types**: `"open"` | `"spare"` | `"strike"`. Perfect game = 12 strikes = 300 points.

---

### Farkle

```json
{
  "current_player_id": "p1",
  "target_score": 10000,
  "player_totals": { "p1": 3500, "p2": 2750 },
  "current_turn_score": 450,
  "current_turn_dice": [1, 2, 3, 4, 5, 6],
  "dice_banked": [true, false, false, false, false, false],
  "has_opened": { "p1": true, "p2": true },
  "game_over": false,
  "winner_id": null
}
```

Opening threshold: 500 points in a single turn to get on the board. Farkle (no scoring dice) = turn score resets to 0.

---

### UNO / Card Game Penalty Tracker

```json
{
  "direction": "high_loses",
  "target_score": 500,
  "player_totals": { "p1": 120, "p2": 215 },
  "round_scores": [
    { "round": 1, "scores": { "p1": 45, "p2": 80 } }
  ],
  "game_over": false,
  "winner_id": null
}
```

`direction: "high_loses"` — player who reaches `target_score` first loses (standard UNO rules).

---

### Dominoes

```json
{
  "direction": "low_wins",
  "player_totals": { "p1": 45, "p2": 100 },
  "round_scores": [
    { "round": 1, "scores": { "p1": 10, "p2": 30 } }
  ],
  "game_over": false,
  "winner_id": null
}
```

`direction: "low_wins"` — lowest pip count at round end wins. Final score = sum of pips in hand.

---

## Entity Relationship Diagram

```
UserPreferences (shared_preferences)
    └─ (no FK relationships)

game_sessions  ──────────────────────────────────────────────────────────
    │  id, game_type, status, participants_json, module_state_json, ...  │
    │                                                                     │
    ├──< score_entries                                         1-to-1 >──┤
    │      id, session_id(FK), player_id, round_number, value           │
    │                                                                     │
    └──< history_records (created on session completion)                 │
           id, session_id(FK), game_type, player_names, ...             ─┘

notepad_entries (standalone)
    id, title, body, updated_at

tally_counters (standalone)
    id, name, value, updated_at
```

---

## Dart Domain Model Classes (Freezed)

### `GameSession`
```dart
@freezed
class GameSession with _$GameSession {
  const factory GameSession({
    required int id,
    required GameType gameType,
    String? sessionName,
    required SessionStatus status,
    required DateTime startedAt,
    DateTime? endedAt,
    required List<SessionPlayer> participants,
    required Map<String, dynamic> moduleState,
    String? winnerDisplayName,
  }) = _GameSession;
}
```

### `SessionPlayer`
```dart
@freezed
class SessionPlayer with _$SessionPlayer {
  const factory SessionPlayer({
    required String id,
    required String displayName,
    required String colorHex,
    required int seatOrder,
  }) = _SessionPlayer;
}
```

### `ScoreEntry`
```dart
@freezed
class ScoreEntry with _$ScoreEntry {
  const factory ScoreEntry({
    required int id,
    required int sessionId,
    required String playerId,
    required int roundNumber,
    required int value,
    String? notes,
    required DateTime recordedAt,
  }) = _ScoreEntry;
}
```

### `UserPreferences`
```dart
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(false) bool useAlternatePalette,
    @Default(true) bool soundEnabled,
    @Default(true) bool hapticEnabled,
    @Default(true) bool shakeToRollEnabled,
    @Default(15.0) double shakeSensitivity,
    @Default([]) List<String> defaultPlayerNames,
  }) = _UserPreferences;
}
```

---

## Enumerations

```dart
enum GameType {
  custom,
  darts501, darts301, darts701,
  dartsCricket, dartsCutThroat,
  dartsAroundTheClock, dartsShanghai, dartsKiller, dartsHalveIt,
  yahtzee,
  golf9, golf18, minigolf,
  cribbage,
  bowling,
  farkle,
  uno,
  dominoes,
}

enum SessionStatus { active, completed }
```

---

## Migration Strategy

Drift migrations use `MigrationStrategy` with explicit version steps. Schema version starts at `1`. Rules:
- Never use `destroyEverything()` in production migrations.
- Each schema change increments the version by 1.
- Additive changes (new columns with defaults, new tables) are safe.
- Column renames or type changes require explicit data migration steps.
- All migrations are tested in isolation with `verifyDatabase(schema)` from Drift's test utilities.
