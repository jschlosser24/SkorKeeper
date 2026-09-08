# Quickstart Validation Guide: SkorKeeper Sports Monetization Tiers

**Feature**: 003-sports-tracking-tier | **Phase**: 1 — Design
**Date**: 2026-08-08

---

## Overview

This guide describes how to validate that the Sports Monetization Tiers feature works end-to-end. Validation scenarios map directly to the spec's User Stories and Acceptance Scenarios. Run these after implementation is complete.

For entity structures, see [data-model.md](./data-model.md). For API/format details, see [contracts/](./contracts/).

---

## Prerequisites

### Environment Setup

1. **Flutter SDK** `>=3.8.0 <4.0.0` installed and on PATH
2. **Device or Simulator**: iOS 14+ simulator or Android API 26+ emulator (or physical device)
3. **RevenueCat test mode**: Configure sandbox credentials in `PurchaseKeys.androidApiKey` / `iosApiKey`
4. **Sandbox IAP accounts**:
   - iOS: Create sandbox tester accounts in App Store Connect; use these in iOS Simulator settings
   - Android: Use a test Google account added to the Play Console testing track
5. **RevenueCat Dashboard**: Products `sports_plan` ($6.99) and `sports_pro` ($19.99) created and attached to entitlements `sports_plan` and `sports_pro` respectively

### Build & Run

```bash
cd skorkeeper/
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

> For export validation, run on a physical device or simulator with file access. Export via `share_plus` opens the iOS share sheet or Android intent chooser.

---

## Scenario 1: Free User Discovers and Purchases Sports Plan

**Maps to**: User Story 1 (P1) — [spec.md §User Story 1](./spec.md#user-story-1)

**Steps**:
1. Launch app on a fresh account (no purchases)
2. Navigate to Home screen
3. Verify: Baseball, Basketball, Football, Soccer, Tennis, Volleyball tiles are visible with lock icon labeled "Sports Plan"
4. Tap a locked tile (e.g., Baseball)
5. Verify: Purchase prompt appears showing Sports Plan feature list and **$6.99** price
6. In sandbox mode, complete the IAP purchase
7. Verify: All 6 sports tiles unlock **immediately** (no app restart)
8. Tap Baseball — verify it opens the game setup screen

**Expected outcomes**:
- [ ] Locked tiles visible before purchase with lock icon + "Sports Plan" label
- [ ] Purchase prompt shows correct feature list and $6.99 price
- [ ] Post-purchase: all 6 tiles unlocked without restart
- [ ] Baseball opens to team name entry screen

**Cancellation check** (Acceptance Scenario 4):
1. Tap locked tile → purchase prompt appears
2. Dismiss the payment sheet mid-purchase
3. Verify: app returns to home screen with no entitlement granted, no error displayed

---

## Scenario 2: Sports Plan User Tracks a Full Baseball Game

**Maps to**: User Story 2 (P1) — [spec.md §User Story 2](./spec.md#user-story-2)

**Steps**:
1. With Sports Plan active, tap Baseball
2. Enter: Home = "Wildcats", Away = "Eagles"; select "9-Inning" format
3. Start game — verify display shows "Top of 1st", outs = 0, score 0-0
4. Tap "Out" 3 times — verify:
   - After 1st out: outs = 1
   - After 3rd out: auto-transitions to "Bottom of 1st", outs reset to 0
5. Record a "Hit" then a "Run" for home team — verify score updates to 1-0
6. Continue play through at least 3 full innings
7. End game — verify game summary shows:
   - Final score
   - Inning-by-inning breakdown
   - Runs, Hits, Errors totals per team
8. Navigate to History — verify game appears (count ≤ 100 for Plan)

**Expected outcomes**:
- [ ] Outs counter increments 0→1→2→3→reset with inning auto-transition
- [ ] Score updates immediately on "Run" tap
- [ ] Game summary shows complete box score with inning breakdown
- [ ] Game saved to local history, accessible offline

---

## Scenario 3: Sports Plan User Tracks a Basketball Game with Timer

**Maps to**: User Story 3 (P1) — [spec.md §User Story 3](./spec.md#user-story-3)

**Steps**:
1. With Sports Plan active, tap Basketball
2. Enter team names; select "Full Game" (4 quarters)
3. Start Q1 — verify timer starts counting
4. Tap "2-Pointer" (home team) — verify score updates instantly, timer does not pause
5. Tap "3-Pointer" (away team) — verify +3 to away score
6. Tap "Pause" — verify timer stops
7. Tap "Resume" — verify timer continues from where it paused
8. Advance to end of Q1 — verify quarter-break prompt
9. Start Q2 — verify display shows "Q2"
10. End game — verify summary shows: final scores, FG%, FT%, quarter-by-quarter breakdown

**Expected outcomes**:
- [ ] Timer runs continuously during active play; pauses on tap
- [ ] Score updates are immediate (< 1 frame visual delay)
- [ ] Quarter transitions work correctly
- [ ] Final stats calculations are accurate: FG% = fieldGoalsMade / fieldGoalsAttempted

---

## Scenario 4: Sports Pro User Tracks Soccer with In-Depth Mode

**Maps to**: User Story 4 (P1) — [spec.md §User Story 4](./spec.md#user-story-4)

**Prerequisite**: User has Sports Pro entitlement

**Steps**:
1. Tap Soccer on home screen
2. On setup: enter team names, add a roster of 3 players per team, enable "In-Depth Mode"
3. Start game
4. Toggle possession indicator → verify visual changes to show new possessing team
5. Tap "Goal" → verify player-selection dialog appears → select a scorer → verify:
   - Score increments by 1
   - Goal attributed to selected player
6. Advance to halftime (45 min timer or manual advance)
7. Verify halftime prompt shown; resume second half
8. End match — verify summary shows:
   - Final score
   - Goal timeline with player names and timestamps
   - Possession percentage breakdown by half

**Expected outcomes**:
- [ ] In-Depth Mode toggle only visible for Sports Pro users
- [ ] Player-selection dialog appears on Goal tap
- [ ] Possession percentage computed: `homePossessionSeconds / (homePossessionSeconds + awayPossessionSeconds) * 100`
- [ ] Goal timeline in summary lists scorer + game timestamp for each goal

---

## Scenario 5: Sports Pro User Exports Game Data

**Maps to**: User Story 5 (P2) — [spec.md §User Story 5](./spec.md#user-story-5)

**Prerequisite**: User has Sports Pro; at least 3 completed sport games in history

**PDF Export**:
1. Navigate to Sports History
2. Select 2 games for export → tap "Export" → choose "PDF"
3. Verify share sheet appears with PDF file
4. Open PDF — verify:
   - Both games present (one page each)
   - Final scores, team names, sport-specific stats all accurate
   - Cover summary page lists both games

**CSV Export**:
1. Select the same 2 games → export as CSV
2. Import into Excel or Google Sheets
3. Verify: 2 data rows + header row; scores match source games

**JSON Export**:
1. Export same games as JSON
2. Open in a text editor or JSON viewer
3. Verify: valid JSON, `exportVersion: "1.0"`, both games present, all stats match source
4. See [contracts/export-formats.md](./contracts/export-formats.md) for exact schema

**Expected outcomes**:
- [ ] PDF is well-formatted, readable, and contains accurate data
- [ ] CSV is importable into a spreadsheet with correct column alignment
- [ ] JSON is valid and matches the schema in `contracts/export-formats.md`
- [ ] Export completes without error; share sheet opens correctly

---

## Scenario 6: Sports Plan User Upgrades to Sports Pro

**Maps to**: User Story 6 (P2) — [spec.md §User Story 6](./spec.md#user-story-6)

**Prerequisite**: User has Sports Plan only

**Steps**:
1. View Sports section — verify Hockey and Lacrosse tiles are locked with "Sports Pro Only" label
2. Tap a locked tile → verify upgrade prompt with Sports Pro features and **$19.99** price
3. Complete Sports Pro purchase in sandbox
4. Verify: Hockey and Lacrosse tiles unlock immediately
5. Open Hockey — add team names, add roster
6. Start game — verify available actions: Goal, Assist, Penalty, Period Change
7. Record a goal with an assist — verify both are logged
8. View game summary — verify penalty log, goals, and assists are displayed
9. Also verify: in-depth mode is now available for previously Basic-only sports (Basketball, Football, Soccer)

**Expected outcomes**:
- [ ] Hockey and Lacrosse locked before upgrade with correct "Sports Pro Only" label
- [ ] Unlocked immediately after purchase without restart
- [ ] Hockey records goal + assist correctly
- [ ] Penalty log shows player name, type, and duration

---

## Scenario 7: Sports Plan History Limit Enforcement

**Maps to**: Edge Case — 100-game limit

**Steps**:
1. Create a Sports Plan account with exactly 100 saved sport games (in test: set up the DB with 100 rows via migration or test utility)
2. Attempt to start and complete a new sport game
3. Verify: app shows a message: "You've reached your 100-game limit. Delete a game or upgrade to Sports Pro for unlimited storage."
4. Delete one game from history
5. Verify: new game can now be saved successfully

**Expected outcomes**:
- [ ] 101st game save attempt is blocked with informative error
- [ ] After deleting one game, save succeeds
- [ ] History count reflects deletion correctly

---

## Scenario 8: Offline Play

**Maps to**: FR-016, FR-030

**Steps**:
1. Enable airplane mode on device
2. Launch app — verify Sports Plan tiles are unlocked (cached entitlement)
3. Complete a full basketball game
4. Navigate to History — verify game is saved and visible
5. Restore network connection — verify no errors, no data loss

**Expected outcomes**:
- [ ] App launches and entitlement is recognized while offline
- [ ] Game completes and saves correctly with no network
- [ ] History shows the game after network restores

---

## Unit Test Commands

Run all unit tests for sports modules:

```bash
cd skorkeeper/
flutter test test/unit/modules/
flutter test test/unit/monetization/
flutter test test/unit/export/
```

Run integration tests (requires device/emulator):

```bash
flutter test integration_test/sports/baseball_game_flow_test.dart
flutter test integration_test/sports/basketball_game_flow_test.dart
```

Run all tests:

```bash
flutter test
```

---

## Key Validation Checkpoints (Success Criteria)

| Criterion | Spec Ref | How to Verify |
|---|---|---|
| Purchase converts within session | SC-001 | Complete Scenario 1; tiles unlock same session |
| Sports Pro upgrade path works | SC-002 | Complete Scenario 6; Hockey/Lacrosse unlock |
| Full basketball game ≤ 60 taps | SC-004 | Count taps in Scenario 3 from start to finish |
| Score entry ≤ 3 taps | SC-005 / FR-026 | Verify 2pt button = 1 tap from active game screen |
| Game save/load ≤ 500ms | SC-006 | Add timing log to `SportHistoryDao.saveGame()` in test build |
| Export data accuracy 100% | SC-011 | Compare JSON export values to in-app history values in Scenario 5 |
| Stats formula accuracy | SC-013 | Baseball: verify BA = hits/atBats; Basketball: FG% = made/attempted |
| iOS + Android parity | SC-014 | Run Scenario 1–4 on both platforms; compare outcomes |
