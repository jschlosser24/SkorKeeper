# Contract: Sport GameModule Protocol Extension

**Feature**: 003-sports-tracking-tier | **Contract Type**: Internal Module Interface

---

## Overview

All sport modules implement the existing `GameModule` interface from `lib/core/modules/game_module.dart` (unchanged). This contract defines the conventions sports modules must follow and the two new `ScoringLayoutType` enum values added to `lib/core/modules/scoring_layout_descriptor.dart`.

---

## `GameModule` Interface Requirements for Sports Modules

Each sport module (`BaseballModule`, `BasketballModule`, etc.) implements `GameModule` with these conventions:

| Method | Sports Convention |
|---|---|
| `gameTypeId` | Prefixed with `sport_`: e.g. `'sport_baseball'`, `'sport_hockey'` |
| `displayName` | Human-readable: `'Baseball'`, `'Hockey'` |
| `minPlayers` | Always `2` (two teams) |
| `maxPlayers` | Always `2` (two teams; roster size is within module state, not player slots) |
| `initialState(players)` | `players` always has exactly 2 entries: `players[0]` = home team, `players[1]` = away team |
| `stateFromJson(json)` | Returns `SportGameState` subtype; returns `null` on parse error |
| `applyAction(state, action)` | Returns new `SportGameState`; MUST be pure (no side effects) |
| `leaderboard(state)` | Returns list of 2 `LeaderboardEntry` items (home + away); higher score = rank 1 |
| `checkWinCondition(state)` | Returns `WinResult` when `gamePhase == completed`; `null` while game is active |
| `scoringLayout(state)` | Returns `ScoringLayoutDescriptor` with type `sportsBasic` or `sportsInDepth` |
| `validateScore(state, playerId, value)` | `playerId` is `'home'` or `'away'`; `value` is the event type string for sports |

---

## New `ScoringLayoutType` Values

Add to `lib/core/modules/scoring_layout_descriptor.dart`:

```dart
enum ScoringLayoutType {
  // --- Existing (unchanged) ---
  standard,
  bowlingSheet,
  darts,
  golf,
  // ... other existing types

  // --- New for Sports ---
  /// Basic sports layout: team scoreboard, timer, quick-entry action buttons.
  /// Rendered by SportBasicGameScreen.
  sportsBasic,

  /// In-depth sports layout: all of basic + player selection drawer,
  /// per-player stat panel, possession indicator.
  /// Rendered by SportInDepthGameScreen. Requires Sports Pro entitlement.
  sportsInDepth,
}
```

---

## `ScoringLayoutDescriptor.config` Contract for Sports

The `config` map in `ScoringLayoutDescriptor` carries sport-specific UI rendering hints. These are read by the presentation layer to configure the game screen dynamically.

### Required keys (all sports):

| Key | Type | Description |
|---|---|---|
| `sport` | `String` | Sport identifier matching `SportType` name |
| `hasTimer` | `bool` | Whether this sport displays a running game timer |
| `scoreActions` | `List<String>` | Action button labels for quick score entry |
| `periodLabel` | `String` | Display label for game divisions (Quarter, Half, Inning, Set, Period) |

### Optional keys (sport-specific):

| Key | Type | Sports | Description |
|---|---|---|---|
| `periodCount` | `int` | Basketball, Football, Hockey | Number of regulation periods/quarters |
| `periodDurationSeconds` | `int` | Basketball, Football, Hockey | Duration of each period in seconds |
| `hasPossessionToggle` | `bool` | Soccer | Whether to show the possession indicator |
| `hasInningCounter` | `bool` | Baseball | Whether to show top/bottom inning counter |
| `maxOuts` | `int` | Baseball | Always 3 |
| `hasSetTracking` | `bool` | Tennis, Volleyball | Whether to show set tracker |
| `hasOvertime` | `bool` | Hockey | Whether OT/shootout logic is enabled |

### Example — Basketball basic mode:

```dart
ScoringLayoutDescriptor(
  type: ScoringLayoutType.sportsBasic,
  config: {
    'sport': 'basketball',
    'hasTimer': true,
    'scoreActions': ['2pt', '3pt', 'ft'],
    'periodLabel': 'Quarter',
    'periodCount': 4,
    'periodDurationSeconds': 600,   // 10-minute quarters
    'hasPossessionToggle': false,
  },
)
```

### Example — Soccer in-depth mode:

```dart
ScoringLayoutDescriptor(
  type: ScoringLayoutType.sportsInDepth,
  config: {
    'sport': 'soccer',
    'hasTimer': true,
    'scoreActions': ['goal'],
    'periodLabel': 'Half',
    'periodCount': 2,
    'hasPossessionToggle': true,
  },
)
```

---

## Module Registration

Sport modules are registered in `GameModuleRegistry` alongside existing modules:

```dart
// lib/core/modules/game_module_registry.dart (additions)
GameModuleRegistry._() {
  // ... existing modules ...
  register(const BaseballModule());
  register(const BasketballModule());
  register(const FootballModule());
  register(const SoccerModule());
  register(const TennisModule());
  register(const VolleyballModule());
  register(const HockeyModule());     // Pro-only (UI gates access; module is always registered)
  register(const LacrosseModule());   // Pro-only (same)
}
```

> **Important**: Modules are always registered regardless of entitlement. The entitlement check is in the UI layer (home screen tile rendering and sport setup screen). This allows the module to deserialize existing game sessions regardless of current entitlement state.

---

## `GameModuleRegistry` Entitlement Query

A new lookup method on the registry:

```dart
/// Returns all registered sport modules.
List<GameModule> get sportModules =>
    _modules.values
        .where((m) => m.gameTypeId.startsWith('sport_'))
        .toList();

/// Returns sport modules accessible given the current entitlement.
List<GameModule> sportModulesFor(SportsEntitlement entitlement) =>
    sportModules.where((m) {
      final sport = SportType.values.firstWhere(
        (s) => 'sport_${s.name}' == m.gameTypeId,
        orElse: () => SportType.baseball,
      );
      return entitlement.canAccess(sport);
    }).toList();
```
