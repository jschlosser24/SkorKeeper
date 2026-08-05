# Implementation Plan: SkorKeeper — All-In-One Scoring & Game Tools App

**Branch**: `001-skorkeeper-app` | **Date**: 2026-08-04 | **Spec**: [`spec.md`](./spec.md)

**Input**: Feature specification from `specs/001-skorkeeper-app/spec.md`

---

## Summary

SkorKeeper is a cross-platform iOS + Android mobile app built with **Flutter (Dart)** that replaces physical scorecards, dice, timers, and other analog game accessories. It provides 10 scoring modules (Custom/Freeform, Darts with 9 variants, Yahtzee, Golf/Mini Golf, Cribbage, Bowling, Farkle, UNO, Dominoes), 9 game tools (Dice Roller, Coin Flipper, Spinner, Timer, Stopwatch, Lives Counter, Tally Counter, Notepad, Random Team Picker), local game history, and full light/dark theming with the Minnesota Timberwolves and Prince color palettes.

The app is entirely offline, requires no account, and persists all data in a local SQLite database via Drift. State management uses Riverpod 2.x for app-wide concerns and BLoC/Cubit for complex game state machines. Animations are handled by flutter_animate (code-driven), Rive (interactive state machines), and Lottie (one-shot AE exports). All scoring modules conform to the `GameModule` interface contract, enabling new game types to be added without modifying existing code.

---

## Technical Context

**Language/Version**: Dart 3.x (null-safe) via Flutter SDK 3.22+

**Primary Dependencies**:
- Navigation: `go_router ^14.6.3`
- State: `flutter_riverpod ^2.6.1`, `flutter_bloc ^9.0.0`
- Database: `drift ^2.25.0` + `sqlite3_flutter_libs ^0.5.28`
- Preferences: `shared_preferences ^2.5.3`
- Animations: `flutter_animate ^4.5.2`, `lottie ^3.3.1`, `rive ^0.13.20`
- Sensors: `sensors_plus ^6.1.1` (shake detection)
- Audio: `just_audio ^0.9.46` + `audio_session ^0.1.22`
- Models: `freezed_annotation ^3.0.0` + `json_annotation ^4.9.0`
- Utilities: `collection ^1.19.1`, `intl ^0.20.2`, `flutter_svg ^2.0.17`

**Dev dependencies**: `build_runner`, `drift_dev`, `freezed`, `riverpod_generator`, `json_serializable`, `mocktail`, `bloc_test`

**Storage**: Drift SQLite (game sessions, score entries, history, notepad, tally) + shared_preferences (scalar user settings)

**Testing**: `flutter test` (unit + widget, no device), `integration_test` (device/emulator), `bloc_test` (BLoC state machines), `mocktail` (mock DAO/repository)

**Target Platform**: iOS 14.0+ (iPhone SE 2 through Pro Max) and Android 8.0+ (API 26), with Impeller rendering enabled on both

**Project Type**: Cross-platform mobile app (offline-first, no backend)

**Performance Goals**:
- App launch to interactive home screen: ≤ 2 000 ms cold start
- Score entry confirmation (tap → state update + UI refresh): ≤ 300 ms
- Screen navigation transitions: 150–250 ms (Impeller Vulkan/Metal)
- All unit + widget tests: ≤ 30 seconds total (no device required)

**Constraints**:
- Fully offline, no network permissions required
- No account or login for any core feature
- Android 8.0 (API 26) minimum — Vulkan-capable, Impeller available
- iOS 14.0 minimum — CoreMotion, AVAudioSession, UIImpactFeedbackGenerator available
- Shake detection requires `NSMotionUsageDescription` in `Info.plist`
- Audio respects device mute/silent switch via `AVAudioSessionCategory.ambient`

**Scale/Scope**: ~55 screens across 10 game modules + 9 tools + history + settings; 18 registered GameModule instances; 5 Drift tables; 7 shared_preferences keys

---

## Constitution Check

*GATE: Must pass before implementation. Re-check after Phase 1 design.*

| Principle | Status | Evidence |
|-----------|--------|----------|
| **I. Cross-Platform First** | ✅ PASS | Flutter single codebase targets iOS and Android identically. Platform-specific code (audio session, motion plist) is isolated in `audio_session` and `sensors_plus` package abstractions — not in app code. |
| **II. Game-Agnostic Modular Scoring Engine** | ✅ PASS | `GameModule` abstract interface defined in `lib/core/modules/` (see `contracts/game_module_interface.md`). Each game type is self-contained in `lib/features/modules/<name>/`. Module registration is the only app-level coupling. |
| **III. Offline-First, No Account Required** | ✅ PASS | Drift SQLite — no remote dependency. No network permission declared. No login/signup screen. `shared_preferences` for settings. |
| **IV. Speed & Minimal Friction** | ✅ PASS | Impeller pre-compiled shaders eliminate jank. Score entry target: ≤ 3 taps from active game screen. Large tap targets (min 44 × 44 pt). 300 ms transition budget explicitly tracked in Quickstart Scenario 1. |
| **V. Extensibility & Simplicity** | ✅ PASS | Feature-first folder structure. New game type = new `features/modules/<name>/` folder + one `register()` call. YAGNI enforced: cloud sync, multi-device, tournament brackets explicitly excluded from v1. |
| **Technology: Framework** | ✅ PASS | Flutter chosen at kickoff (resolves constitution's "to be decided" clause). No framework mixing. |
| **Technology: State Management** | ✅ PASS | Riverpod (app-wide) + BLoC/Cubit (game state machines) — consistent, single library per concern. No ad-hoc local state in shared widgets. |
| **Technology: Local Persistence** | ✅ PASS | Drift (SQLite structured ORM). No raw file I/O for structured data. |
| **Technology: OS Targets** | ✅ PASS | Android 8.0 (API 26), iOS 14.0 — matches constitution. |
| **No Unnecessary Permissions** | ✅ PASS | Only permission requested: motion/accelerometer (shake-to-roll). No network, camera, location, or contacts. |
| **Unit Tests Required** | ✅ PASS | All scoring logic, rule enforcement, stat calculations mandated with unit test coverage. `bloc_test` for BLoC state machines. |
| **UI Smoke Tests** | ✅ PASS | Each game module requires ≥ 1 integration test (start → score → end). |
| **Accessible by Default** | ✅ PASS | WCAG AA contrast enforced by theme token design. OS font scaling tested in Quickstart Scenario 12. `semanticsLabel` required on all interactive elements (enforced in code review checklist). |

**Gate result: ALL PASS — no violations.** ✅

---

## Project Structure

### Documentation (this feature)

```text
specs/001-skorkeeper-app/
├── plan.md              ← This file
├── research.md          ← Phase 0: Tech stack decisions and rationale
├── data-model.md        ← Phase 1: Entities, Drift tables, module state schemas
├── quickstart.md        ← Phase 1: End-to-end validation scenarios
├── contracts/
│   ├── game_module_interface.md  ← GameModule abstract interface contract
│   ├── navigation_routes.md      ← go_router route tree and transition contract
│   └── storage_schema.md         ← Drift table DSL and DAO contracts
└── tasks.md             ← Phase 2 output (created by /speckit.tasks — NOT this file)
```

### Source Code (repository root)

```text
SkorKeeper/
├── lib/
│   ├── main.dart                      # App entry, module registration, ProviderScope
│   │
│   ├── core/                          # App-wide infrastructure (no game logic)
│   │   ├── database/
│   │   │   ├── app_database.dart      # @DriftDatabase, schema v1, WAL + FK pragmas
│   │   │   ├── tables/
│   │   │   │   ├── game_sessions.dart
│   │   │   │   ├── score_entries.dart
│   │   │   │   ├── history_records.dart
│   │   │   │   ├── notepad_entries.dart
│   │   │   │   └── tally_counters.dart
│   │   │   └── daos/
│   │   │       ├── session_dao.dart
│   │   │       ├── history_dao.dart
│   │   │       └── tools_dao.dart
│   │   ├── models/                    # @freezed domain models (GameSession, SessionPlayer, etc.)
│   │   │   ├── game_session.dart
│   │   │   ├── session_player.dart
│   │   │   ├── score_entry.dart
│   │   │   ├── history_record.dart
│   │   │   └── user_preferences.dart
│   │   ├── modules/                   # GameModule interface + registry
│   │   │   ├── game_module.dart       # abstract interface GameModule
│   │   │   ├── game_module_registry.dart
│   │   │   ├── game_module_state.dart # abstract class GameModuleState
│   │   │   ├── score_action.dart      # sealed class ScoreAction
│   │   │   ├── leaderboard_entry.dart
│   │   │   ├── win_result.dart
│   │   │   └── scoring_layout_descriptor.dart
│   │   ├── providers/                 # @riverpod: db, prefs, active session, history
│   │   │   ├── database_provider.dart
│   │   │   ├── preferences_provider.dart
│   │   │   ├── active_sessions_provider.dart
│   │   │   ├── history_provider.dart
│   │   │   └── prefs_keys.dart
│   │   └── router/
│   │       └── app_router.dart        # GoRouter + StatefulShellRoute config
│   │
│   ├── features/
│   │   ├── home/                      # Tab 0: game module picker grid
│   │   │   └── presentation/
│   │   │       ├── home_screen.dart
│   │   │       └── game_module_card.dart
│   │   │
│   │   ├── modules/                   # Scoring game modules
│   │   │   │
│   │   │   ├── custom/                # Custom / Freeform spreadsheet grid
│   │   │   │   ├── domain/
│   │   │   │   │   ├── custom_game_module.dart     # implements GameModule
│   │   │   │   │   └── custom_game_state.dart      # @freezed CustomGameState
│   │   │   │   └── presentation/
│   │   │   │       ├── custom_setup_screen.dart
│   │   │   │       └── custom_session_screen.dart  # spreadsheet grid
│   │   │   │
│   │   │   ├── darts/                 # 9 darts variants
│   │   │   │   ├── domain/
│   │   │   │   │   ├── darts_module_base.dart      # shared darts logic
│   │   │   │   │   ├── darts_501_module.dart
│   │   │   │   │   ├── darts_301_module.dart
│   │   │   │   │   ├── darts_701_module.dart
│   │   │   │   │   ├── darts_cricket_module.dart
│   │   │   │   │   ├── darts_cut_throat_module.dart
│   │   │   │   │   ├── darts_around_the_clock_module.dart
│   │   │   │   │   ├── darts_shanghai_module.dart
│   │   │   │   │   ├── darts_killer_module.dart
│   │   │   │   │   ├── darts_halve_it_module.dart
│   │   │   │   │   └── darts_game_state.dart       # @freezed DartsGameState
│   │   │   │   ├── application/
│   │   │   │   │   └── darts_bloc.dart             # BLoC: DartsEvent → DartsState
│   │   │   │   └── presentation/
│   │   │   │       ├── darts_variant_picker_screen.dart
│   │   │   │       ├── darts_setup_screen.dart
│   │   │   │       ├── darts_session_screen.dart
│   │   │   │       └── darts_keypad_widget.dart    # 1–20 grid + bull + multipliers
│   │   │   │
│   │   │   ├── yahtzee/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── yahtzee_module.dart
│   │   │   │   │   └── yahtzee_state.dart
│   │   │   │   ├── application/
│   │   │   │   │   └── yahtzee_cubit.dart          # Cubit: category select, dice hold
│   │   │   │   └── presentation/
│   │   │   │       ├── yahtzee_setup_screen.dart
│   │   │   │       ├── yahtzee_session_screen.dart
│   │   │   │       ├── yahtzee_scorecard_widget.dart
│   │   │   │       └── yahtzee_dice_widget.dart    # 5 dice + hold toggles
│   │   │   │
│   │   │   ├── golf/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── golf_module.dart            # handles 9, 18, mini variants
│   │   │   │   │   └── golf_state.dart
│   │   │   │   └── presentation/
│   │   │   │       ├── golf_setup_screen.dart
│   │   │   │       └── golf_session_screen.dart    # hole-by-hole grid + par labels
│   │   │   │
│   │   │   ├── cribbage/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── cribbage_module.dart
│   │   │   │   │   └── cribbage_state.dart
│   │   │   │   ├── application/
│   │   │   │   │   └── cribbage_cubit.dart
│   │   │   │   └── presentation/
│   │   │   │       ├── cribbage_setup_screen.dart
│   │   │   │       ├── cribbage_session_screen.dart
│   │   │   │       └── cribbage_board_widget.dart  # CustomPainter + peg animation
│   │   │   │
│   │   │   ├── bowling/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── bowling_module.dart
│   │   │   │   │   └── bowling_state.dart
│   │   │   │   ├── application/
│   │   │   │   │   └── bowling_cubit.dart          # frame state machine
│   │   │   │   └── presentation/
│   │   │   │       ├── bowling_setup_screen.dart
│   │   │   │       ├── bowling_session_screen.dart
│   │   │   │       └── bowling_sheet_widget.dart   # CustomPainter frame grid
│   │   │   │
│   │   │   ├── farkle/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── farkle_module.dart
│   │   │   │   │   └── farkle_state.dart
│   │   │   │   └── presentation/
│   │   │   │       ├── farkle_setup_screen.dart
│   │   │   │       └── farkle_session_screen.dart
│   │   │   │
│   │   │   ├── uno/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── uno_module.dart
│   │   │   │   │   └── uno_state.dart
│   │   │   │   └── presentation/
│   │   │   │       ├── uno_setup_screen.dart
│   │   │   │       └── uno_session_screen.dart
│   │   │   │
│   │   │   └── dominoes/
│   │   │       ├── domain/
│   │   │       │   ├── dominoes_module.dart
│   │   │       │   └── dominoes_state.dart
│   │   │       └── presentation/
│   │   │           ├── dominoes_setup_screen.dart
│   │   │           └── dominoes_session_screen.dart
│   │   │
│   │   ├── shared_session/            # Shared scaffolding used by all game modules
│   │   │   ├── game_session_scaffold.dart   # Bottom bar, leaderboard panel, End Game
│   │   │   ├── session_setup_scaffold.dart  # Player name entry, player count picker
│   │   │   └── session_summary_screen.dart  # Win screen, final standings
│   │   │
│   │   ├── tools/                     # Tab 1: game utility tools
│   │   │   ├── tools_screen.dart      # Tool grid
│   │   │   ├── dice/
│   │   │   │   ├── dice_roller_screen.dart
│   │   │   │   ├── die_widget.dart                 # CustomPainter die face
│   │   │   │   └── shake_provider.dart             # sensors_plus stream → Riverpod
│   │   │   ├── coin/
│   │   │   │   └── coin_flip_screen.dart           # Rive state machine
│   │   │   ├── spinner/
│   │   │   │   ├── spinner_screen.dart
│   │   │   │   └── spinner_painter.dart            # CustomPainter pie chart
│   │   │   ├── timer/
│   │   │   │   ├── timer_screen.dart
│   │   │   │   └── hourglass_widget.dart           # Lottie animation
│   │   │   ├── stopwatch/
│   │   │   │   └── stopwatch_screen.dart
│   │   │   ├── lives/
│   │   │   │   └── lives_counter_screen.dart
│   │   │   ├── tally/
│   │   │   │   └── tally_counter_screen.dart
│   │   │   ├── notepad/
│   │   │   │   ├── notepad_list_screen.dart
│   │   │   │   └── notepad_detail_screen.dart
│   │   │   └── team_picker/
│   │   │       └── team_picker_screen.dart
│   │   │
│   │   ├── history/                   # Tab 2: completed session history
│   │   │   ├── history_list_screen.dart
│   │   │   └── history_detail_screen.dart
│   │   │
│   │   └── settings/                  # Tab 3: preferences
│   │       └── settings_screen.dart
│   │
│   └── ui/                            # Shared presentation layer
│       ├── theme/
│       │   ├── app_theme.dart         # ThemeData factory for light/dark + both palettes
│   │   │   ├── color_tokens.dart      # Brand color constants (#0C2340, #236192, etc.)
│   │   │   └── text_styles.dart       # Typography scale
│       ├── painters/
│       │   ├── cribbage_board_painter.dart
│       │   ├── bowling_sheet_painter.dart
│       │   └── spinner_painter.dart
│       └── widgets/                   # Reusable app-wide widgets
│           ├── score_cell.dart        # Score entry cell for grids
│           ├── leaderboard_row.dart   # Single row in leaderboard panel
│           ├── player_chip.dart       # Player name + color badge
│           ├── die_widget.dart        # Animated die face
│           ├── numeric_keypad.dart    # Shared numeric input keypad
│           └── app_bottom_nav_bar.dart
│
├── test/
│   ├── unit/
│   │   ├── modules/                   # GameModule rule engine tests
│   │   │   ├── darts_501_test.dart
│   │   │   ├── darts_cricket_test.dart
│   │   │   ├── yahtzee_scoring_test.dart
│   │   │   ├── bowling_frame_test.dart
│   │   │   ├── cribbage_peg_test.dart
│   │   │   ├── golf_par_test.dart
│   │   │   └── farkle_scoring_test.dart
│   │   ├── blocs/
│   │   │   ├── darts_bloc_test.dart
│   │   │   └── bowling_cubit_test.dart
│   │   └── database/
│   │       ├── session_dao_test.dart
│   │       └── history_dao_test.dart
│   ├── widget/
│   │   ├── yahtzee_scorecard_test.dart
│   │   ├── custom_session_screen_test.dart
│   │   ├── leaderboard_widget_test.dart
│   │   └── settings_theme_switch_test.dart
│   └── integration/
│       ├── custom_session_e2e_test.dart
│       ├── darts_501_e2e_test.dart
│       ├── yahtzee_e2e_test.dart
│       └── launch_performance_test.dart
│
├── android/
│   └── app/
│       └── src/main/AndroidManifest.xml  # Motion sensor permission declaration
│
├── ios/
│   └── Runner/
│       └── Info.plist                    # NSMotionUsageDescription
│
└── assets/
    ├── animations/
    │   ├── coin_flip.riv              # Rive: heads/tails state machine
    │   ├── spinner_wheel.riv          # Rive: spin + decelerate state machine
    │   ├── hourglass.json             # Lottie: looping hourglass sand
    │   └── win_celebration.json       # Lottie: confetti one-shot
    ├── sounds/
    │   ├── dice_roll.wav
    │   ├── coin_flip.wav
    │   ├── timer_alert.wav
    │   ├── score_confirm.wav
    │   └── bust.wav
    └── fonts/
        └── (brand typography)
```

**Structure Decision**: Feature-first, domain-driven. Each game module is a self-contained feature folder with `domain/`, `application/` (optional), and `presentation/` sub-layers. Shared infrastructure in `core/`. Shared UI primitives in `ui/`. This directly maps to Constitution Principle II's "each module encapsulates its own rules, scoring logic, and state transitions."

---

## Complexity Tracking

> No constitution violations detected. This section is intentionally empty.

---

## Appendix A — Color Palette Tokens

| Token | Light Mode | Dark Mode | Usage |
|-------|-----------|-----------|-------|
| `primary` (Timberwolves) | `#0C2340` | `#236192` | App bar, primary buttons |
| `secondary` (Timberwolves) | `#236192` | `#9ea2a2` | Cards, secondary elements |
| `accent` (Timberwolves) | `#78BE20` | `#78BE20` | CTAs, leader highlight, active nav tab |
| `neutral` | `#9ea2a2` | `#9ea2a2` | Borders, disabled states |
| `surface` | `#FFFFFF` | `#1A1A2E` | Card backgrounds |
| `background` | `#F5F7FA` | `#0C2340` | Screen backgrounds |
| `primary` (Prince alt) | `#221C35` | `#221C35` | Same roles as Timberwolves primary |
| `accent` (Prince alt) | `#981D97` | `#981D97` | Replaces `#78BE20` when alternate palette active |

---

## Appendix B — Darts Game Variant Reference

| Variant | Starting Score | Win Condition | Special Rules |
|---------|---------------|---------------|---------------|
| 301 | 301 | Reach exactly 0 | Optional double-in, optional double-out |
| 501 | 501 | Reach exactly 0 | Optional double-in, optional double-out |
| 701 | 701 | Reach exactly 0 | Optional double-in, optional double-out |
| Cricket | N/A | Close 15–20 + bull, lead points | Marks: singles=1, double=2, triple=3 |
| Cut-Throat Cricket | N/A | Open numbers add points to opponents | Lowest score when all numbers closed wins |
| Around the Clock | N/A | Hit 1–20 in order, then bull | Must hit each number once in sequence |
| Shanghai | N/A | Most points after 7 rounds | "Shanghai" (single+double+triple of same number) = instant win |
| Killer | N/A | Last player with lives | Assign numbers; hit own number = killer; killers take lives |
| Halve It | Varies | Highest score after all rounds | Miss a target = score halved |

---

## Appendix C — Performance Budget by Screen

| Screen | Target Render | Notes |
|--------|--------------|-------|
| Cold launch → Home | ≤ 2 000 ms | Drift DB init, module registration, audio pre-warm |
| Home → Game Setup | ≤ 250 ms | Slide-up transition |
| Game Setup → Active Session | ≤ 250 ms | Drift insert + module state init |
| Score entry → UI update | ≤ 300 ms | BLoC event → state → Drift write → stream → widget rebuild |
| Active Session → Summary | ≤ 300 ms | Fade transition + win animation start |
| Tab switch (all tabs) | ≤ 150 ms | StatefulShellRoute crossfade |
| History list load | ≤ 500 ms | Drift reactive stream, first emission |
| Tools screen open | ≤ 150 ms | No DB I/O, pure widget render |

---

## Appendix D — Known Implementation Gotchas

| # | Concern | Mitigation |
|---|---------|------------|
| 1 | Rive + Impeller visual discrepancies on iOS | Test all `.riv` files with and without `--no-enable-impeller`; use `RiveAnimation`'s Rive renderer if mismatches found |
| 2 | Drift first-launch schema creation can block UI thread | Use `NativeDatabase.createInBackground(file)` (background isolate) in `_openConnection()` |
| 3 | sensors_plus iOS crash without plist entry | Add `NSMotionUsageDescription` to `ios/Runner/Info.plist` before any motion code ships |
| 4 | sensors_plus Android on devices without accelerometer | Wrap `userAccelerometerEventStream()` in `onError` handler; disable shake feature silently |
| 5 | just_audio first-play latency (100–300 ms) | Call `player.setAsset('...')` during game loading screen; first `play()` will be instant |
| 6 | Riverpod autoDispose disposes game state on tab switch | Use `keepAlive: true` on `activeSessionProvider`; test tab switching mid-game in integration tests |
| 7 | BLoC bloc-to-bloc dependency temptation | No bloc may subscribe to another bloc's stream; coordinate via shared Repository or push to presentation layer |
| 8 | Drift migrations — no auto-migration | Plan schema carefully before v1 launch; write `MigrationStrategy` tests with `verifyDatabase(schema)` |
| 9 | Cribbage 10th frame / peg-wrap at 60 | Peg snake: 0→60 forward column, 61→120 reverse column; `CustomPainter` must map score to (x,y) via snake-path lookup table |
| 10 | Yahtzee category = 0 vs unscored | Represent unscored as `null`, not `0` — a 0-point assignment is a valid intentional score |
| 11 | Bowling 10th frame (up to 3 rolls) | Frame index 9 is special; cumulative score not computable until 12th roll is recorded |
| 12 | Farkle opening threshold (500 pts) | Players with `has_opened: false` cannot accumulate score below 500; first turn must reach 500 to "open" |
