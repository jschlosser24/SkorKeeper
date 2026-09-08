# Tasks: SkorKeeper Sports Monetization Tiers

**Feature Branch**: `003-sports-tracking-tier`
**Input**: Design documents from `specs/003-sports-tracking-tier/`
**Prerequisites**: plan.md ✅ spec.md ✅ research.md ✅ data-model.md ✅ contracts/ ✅

## Format: `[ID] [P?] [Story?] Description with file path`

- **[P]**: Can run in parallel (different files, no incomplete-task dependencies)
- **[US#]**: User story label — present only in user story phases (Phase 3+)
- **No tests**: Spec does not request TDD; unit test tasks are included in the Polish phase per the constitution's mandate

---

## Phase 1: Setup

**Purpose**: Add the one new dependency (`pdf` package) and scaffold the directory structure for all sport modules.

- [X] T001 Add `pdf: ^3.10.0` to `dependencies` in `skorkeeper/pubspec.yaml` (only new dependency per research.md §10)
- [X] T002 [P] Create feature directory scaffolding for all 8 sport modules under `skorkeeper/lib/features/modules/` per plan.md project structure: `baseball/`, `basketball/`, `football/`, `soccer/`, `tennis/`, `volleyball/`, `hockey/`, `lacrosse/` — each with `domain/`, `application/`, `presentation/` subdirectories
- [X] T003 Run `flutter pub get` inside `skorkeeper/` to resolve the new `pdf` dependency

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared infrastructure that ALL user story phases depend on — core module extensions, shared Freezed models, Drift tables + DAOs, and entitlement value objects. No user story work can begin until this phase is complete.

**⚠️ CRITICAL**: Phase 3+ cannot start until T004–T017 are all complete.

- [X] T004 Add `ScoringLayoutType.sportsBasic` and `ScoringLayoutType.sportsInDepth` enum values (with dartdoc) to `skorkeeper/lib/core/modules/scoring_layout_descriptor.dart` per contracts/game-module.md
- [X] T005 Append all sport `ScoreAction` subclasses to `skorkeeper/lib/core/modules/score_action.dart`: `BaseballEventRecorded`, `BaseballGameFormatSelected`, `BasketballTeamScored`, `BasketballTimerToggled`, `BasketballQuarterAdvanced`, `BasketballPlayerScored`, `BasketballPlayerStatRecorded`, `FootballTeamScored`, `FootballDownAdvanced`, `FootballQuarterAdvanced`, `FootballPlayerStatRecorded`, `SoccerGoalScored`, `SoccerPossessionToggled`, `SoccerHalfAdvanced`, `SoccerGoalWithAssist`, `TennisPointWon`, `TennisGameWon`, `TennisSetWon`, `TennisTiebreakPointWon`, `TennisPlayerShotRecorded`, `VolleyballPointWon`, `VolleyballSetWon`, `VolleyballServingChanged`, `VolleyballPlayerStatRecorded`, `HockeyGoalScored`, `HockeyPenaltyAssessed`, `HockeyPeriodAdvanced`, `LacrosseGoalScored`, `LacrosseGroundBallWon`, `LacrosseClearAttempted`, `SportTimerStarted`, `SportTimerPaused`, `SportTimerReset`, `SportGameEnded`, `SportNoteUpdated` per contracts/score-actions.md
- [X] T006 [P] Create `SportType`, `TrackingMode`, `GamePhase`, `ExportFormat`, `ExportStatus` enums (with computed properties: `SportType.requiresPro`, `GamePhase.isPlayable`) in `skorkeeper/lib/core/modules/sport_enums.dart` per data-model.md §Enumerations
- [X] T007 [P] Create `SportGameState` (Freezed, implements `GameModuleState`), `SportTeam` (Freezed, includes nullable `roster`), `SportPlayer` (Freezed), `SportEvent` (Freezed, with event type string constants per data-model.md §SportEvent) Freezed models in `skorkeeper/lib/core/modules/sport_game_state.dart`; include `fromJson`/`toJson` factories and `_schemaVersion: 1` sentinel field per contracts/game-state-schema.md
- [X] T008 [P] Create `SportsEntitlement` Freezed value object with `hasSportsPlan`, `hasSportsPro`, `canAccessPlanFeatures` getter, `canAccessProFeatures` getter, `canAccess(SportType)` method, and `SportsEntitlement.none` const in `skorkeeper/lib/core/monetization/sports_entitlement.dart` per contracts/entitlements.md
- [X] T009 Extend `PurchaseService` in `skorkeeper/lib/core/monetization/purchase_service.dart`: add `PurchaseKeys.entitlementSportsPlan`, `PurchaseKeys.entitlementSportsPro`, `PurchaseKeys.productSportsPlan`, `PurchaseKeys.productSportsPro` constants; add `isSportsPlanUnlocked()`, `isSportsProUnlocked()`, `purchaseSportsPlan()`, `purchaseSportsPro()`, `restoreSportsPurchases()` static methods per contracts/entitlements.md §PurchaseService API Extension
- [X] T010 [P] Create `SportHistoryMeta` Drift table class in `skorkeeper/lib/core/database/tables/sport_history_meta.dart`: columns `id` (autoincrement PK), `sessionId` (unique int FK), `sportType` (text), `trackingMode` (text), `tierRequired` (text), `exportedAt` (nullable int), `exportFormats` (nullable text); add `idx_sport_meta_tier` index on `tier_required` per data-model.md §SportHistoryMeta
- [X] T011 [P] Create `SportGameNotes` Drift table class in `skorkeeper/lib/core/database/tables/sport_game_notes.dart`: columns `id` (autoincrement PK), `sessionId` (unique int FK), `content` (text, default `''`), `updatedAt` (int) per data-model.md §SportGameNotes
- [X] T012 Create `SportHistoryDao` in `skorkeeper/lib/core/database/daos/sport_history_dao.dart`: methods `saveSportGame()` (with 100-game limit check throwing `GameHistoryLimitReachedException` when `tierRequired == 'sports_plan' AND count >= 100`), `getSportGames()`, `deleteSportGame(int sessionId)`, `getSportGameCount({required String tierRequired})`, `updateExportStatus(int sessionId, String formats)` per research.md §6
- [X] T013 [P] Create `SportExportDao` in `skorkeeper/lib/core/database/daos/sport_export_dao.dart`: methods `getGamesForExport(List<int> sessionIds)` (JOIN `game_sessions` + `sport_history_meta` + `sport_game_notes`), `getGamesByDateRange()`, `getGamesBySportType(String sportType)`
- [X] T014 Register `SportHistoryMeta` and `SportGameNotes` tables and add `SportHistoryDao` and `SportExportDao` accessors to the Drift `AppDatabase` class (locate the existing `@DriftDatabase` annotated class in `skorkeeper/lib/core/database/`)
- [X] T015 Add `sportModules` getter (filter `gameTypeId.startsWith('sport_')`) and `sportModulesFor(SportsEntitlement entitlement)` method to `GameModuleRegistry` in `skorkeeper/lib/core/modules/game_module_registry.dart` per contracts/game-module.md §GameModuleRegistry Entitlement Query
- [X] T016 Add `SportExport` Freezed transient model (fields: `exportId`, `format`, `gameSessionIds`, `createdAt`, `filePath?`, `status`, `errorMessage?`) in `skorkeeper/lib/features/sports_export/domain/sport_export.dart` per data-model.md §SportExport
- [X] T017 Run `dart run build_runner build --delete-conflicting-outputs` inside `skorkeeper/` to generate all `.freezed.dart`, `.g.dart` (Drift + json_serializable) files for T006–T016

**Checkpoint**: All shared models, enums, Drift tables, DAOs, and core extension points are ready. User story phases may now proceed.

---

## Phase 3: User Story 1 — Sports Plan Discovery & Purchase (Priority: P1) 🎯 MVP Entry

**Goal**: A free user discovers locked sports tiles, views a compelling purchase pitch, completes a $6.99 one-time IAP, and immediately gains access to all Sports Plan modules without an app restart.

**Independent Test**: Launch on a fresh device (no purchases). Navigate to Home → verify 6 sports tiles locked with lock icon + "Sports Plan" label. Tap Baseball tile → `SportsPurchaseSheet` shows feature list + $6.99 price. Complete sandbox IAP → all 6 tiles unlock in the same session without restart. Dismiss mid-purchase → no entitlement granted, no error shown.

- [X] T018 [US1] Create `SportsEntitlementNotifier` (Riverpod `AsyncNotifier`) that loads `SportsEntitlement` from `PurchaseService.isSportsPlanUnlocked()` + `isSportsProUnlocked()` on initialization and exposes a `refresh()` method for post-purchase reload in `skorkeeper/lib/features/sports_hub/application/sports_entitlement_notifier.dart`
- [X] T019 [P] [US1] Create `SportsHubScreen` with a `GridView` of sport tiles (Baseball, Basketball, Football, Soccer, Tennis, Volleyball, Hockey, Lacrosse); each tile reads `SportsEntitlementNotifier` and renders a lock icon overlay + tier label (`"Sports Plan"` for Plan-only sports, `"Sports Pro Only"` for Hockey/Lacrosse) when the user lacks the required entitlement in `skorkeeper/lib/features/sports_hub/presentation/sports_hub_screen.dart`
- [X] T020 [P] [US1] Create `SportsPurchaseSheet` modal bottom sheet displaying: feature bullet list (sport modules included, real-time timers, game notes, game history), one-time price (`$6.99` or `$19.99` parameterized by tier), "Purchase" CTA invoking the appropriate `PurchaseService` method, "Restore Purchases" link; handle in-flight/cancelled/failed states per contracts/entitlements.md §Error States in `skorkeeper/lib/features/sports_hub/presentation/sports_purchase_sheet.dart`
- [X] T021 [US1] Wire sport tiles on the Home screen: tap on a locked tile → push `SportsPurchaseSheet`; tap on an unlocked tile → navigate to that sport's setup route; source tile lock state from `SportsEntitlementNotifier` so the home screen re-renders immediately after purchase completes (locate the home screen tile list in `skorkeeper/lib/features/home/`)
- [X] T022 [US1] Add GoRouter routes for `/sports`, `/sports/purchase`, `/sports/:sport/setup`, `/sports/:sport/game`, `/sports/history`, `/sports/analytics` in `skorkeeper/lib/core/router/app_router.dart`; guard Pro-only routes (`/sports/analytics`) with an entitlement redirect
- [X] T023 [US1] Wire the full purchase completion flow: `SportsPurchaseSheet` calls `PurchaseService.purchaseSportsPlan()` → on success calls `SportsEntitlementNotifier.refresh()` → closes sheet → home screen tiles re-render as unlocked; on cancel/error return to home with no state change and display appropriate snackbar per FR-005

**Checkpoint**: A free user can discover, evaluate, and complete the Sports Plan purchase, gaining immediate tile access. US1 is independently verifiable.

---

## Phase 4: User Story 2 — Baseball Full Bookkeeping (Priority: P1)

**Goal**: A Sports Plan user opens Baseball, enters team info, plays a game with inning/outs tracking, and sees an accurate box score saved to local history.

**Independent Test**: With Sports Plan active, open Baseball → set up Wildcats vs. Eagles, 9-inning format. Tap "Out" 3 times → verify outs reset and inning advances from Top 1st → Bottom 1st → Top 2nd. Tap "Hit" then "Run" → verify score updates to 1-0 instantly. End game → verify box score R/H/E per inning. Navigate to History → game appears within 100-game limit.

- [X] T024 [P] [US2] Create `BaseballState` Freezed model extending `SportGameState` helpers with baseball `sportSpecific` factory (`currentInning`, `currentHalf: 'top'|'bottom'`, `outs: 0–3`, `maxInnings`) and per-team `stats` map (`hits`, `errors`, `strikeouts`, `walks`, `earnedRuns`, `atBats`, `inningScores: List<int>`) in `skorkeeper/lib/features/modules/baseball/domain/baseball_state.dart`
- [X] T025 [P] [US2] Create `BaseballModule` implementing `GameModule`: `gameTypeId: 'sport_baseball'`, `minPlayers/maxPlayers: 2`, `applyAction()` handling all `BaseballEventRecorded` event types (run increments score; out increments outs → 3 outs triggers half-inning auto-transition per data-model.md §Baseball Inning Auto-Transition; hit/error/walk/strikeout/ball/strike update stats), `checkWinCondition()` detecting game completion when `currentInning > maxInnings` after bottom half, `scoringLayout()` returning `sportsBasic` descriptor with `hasInningCounter: true, maxOuts: 3` in `skorkeeper/lib/features/modules/baseball/domain/baseball_module.dart`
- [X] T026 [US2] Implement `BaseballGameNotifier` (Riverpod `Notifier<AsyncValue<BaseballState>>`) that persists state to Drift on every action, calculates BA (`hits / atBats`) and ERA (`earnedRuns / inningsPitched * 9`) from the event log, and handles `SportGameEnded` action to finalize history record in `skorkeeper/lib/features/modules/baseball/application/baseball_game_notifier.dart`
- [X] T027 [US2] Create `BaseballSetupScreen` with: home/away team name fields (1–40 char validation per data-model.md), optional roster size input, `DropdownButton` for game format (`nine_inning`, `seven_inning`, `scrimmage`), "Start Game" CTA creating the `GameSession` row and navigating to `BaseballGameScreen` in `skorkeeper/lib/features/modules/baseball/presentation/baseball_setup_screen.dart`
- [X] T028 [US2] Create `BaseballGameScreen` displaying: inning/half header (e.g., "Top of 3rd"), outs dots (0–3), home/away team scores, 8 action buttons in a 2×4 grid (Run, Out, Hit, Strikeout, Ball, Strike, Error, Walk — each ≤1 tap from game screen per FR-026), "End Game" button; action buttons dispatch `BaseballEventRecorded` actions through `BaseballGameNotifier` in `skorkeeper/lib/features/modules/baseball/presentation/baseball_game_screen.dart`
- [X] T029 [US2] Add baseball game summary overlay/screen: inning-by-inning box score table (rows: home team, away team; columns: 1–9/7, R, H, E), final score, per-team BA and ERA; reachable from "End Game" action in `skorkeeper/lib/features/modules/baseball/presentation/baseball_game_screen.dart`
- [X] T030 [US2] Register `BaseballModule` in `GameModuleRegistry` constructor in `skorkeeper/lib/core/modules/game_module_registry.dart`; add baseball setup and game GoRouter routes
- [X] T031 [US2] Create `SportsHistoryScreen` querying `SportHistoryDao.getSportGames()` and displaying a `ListView` of past games (sport type chip, team names, final score, date, duration); implement per-row swipe-to-delete calling `SportHistoryDao.deleteSportGame()`; show 100-game limit warning banner when `count >= 95` for Plan users in `skorkeeper/lib/features/sports_history/presentation/sports_history_screen.dart`

**Checkpoint**: Baseball is fully playable with box score and saved history. US2 independently verifiable.

---

## Phase 5: User Story 3 — Basketball with Real-Time Timer (Priority: P1)

**Goal**: A Sports Plan user tracks a basketball game with a live running clock, instant score entry via large tap targets, quarter transitions, and accurate shooting percentage stats at game end.

**Independent Test**: Open Basketball → enter teams, select "Full Game" (4 quarters). Start Q1 → verify timer increments each second. Tap "2-Pointer" → score updates instantly, timer keeps running. Tap "Pause" → timer halts. Tap "Resume" → timer continues from same second. Advance to end of Q1 via "End Quarter" → Q-break prompt shown → "Start Q2" resumes play. End game → verify FG% = fieldGoalsMade / fieldGoalsAttempted, FT% = ftMade / ftAttempted, quarter breakdown correct.

- [X] T032 [P] [US3] Create `BasketballState` Freezed helpers with basketball `sportSpecific` factory (`currentPeriod`, `periodCount`) and per-team `stats` map (`fieldGoalsMade`, `fieldGoalsAttempted`, `threesMade`, `threesAttempted`, `ftMade`, `ftAttempted`, `quarterScores: List<int>`) in `skorkeeper/lib/features/modules/basketball/domain/basketball_state.dart`
- [X] T033 [P] [US3] Create `BasketballModule` implementing `GameModule`: `applyAction()` handling `BasketballTeamScored` (2pt adds 2, 3pt adds 3, ft adds 1; each updates corresponding made/attempted stats), `BasketballTimerToggled` (flips `timerRunning`), `BasketballQuarterAdvanced` (increments `currentPeriod`; triggers `gamePhase = completed` when `currentPeriod > periodCount`), `BasketballPlayerScored` (in-depth — attributes points to `SportPlayer.stats`), `BasketballPlayerStatRecorded`; `checkWinCondition()` when phase is `completed` in `skorkeeper/lib/features/modules/basketball/domain/basketball_module.dart`
- [X] T034 [US3] Implement `SportTimerNotifier` (shared Riverpod `Notifier`) in `skorkeeper/lib/features/modules/shared/sport_timer_notifier.dart`: wraps `dart:async Timer.periodic(Duration(seconds: 1), ...)` incrementing `elapsedSeconds` in the sport state; exposes `startTimer()`, `pauseTimer()`, `stopTimer()`; subscribes to `AppLifecycleState` via `WidgetsBindingObserver` to auto-pause on background per research.md §2
- [X] T035 [US3] Implement `BasketballGameNotifier` composing `SportTimerNotifier` and `BasketballModule.applyAction()`; calculates FG%, 3P%, FT% derived stats on every state update; persists state on pause/game-end in `skorkeeper/lib/features/modules/basketball/application/basketball_game_notifier.dart`
- [X] T036 [US3] Create `BasketballSetupScreen` with: team name fields, `SegmentedButton` for game format (`full`/`halves`/`scrimmage`), optional "Add Roster" toggle (always visible; in-depth mode roster entry requires Sports Pro entitlement check from `SportsEntitlementNotifier`) in `skorkeeper/lib/features/modules/basketball/presentation/basketball_setup_screen.dart`
- [X] T037 [US3] Create `BasketballGameScreen` with: timer display (count-up elapsed; UI computes `periodDurationSeconds - elapsed` for count-down display), current quarter label, home/away scoreboards, 2pt/3pt/FT `ElevatedButton` pairs per team with large tap targets (≥48dp), pause/resume control; auto-show quarter-break bottom sheet when `gamePhase == periodBreak`; "End Game" button in `skorkeeper/lib/features/modules/basketball/presentation/basketball_game_screen.dart`
- [X] T038 [US3] Add basketball game summary in `BasketballGameScreen`: final scores, FG%/3P%/FT% per team (format: "12/28 (42.9%)"), quarter-by-quarter point breakdown table, winner declaration
- [X] T039 [US3] Register `BasketballModule` in `GameModuleRegistry`; add basketball routes

**Checkpoint**: Basketball is live-scoreable with a working timer and stats. US3 independently verifiable.

---

## Phase 6: User Story 4 — Soccer In-Depth Mode + Remaining Plan Sports (Priority: P1)

**Goal**: Sports Pro user can track soccer with in-depth player attribution and possession tracking; Football, Tennis, and Volleyball round out the full Sports Plan module set; all 6 Plan sports are playable after this phase.

**Independent Test**: With Sports Pro, open Soccer → enable In-Depth Mode, add 3 players per team. Start match. Toggle possession → visual indicator changes team. Tap "Goal" → `PlayerSelectionDialog` appears → select scorer → score increments, goal attributed to player. Advance to halftime → halftime prompt. End match → match summary shows goal timeline (scorer + game-clock timestamp), possession % by half, goal-scorer rankings.

### Soccer

- [X] T040 [P] [US4] Create `SoccerState` Freezed helpers with soccer `sportSpecific` factory (`currentHalf: 1|2`, `possessingTeamId: 'home'|'away'`, `homePossessionSeconds`, `awayPossessionSeconds`) and per-team `stats` map (`goals`, `halfScores`, `possessionSeconds`) in `skorkeeper/lib/features/modules/soccer/domain/soccer_state.dart`
- [X] T041 [P] [US4] Create `SoccerModule` implementing `GameModule`: `applyAction()` for `SoccerGoalScored` (basic: team score +1), `SoccerPossessionToggled` (swap `possessingTeamId`, save prior possession seconds), `SoccerHalfAdvanced` (transition `active → halftimeBreak → active → completed`), `SoccerGoalWithAssist` (in-depth: attribute goal to `scorerPlayerId`, optional `assistPlayerId`); emit `periodBreak` phase at halftime in `skorkeeper/lib/features/modules/soccer/domain/soccer_module.dart`
- [X] T042 [US4] Implement `SoccerGameNotifier` composing `SportTimerNotifier`; on each timer tick increment `possessingTeamId`'s possession seconds; handle `SoccerHalfAdvanced` to freeze possession counter and save halftime snapshot; in-depth mode: `SoccerGoalWithAssist` logs `SportEvent` with `metadata: {assistPlayerId, period}` in `skorkeeper/lib/features/modules/soccer/application/soccer_game_notifier.dart`
- [X] T043 [US4] Create `SoccerSetupScreen` with: team name fields, format picker (`full`/`short`/`scrimmage`), "In-Depth Mode" `SwitchListTile` (visible but disabled with "Sports Pro required" tooltip for Plan-only users per `SportsEntitlementNotifier`), roster entry rows (visible only when in-depth enabled) in `skorkeeper/lib/features/modules/soccer/presentation/soccer_setup_screen.dart`
- [X] T044 [US4] Create `SoccerGameScreen` with: running match timer, current half label ("1st Half" / "2nd Half"), home/away scores, "Goal" button (opens `PlayerSelectionDialog` in in-depth mode; directly scores in basic mode), possession `AnimatedToggle` widget showing possessing team in high-contrast color, halftime prompt bottom sheet, "End Match" button in `skorkeeper/lib/features/modules/soccer/presentation/soccer_game_screen.dart`
- [X] T045 [US4] Create reusable `PlayerSelectionDialog` (modal bottom sheet) rendering a scrollable list of `SportPlayer` names with optional jersey number chips; returns selected `playerId`; used by Soccer, Hockey, and Lacrosse game screens for in-depth goal attribution in `skorkeeper/lib/features/modules/shared/player_selection_dialog.dart`
- [X] T046 [US4] Add soccer match summary: goal-by-goal timeline list (scorer name, team color dot, game-clock timestamp formatted as `mm:ss`), possession bar chart or percentage display split by half, per-player goal counts ranked descending in `skorkeeper/lib/features/modules/soccer/presentation/soccer_game_screen.dart`

### Football

- [X] T047 [P] [US4] Create `FootballState` Freezed helpers with football `sportSpecific` factory (`currentPeriod`, `currentDown: 1–4`, `yardsToGo`, `possessingTeamId`) and per-team `stats` map (`totalYards`, `touchdowns`, `fieldGoals`, `safeties`, `firstDowns`, `quarterScores`) in `skorkeeper/lib/features/modules/football/domain/football_state.dart`
- [X] T048 [P] [US4] Create `FootballModule` implementing `GameModule`: `applyAction()` for `FootballTeamScored` (TD +6, XP +1, 2-pt conv +2, FG +3, safety +2), `FootballDownAdvanced` (increment down; first down when `yardsGained >= yardsToGo`; reset after 4th down turnover), `FootballQuarterAdvanced` (period break → completed after Q4), `FootballPlayerStatRecorded` (in-depth only) in `skorkeeper/lib/features/modules/football/domain/football_module.dart`
- [X] T049 [US4] Implement `FootballGameNotifier`, `FootballSetupScreen` (team names, format picker: `full`/`two_minute_drill`/`scrimmage`), and `FootballGameScreen` (quarter timer, down-and-distance display "3rd & 7", scoring buttons TD/XP/2pt/FG/Safety per team, "Advance Down" button, quarter-break prompt, in-depth player stat entry sheet for Pro users) in `skorkeeper/lib/features/modules/football/`

### Tennis

- [X] T050 [P] [US4] Create `TennisState` Freezed helpers with tennis `sportSpecific` factory (`currentSet`, `homeGamesThisSet`, `awayGamesThisSet`, `homePoints: 0–4`, `awayPoints: 0–4`, `isTiebreak`, `servingTeamId`, `setScores: List<Map<String, int>>`) and per-team `stats` map (`setsWon`, `totalGamesWon`, `setScores`) in `skorkeeper/lib/features/modules/tennis/domain/tennis_state.dart`
- [X] T051 [P] [US4] Create `TennisModule` implementing `GameModule`: `applyAction()` for `TennisPointWon` (increment points; detect deuce at `homePoints == awayPoints == 3` — advantage on next; game won when player reaches 4 and leads by 2, or wins deuce advantage), `TennisGameWon` (increment games; detect set win at 6 games with 2-game lead or 7–5; trigger tiebreak at 6–6 per format), `TennisSetWon`, `TennisTiebreakPointWon`; `checkWinCondition()` when sets won matches format (best-of-3: 2 sets, best-of-5: 3 sets) in `skorkeeper/lib/features/modules/tennis/domain/tennis_module.dart`
- [X] T052 [US4] Implement `TennisGameNotifier`, `TennisSetupScreen` (team/player names, game format: `best_of_3`/`best_of_5`/`one_set`/`pro_set`, serving team selection), and `TennisGameScreen` (tennis score display `0/15/30/40/Ad/Deuce` per team, set scoreboard, current set games, serving indicator, tiebreak mode indicator, in-depth shot type buttons for Pro: ace/double fault/winner) in `skorkeeper/lib/features/modules/tennis/`

### Volleyball

- [X] T053 [P] [US4] Create `VolleyballState` Freezed helpers with volleyball `sportSpecific` factory (`currentSet`, `servingTeamId`, `setScores: List<Map<String, int>>`) and per-team `stats` map (`setsWon`, `totalPoints`, `setScores`) in `skorkeeper/lib/features/modules/volleyball/domain/volleyball_state.dart`
- [X] T054 [P] [US4] Create `VolleyballModule` implementing `GameModule`: `applyAction()` for `VolleyballPointWon` (increment score; detect set win at 25 pts with 2-pt lead, or 15 pts in 5th set), `VolleyballSetWon`, `VolleyballServingChanged`; `checkWinCondition()` when sets won reaches format target in `skorkeeper/lib/features/modules/volleyball/domain/volleyball_module.dart`
- [X] T055 [US4] Implement `VolleyballGameNotifier`, `VolleyballSetupScreen` (team names, format: `best_of_5`/`best_of_3`/`one_set`), and `VolleyballGameScreen` (large "Point" buttons per team, serving arrow indicator, current set score, set scoreboard, "Rotate Serve" button auto-triggering on point won per rally-scoring rules, in-depth player stat entry for Pro) in `skorkeeper/lib/features/modules/volleyball/`

### Module Registration (All Phase 6 Sports)

- [X] T056 [US4] Register `SoccerModule`, `FootballModule`, `TennisModule`, `VolleyballModule` in `GameModuleRegistry` constructor in `skorkeeper/lib/core/modules/game_module_registry.dart`; add corresponding GoRouter routes for each sport's setup and game screens

**Checkpoint**: All 6 Sports Plan modules are playable. Sports Pro in-depth Soccer mode is active. US4 independently verifiable.

---

## Phase 7: User Story 5 — Export & Advanced Analytics (Priority: P2)

**Goal**: Sports Pro user can bulk-export completed games to PDF/CSV/JSON and view an analytics dashboard with season summaries, scoring trends, and sport-specific performance metrics.

**Independent Test**: With Sports Pro and 3+ completed games, navigate to Sports History → select 2 games → tap Export → choose PDF → share sheet opens with PDF file; open PDF and confirm: both games present, final scores/stats accurate, cover page lists both games. Repeat for CSV (verify spreadsheet import with 2 data rows), JSON (verify `exportVersion: "1.0"`, all stats present). Navigate to Analytics → season summary shows correct game counts and average scores.

- [X] T057 [P] [US5] Create `SportExportService` abstract interface with `Future<File> exportGames(List<SportGameSession> games, {required Directory tempDir})` contract in `skorkeeper/lib/features/sports_export/domain/sport_export_service.dart`
- [X] T058 [P] [US5] Implement `CsvExportService` implementing `SportExportService`: header row + one data row per game (columns: Export Date, Sport, Game Date, Home Team, Away Team, Final Score Home, Final Score Away, Duration (s), Format, Tracking Mode, Notes); append `"Player Stats JSON"` column for in-depth games; UTF-8 BOM prefix for Excel compatibility; RFC 4180 quoting per contracts/export-formats.md §CSV Export in `skorkeeper/lib/features/sports_export/domain/csv_export_service.dart`
- [X] T059 [P] [US5] Implement `JsonExportService` implementing `SportExportService`: serializes to pretty-printed JSON (`JsonEncoder.withIndent('  ')`); includes `exportVersion: "1.0"`, `exportedAt` ISO-8601, `exportedBy: "SkorKeeper"`, `games` array with full `SportGameState` fields including `roster` for in-depth games per contracts/export-formats.md §JSON Export in `skorkeeper/lib/features/sports_export/domain/json_export_service.dart`
- [X] T060 [US5] Implement `PdfExportService` implementing `SportExportService` using the `pdf` package: multi-game report has a cover page (game list with final scores), then one page per game (header with sport/date/teams, final score section, sport-specific stats table per contracts/export-formats.md §PDF Required Fields, game notes section, footer "Generated by SkorKeeper"); file named `SkorKeeper_Export_{YYYYMMDD_HHMMSS}.pdf` in `skorkeeper/lib/features/sports_export/domain/pdf_export_service.dart`
- [X] T061 [US5] Implement `ExportNotifier` (Riverpod `Notifier<AsyncValue<SportExport>>`) orchestrating: receive selected `gameSessionIds` + `ExportFormat` → query `SportExportDao.getGamesForExport()` → instantiate correct service → write to `(await getTemporaryDirectory()).path/SkorKeeper_Export_{ts}.{ext}` → call `SharePlus.instance.shareXFiles([XFile(filePath)])` → update `SportHistoryMeta.exportedAt` via `SportHistoryDao.updateExportStatus()`; expose `exportGames(List<int> ids, ExportFormat format)` method in `skorkeeper/lib/features/sports_export/application/export_notifier.dart`
- [X] T062 [US5] Update `SportsHistoryScreen` to support multi-select export: add `Checkbox` per history row (visible when in "select mode"), floating action button revealing export panel with PDF/CSV/JSON `ChoiceChip` row and "Export Selected" `ElevatedButton`; show loading indicator during export; handle "no games selected" error per contracts/export-formats.md §Export Error Handling in `skorkeeper/lib/features/sports_history/presentation/sports_history_screen.dart`
- [X] T063 [P] [US5] Create `AnalyticsCalculator` in `skorkeeper/lib/features/sports_analytics/domain/analytics_calculator.dart`: `SeasonSummary computeSummary(List<SportHistoryRecord> records)` returning total games played per sport, average final scores (home + away), scoring trend list ordered by date; sport-specific: BA/ERA from baseball event log, FG% from basketball stats map, possession % from soccer `possessionSeconds`; all calculations in pure Dart, no DB calls
- [X] T064 [US5] Implement `AnalyticsNotifier` (Riverpod `AsyncNotifier<SeasonSummary>`) querying `SportHistoryDao.getSportGames()` and passing results to `AnalyticsCalculator.computeSummary()`; expose `refresh()` method in `skorkeeper/lib/features/sports_analytics/application/analytics_notifier.dart`
- [X] T065 [US5] Create `AnalyticsDashboardScreen`: season summary cards (games played per sport, overall avg score), scoring trend list (or `LineChart`-equivalent widget), sport-specific metrics section (BA/ERA for baseball, FG% for basketball, possession % for soccer); show a "Sports Pro Required" upgrade prompt with `SportsPurchaseSheet` for Plan-only users accessing this route in `skorkeeper/lib/features/sports_analytics/presentation/analytics_dashboard_screen.dart`
- [X] T066 [US5] Add export error handling in `ExportNotifier`: `path_provider` failure → "Unable to create export file. Please check device storage and try again."; PDF generation error → "Export failed. Please try again."; game data missing → skip game + show "N game(s) could not be exported due to missing data" warning snackbar; share cancelled silently per contracts/export-formats.md §Export Error Handling

**Checkpoint**: Pro users can export all formats and view analytics. US5 independently verifiable.

---

## Phase 8: User Story 6 — Sports Pro Upgrade + Hockey & Lacrosse (Priority: P2)

**Goal**: A Sports Plan user can view locked Hockey/Lacrosse tiles, purchase Sports Pro, immediately access those sports, and track a full hockey game with period tracking, goal + assist attribution, and penalty logging.

**Independent Test**: With Sports Plan, view Home → Hockey and Lacrosse tiles show lock icon + "Sports Pro Only" label. Tap Hockey → `SportsPurchaseSheet` shows Pro upgrade pitch + $19.99 price. Complete sandbox Pro purchase → Hockey and Lacrosse tiles unlock instantly. Open Hockey → add teams, add roster. Start game. Tap "Goal" → `PlayerSelectionDialog` → select scorer → tap "Add Assist" → select assistant; both logged in event stream. Tap "Penalty" → enter player/type/duration. View game summary → goal log (scorer + assists), period scores, full penalty log. Also confirm in-depth mode option now appears in Basketball/Football/Soccer setup screens.

### Hockey

- [X] T067 [P] [US6] Create `HockeyState` Freezed helpers with hockey `sportSpecific` factory (`currentPeriod: 1–3`, `isOvertime: false`, `isShootout: false`, `activePenalties: List<Map<String, dynamic>>` each with `teamId`, `playerId`, `type`, `durationMinutes`, `startedAtSeconds`) and per-team `stats` map (`goals`, `assists`, `penaltyMinutes`, `periodScores`, `shotsOnGoal`) in `skorkeeper/lib/features/modules/hockey/domain/hockey_state.dart`
- [X] T068 [P] [US6] Create `HockeyModule` implementing `GameModule`: `applyAction()` for `HockeyGoalScored` (score +1, append `SportEvent` with `metadata: {assistPlayerId?, period}`), `HockeyPenaltyAssessed` (add to `activePenalties`; update `penaltyMinutes` stat), `HockeyPeriodAdvanced` (cycle `period_2 → period_3 → overtime → shootout → completed`; set `isOvertime/isShootout` flags); `checkWinCondition()` detects win at any `completed` phase or after shootout; `scoringLayout()` returns `sportsBasic` descriptor with `hasOvertime: true` in `skorkeeper/lib/features/modules/hockey/domain/hockey_module.dart`
- [X] T069 [US6] Implement `HockeyGameNotifier` composing `SportTimerNotifier`; on each timer tick check active penalties and remove expired ones (`elapsedSeconds - startedAtSeconds >= durationMinutes * 60`); handle `HockeyGoalScored` logging primary + secondary assist events; persist state on period-end in `skorkeeper/lib/features/modules/hockey/application/hockey_game_notifier.dart`
- [X] T070 [US6] Create `HockeySetupScreen` (team names, roster entry required — hockey requires players for goal/assist attribution, format: `full`/`recreational`/`scrimmage`) and `HockeyGameScreen` (period timer, current period label, "Goal" button → scorer + assists dialog, "Penalty" button → player/type/duration picker, "End Period" button, active penalty list with countdown timers, shootout mode toggle) in `skorkeeper/lib/features/modules/hockey/presentation/`
- [X] T071 [US6] Add hockey game summary: goal log (each goal row: scorer name, assist name(s), period, game clock), period-by-period score table, complete penalty log (player, type, minutes) in `skorkeeper/lib/features/modules/hockey/presentation/`

### Lacrosse

- [X] T072 [P] [US6] Create `LacrosseState` Freezed helpers with lacrosse `sportSpecific` factory (`currentQuarter: 1–4`) and per-team `stats` map (`goals`, `assists`, `groundBalls`, `clearsSuccessful`, `clearsFailed`, `quarterScores`) in `skorkeeper/lib/features/modules/lacrosse/domain/lacrosse_state.dart`
- [X] T073 [P] [US6] Create `LacrosseModule` implementing `GameModule`: `applyAction()` for `LacrosseGoalScored` (score +1, optional `assistPlayerId`), `LacrosseGroundBallWon` (increment `groundBalls` for team + player), `LacrosseClearAttempted` (increment `clearsSuccessful` or `clearsFailed`); quarter advancement and win condition (most goals after 4 quarters, or OT if tied) in `skorkeeper/lib/features/modules/lacrosse/domain/lacrosse_module.dart`
- [X] T074 [US6] Implement `LacrosseGameNotifier`, `LacrosseSetupScreen` (team names, full roster entry, format: `full`/`short`/`scrimmage`), and `LacrosseGameScreen` (quarter timer, "Goal + Assist" button with `PlayerSelectionDialog` for scorer then optional assist, "Ground Ball" button per team, "Clear" success/fail toggle per team, "End Quarter" button, game summary with per-player stats) in `skorkeeper/lib/features/modules/lacrosse/`

### Upgrade Path & Pro Gating

- [X] T075 [US6] Update `SportsPurchaseSheet` to render an upgrade variant when `SportsEntitlement.hasSportsPlan == true && !hasSportsPro`: headline "Unlock Sports Pro", highlight Hockey/Lacrosse exclusivity and in-depth tracking benefits, show `$19.99` price, call `PurchaseService.purchaseSportsPro()` on confirm; re-use same component for first-time Pro purchase (parameterize by `showUpgradePitch: bool`) in `skorkeeper/lib/features/sports_hub/presentation/sports_purchase_sheet.dart`
- [X] T076 [US6] Register `HockeyModule` and `LacrosseModule` in `GameModuleRegistry` constructor; verify `SportsHubScreen` renders Hockey and Lacrosse tiles with `"Sports Pro Only"` lock label for Plan users and unlocked for Pro users per `SportsEntitlementNotifier`; add hockey and lacrosse GoRouter routes in `skorkeeper/lib/core/modules/game_module_registry.dart`

**Checkpoint**: All 8 sport modules are playable. Full tier differentiation is live. Sports Pro upgrade path works. US6 independently verifiable.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Game notes persistence, timer lifecycle safety, entitlement restore, accessibility, and final validation. Affects all user stories.

- [X] T077 [P] Add `SportNoteUpdated` action handling to all 8 sport game notifiers: `applyAction()` copies `content` into `SportGameState.notes`; on save/end-game upsert a `SportGameNotes` row via `SportHistoryDao`; wire a dismissible notes text field (expandable) to each game screen's overflow menu, accessible mid-game per FR-020
- [X] T078 [P] Implement `AppLifecycleState` observer in `SportTimerNotifier` (created in T034): subscribe via `WidgetsBinding.instance.addObserver(this)` on init; call `pauseTimer()` on `AppLifecycleState.paused`, `stopTimer()` on `AppLifecycleState.detached`; save `elapsedSeconds` to Drift on pause; restore and resume on `AppLifecycleState.resumed` per research.md §2; verify all 7 timed sport notifiers (Basketball/Football/Soccer/Hockey/Tennis/Volleyball/Lacrosse) use `SportTimerNotifier`
- [X] T079 [P] Invoke `PurchaseService.restoreSportsPurchases()` during app startup (after existing RevenueCat initialization); update `SportsEntitlementNotifier` with the restored `SportsEntitlement` snapshot so cached entitlements work offline per FR-002/FR-030/research.md §1
- [X] T080 [P] Add `Semantics` wrappers with descriptive labels to all sport scoring buttons (e.g., `Semantics(label: 'Record 2-pointer for home team')`), lock icons (`Semantics(label: 'Locked — Sports Plan required')`), purchase CTAs, and possession toggles to meet WCAG AA and constitution accessibility requirement across all sport game screens and the `SportsHubScreen`
- [X] T081 Run `dart run build_runner build --delete-conflicting-outputs` inside `skorkeeper/` to finalize code generation for all Freezed models (T024/T032/T040/T047/T050/T053/T067/T072) and any new Drift tables added during implementation
- [X] T082 Execute quickstart.md validation scenarios 1–8 end-to-end: purchase discovery (S1), baseball box score (S2), basketball timer (S3), soccer in-depth (S4), export all 3 formats (S5), Pro upgrade + Hockey (S6), 100-game limit enforcement (S7), offline play (S8); record and fix any failures against acceptance criteria in spec.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (Foundational)**: Requires Phase 1 completion — **BLOCKS all user story phases**
- **Phase 3 (US1)**: Requires Phase 2 ✅ — no dependency on other user stories
- **Phase 4 (US2)**: Requires Phase 2 ✅ — no dependency on US1 (but shares `SportsHistoryScreen` added here)
- **Phase 5 (US3)**: Requires Phase 2 ✅ — no dependency on US1 or US2; introduces `SportTimerNotifier` reused by US4/US6
- **Phase 6 (US4)**: Requires Phase 2 ✅ and T034 (`SportTimerNotifier`) from Phase 5
- **Phase 7 (US5)**: Requires Phase 2 ✅ and T031 (`SportsHistoryScreen`) from Phase 4; `SportsHistoryScreen` multi-select added at T062
- **Phase 8 (US6)**: Requires Phase 2 ✅ and T034 (`SportTimerNotifier`) from Phase 5; Hockey/Lacrosse reuse `PlayerSelectionDialog` from T045 (Phase 6)
- **Phase 9 (Polish)**: Requires all desired user story phases complete

### User Story Dependencies

| Story | Depends On | Can Start After |
|---|---|---|
| US1 (T018–T023) | Phase 2 complete | T017 ✅ |
| US2 (T024–T031) | Phase 2 complete | T017 ✅ |
| US3 (T032–T039) | Phase 2 complete | T017 ✅ |
| US4 (T040–T056) | Phase 2 + T034 | T034 ✅ |
| US5 (T057–T066) | Phase 2 + T031 | T031 ✅ |
| US6 (T067–T076) | Phase 2 + T034 + T045 | T045 ✅ |

### Within Each User Story

1. Domain models (`*_state.dart`, `*_module.dart`) → can be created in parallel within a phase
2. Application layer notifier → depends on domain models
3. Presentation screens → depend on notifier
4. Module registration + routes → final step in each story

### Key Cross-Story Dependencies

- `SportTimerNotifier` (T034, US3) is used by Soccer (T042), Football (T049), Tennis (T052), Volleyball (T055), Hockey (T069), Lacrosse (T074) — US3 must complete T034 before US4/US6 game notifiers can use it
- `PlayerSelectionDialog` (T045, US4) is used by Hockey (T070) and Lacrosse (T074) — T045 must complete before T070/T074
- `SportsHistoryScreen` (T031, US2) is extended for multi-select export at T062 (US5) — T031 must exist before T062

---

## Parallel Execution Examples

### Phase 2 Parallel Batch (launch together after T005 completes)

```
T006 — sport_enums.dart          (new file)
T007 — sport_game_state.dart     (new file)
T008 — sports_entitlement.dart   (new file)
T010 — sport_history_meta.dart   (new file)
T011 — sport_game_notes.dart     (new file)
```

Then parallel:
```
T012 — sport_history_dao.dart    (depends on T010, T011)
T013 — sport_export_dao.dart     (depends on T010)
T016 — sport_export.dart         (new file, independent)
```

### Phase 6 Domain Parallel Batch (all safe to launch together)

```
T040 — soccer_state.dart
T041 — soccer_module.dart
T047 — football_state.dart
T048 — football_module.dart
T050 — tennis_state.dart
T051 — tennis_module.dart
T053 — volleyball_state.dart
T054 — volleyball_module.dart
```

### Phase 8 Domain Parallel Batch

```
T067 — hockey_state.dart
T068 — hockey_module.dart
T072 — lacrosse_state.dart
T073 — lacrosse_module.dart
```

### Phase 7 Export Services Parallel Batch

```
T057 — sport_export_service.dart  (interface — others depend on it)
```
Then:
```
T058 — csv_export_service.dart
T059 — json_export_service.dart
T063 — analytics_calculator.dart
```

---

## Implementation Strategy

### MVP Scope: Phases 1–4 (US1 + US2 Only)

After Phases 1–4:
- Users can discover, purchase, and unlock Sports Plan
- Baseball is fully playable with box score
- History screen is live with 100-game limit
- **Demo-able and shippable minimum**

```
Phase 1: Setup           (T001–T003)     ~½ day
Phase 2: Foundational    (T004–T017)     ~2–3 days
Phase 3: US1 Purchase    (T018–T023)     ~1–2 days
Phase 4: US2 Baseball    (T024–T031)     ~2–3 days
─────────────────────────────────────────────────
MVP ready to demo/validate               ~6–9 days
```

### Incremental Delivery

| Milestone | Phases | Value Delivered |
|---|---|---|
| MVP | 1–4 | Sports Plan purchase + Baseball |
| +Timer Sports | +5 | Basketball live-scoreable |
| +All Plan Sports | +6 | Football, Soccer, Tennis, Volleyball; Pro in-depth |
| +Pro Export | +7 | PDF/CSV/JSON export + Analytics |
| +Pro Sports | +8 | Hockey + Lacrosse; upgrade path |
| Launch Ready | +9 | Notes, lifecycle safety, accessibility |

### Parallel Team Strategy (if multi-developer)

After Phase 2 is complete:
- **Developer A**: US1 (purchase + hub screens) → US5 (export)
- **Developer B**: US2 (baseball) → US3 (basketball) → US6 (hockey/lacrosse)
- **Developer C**: US4 (soccer in-depth + football + tennis + volleyball)

---

## Notes

- `[P]` = tasks in different files with no dependency on incomplete peer tasks; safe to parallelize
- `[US#]` label is only present in Phases 3–8; setup and foundational tasks carry no story label
- All 8 sport modules are always registered in `GameModuleRegistry` regardless of entitlement (entitlement gating is UI-only per research.md §4 and contracts/game-module.md §Module Registration)
- `SportTimerNotifier` is shared across all timed sports; create once in T034 and reuse
- `PlayerSelectionDialog` is shared across Soccer (in-depth goals), Hockey (goal/assist), and Lacrosse; create once in T045 and reuse
- The `sport_history_meta.tier_required` column drives the 100-game limit query — always populate correctly (`'sports_plan'` for Plan sports, `'sports_pro'` for Hockey/Lacrosse)
- Run `build_runner` at T017 (initial generation) and T081 (final generation after all models are complete); avoid running it between every model file to reduce churn
- Constitution mandates unit test coverage for all scoring logic — after each sport module's `applyAction()` is complete, write unit tests (follow test file paths in plan.md `skorkeeper/test/unit/modules/`)
- Commit after each checkpoint (end of each phase) to create clean rollback points

