# Quickstart Validation Guide: SkorKeeper

**Branch**: `001-skorkeeper-app` | **Phase**: 1 — Design
**Spec**: `specs/001-skorkeeper-app/spec.md`

---

## Purpose

This guide defines runnable validation scenarios that prove each feature works end-to-end. It is used by developers to verify their implementation and by QA to confirm acceptance criteria are met before merge.

For data model details, see [`data-model.md`](./data-model.md).
For interface contracts, see [`contracts/`](./contracts/).

---

## Prerequisites

### Environment Setup

```bash
# 1. Install Flutter SDK (3.22+ required for Impeller on Android)
flutter --version  # Must show 3.22.0 or higher

# 2. Install dependencies
flutter pub get

# 3. Run code generation (Drift tables, Freezed models, Riverpod providers)
dart run build_runner build --delete-conflicting-outputs

# 4. Verify no analysis errors
flutter analyze

# 5. Run all unit + widget tests (no device required)
flutter test

# Expected: All tests pass. Zero failures.
```

### Device/Simulator Requirements

- iOS Simulator (iPhone 14 or SE) **or** Android Emulator (API 26+, 3 GB RAM)
- Physical device preferred for shake gesture and haptic validation
- Test on **both** platforms before marking any scenario as complete

### Run the App

```bash
# iOS
flutter run -d "iPhone 14"

# Android
flutter run -d emulator-5554
```

---

## Scenario 1 — App Launch Performance (SC-001, FR-035)

**What it validates**: App launches to the home screen within 2 seconds on a mid-range device.

**Steps**:
1. Kill the app if running.
2. Launch the app cold.
3. Start a stopwatch at the moment you tap the app icon.
4. Stop the stopwatch when the home screen (game module grid) is fully rendered and interactive.

**Expected outcome**: ≤ 2000 ms from tap to interactive home screen.

**Automated equivalent**: `integration_test/launch_performance_test.dart` — measures `FlutterDriver.waitFor(find.byKey(Key('home_game_grid')))` from app start.

---

## Scenario 2 — Custom Freeform Scoring (User Story 1, FR-008–FR-010)

**What it validates**: A custom game session can be created, scored over multiple rounds, and ended with correct totals.

**Steps**:
1. From the home screen, tap **"New Game"**.
2. Select **"Custom / Freeform"**.
3. Enter game name: `"Crazy Eights"`.
4. Add 4 players: `"Alice"`, `"Bob"`, `"Carol"`, `"Dave"`.
5. Tap **"Start Game"**.
6. Enter scores for Round 1: `25`, `18`, `30`, `12`. Tap **"Confirm Round"**.
7. Enter scores for Round 2: `15`, `22`, `10`, `28`. Tap **"Confirm Round"**.
8. Enter scores for Round 3: `20`, `5`, `25`, `20`. Tap **"Confirm Round"**.
9. Tap **"End Game"**.

**Expected outcome**:
- After Step 6: Running totals display `Alice: 25`, `Bob: 18`, `Carol: 30` (highlighted as leader), `Dave: 12`. Score entry confirmed in < 300 ms.
- After Step 8: Totals: `Alice: 60`, `Bob: 45`, `Carol: 65`, `Dave: 60`. Carol is highlighted as leader.
- After Step 9: Summary screen shows: Winner: **Carol (65)**, Final standings in descending order.

**Session persistence check**:
1. After Step 7 (Round 2 complete), force-close the app.
2. Reopen SkorKeeper.
3. **Expected**: App navigates back to the active session with Rounds 1 and 2 already populated.

---

## Scenario 3 — Darts 501 with Bust Detection (User Story 2, FR-011–FR-013)

**What it validates**: 501 darts game enforces bust rule and correctly declares a winner.

**Steps**:
1. New Game → **Darts → 501**, Double Out = ON, 2 players: `"P1"`, `"P2"`.
2. P1 enters: 60, 60, 60 (180 total, remaining: 321). Tap **End Turn**.
3. P2 enters: 60, 60, 60. Tap **End Turn**.
4. Advance P1 to a state where remaining = 32.
   *(Continue entering valid scores until P1 has exactly 32 remaining.)*
5. P1 enters a score that would exceed 32 (e.g., 40). Tap **Throw**.

**Expected outcome** at Step 5:
- Turn is marked **BUST**.
- P1's score reverts to **32**.
- Visual indicator shows "Bust" with a red flash animation.
- Turn passes to P2.

6. Return P1 to 32 remaining via prior turns.
7. P1 enters **Double 16** (16 × 2 = 32). Tap **Throw**.

**Expected outcome** at Step 7:
- Win screen appears: **P1 wins!**
- Stats displayed: legs won, darts thrown, average per dart.

---

## Scenario 4 — Yahtzee Scorecard and Bonuses (User Story 5, FR-014–FR-015, SC-008)

**What it validates**: Yahtzee scorecard computes correct totals including upper section bonus, Yahtzee bonus, and final winner.

**Steps**:
1. New Game → **Yahtzee**, 2 players: `"P1"`, `"P2"`.
2. Play a complete game. For correctness validation, manually assign:
   - P1: Ones=1, Twos=4, Threes=9, Fours=16, Fives=25, Sixes=30, 3-of-a-Kind=24, 4-of-a-Kind=22, Full House=25, Small Straight=30, Large Straight=40, Yahtzee=50, Chance=28
   - P2: Ones=3, Twos=6, Threes=6, Fours=12, Fives=20, Sixes=24, 3-of-a-Kind=18, 4-of-a-Kind=0, Full House=25, Small Straight=30, Large Straight=40, Yahtzee=50, Chance=22

**Expected outcome**:
- P1 upper section total: 1+4+9+16+25+30 = **85** → Upper bonus applied (+35). Upper total with bonus: **120**.
- P1 lower section: 24+22+25+30+40+50+28 = **219**.
- P1 grand total: 120+219 = **339**.
- P2 upper section: 3+6+6+12+20+24 = **71** → Upper bonus applied (+35). Upper total: **106**.
- P2 lower section: 18+0+25+30+40+50+22 = **185**.
- P2 grand total: 106+185 = **291**.
- Winner: **P1 (339)**. Tap "End Game" → Summary screen confirms.

**Category lock check**:
1. After P1 scores Yahtzee once (50 pts), attempt to tap the Yahtzee category again.
2. **Expected**: Category is visually locked; tapping it does nothing (no score change).

**Yahtzee bonus check**:
1. After P1 has already scored 50 in the Yahtzee box, simulate a second Yahtzee roll.
2. **Expected**: +100 bonus is automatically applied and visible in bonus count.

---

## Scenario 5 — Golf Scoring with Par Calculations (User Story 4, FR-016–FR-017)

**What it validates**: 9-hole golf session correctly calculates scores relative to par.

**Steps**:
1. New Game → **Golf → 9 Holes**, 2 players: `"Tiger"`, `"Phil"`.
2. Enter pars: `4, 3, 5, 4, 4, 3, 4, 5, 4` (total par: 36).
3. Enter Tiger's strokes: `3, 3, 4, 4, 5, 2, 4, 4, 3` (total: 32).
4. Enter Phil's strokes: `4, 4, 5, 5, 4, 3, 5, 5, 4` (total: 39).
5. Tap **"End Round"**.

**Expected outcome**:
- Tiger total: **32**, relative to par: **−4** (4 under par).
- Phil total: **39**, relative to par: **+3** (3 over par).
- Tiger's hole 1 (3 on par 4): shows **Birdie** with yellow color coding.
- Tiger's hole 6 (2 on par 3): shows **Birdie**.
- Phil's holes show **Par** (0) and **Bogey** (+1) labels.
- Winner: **Tiger** highlighted on summary screen.

---

## Scenario 6 — Cribbage Board Peg Animation (User Story 6, FR-018)

**What it validates**: Cribbage board pegs advance correctly and game ends at 121.

**Steps**:
1. New Game → **Cribbage**, 2 players: `"Alice"`, `"Bob"`.
2. Enter Alice's hand score: **15** points. Tap **Score**.
3. Enter Bob's hand score: **12** points. Tap **Score**.
4. Verify visual peg positions on the board CustomPainter view.
5. Continue play until Alice reaches exactly **121** points.

**Expected outcomes**:
- After Step 2: Alice's front peg visually animates from hole 0 to hole 15. Rear peg stays at 0.
- After Step 3: Bob's front peg animates from 0 to 12.
- After multiple rounds: rear peg leaps ahead of old front peg on each score.
- At Step 5: When Alice's peg reaches or passes 121, **win screen appears immediately** — `"Alice wins! 121+ points"`.

---

## Scenario 7 — Tools: Dice Roller with Shake Gesture (FR-023–FR-024)

**What it validates**: Dice roller generates results, animates, and responds to shake.

**Steps**:
1. Open Tools tab → **Dice Roller**.
2. Configure: 3 × d6.
3. Tap the **Roll** button.
4. Observe animation.
5. On a physical device: shake the device.

**Expected outcomes**:
- Step 3: Animation starts within **100 ms** of tap. Individual die results visible within **500 ms** (FR-022 scenario 1).
- Step 3: Three individual die values displayed, plus their **total**.
- Step 3: Haptic feedback triggers on roll (if haptic_enabled = true).
- Step 3: Sound effect plays (if sound_enabled = true AND device not muted).
- Step 5: Shake triggers a roll with animation identical to button tap. No crash if device has no accelerometer (graceful degradation).

**Mute check**:
1. Enable device silent/mute mode.
2. Roll dice.
3. **Expected**: No audio plays. Haptic feedback still triggers.

---

## Scenario 8 — Tools: Timer with Haptic Alert (FR-026)

**What it validates**: Countdown timer triggers haptic alert when complete.

**Steps**:
1. Open Tools tab → **Timer**.
2. Set timer to **5 seconds**.
3. Switch to **Hourglass mode** (Lottie animation).
4. Tap **Start**.
5. Wait for timer to expire.

**Expected outcomes**:
- Hourglass animation plays throughout countdown.
- At expiry: haptic feedback fires (buzz pattern).
- If device is unmuted: alert sound plays.
- If device is muted: haptic fires, no sound. *(FR-026 silent mode fallback)*
- Timer UI shows "00:00" and "Time's up!" message.

---

## Scenario 9 — History: Save, Filter, Search (User Story 7, FR-031–FR-033)

**What it validates**: Completed sessions appear in history with correct metadata, and filtering/search work.

**Steps**:
1. Complete a Yahtzee session (players: `"Alice"`, `"Bob"`). Note the winner.
2. Complete a Custom session (players: `"Carol"`, `"Dave"`).
3. Navigate to the **History** tab.
4. Filter by **"Yahtzee"**.
5. Search by player name `"Alice"`.
6. Tap the Yahtzee history entry.

**Expected outcomes**:
- Step 3: Both sessions shown in reverse chronological order with: game type, date, player names, winner name.
- Step 4: Only the Yahtzee session is shown.
- Step 5: Only the Yahtzee session appears (Alice was a player).
- Step 6: Full read-only scorecard shows all categories, scores, and final totals.
- Step 6: No edit controls visible — history is read-only.

**Deletion check**:
1. Long-press (or swipe) a history entry → select **Delete**.
2. **Expected**: Confirmation dialog appears. On confirm: entry removed from list immediately. Cannot be undone.

---

## Scenario 10 — Theming: Light/Dark Mode and Palette Switch (User Story 8, FR-003–FR-004, SC-007)

**What it validates**: Theme switching updates all screens instantly with no un-themed elements.

**Steps**:
1. Open **Settings**.
2. Switch theme to **Dark mode**.
3. Navigate through Home, an active game session, Tools, History, and Settings.
4. Return to Settings. Switch theme to **Light mode**.
5. Repeat navigation in Step 3.
6. In Settings: switch to **Prince palette** accent.
7. Verify accent colors changed across screens.

**Expected outcomes**:
- Step 2/4: All backgrounds, text, icons, cards update **instantly** (no flash, no grey rectangles).
- Step 3/5: No screen has unthemed elements (white on dark, black on light, missing icons).
- Step 6: Accent colors (`#78BE20` → `#981D97`) update everywhere that previously showed the green accent: buttons, highlights, active tab indicator, leaderboard leader chip.
- All text passes WCAG AA contrast (4.5:1 minimum for normal text) in both themes.

---

## Scenario 11 — Session Recovery After Force-Close (FR-007)

**What it validates**: Active sessions survive force-close and OS background kill.

**Steps**:
1. Start a Darts 501 session. Enter 3 turns of scores.
2. Note the current score state.
3. Force-close the app (swipe away from app switcher).
4. Reopen the app.

**Expected outcomes**:
- App navigates directly to the active darts session (not home screen).
- All scores from Step 1 are present and accurate.
- It is the correct player's turn.

---

## Scenario 12 — Screen Size Compatibility (SC-006)

**What it validates**: All interactive elements are reachable on the smallest and largest supported screen sizes.

**Test on**:
- iPhone SE (4.7″, 375 × 667 pt)
- iPhone 15 Pro Max (6.7″, 430 × 932 pt)
- Samsung Galaxy A53 (6.5″, 390 × 844 dp)

**Steps**:
1. On each device/simulator, navigate through every major screen (Home, each game setup, an active session, all tools, History, Settings).
2. Verify all buttons, score entry cells, and navigation elements are tap-reachable without zooming.
3. Increase OS font size to "Accessibility Extra Large". Navigate all screens.

**Expected outcomes**:
- No overflow errors (RenderFlex overflowed by X pixels).
- No text truncated on SE-sized screen in critical score display areas.
- Font scaling does not break layouts; text wraps or scrolls rather than overflowing.
- All interactive elements have minimum 44 × 44 pt tap target size.

---

## Automated Test Coverage Expectations

| Layer | Test Type | Tool | Minimum Coverage |
|-------|-----------|------|-----------------|
| Game module scoring logic | Unit | `flutter test` | 100% of rule paths |
| BLoC state machines (Darts, Bowling) | Unit | `bloc_test` | All events + bust/win conditions |
| Yahtzee bonus calculations | Unit | `flutter test` | All bonus scenarios |
| Drift DAOs | Unit (with in-memory DB) | `flutter test` | All CRUD + stream operations |
| Score entry widgets | Widget | `testWidgets` | Happy path + validation error |
| Leaderboard widget | Widget | `testWidgets` | Rank ordering, tie handling |
| Custom scoring grid | Widget | `testWidgets` | Round entry, totals update |
| Full session happy path (each module) | Integration | `integration_test` | Start → score → end |
| Navigation routing | Widget | `testWidgets` | Tab switches, session restore redirect |

All unit and widget tests run in `flutter test` (no device, < 30 seconds total). Integration tests require a connected device or emulator.
