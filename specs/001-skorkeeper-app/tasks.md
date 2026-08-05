# Tasks: SkorKeeper â€” All-In-One Scoring & Game Tools App

**Feature Branch**: `001-skorkeeper-app`
**Input**: `specs/001-skorkeeper-app/` â€” spec.md, plan.md, data-model.md, research.md, quickstart.md, contracts/
**Constitution**: `.specify/memory/constitution.md` â€” Cross-platform, game-agnostic modules, offline-first, speed, extensibility

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Parallelizable (operates on different files, no dependency on a sibling in-progress task)
- **[US#]**: User story label mapping to spec.md priorities (US1â€“US8, US-extra)
- All file paths are relative to the Flutter project root (`SkorKeeper/`)

---

## Phase 1: Project Setup

**Purpose**: Initialize the Flutter project, configure platforms, establish folder structure, declare all dependencies and assets, and wire up linting. No game logic here â€” just the empty scaffold the rest of the project builds on.

- [x] T001 Create Flutter project (`flutter create --org com.skorkeeper --platforms ios,android skorkeeper`) and verify `flutter run` boots to the default counter app
- [x] T002 Replace `pubspec.yaml` with full dependency manifest: `go_router ^14.6.3`, `flutter_riverpod ^2.6.1`, `riverpod_annotation ^2.6.1`, `flutter_bloc ^9.0.0`, `bloc ^9.0.0`, `drift ^2.25.0`, `sqlite3_flutter_libs ^0.5.28`, `shared_preferences ^2.5.3`, `flutter_animate ^4.5.2`, `lottie ^3.3.1`, `rive ^0.13.20`, `sensors_plus ^6.1.1`, `just_audio ^0.9.46`, `audio_session ^0.1.22`, `freezed_annotation ^3.0.0`, `json_annotation ^4.9.0`, `collection ^1.19.1`, `intl ^0.20.2`, `flutter_svg ^2.0.17`; dev deps: `build_runner ^2.4.15`, `riverpod_generator ^2.6.1`, `drift_dev ^2.25.0`, `freezed ^3.0.0`, `json_serializable ^6.9.5`, `mocktail ^1.0.4`, `bloc_test ^9.1.7`
- [x] T003 [P] Declare all asset paths in `pubspec.yaml` under `flutter.assets`: `assets/animations/` (coin_flip.riv, spinner_wheel.riv, hourglass.json, win_celebration.json), `assets/sounds/` (dice_roll.wav, coin_flip.wav, timer_alert.wav, score_confirm.wav, bust.wav), `assets/fonts/`
- [x] T004 [P] Configure Android: set `minSdkVersion 26` in `android/app/build.gradle`; add `<uses-feature android:name="android.hardware.sensor.accelerometer" android:required="false"/>` to `android/app/src/main/AndroidManifest.xml`; register deep-link intent filter for `skorkeeper://` scheme
- [x] T005 [P] Configure iOS: set `IPHONEOS_DEPLOYMENT_TARGET = 14.0` in `ios/Runner.xcodeproj/project.pbxproj`; add `NSMotionUsageDescription` key ("SkorKeeper uses motion to detect shake-to-roll") to `ios/Runner/Info.plist`; register `skorkeeper://` URL scheme in `Info.plist`
- [x] T006 [P] Create `analysis_options.yaml` at project root: extend `package:flutter_lints/flutter.yaml`; enable `prefer_const_constructors`, `avoid_print`, `use_key_in_widget_constructors`, `lines_longer_than_80_chars` (warn); configure `dart_code_metrics` include rules for unused code
- [x] T007 [P] Create complete folder structure under `lib/`: `core/database/tables/`, `core/database/daos/`, `core/models/`, `core/modules/`, `core/providers/`, `core/router/`; `features/home/presentation/`, `features/shared_session/`, `features/modules/custom/domain/`, `features/modules/custom/presentation/`, `features/modules/darts/domain/`, `features/modules/darts/application/`, `features/modules/darts/presentation/`, `features/modules/yahtzee/domain/`, `features/modules/yahtzee/application/`, `features/modules/yahtzee/presentation/`, `features/modules/golf/domain/`, `features/modules/golf/presentation/`, `features/modules/cribbage/domain/`, `features/modules/cribbage/application/`, `features/modules/cribbage/presentation/`, `features/modules/bowling/domain/`, `features/modules/bowling/application/`, `features/modules/bowling/presentation/`, `features/modules/farkle/domain/`, `features/modules/farkle/presentation/`, `features/modules/uno/domain/`, `features/modules/uno/presentation/`, `features/modules/dominoes/domain/`, `features/modules/dominoes/presentation/`; `features/tools/dice/`, `features/tools/coin/`, `features/tools/spinner/`, `features/tools/timer/`, `features/tools/stopwatch/`, `features/tools/lives/`, `features/tools/tally/`, `features/tools/notepad/`, `features/tools/team_picker/`; `features/history/`, `features/settings/`; `ui/theme/`, `ui/painters/`, `ui/widgets/`
- [x] T008 [P] Add placeholder asset stub files: empty `assets/animations/coin_flip.riv`, `assets/animations/spinner_wheel.riv`, `assets/animations/hourglass.json` (valid empty Lottie JSON `{}`), `assets/animations/win_celebration.json`; empty WAV placeholders for all five `assets/sounds/*.wav` entries; create `assets/fonts/.gitkeep`; verify `flutter pub get` succeeds and `flutter analyze` reports zero errors
- [x] T009 Create `test/`, `test/unit/modules/`, `test/unit/blocs/`, `test/unit/database/`, `test/widget/`, `test/integration/` directories; add a single passing smoke test in `test/smoke_test.dart` (`expect(1, 1)`) to confirm `flutter test` runs cleanly

**Checkpoint**: `flutter pub get`, `flutter analyze`, and `flutter test` all pass with zero errors on a fresh clone.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that ALL user stories depend on â€” color system, typography, Drift database, @freezed domain models, GameModule interface, Riverpod providers, go_router shell, shared session scaffolding, and the HomeScreen frame. No user story work can begin until this phase is complete.

**âš ï¸ CRITICAL**: Run `dart run build_runner build --delete-conflicting-outputs` after T025 (models complete) and again after adding each module's @freezed state class.

### Theme & Design System

- [x] T010 Implement `lib/ui/theme/color_tokens.dart`: define all brand color constants as `const Color` values â€” `navyPrimary (#0C2340)`, `lakeBlue (#236192)`, `moonlightSilver (#9ea2a2)`, `associationGreen (#78BE20)`, `princePurple (#221C35)`, `princeViolet (#981D97)` and semantic tokens (surface, background, onPrimary, etc.) for both light/dark modes
- [x] T011 [P] Implement `lib/ui/theme/text_styles.dart`: define `AppTextStyles` with `TextStyle` constants for display, headline, title, body, label, and caption using Flutter's `TextTheme` scale; use `GoogleFonts` or system font fallback; ensure all weights are available
- [x] T012 Implement `lib/ui/theme/app_theme.dart`: export `AppTheme.light(bool useAlternatePalette)` and `AppTheme.dark(bool useAlternatePalette)` factory methods returning fully configured `ThemeData` objects; use `color_tokens.dart` and `text_styles.dart`; apply palette swap (swap `#78BE20` â†’ `#981D97` and `#0C2340` â†’ `#221C35` when `useAlternatePalette = true`)

### Domain Models (@freezed)

- [x] T013 [P] Implement `lib/core/models/session_player.dart`: `@freezed SessionPlayer` with fields `id (String)`, `displayName (String)`, `colorHex (String)`, `seatOrder (int)`; add `@JsonSerializable` for `toJson`/`fromJson`; include `kDefaultPlayerColors` list constant (10 hex strings from data-model.md)
- [x] T014 [P] Implement `lib/core/models/score_entry.dart`: `@freezed ScoreEntry` with fields `id (int)`, `sessionId (int)`, `playerId (String)`, `roundNumber (int)`, `value (int)`, `notes (String?)`, `recordedAt (DateTime)`; add `@JsonSerializable`
- [x] T015 [P] Implement `lib/core/models/history_record.dart`: `@freezed HistoryRecord` with fields `id (int)`, `sessionId (int)`, `gameType (String)`, `sessionName (String?)`, `playerNames (String)`, `winnerDisplayName (String?)`, `finalScoresJson (String)`, `playedAt (DateTime)`, `durationSeconds (int?)`; add `@JsonSerializable`
- [x] T016 [P] Implement `lib/core/models/user_preferences.dart`: `@freezed UserPreferences` with fields `themeMode (ThemeMode)`, `useAlternatePalette (bool)`, `soundEnabled (bool)`, `hapticEnabled (bool)`, `shakeToRollEnabled (bool)`, `shakeSensitivity (double)`, `defaultPlayerNames (List<String>)`; include all `@Default` annotations per data-model.md
- [x] T017 Implement `lib/core/models/game_session.dart`: `@freezed GameSession` with fields `id (int)`, `gameType (String)`, `sessionName (String?)`, `status (SessionStatus)`, `startedAt (DateTime)`, `endedAt (DateTime?)`, `participants (List<SessionPlayer>)`, `moduleState (Map<String, dynamic>)`, `winnerDisplayName (String?)`; also define `enum GameType` (all 18 variants) and `enum SessionStatus { active, completed }` in `lib/core/models/game_type.dart`
- [x] T018 Run `dart run build_runner build --delete-conflicting-outputs` to generate all `.freezed.dart` and `.g.dart` files for T013â€“T017; verify `flutter analyze` passes

### Drift Database Layer

- [x] T019 [P] Implement `lib/core/database/tables/game_sessions.dart`: `GameSessions extends Table` per storage_schema.md contract â€” columns `id`, `gameType`, `sessionName`, `status`, `startedAt`, `endedAt`, `participantsJson`, `moduleStateJson`, `winnerDisplayName`; define all three `Index` entries (`idx_sessions_status`, `idx_sessions_game_type_status`, `idx_sessions_started_at`)
- [x] T020 [P] Implement `lib/core/database/tables/score_entries.dart`: `ScoreEntries extends Table` â€” columns `id`, `sessionId` (FK â†’ GameSessions with cascade delete), `playerId`, `roundNumber`, `value`, `notes`, `recordedAt`; define three `Index` entries
- [x] T021 [P] Implement `lib/core/database/tables/history_records.dart`: `HistoryRecords extends Table` â€” columns `id`, `sessionId` (FK â†’ GameSessions, unique), `gameType`, `sessionName`, `playerNames`, `winnerDisplayName`, `finalScoresJson`, `playedAt`, `durationSeconds`; define `idx_history_game_type`, `idx_history_played_at`, `idx_history_player_names`
- [x] T022 [P] Implement `lib/core/database/tables/notepad_entries.dart`: `NotepadEntries extends Table` â€” columns `id`, `title` (default `'Note'`), `body` (default `''`), `updatedAt`
- [x] T023 [P] Implement `lib/core/database/tables/tally_counters.dart`: `TallyCounters extends Table` â€” columns `id`, `name` (default `'Counter'`), `value` (default `0`), `updatedAt`
- [x] T024 Implement `lib/core/database/daos/session_dao.dart`: `@DriftAccessor(tables: [GameSessions, ScoreEntries]) SessionDao` with methods `watchActiveSessions()`, `getSession(int id)`, `insertSession(GameSessionsCompanion)`, `updateModuleState(int sessionId, String stateJson)`, `completeSession(int id, String winnerName, int endedAt)`, `insertScoreEntry(ScoreEntriesCompanion)`, `watchScoreEntriesForSession(int sessionId)`; all write methods run in transactions where multiple rows are affected
- [x] T025 [P] Implement `lib/core/database/daos/history_dao.dart`: `@DriftAccessor(tables: [HistoryRecords]) HistoryDao` with methods `watchHistory()`, `watchHistoryByGameType(String gameType)`, `searchHistory(String query)` (LIKE on `playerNames` and `sessionName`), `insertHistoryRecord(HistoryRecordsCompanion)`, `getHistoryRecord(int sessionId)`, `deleteHistoryRecord(int id)`
- [x] T026 [P] Implement `lib/core/database/daos/tools_dao.dart`: `@DriftAccessor(tables: [NotepadEntries, TallyCounters]) ToolsDao` with methods `watchNotes()`, `getNote(int id)`, `insertNote(NotepadEntriesCompanion)`, `updateNote(int id, String title, String body)`, `deleteNote(int id)`, `watchTallyCounters()`, `upsertTallyCounter(TallyCountersCompanion)`, `deleteTallyCounter(int id)`
- [x] T027 Implement `lib/core/database/app_database.dart`: `@DriftDatabase(tables: [GameSessions, ScoreEntries, HistoryRecords, NotepadEntries, TallyCounters], daos: [SessionDao, HistoryDao, ToolsDao]) AppDatabase extends _$AppDatabase`; set `schemaVersion = 1`; implement `_openConnection()` using `NativeDatabase.createInBackground(file)` (background isolate); enable WAL mode and FK pragma in `beforeOpen` callback; define `MigrationStrategy` with `onCreate` that calls `createAll()`; add `onUpgrade` stub for future migrations
- [x] T028 Run `dart run build_runner build --delete-conflicting-outputs` to generate Drift code for T019â€“T027; verify `flutter analyze` passes

### GameModule Interface & Registry

- [x] T029 [P] Implement `lib/core/modules/game_module_state.dart`: `abstract class GameModuleState` with `const GameModuleState()` and abstract `Map<String, dynamic> toJson()`
- [x] T030 [P] Implement `lib/core/modules/score_action.dart`: `sealed class ScoreAction`; include concrete action classes `CustomRoundScoreEntered`, `DartThrown`, `YahtzeeScoreSelected`, `GolfHoleScoreEntered`, `CribbagePointsScored`, `BowlingRollEntered`, `FarkleBankScore`, `FarkleFarkled`, `UnoRoundScoreEntered`, `DominoesRoundScoreEntered` per contracts/game_module_interface.md
- [x] T031 [P] Implement `lib/core/modules/leaderboard_entry.dart`: `@freezed LeaderboardEntry` with fields `playerId`, `displayName`, `colorHex`, `rank (int)`, `scoreDisplay (String)`, `sortKey (int)`, `isLeading (bool)`
- [x] T032 [P] Implement `lib/core/modules/win_result.dart`: `@freezed WinResult` with fields `winnerId`, `winnerDisplayName`, `winDescription`, `finalStandings (List<LeaderboardEntry>)`
- [x] T033 [P] Implement `lib/core/modules/scoring_layout_descriptor.dart`: `enum ScoringLayoutType { numericKeypad, dartsKeypad, yahtzeeScorecard, golfScorecard, cribbageBoard, bowlingSheet, livesCounter }`; `@freezed ScoringLayoutDescriptor` with fields `type (ScoringLayoutType)`, `config (Map<String, dynamic>)`
- [x] T034 [P] Implement `lib/core/modules/score_validation_result.dart` (referenced as `ScoreValidationResult` in contracts): `@freezed ScoreValidationResult` with `const factory ScoreValidationResult.valid()` and `const factory ScoreValidationResult.invalid({required String reason, required String shortCode})`; also define `class InvalidScoreActionException implements Exception`
- [x] T035 Implement `lib/core/modules/game_module.dart`: `abstract interface class GameModule` per contracts/game_module_interface.md â€” getters `gameTypeId`, `displayName`, `description`, `iconAsset`, `minPlayers`, `maxPlayers`; methods `initialState(List<SessionPlayer>)`, `stateFromJson(Map<String, dynamic>)`, `applyAction(GameModuleState, ScoreAction)`, `leaderboard(GameModuleState)`, `checkWinCondition(GameModuleState)`, `scoringLayout(GameModuleState)`, `validateScore(GameModuleState, String, dynamic)`
- [x] T036 Implement `lib/core/modules/game_module_registry.dart`: `GameModuleRegistry` class with `static void register(GameModule)`, `static GameModule? get(String gameTypeId)`, `static List<GameModule> get all`; add assertion guard against duplicate `gameTypeId` registration

### Riverpod Providers

- [x] T037 [P] Implement `lib/core/providers/prefs_keys.dart`: `abstract class PrefsKeys` with all seven `static const String` key constants (`theme_mode`, `use_alternate_palette`, `sound_enabled`, `haptic_enabled`, `shake_to_roll_enabled`, `shake_sensitivity`, `default_player_names`) per data-model.md
- [x] T038 Implement `lib/core/providers/database_provider.dart`: `@riverpod AppDatabase appDatabase(Ref ref)` annotated with `keepAlive: true`; instantiate `AppDatabase()` and register `ref.onDispose(() => db.close())`
- [x] T039 [P] Implement `lib/core/providers/preferences_provider.dart`: `@riverpod class PreferencesNotifier extends _$PreferencesNotifier` with `keepAlive: true`; reads/writes all seven keys from `PrefsKeys` using `SharedPreferences`; exposes `updateThemeMode()`, `updatePalette()`, `updateSoundEnabled()`, `updateHapticEnabled()`, `updateShakeEnabled()`, `updateShakeSensitivity()`, `updateDefaultPlayerNames()` methods
- [x] T040 [P] Implement `lib/core/providers/active_sessions_provider.dart`: `@riverpod class ActiveSessionsNotifier extends _$ActiveSessionsNotifier` with `keepAlive: true`; wraps `SessionDao.watchActiveSessions()` stream; exposes `createSession(...)`, `recordScore(...)`, `endSession(...)` methods; all writes auto-persist to Drift and emit updated state
- [x] T041 [P] Implement `lib/core/providers/history_provider.dart`: `@riverpod class HistoryNotifier extends _$HistoryNotifier`; wraps `HistoryDao.watchHistory()` stream; exposes `filterByGameType(String?)`, `search(String)`, `deleteEntry(int id)` methods

### App Router

- [x] T042 Implement `lib/core/router/app_router.dart`: `@riverpod GoRouter appRouter(Ref ref)` with `keepAlive: true`; configure `StatefulShellRoute.indexedStack` with four branches (`/home`, `/tools`, `/history`, `/settings`) per contracts/navigation_routes.md; add all sub-routes (`/home/new/:gameTypeId`, `/home/session/:sessionId`, `/home/session/:sessionId/summary`, `/tools/dice`, `/tools/coin`, `/tools/spinner`, `/tools/timer`, `/tools/stopwatch`, `/tools/lives`, `/tools/tally`, `/tools/notepad`, `/tools/notepad/:noteId`, `/tools/team-picker`, `/history/:sessionId`); implement three redirect guards (restore active session on cold launch, block invalid sessionId, redirect non-completed session from history); configure `flutter_animate` page transitions per transition spec in navigation_routes.md

### Shared Session Scaffolding & Core UI Widgets

- [x] T043 [P] Implement `lib/features/shared_session/session_setup_scaffold.dart`: reusable `SessionSetupScaffold` widget with player name entry fields (up to 10), player count stepper, color assignment cycling through `kDefaultPlayerColors`, optional session name field, and "Start Game" CTA that validates player count is within module's `minPlayers`â€“`maxPlayers` before proceeding
- [x] T044 [P] Implement `lib/features/shared_session/game_session_scaffold.dart`: `GameSessionScaffold` widget providing common session chrome â€” app bar with session name + "End Game" button, collapsible live leaderboard panel (`LeaderboardRow` list, updates on every state change), and a content slot that renders the correct scoring widget based on `ScoringLayoutDescriptor.type`; "End Game" shows confirmation dialog then calls `activeSessionsProvider.endSession()`
- [x] T045 [P] Implement `lib/features/shared_session/session_summary_screen.dart`: read-only win screen showing winner name with `win_celebration.json` Lottie animation (one-shot), final standings via `LeaderboardRow` list, game duration, and "Done" button that pops to `/home`
- [x] T046 [P] Implement shared UI widgets in `lib/ui/widgets/`: `score_cell.dart` (tappable score input cell with confirm tap and `flutter_animate` `.scale()` feedback), `leaderboard_row.dart` (player rank, color chip, name, formatted score, leading indicator), `player_chip.dart` (colored avatar + display name badge), `numeric_keypad.dart` (0â€“9 grid + backspace + confirm, used by Custom/Farkle/Dominoes/UNO), `app_bottom_nav_bar.dart` (four-tab `NavigationBar` wired to `StatefulShellRoute`)
- [x] T047 [P] Implement `lib/ui/widgets/die_widget.dart`: `DieWidget` using `CustomPainter` â€” renders a die face (d6 default) with pip positions for values 1â€“6; supports `.shake()` + `.rotate()` via `flutter_animate` wrapper; `DieType` enum (d4, d6, d8, d10, d12, d20, d100) with numeric display fallback for non-d6 types
- [x] T048 Run `dart run build_runner build --delete-conflicting-outputs` to generate all provider/freezed code from T029â€“T047; verify `flutter analyze` passes with zero errors

### Home Screen & App Entry Point

- [x] T049 [P] Implement `lib/features/home/presentation/game_module_card.dart`: `GameModuleCard` widget â€” rounded card with `iconAsset` SVG, `displayName`, `description`, player count range badge; taps navigate to `/home/new/:gameTypeId`; applies `flutter_animate` `.fadeIn().slideY()` entrance animation
- [x] T050 [P] Implement `lib/features/home/presentation/home_screen.dart`: `HomeScreen` widget â€” scrollable grid of `GameModuleCard` widgets populated from `GameModuleRegistry.all`; shows active session resume banner if `activeSessionsProvider` has a session with `status=active`; tapping the banner navigates to `/home/session/:id`
- [x] T051 Implement `lib/main.dart`: `_registerModules()` function calling `GameModuleRegistry.register()` for all 18 modules (stubs initially); `void main()` that initializes `WidgetsFlutterBinding`, opens `AppDatabase`, configures `AudioSession` for `AVAudioSessionCategory.ambient`, wraps app in `ProviderScope` with `appDatabase` override; `SkorKeeperApp` `MaterialApp.router` using `appRouterProvider`; `ThemeData` from `AppTheme.light/dark` driven by `preferencesProvider`

**Checkpoint**: `flutter run` shows a themed HomeScreen with bottom nav and four tabs. `flutter test` passes. All Drift tables created on first launch. No active game modules yet (grid is empty until Phase 3+ modules are registered).

---

## Phase 3: User Story 1 â€” Custom / Freeform Scoring (Priority: P1) ðŸŽ¯ MVP

**Goal**: Replace a notepad for any game â€” spreadsheet-style grid, 1â€“10 players, round-by-round entry, real-time totals, session save/restore across app restarts.

**Independent Test**: Start a custom session ("Crazy Eights") with 4 players, enter 3 rounds of scores (including a negative), verify running totals update instantly, force-close the app, reopen and confirm full session restoration, tap "End Game" and verify winner is highlighted on summary screen.

- [x] T052 [P] [US1] Implement `lib/features/modules/custom/domain/custom_game_state.dart`: `@freezed CustomGameState extends GameModuleState` with fields `gameName (String)`, `roundLabels (List<String>)`, `scoreDirection (ScoreDirection enum: highWins | lowWins)`; `enum ScoreDirection { highWins, lowWins }`; implement `toJson()`/`fromJson()`
- [x] T053 [US1] Implement `lib/features/modules/custom/domain/custom_game_module.dart`: `CustomGameModule implements GameModule` â€” `gameTypeId = 'custom'`, `minPlayers = 1`, `maxPlayers = 10`; `initialState()` produces `CustomGameState` with empty `roundLabels` and `score_direction = highWins`; `applyAction()` handles `CustomRoundScoreEntered` (saves to `score_entries` table via `SessionDao`); `leaderboard()` sums all `ScoreEntry.value` per player; `checkWinCondition()` returns `WinResult` only if user explicitly calls "End Game" (no auto-win for Custom); `validateScore()` accepts any integer; `scoringLayout()` returns `numericKeypad`
- [x] T054 [US1] Implement `lib/features/modules/custom/presentation/custom_setup_screen.dart`: composing `SessionSetupScaffold` with additional "Score Direction" toggle (High Wins / Low Wins) and optional "Game Name" text field; routes to `/home/session/:sessionId` on confirm
- [x] T055 [US1] Implement `lib/features/modules/custom/presentation/custom_session_screen.dart`: spreadsheet grid using `GridView` â€” columns = players, rows = rounds; each cell is a `ScoreCell`; totals row pinned at bottom; current leading player column highlighted with accent color; "Add Round" FAB appends a new row; tapping a cell opens `NumericKeypad` overlay; score confirm triggers `CustomRoundScoreEntered` action â†’ `activeSessionsProvider` â†’ Drift write â†’ reactive stream â†’ leaderboard update; all within â‰¤300 ms per FR-034
- [x] T056 [US1] Register `CustomGameModule()` in `lib/main.dart` `_registerModules()` and add route case in `lib/core/router/app_router.dart` to render `CustomSetupScreen` for `gameTypeId = 'custom'` and `CustomSessionScreen` for active custom sessions

**Checkpoint**: Full Custom scoring flow â€” create session â†’ score rounds â†’ End Game â†’ Summary screen â€” works end-to-end. Session survives app restart. Leaderboard updates on every score entry.

---

## Phase 4: User Story 2 â€” Darts Module (Priority: P2)

**Goal**: Full darts scoring for 9 variants (301, 501, 701, Cricket, Cut-Throat Cricket, Around the Clock, Shanghai, Killer, Halve It) with bust detection, double-in/out options, live stats (remaining score, avg per dart, darts thrown).

**Independent Test**: Start a 501 game (double-out) with 2 players; enter several valid throws; enter a throw that causes a bust â€” verify score reverts; enter the exact checkout â€” verify game-over screen with correct winner. Then start a Cricket game and verify mark tracking and point attribution logic.

- [x] T057 [P] [US2] Implement `lib/features/modules/darts/domain/darts_game_state.dart`: `@freezed DartsGameState extends GameModuleState` matching the JSON schema in data-model.md â€” fields `gameVariant (DartsVariant enum)`, `doubleIn (bool)`, `doubleOut (bool)`, `playerStates (Map<String, DartsPlayerState>)`, `currentPlayerId (String)`, `currentThrowInTurn (int)`, `throwsThisTurn (List<int>)`, `legsWon (Map<String, int>)`, `setsWon (Map<String, int>)`, `cricketMarks (Map<String, Map<String, int>>?)`, `cricketPoints (Map<String, int>?)`, `gameOver (bool)`, `winnerId (String?)`; `@freezed DartsPlayerState` with `scoreRemaining`, `dartsThrown`, `scoresThisLeg`, `hasOpened`; `enum DartsVariant { v301, v501, v701, cricket, cutThroatCricket, aroundTheClock, shanghai, killer, halveIt }` 
- [x] T058 [US2] Implement `lib/features/modules/darts/domain/darts_module_base.dart`: abstract `DartsModuleBase implements GameModule` with shared x01 logic â€” `applyX01Throw(DartsGameState state, DartThrown action)` implementing bust detection (score < 0 OR score = 1 with double-out OR score = 0 without valid double), score reversion on bust, turn advancement, win detection (score = 0 with valid double when double-out enabled); `computeLeaderboard()` sorts by score remaining (ascending); `averagePerDart()` stat calculation; `validateScore()` checks throw value is 1â€“20 or 25 and multiplier is 1â€“3
- [x] T059 [P] [US2] Implement the three x01 variant modules: `lib/features/modules/darts/domain/darts_501_module.dart` (`Darts501Module extends DartsModuleBase`, `initialState()` sets `scoreRemaining = 501`), `darts_301_module.dart` (starts at 301), `darts_701_module.dart` (starts at 701)
- [x] T060 [P] [US2] Implement `lib/features/modules/darts/domain/darts_cricket_module.dart`: `DartsCricketModule extends DartsModuleBase` â€” target numbers 15â€“20 + bull; `applyAction()` increments marks for the thrown number (single=1, double=2, triple=3, capped at 3); when marks â‰¥ 3 and opponent has < 3 marks, award points to thrower; `checkWinCondition()` when all numbers closed AND player leads or ties in points; `scoringLayout()` returns `dartsKeypad`
- [x] T061 [P] [US2] Implement remaining 5 darts variant modules: `darts_cut_throat_module.dart` (Cut-Throat Cricket â€” open numbers add points to ALL opponents instead of self), `darts_around_the_clock_module.dart` (must hit 1â€“20 in sequence then bull), `darts_shanghai_module.dart` (7 rounds, highest score wins; Shanghai = instant win), `darts_killer_module.dart` (assign numbers, gain killer status, take opponent lives), `darts_halve_it_module.dart` (miss target = score halved; highest score wins); all in `lib/features/modules/darts/domain/`
- [x] T062 [US2] Implement `lib/features/modules/darts/application/darts_bloc.dart`: `DartsBloc extends Bloc<DartsEvent, DartsState>` (using `bloc ^9.0.0`); define sealed `DartsEvent` hierarchy (`DartThrown`, `UndoLastDart`, `EndTurn`, `NewGame`); `DartsState` wraps `DartsGameState`; `EventHandler` for `DartThrown` calls the active module's `applyAction()`, persists new state via `SessionDao`, emits new `DartsState`; `UndoLastDart` reverts last throw (pop from `throwsThisTurn`); `EndTurn` forces turn advancement; `on<_>` uses `EventTransformer.sequential()` to prevent out-of-order state
- [x] T063 [P] [US2] Implement `lib/features/modules/darts/presentation/darts_variant_picker_screen.dart`: grid of darts variant cards (9 variants) with icons, variant name, and brief description; taps navigate to `DartsSetupScreen` with selected variant passed as route parameter; `lib/features/modules/darts/presentation/darts_setup_screen.dart` composing `SessionSetupScaffold` plus variant-specific options (double-in/out toggles for x01 variants)
- [x] T064 [US2] Implement `lib/features/modules/darts/presentation/darts_session_screen.dart`: wraps `GameSessionScaffold`; displays current player's remaining score prominently; shows per-player stats bar (darts thrown, average per dart); integrates `DartsKeypadWidget`; bust throws trigger red flash + `bust.wav` audio + haptic; checkout suggestions panel (possible finishes) displayed when score â‰¤ 170
- [x] T065 [US2] Implement `lib/features/modules/darts/presentation/darts_keypad_widget.dart`: 4Ã—5 grid of buttons (1â€“20) + bull (25/50) + Ã—1/Ã—2/Ã—3 multiplier toggles + miss button; "Confirm Throw" CTA dispatches `DartThrown` event to `DartsBloc`; buttons styled with Timberwolves colors; real-time score preview showing what remaining score would be after current throw; register all 9 darts modules in `lib/main.dart` and add variant-picker routing in `app_router.dart`

**Checkpoint**: Complete 501 and Cricket game flows work end-to-end. Busts revert correctly. Win screen appears on checkout. Average/stats update live.

---

## Phase 5: User Story 3 â€” Game Tools (Priority: P3)

**Goal**: 9 standalone tools accessible from the Tools tab â€” Dice Roller (shake-to-roll, multi-die/type), Coin Flipper (Rive animation), Spinner (customizable segments), Timer/Countdown (hourglass Lottie, alert on expiry), Stopwatch, Lives Counter, Notepad (persisted), Tally Counter (persisted), Random Team Picker.

**Independent Test**: Open Tools tab; shake device to roll 2d6 â€” verify result appears within 500ms with animation; flip a coin â€” verify animation and result; start a 10-second timer â€” verify Lottie animation runs and audio+haptic fires on expiry; create and save a Notepad entry â€” verify it persists after app restart; configure Spinner with 4 segments â€” verify spin animation resolves to one winner.

### Tools Infrastructure

- [x] T066 [P] [US3] Implement `lib/features/tools/tools_screen.dart`: `ToolsScreen` widget â€” 3Ã—3 grid of tool tiles (icon + label); tiles for Dice, Coin, Spinner, Timer, Stopwatch, Lives, Tally, Notepad, Team Picker; each taps to its sub-route; `flutter_animate` `.fadeIn().slideY()` staggered entrance animation
- [x] T067 [P] [US3] Implement `lib/features/tools/dice/shake_provider.dart`: `@riverpod ShakeProvider` â€” subscribes to `SensorsPlatform.instance.userAccelerometerEventStream()`; computes vector magnitude; emits shake events when magnitude exceeds `shakeSensitivity` threshold (from prefs) with 800ms cooldown; wraps stream in `onError` handler for devices without accelerometer (disables shake silently per gotcha #4)

### Dice Roller

- [x] T068 [US3] Implement `lib/features/tools/dice/dice_roller_screen.dart`: Riverpod-backed screen with `dieCount (1â€“10)` stepper and `DieType` picker (d4, d6, d8, d10, d12, d20, d100); displays `dieCount` instances of `DieWidget` in a wrap layout; "Roll" FAB + shake gesture (via `shakeProvider`) both trigger roll; roll plays `dice_roll.wav` + `HapticFeedback.mediumImpact()`; each die animates via `flutter_animate` `.shake().rotate()` for 400ms then reveals result; shows sum total prominently below dice

### Coin Flipper

- [x] T069 [P] [US3] Implement `lib/features/tools/coin/coin_flip_screen.dart`: displays `RiveAnimation.asset('assets/animations/coin_flip.riv')` state machine; "Flip" FAB generates random `heads | tails` and triggers the corresponding Rive state machine input; plays `coin_flip.wav` + `HapticFeedback.lightImpact()`; shows result label ("Heads!" / "Tails!") with `flutter_animate` `.fadeIn()` after animation completes; flip history (last 5 results) shown below

### Spinner

- [x] T070 [P] [US3] Implement `lib/ui/painters/spinner_painter.dart`: `SpinnerPainter extends CustomPainter` â€” renders pie chart with up to 20 colored segments; accepts `List<SpinnerSegment>` (label, color) and `double rotationAngle`; draws filled arc per segment with contrast label text; highlights winning segment with border glow; also implement `lib/features/tools/spinner/spinner_screen.dart`: segment editor (add/remove/rename/recolor up to 20 segments, minimum 2); "Spin" button triggers `RiveAnimation` if riv asset available, else `AnimationController` + `CurvedAnimation` for deceleration; final angle determines winner segment; displays winner with `flutter_animate` pulse

### Timer & Stopwatch

- [x] T071 [P] [US3] Implement `lib/features/tools/timer/hourglass_widget.dart`: `HourglassWidget` wrapping `Lottie.asset('assets/animations/hourglass.json')`; accepts `progress (0.0â€“1.0)` and drives Lottie `AnimationController` to match elapsed fraction; loops sand animation; implement `lib/features/tools/timer/timer_screen.dart`: duration picker (hours:minutes:seconds, max 99h); Riverpod `TimerNotifier` (autoDispose) using `Stream.periodic`; displays `HourglassWidget` + digital countdown; on expiry plays `timer_alert.wav` + `HapticFeedback.heavyImpact()` (3 pulses); respects `soundEnabled` pref (haptic-only fallback if muted)
- [x] T072 [P] [US3] Implement `lib/features/tools/stopwatch/stopwatch_screen.dart`: Riverpod `StopwatchNotifier` (autoDispose) with `start()`, `stop()`, `reset()`, `lap()` actions; displays elapsed time (MM:SS.mm); lap list below; large tap-target buttons per constitution Principle IV

### Lives & Tally

- [x] T073 [P] [US3] Implement `lib/features/tools/lives/lives_counter_screen.dart`: player count selector (1â€“10), starting lives picker (1â€“999); each player shown as a card with `-` / `+` buttons (large 44pt tap targets); zero-lives players shown with skull indicator and "eliminated" styling; player names editable inline; state managed by Riverpod `LivesNotifier` (autoDispose â€” ephemeral, not persisted)
- [x] T074 [P] [US3] Implement `lib/features/tools/tally/tally_counter_screen.dart`: Riverpod `TallyNotifier` backed by `ToolsDao.watchTallyCounters()` Drift stream (persisted); displays all counters as scrollable cards with large `+` / `-` / reset buttons; "Add Counter" FAB; swipe-to-delete; counter names editable via tap; tap `+`/`-` triggers `HapticFeedback.selectionClick()`

### Notepad

- [x] T075 [P] [US3] Implement `lib/features/tools/notepad/notepad_list_screen.dart`: scrollable list of `NotepadEntry` rows from `ToolsDao.watchNotes()` Drift stream; shows `title` and truncated `body` preview; swipe-to-delete with undo snackbar; "New Note" FAB creates a blank entry and navigates to detail; implement `lib/features/tools/notepad/notepad_detail_screen.dart`: editable `title` field (top) + full-width `body` `TextField` (multiline, autofocus); auto-saves on every `onChanged` via debounce (500ms) using `ToolsDao.updateNote()`; back navigation is immediate (no explicit save button required)

### Team Picker

- [x] T076 [P] [US3] Implement `lib/features/tools/team_picker/team_picker_screen.dart`: player name entry (add/remove individual names, or import from "default player names" prefs); number-of-teams stepper (2â€“10, max = player count); "Pick Teams" button shuffles names with `flutter_animate` `.shake()` then distributes into teams using Fisher-Yates shuffle; results displayed as color-coded team cards; "Reshuffle" re-randomizes without re-entering names

**Checkpoint**: All 9 tools usable independently from the Tools tab. Notepad and Tally entries persist across app restarts. Dice shake-to-roll works on device. Timer expiry fires audio + haptic.

---

## Phase 6: User Story 4 â€” Golf / Mini Golf (Priority: P4)

**Goal**: Structured scorecard for 9-hole and 18-hole golf with configurable par per hole, relative-to-par display (eagle/birdie/par/bogey/etc.), live leaderboard, and Mini Golf mode (1â€“18 holes, no par tracking).

**Independent Test**: Start a 9-hole golf session with 4 players; enter par values; record scores for all 9 holes; verify eagle/birdie/bogey labels are correctly computed and color-coded; verify the final leaderboard shows lowest total strokes as winner.

- [x] T077 [P] [US4] Implement `lib/features/modules/golf/domain/golf_state.dart`: `@freezed GolfState extends GameModuleState` with fields `holeCount (int)`, `pars (List<int>)`, `scores (Map<String, List<int?>>)`, `isMiniGolf (bool)`, `currentHole (int)`; `toJson()`/`fromJson()`; helper `relativeToParLabel(int strokes, int par) â†’ String` returning eagle/birdie/par/bogey/double bogey/triple bogey/+N
- [x] T078 [US4] Implement `lib/features/modules/golf/domain/golf_module.dart`: `GolfModule implements GameModule` â€” `gameTypeId = 'golf_9'|'golf_18'|'minigolf'`; `initialState()` creates state with null-filled score lists; `applyAction()` handles `GolfHoleScoreEntered` (validates value â‰¥ 1); `leaderboard()` sums all non-null scores per player and sorts ascending (lowest = winner); `checkWinCondition()` triggers when all holes for all players are non-null; `scoringLayout()` returns `golfScorecard`; implement `Golf9Module`, `Golf18Module`, `MiniGolfModule` as thin subclasses setting `holeCount` and `isMiniGolf`
- [x] T079 [US4] Implement `lib/features/modules/golf/presentation/golf_setup_screen.dart`: composing `SessionSetupScaffold` plus hole count confirmation (9/18 for golf; 1â€“18 stepper for mini golf); par value entry grid (one field per hole for standard golf; hidden for mini golf); validates par â‰¥ 1 per hole
- [x] T080 [US4] Implement `lib/features/modules/golf/presentation/golf_session_screen.dart`: hole-by-hole scorecard grid â€” rows = holes, columns = players; each cell shows entered score + relative-to-par label color-coded (eagle=gold, birdie=green, par=white/neutral, bogey=orange, double bogey=red); current hole highlighted; numeric input via `NumericKeypad` overlay; pinned totals row; live leaderboard panel via `GameSessionScaffold`; register Golf9Module, Golf18Module, MiniGolfModule in `lib/main.dart`

**Checkpoint**: Full 9-hole golf session with par tracking works. Mini Golf mode hides par column. Score labels (birdie, bogey, etc.) display correctly. Lowest score wins.

---

## Phase 7: User Story 5 â€” Yahtzee (Priority: P5)

**Goal**: Official Yahtzee scorecard (upper section, lower section, all bonuses), built-in 5-dice roller with hold toggles, 1â€“6 players, automatic sub-total and bonus calculation.

**Independent Test**: Play a 2-player Yahtzee game to completion; fill all 13 categories for both players; verify upper-section bonus (+35 if upper â‰¥ 63) is applied correctly; verify Yahtzee bonus (+100 per additional Yahtzee) works; verify final totals and winner determination.

- [x] T081 [P] [US5] Implement `lib/features/modules/yahtzee/domain/yahtzee_state.dart`: `@freezed YahtzeeState extends GameModuleState` â€” fields `currentPlayerIndex (int)`, `currentRollNumber (int, 1â€“3)`, `diceValues (List<int>)` (5 dice), `diceHeld (List<bool>)`, `scorecards (Map<String, YahtzeeScorecard>)`; `@freezed YahtzeeScorecard` with all 13 nullable `int?` category fields plus `yahtzeeBonusCount (int)`; `toJson()`/`fromJson()`; note: `null` = unscored, `0` = intentionally scored zero (per gotcha #10)
- [x] T082 [US5] Implement `lib/features/modules/yahtzee/domain/yahtzee_module.dart`: `YahtzeeModule implements GameModule` â€” `minPlayers = 1`, `maxPlayers = 6`; `applyAction()` handles `YahtzeeScoreSelected` â€” validates category is null (not already scored), computes score for category based on current dice (ones: sum of 1s, full house: 25, small straight: 30, large straight: 40, yahtzee: 50 first, +100 bonus each subsequent), locks category, advances to next player; `leaderboard()` computes live total including upper bonus (+35 if upper section â‰¥ 63) and Yahtzee bonuses; `checkWinCondition()` when all 13 categories scored for all players; `validateScore()` blocks selecting a locked category with `shortCode = 'CATEGORY_LOCKED'`; `scoringLayout()` returns `yahtzeeScorecard`
- [x] T083 [US5] Implement `lib/features/modules/yahtzee/application/yahtzee_cubit.dart`: `YahtzeeCubit extends Cubit<YahtzeeState>` â€” `rollDice()` generates random values for unheld dice (respects `diceHeld`), increments `currentRollNumber`, blocks roll if `currentRollNumber > 3`; `toggleHold(int diceIndex)` flips `diceHeld[i]`; `selectCategory(String playerId, YahtzeeCategory category)` delegates to `YahtzeeModule.applyAction()`; `YahtzeeCategory` enum with all 13 categories; persists updated state via `SessionDao.updateModuleState()` after each action
- [x] T084 [P] [US5] Implement `lib/features/modules/yahtzee/presentation/yahtzee_scorecard_widget.dart`: `YahtzeeScorecardWidget` â€” scrollable table with player columns; upper section rows (Onesâ€“Sixes) with computed sub-total and bonus row; lower section rows (3-of-a-kind through Chance) and Yahtzee + bonus count; tappable unscored cells show tentative score in the current player's column; locked cells show score grayed out; scoring highlights use accent color; implement `lib/features/modules/yahtzee/presentation/yahtzee_dice_widget.dart`: 5 `DieWidget` instances in a row; each tappable to toggle hold (held = elevated with green border); "Roll" button (disabled after roll 3 or if all categories scored)
- [x] T085 [US5] Implement `lib/features/modules/yahtzee/presentation/yahtzee_setup_screen.dart` (composing `SessionSetupScaffold`, 1â€“6 player limit) and `lib/features/modules/yahtzee/presentation/yahtzee_session_screen.dart` (composing `GameSessionScaffold` with `YahtzeeScorecardWidget` + `YahtzeeDiceWidget`; current player indicator; turn counter); register `YahtzeeModule()` in `lib/main.dart`

**Checkpoint**: Full Yahtzee game plays to completion with correct bonus math. Held dice persist across re-rolls. Category selection is blocked once scored. Final standings accurate.

---

## Phase 8: User Story 6 â€” Cribbage (Priority: P6)

**Goal**: Two-player cribbage with a visual cribbage board â€” pegs advancing along the snake path, two-peg system (front + rear), win at hole 121, hand-by-hand point entry.

**Independent Test**: Start a 2-player cribbage session; record several hands of points for each player; verify peg positions advance correctly (front peg moves, rear peg = previous front); verify that reaching/passing 121 ends the game and declares the winner.

- [x] T086 [P] [US6] Implement `lib/features/modules/cribbage/domain/cribbage_state.dart`: `@freezed CribbageState extends GameModuleState` â€” fields `variant (String, 'two_player')`, `dealerId (String)`, `pegPositions (Map<String, CribbagePegPosition>)`, `gameOver (bool)`, `winnerId (String?)`, `handNumber (int)`; `@freezed CribbagePegPosition` with `front (int)` and `rear (int)` (0â€“121); `toJson()`/`fromJson()`
- [x] T087 [US6] Implement `lib/features/modules/cribbage/domain/cribbage_module.dart`: `CribbageModule implements GameModule` â€” `minPlayers = 2`, `maxPlayers = 2`; `applyAction()` handles `CribbagePointsScored` â€” moves `rear` to current `front`, then advances `front` by scored points; validates points â‰¥ 0; `checkWinCondition()` when any player's `front â‰¥ 121`; `leaderboard()` ranks by `front` peg position descending; `scoringLayout()` returns `cribbageBoard`
- [x] T088 [US6] Implement `lib/features/modules/cribbage/application/cribbage_cubit.dart`: `CribbageCubit extends Cubit<CribbageState>` â€” `scorePoints(String playerId, int points)` validates and delegates to `CribbageModule.applyAction()`; `advanceDealer()` rotates `dealerId`; persists state via `SessionDao.updateModuleState()`
- [x] T089 [P] [US6] Implement `lib/ui/painters/cribbage_board_painter.dart`: `CribbageBoardPainter extends CustomPainter` â€” renders classic two-column snake path (0â†’60 up left column, 61â†’120 down right column, 121 = winning hole); hole positions computed via lookup table mapping `score (0â€“121)` to `Offset(x, y)`; draws two peg circles per player (front peg filled, rear peg outlined) using player's `colorHex`; peg advancement animated via `AnimatedBuilder` + `Tween<int>` driving repaint; board background with branded navy color
- [x] T090 [US6] Implement `lib/features/modules/cribbage/presentation/cribbage_board_widget.dart` (wrapping `CribbageBoardPainter` in `CustomPaint` with `AnimatedBuilder`), `lib/features/modules/cribbage/presentation/cribbage_setup_screen.dart` (2-player setup via `SessionSetupScaffold`), and `lib/features/modules/cribbage/presentation/cribbage_session_screen.dart` (composing `GameSessionScaffold` with `CribbageBoardWidget` prominently; `NumericKeypad` overlay for point entry; current dealer indicator; hand number display); register `CribbageModule()` in `lib/main.dart`

**Checkpoint**: Cribbage board renders correctly. Peg animation works. Two-peg system (front advances, rear holds previous position) works. Win at 121 is detected and summary screen shown.

---

## Phase 9: User Story 7 â€” Game History (Priority: P7)

**Goal**: Chronological history list of all completed sessions, filterable by game type, searchable by player/session name, with read-only detail view and delete capability.

**Independent Test**: Complete 2 sessions of different game types; open History tab; verify both appear in reverse-chronological order with game type, date, players, and winner; filter by one game type â€” verify only matching sessions show; tap an entry â€” verify read-only detail matches the session; delete one entry â€” verify it disappears from the list.

- [x] T091 [P] [US7] Implement `lib/features/history/history_list_screen.dart`: `HistoryListScreen` consuming `historyProvider` Drift stream; shows `HistoryRecord` rows with game-type icon, session name or game type label, date (formatted via `intl`), player names, winner badge; search `TextField` at top (debounced, calls `historyProvider.search()`); game-type filter chips row (scrollable horizontal, "All" + one per game type present); swipe-to-delete with confirmation dialog and undo snackbar; empty state illustration when list is empty
- [x] T092 [US7] Implement `lib/features/history/history_detail_screen.dart`: read-only view of a completed session identified by `sessionId` route param; loads `GameSession` + `HistoryRecord` from `SessionDao.getSession()` + `HistoryDao.getHistoryRecord()`; renders the appropriate module's scoring view in read-only mode by calling `GameModuleRegistry.get(gameType)!.scoringLayout()` and displaying the state snapshot; shows final standings `LeaderboardRow` list; shows session metadata (date, duration, player count); "Delete" action in app bar with confirmation dialog

**Checkpoint**: History list loads, filters, and searches correctly. Detail view accurately represents completed session state. Delete removes from both `history_records` and `game_sessions` tables.

---

## Phase 10: User Story 8 â€” Theming & Settings (Priority: P8)

**Goal**: User-controlled dark/light mode toggle, primary vs. Prince palette switcher, font scaling info, audio and haptic preference toggles â€” all changes reflected instantly across the entire app.

**Independent Test**: Open Settings; toggle dark/light mode â€” verify every screen (Home, Tools, History) updates instantly; switch to Prince palette â€” verify accent colors change from green (#78BE20) to violet (#981D97) across all screens; disable sound â€” verify dice roll produces no audio but haptic still fires; disable haptic â€” verify no haptic on coin flip.

- [x] T093 [P] [US8] Implement `lib/features/settings/settings_screen.dart`: Riverpod-driven settings page with grouped `ListTile` sections â€” **Appearance**: `theme_mode` segmented control (System/Light/Dark), `use_alternate_palette` toggle with before/after color swatch preview; **Audio & Feedback**: `sound_enabled` toggle, `haptic_enabled` toggle, `shake_to_roll_enabled` toggle, `shake_sensitivity` slider (5â€“30 m/sÂ²); **Default Players**: chip editor for `defaultPlayerNames` list (add/remove names used to pre-fill game setup); each preference change calls the relevant `PreferencesNotifier` method and persists immediately via `SharedPreferences`
- [x] T094 [US8] Wire `preferencesProvider` into `lib/main.dart` `SkorKeeperApp`: watch `themeMode` and `useAlternatePalette` from `PreferencesNotifier`; pass `AppTheme.light(useAlternatePalette)` / `AppTheme.dark(useAlternatePalette)` to `MaterialApp.router`'s `theme` and `darkTheme`; verify `MediaQuery.textScalerOf(context)` is not overridden (OS font scaling passes through per FR-003 and SC-007)
- [x] T095 [P] [US8] Implement `lib/core/providers/audio_provider.dart`: `@riverpod AudioService audioService(Ref ref)` with `keepAlive: true`; creates one `AudioPlayer` per sound asset at startup using `player.setAsset(...)` (pre-warms to eliminate first-play latency per gotcha #5); exposes `playDiceRoll()`, `playCoinFlip()`, `playTimerAlert()`, `playScoreConfirm()`, `playBust()` methods that check `preferencesProvider.soundEnabled` before calling `player.play()`; ref.onDispose releases all players; update all existing sound-trigger call sites (dice roller, coin flipper, timer, darts bust, score confirm) to use `audioServiceProvider` instead of direct player calls

**Checkpoint**: Dark/light toggle works instantly. Prince palette swap changes accent color everywhere. Sound and haptic prefs are respected across all tools and game modules.

---

## Phase 11: User Story Extra â€” Additional Game Modules (Priority: P-extra)

**Goal**: Four additional scoring modules â€” Bowling (spare/strike detection, 10-frame scoring), Farkle (opening threshold, 6-dice banking), Dominoes (pip-count round tracking), UNO penalty tracker.

**Independent Test for each**: Start a session, play a complete game, verify win condition and scoring math are correct per each game's rules.

### Bowling

- [x] T096 [P] [US-extra] Implement `lib/features/modules/bowling/domain/bowling_state.dart`: `@freezed BowlingState extends GameModuleState` â€” fields `currentPlayerIndex (int)`, `currentFrame (int, 1â€“10)`, `frames (Map<String, List<BowlingFrame>>)`; `@freezed BowlingFrame` with `frame (int)`, `rolls (List<int>)`, `frameType (FrameType enum: open|spare|strike)`, `cumulativeScore (int?)`; note `cumulative_score = null` until all bonus rolls available (per gotcha #11)
- [x] T097 [US-extra] Implement `lib/features/modules/bowling/domain/bowling_module.dart` + `lib/features/modules/bowling/application/bowling_cubit.dart`: `BowlingModule implements GameModule`; frame state machine â€” frame 1â€“9: 2 rolls max (1 if strike); frame 10: up to 3 rolls; spare bonus = next 1 roll; strike bonus = next 2 rolls; `cumulative_score` computed once all bonus rolls available; perfect game = 12 strikes = 300; `BowlingCubit extends Cubit<BowlingState>` handles `BowlingRollEntered` events; `scoringLayout()` returns `bowlingSheet`
- [x] T098 [P] [US-extra] Implement `lib/ui/painters/bowling_sheet_painter.dart`: `BowlingSheetPainter extends CustomPainter` â€” renders 10-frame grid per player; frame cells show roll values with strike (X) and spare (/) notation; 10th frame cell is wider (3 rolls); cumulative score below each frame; null scores shown as blank; implement `lib/features/modules/bowling/presentation/bowling_sheet_widget.dart` wrapping the painter
- [x] T099 [US-extra] Implement `lib/features/modules/bowling/presentation/bowling_setup_screen.dart` (1â€“6 players via `SessionSetupScaffold`) and `lib/features/modules/bowling/presentation/bowling_session_screen.dart` (composing `GameSessionScaffold` with `BowlingSheetWidget`; pin count input via `NumericKeypad` overlay 0â€“10 with remaining-pin validation); register `BowlingModule()` in `lib/main.dart`

### Farkle

- [x] T100 [P] [US-extra] Implement `lib/features/modules/farkle/domain/farkle_state.dart`: `@freezed FarkleState extends GameModuleState` â€” fields matching data-model.md JSON schema (`currentPlayerId`, `targetScore`, `playerTotals`, `currentTurnScore`, `currentTurnDice`, `diceBanked`, `hasOpened`, `gameOver`, `winnerId`); implement `lib/features/modules/farkle/domain/farkle_module.dart`: `FarkleModule implements GameModule` â€” `applyAction()` handles `FarkleBankScore` (bank scored dice into turn total) and `FarkleFarkled` (all remaining dice non-scoring = turn score resets to 0); opening threshold: player must reach 500 in single turn before accumulating; `checkWinCondition()` at target score (default 10,000); `scoringLayout()` returns `numericKeypad`
- [x] T101 [US-extra] Implement `lib/features/modules/farkle/presentation/farkle_setup_screen.dart` (1â€“10 players + target score picker) and `lib/features/modules/farkle/presentation/farkle_session_screen.dart` (6-die display using `DieWidget`, bank/roll buttons, turn score accumulator, player total scoreboard); register `FarkleModule()` in `lib/main.dart`

### UNO Penalty Tracker

- [x] T102 [P] [US-extra] Implement `lib/features/modules/uno/domain/uno_state.dart` + `lib/features/modules/uno/domain/uno_module.dart`: `UnoModule implements GameModule` â€” round-by-round penalty tracking; `direction = high_loses`; `target_score` configurable (default 500); `applyAction()` handles `UnoRoundScoreEntered`; `checkWinCondition()` when any player reaches `target_score` (that player loses â€” last remaining player wins); `scoringLayout()` returns `numericKeypad`; implement `lib/features/modules/uno/presentation/uno_setup_screen.dart` + `lib/features/modules/uno/presentation/uno_session_screen.dart`; register `UnoModule()` in `lib/main.dart`

### Dominoes

- [x] T103 [P] [US-extra] Implement `lib/features/modules/dominoes/domain/dominoes_state.dart` + `lib/features/modules/dominoes/domain/dominoes_module.dart`: `DominoesModule implements GameModule` â€” round-by-round pip-count tracking; `direction = low_wins`; `applyAction()` handles `DominoesRoundScoreEntered`; `checkWinCondition()` when user taps "End Game" (no auto-trigger); `scoringLayout()` returns `numericKeypad`; implement `lib/features/modules/dominoes/presentation/dominoes_setup_screen.dart` + `lib/features/modules/dominoes/presentation/dominoes_session_screen.dart`; register `DominoesModule()` in `lib/main.dart`

**Checkpoint**: All four additional modules (Bowling, Farkle, UNO, Dominoes) appear on HomeScreen, play to completion, persist state, and write history records correctly.

---

## Final Phase: Polish & Cross-Cutting Concerns

**Purpose**: Animations, audio/haptic integration completion, accessibility labels, performance validation, onboarding empty states, and full quickstart.md validation. These tasks span multiple modules.

- [x] T104 [P] Implement Lottie asset files: replace placeholder `assets/animations/win_celebration.json` with a valid confetti Lottie animation JSON (download from LottieFiles or generate); replace `assets/animations/hourglass.json` with a valid looping hourglass sand Lottie animation; verify both assets render correctly in `SessionSummaryScreen` and `TimerScreen`
- [x] T105 [P] Implement Rive asset files: replace placeholder `assets/animations/coin_flip.riv` with a two-state Rive state machine (heads / tails inputs); replace `assets/animations/spinner_wheel.riv` with a spin-decelerate state machine; wire state machine inputs in `CoinFlipScreen` and `SpinnerScreen` (or fall back to `AnimationController`-based animation if Rive assets have Impeller issues per gotcha #1)
- [x] T106 [P] Replace placeholder WAV stubs in `assets/sounds/` with actual short SFX audio clips (dice rattle, coin tumble, 3-beep timer alert, soft tap confirm, buzz bust); verify `AudioPlayer.setAsset()` loads all five without error; verify first `play()` call fires within 100ms per research Decision 7
- [x] T107 Apply `flutter_animate` page transitions throughout `app_router.dart`: slide-up + fade for `/home/new/:gameTypeId` (250ms), slide-up + fade for `/home/session/:sessionId` (250ms), fade for `session/:sessionId/summary` (300ms), crossfade for tab switches (150ms), slide-right + fade for all `/tools/*` sub-routes (200ms) and `/history/:sessionId` (200ms); verify all transitions stay â‰¤300ms on a Pixel 6a equivalent emulator
- [x] T108 [P] Add `Semantics` widgets and `semanticsLabel` strings to all interactive elements: `GameModuleCard` (label: "{displayName} â€” {description}"), `ScoreCell` (label: "Player {name} score input, round {n}"), all `+`/`-` buttons in tools (label: "Increment/Decrement {counter name}"), die roll button (label: "Roll {n} {type} dice"), coin flip button, timer start/stop buttons, all navigation items in `AppBottomNavBar`; run `flutter test --semantics` to verify accessibility tree
- [x] T109 [P] Add `semanticsLabel` and tooltip to all icon-only buttons (darts keypad multiplier toggles, Yahtzee hold toggles, Bowling roll confirm, Cribbage score confirm); ensure all color contrast ratios meet WCAG AA (â‰¥4.5:1 for text, â‰¥3:1 for UI components) by running a contrast check against `color_tokens.dart` token pairs in light and dark modes
- [x] T110 Add onboarding empty-state content: `HomeScreen` empty-state with branded illustration and "Tap any game to get started" copy when `GameModuleRegistry.all` yields zero (safety guard); `HistoryListScreen` empty-state with icon and "Your completed games will appear here" copy when history is empty; first-run welcome snackbar ("Welcome to SkorKeeper â€” no account needed, works offline") dismissed on first tap
- [x] T111 [P] Performance audit â€” cold start: add `Timeline.startSync('AppDatabase.open')` / `finishSync()` markers around Drift DB init in `main.dart`; verify total cold-start time â‰¤ 2,000ms on a mid-range device emulator (API 26, 3 GB RAM) per FR-035; ensure `NativeDatabase.createInBackground()` is in use (per gotcha #2); verify `AudioPlayer.setAsset()` calls complete before first game session screen is reachable
- [x] T112 [P] Performance audit â€” score entry: add instrumentation timing around `activeSessionsProvider` write â†’ Drift stream emission â†’ widget rebuild cycle; verify â‰¤300ms per FR-034 on Custom, Darts, and Yahtzee modules; if any module exceeds budget, profile with `flutter devtools` and optimize (typical fixes: move Drift writes off the UI isolate, reduce unnecessary rebuilds with `select()` on Riverpod providers)
- [x] T113 [P] Validate `Riverpod keepAlive: true` on `activeSessionProvider` â€” write an integration test in `test/integration/tab_switch_session_test.dart` that starts a custom session, navigates to Tools tab, navigates back to Home, and asserts the session state is still intact; also verify Darts and Yahtzee BLoC/Cubit state is preserved on tab switch
- [x] T114 Run all 12 quickstart.md validation scenarios: Scenario 1 (launch performance), Scenario 2 (custom session flow), Scenario 3 (darts 501 full game), Scenario 4 (darts bust), Scenario 5 (Cricket marks), Scenario 6 (Golf relative-to-par), Scenario 7 (Yahtzee bonuses), Scenario 8 (cribbage peg advance + win), Scenario 9 (tools â€” dice/coin/timer), Scenario 10 (history filter/search), Scenario 11 (settings theme switch), Scenario 12 (OS font scaling); document any failures as GitHub issues before marking done
- [x] T115 Run `flutter test` (all unit + widget tests must pass â‰¤30 seconds) and `flutter analyze` (zero errors, zero warnings); run `dart format . --set-exit-if-changed` to enforce formatting; tag passing commit as `v0.1.0-alpha`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies â€” can start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 completion â€” **BLOCKS all user stories**
- **Phase 3â€“11 (User Stories + Extra)**: All depend on Phase 2 completion; can proceed in priority order (P1 â†’ P2 â†’ â€¦ â†’ P-extra) or in parallel if staffed
- **Final Phase (Polish)**: Depends on all desired user story phases being complete

### User Story Dependencies

| Story | Can Start After | Depends On Other Stories? |
|-------|----------------|--------------------------|
| US1 Custom (P3) | Phase 2 complete | No â€” fully independent |
| US2 Darts (P4) | Phase 2 complete | No â€” uses same scaffold |
| US3 Tools (P5) | Phase 2 complete | Dice tool reuses `DieWidget` from Phase 2 |
| US4 Golf (P6) | Phase 2 complete | No â€” independent |
| US5 Yahtzee (P7) | Phase 2 complete | Reuses `DieWidget` (T047) |
| US6 Cribbage (P8) | Phase 2 complete | No â€” independent |
| US7 History (P9) | Phase 2 complete | Benefits from sessions created in US1â€“US6 for manual testing |
| US8 Settings (P10) | Phase 2 complete | Theme wiring is partially done in Phase 2; Settings extends it |
| US-extra Bowling (P11) | Phase 2 complete | `BowlingSheetPainter` is new; no story deps |
| US-extra Farkle/UNO/Dominoes (P11) | Phase 2 complete | Reuse `NumericKeypad` from Phase 2 |

### Within Each User Story

- Domain models and state â†’ Module implementation â†’ BLoC/Cubit (if applicable) â†’ Presentation screens â†’ Registration in `main.dart`
- Each story: complete domain layer before presentation layer
- Run `build_runner` after any new `@freezed` or `@riverpod` annotation

### Parallel Opportunities

All tasks within a phase marked `[P]` can be executed in parallel by different LLM agent sessions or developers, as they operate on different files with no shared write targets.

| Phase | Best Parallel Set |
|-------|------------------|
| Phase 2 | T013â€“T017 (models), T019â€“T023 (tables), T029â€“T034 (module types) â€” all fully parallel |
| Phase 4 | T059 (x01 variants) + T060 (Cricket) + T061 (5 remaining variants) â€” parallel after T058 |
| Phase 5 | T068â€“T076 (all tools) â€” fully parallel after T066â€“T067 |
| Final Phase | T104â€“T109 â€” all independent polish tasks, fully parallel |

---

## Parallel Execution Examples

### Phase 2 Parallel Burst (After T012 theme complete)

```
Agent A: T013 session_player.dart + T014 score_entry.dart + T015 history_record.dart
Agent B: T016 user_preferences.dart + T017 game_session.dart + game_type.dart
Agent C: T019 game_sessions table + T020 score_entries table + T021 history_records table
Agent D: T022 notepad_entries table + T023 tally_counters table
â†’ T018 build_runner (after A+B done)
â†’ T024 session_dao.dart (after T018 + C+D done)
â†’ T025 history_dao.dart + T026 tools_dao.dart (parallel, after tables done)
â†’ T027 app_database.dart (after all tables + DAOs done)
â†’ T028 build_runner (after T027)
```

### Phase 4 Parallel Burst (After T058 darts_module_base.dart)

```
Agent A: T059 darts_501, darts_301, darts_701 modules
Agent B: T060 darts_cricket_module.dart
Agent C: T061 cut_throat, around_the_clock, shanghai, killer, halve_it modules
Agent D: T062 darts_bloc.dart
â†’ T063 darts_variant_picker + darts_setup screens (after A+B+C done)
â†’ T064 darts_session_screen (after T062 done)
â†’ T065 darts_keypad_widget (parallel with T064)
```

### Phase 5 All-Parallel Burst (After T066â€“T067)

```
Agent A: T068 dice_roller_screen.dart
Agent B: T069 coin_flip_screen.dart
Agent C: T070 spinner_screen.dart + spinner_painter.dart
Agent D: T071 timer_screen.dart + hourglass_widget.dart
Agent E: T072 stopwatch_screen.dart
Agent F: T073 lives_counter_screen.dart
Agent G: T074 tally_counter_screen.dart
Agent H: T075 notepad_list + notepad_detail screens
Agent I: T076 team_picker_screen.dart
```

---

## Implementation Strategy

### MVP First (Custom Scoring Only â€” US1)

1. Complete Phase 1: Project Setup (T001â€“T009)
2. Complete Phase 2: Foundational (T010â€“T051) â€” CRITICAL
3. Complete Phase 3: Custom Scoring (T052â€“T056)
4. **STOP and VALIDATE**: Create a custom session with 4 players, record 3 rounds, close app, reopen, end game â€” verify all acceptance scenarios from spec.md US1
5. Submit for review / demo

### Incremental Delivery Order

| Milestone | Phases | What It Unlocks |
|-----------|--------|----------------|
| Foundation | 1 + 2 | Themed app shell, empty home screen, all infra |
| MVP | + Phase 3 | Custom scoring â€” replaces notepad for ANY game |
| Darts | + Phase 4 | Full darts scoring â€” highest convenience gain |
| Tools | + Phase 5 | Dice, coin, timer, notepad â€” one-stop companion |
| Golf | + Phase 6 | Structured 9/18-hole scorecards |
| Yahtzee | + Phase 7 | Official Yahtzee scorecard with bonuses |
| Cribbage | + Phase 8 | Visual cribbage board with peg animation |
| History | + Phase 9 | Long-term value â€” see past game records |
| Settings | + Phase 10 | Personalization â€” palettes, dark mode, prefs |
| Extra Modules | + Phase 11 | Bowling, Farkle, UNO, Dominoes |
| Release-Ready | + Final Phase | Animations, audio, accessibility, perf audit |

### Parallel Team Strategy

With 3+ developers:
1. All complete Phase 1 + Phase 2 together (foundational â€” no parallelism across stories possible)
2. Once Phase 2 is done:
   - **Dev A**: Phase 3 (Custom) â†’ Phase 4 (Darts)
   - **Dev B**: Phase 5 (Tools) â†’ Phase 7 (Yahtzee)
   - **Dev C**: Phase 6 (Golf) â†’ Phase 8 (Cribbage)
3. All converge on Phase 9 (History) â†’ Phase 10 (Settings) â†’ Phase 11 (Extra) â†’ Final Phase

---

## Notes

- `[P]` tasks = different files, no dependencies on incomplete siblings â€” safe to parallelize
- `[US#]` label maps every task to its user story for traceability to spec.md acceptance scenarios
- Run `dart run build_runner build --delete-conflicting-outputs` after every batch of new `@freezed`, `@riverpod`, or `@DriftAccessor` annotations
- All score entry paths MUST be profiled against the 300ms budget (FR-034) before marking any game module done
- Drift reactive `watch()` streams are the single source of truth for all live UI â€” never poll, never manually refresh
- BLoC is used **only** for Darts (complex state machine with bust/turn/finish logic) and Bowling (10th-frame edge cases); all other modules use Riverpod Notifier
- Never use `destroyEverything()` in Drift migrations; schema version starts at 1
- `keepAlive: true` is REQUIRED on `activeSessionProvider` and `appDatabaseProvider` â€” autoDispose will silently lose in-progress game state on tab switch (gotcha #6)
- Commit after each phase checkpoint; tag milestone commits (`v0.1.0-mvp`, `v0.1.0-darts`, etc.)
- Stop at any checkpoint to validate the story independently before proceeding to the next phase
