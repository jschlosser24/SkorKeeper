# Contract: Navigation Routes

**Branch**: `001-skorkeeper-app` | **Layer**: App Shell
**Spec ref**: FR-001, FR-002, FR-007

---

## Overview

SkorKeeper uses `go_router` with `StatefulShellRoute.indexedStack` for the bottom navigation shell. Each tab maintains its own independent navigator stack so that switching tabs does not discard an active game session.

---

## Bottom Navigation Tabs

| Index | Tab | Root Path | Icon |
|-------|-----|-----------|------|
| 0 | Games | `/home` | 🎮 |
| 1 | Tools | `/tools` | 🔧 |
| 2 | History | `/history` | 📋 |
| 3 | Settings | `/settings` | ⚙️ |

---

## Route Tree

```
/                                    → redirect → /home
│
├── /home                            → HomeScreen (game module picker)
│   └── /home/new/:gameTypeId        → GameSetupScreen (player names, options)
│       └── /home/session/:sessionId → GameSessionScreen (active scoring)
│           └── /home/session/:sessionId/summary → SessionSummaryScreen (end game)
│
├── /tools                           → ToolsScreen (tool grid)
│   ├── /tools/dice                  → DiceRollerScreen
│   ├── /tools/coin                  → CoinFlipScreen
│   ├── /tools/spinner               → SpinnerScreen
│   ├── /tools/timer                 → TimerScreen
│   ├── /tools/stopwatch             → StopwatchScreen
│   ├── /tools/lives                 → LivesCounterScreen
│   ├── /tools/tally                 → TallyCounterScreen
│   ├── /tools/notepad               → NotepadListScreen
│   │   └── /tools/notepad/:noteId   → NotepadDetailScreen
│   └── /tools/team-picker           → TeamPickerScreen
│
├── /history                         → HistoryListScreen (filter + search)
│   └── /history/:sessionId          → HistoryDetailScreen (read-only session view)
│
└── /settings                        → SettingsScreen
```

---

## Path Parameter Contracts

| Parameter | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| `:gameTypeId` | `String` | Must match a registered `GameModule.gameTypeId` | e.g. `'darts_501'`, `'yahtzee'` |
| `:sessionId` | `String` | Must be parseable as `int` (Drift row ID) | Active session database ID |
| `:noteId` | `String` | Must be parseable as `int` | Notepad entry database ID |

---

## Redirect Guards

```dart
// Redirect rules applied in order:

// 1. Restore active session on cold launch
//    If app launches to /home and there is an active session in the database,
//    redirect to /home/session/:id to restore the in-progress game.

// 2. Block /home/session/:id if session does not exist
//    If sessionId is not found in the database (deleted or invalid),
//    redirect to /home.

// 3. Block /history/:sessionId if session status != completed
//    A non-completed session is not a history record; redirect to
//    /home/session/:sessionId instead.

// 4. No authentication redirects (Constitution Principle III: no account required).
```

---

## Navigation Transitions

All route transitions use `flutter_animate` page transitions:

| Transition Type | Routes | Duration |
|-----------------|--------|----------|
| Slide up + fade | `/home/new/:gameTypeId` (modal sheet feel) | 250 ms |
| Slide up + fade | `/home/session/:sessionId` (full-screen entry) | 250 ms |
| Fade | `/home/session/:sessionId/summary` | 300 ms |
| Bottom-tab crossfade | Tab switches (StatefulShellRoute) | 150 ms |
| Slide right + fade | All `/tools/*` sub-routes | 200 ms |
| Slide right + fade | `/history/:sessionId` | 200 ms |
| Slide right + fade | `/tools/notepad/:noteId` | 200 ms |

All transitions complete within 300 ms on mid-range devices (FR-034).

---

## Deep Link Examples

| Intent | URL |
|--------|-----|
| Open active darts session 42 | `skorkeeper://home/session/42` |
| Start a new Yahtzee game | `skorkeeper://home/new/yahtzee` |
| View history for session 18 | `skorkeeper://history/18` |
| Open dice roller | `skorkeeper://tools/dice` |

Deep linking is an internal-use feature (future: share session results); the custom scheme `skorkeeper://` must be registered in `AndroidManifest.xml` and `Info.plist`.
