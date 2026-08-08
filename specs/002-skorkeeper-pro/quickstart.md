# Quickstart Validation Guide: SkorKeeper Pro

**Branch**: `002-skorkeeper-pro` | **Phase**: 1 — Design
**Spec**: `specs/002-skorkeeper-pro/spec.md`

---

## Purpose

This guide defines runnable QA scenarios that prove each Pro monetization feature works end-to-end. It is used by developers to verify their implementation and by QA to confirm acceptance criteria before merge.

For data model details, see [`data-model.md`](./data-model.md).
For tech stack decisions, see [`research.md`](./research.md).

---

## Prerequisites

### Environment Setup

```bash
# 1. Verify Flutter SDK
flutter --version  # Must show 3.22.0 or higher

# 2. Install dependencies
flutter pub get

# 3. Run code generation (Freezed models, Riverpod providers)
dart run build_runner build --delete-conflicting-outputs

# 4. Verify no analysis errors
flutter analyze

# 5. Run unit + widget tests
flutter test
# Expected: All tests pass. Zero failures.
```

### Device / Simulator Requirements

- **iOS Simulator** (iPhone 14 or SE) **or** **Android Emulator** (API 26+, 3 GB RAM)
- Physical device strongly preferred for IAP sandbox flows (ATT prompt, App Store payment sheet)
- **Sandbox account required** for SC-002 (Pro purchase) and SC-003 (Restore Purchases): configure a sandbox test account in App Store Connect / Play Console before running those scenarios
- Test on **both platforms** before marking any scenario complete

### Run the App

```bash
# iOS
flutter run -d "iPhone 14"

# Android
flutter run -d emulator-5554
```

### Ad Testing Notes

- Use AdMob **test ad unit IDs** in debug builds. Never click real ads during testing.
- Test banner collapse by toggling airplane mode — the `connectivity_plus` stream fires within ~500 ms.
- Interstitial ads in test mode show a "Test Ad" overlay; behavior (show, dismiss) is identical to production.

---

## SC-001 — Free User Full Game Session, Ad Placement (US1)

**Validates**: SC-001, FR-007, FR-008, FR-011, FR-013 — no ad on game screens; one interstitial at session end; banner on ambient screens.

**Steps**:

1. Install a fresh build (or clear app data). Confirm the user is NOT Pro.
2. Navigate to the **Home** screen.
3. **Expected**: A banner ad is visible at the designated position on the Home screen. It does not overlap the game module grid.
4. Tap any game module (e.g., **Cribbage**). Set up a 2-player game and tap **Start Game**.
5. **Expected**: No banner ad is visible on the game setup screen or the game session screen.
6. Record several scores across multiple rounds.
7. **Expected**: No banner ad appears at any point during active scoring.
8. Tap **End Game** → confirm → arrive at the session summary screen.
9. **Expected**: No banner ad on the session summary screen.
10. Tap **Done** to dismiss the summary.
11. **Expected**: An interstitial ad appears before or immediately upon arriving at the Home screen.
12. Dismiss the interstitial.
13. **Expected**: You are back on the Home screen with the banner visible.
14. Start and complete a **second** game in the same app session.
15. Tap **Done** on the second session summary.
16. **Expected**: No second interstitial ad appears. Navigation to Home is immediate.

**Pass criteria**: Banner visible on Home ✓ | No ads on any game screen ✓ | Exactly one interstitial for the session ✓ | Second game triggers no interstitial ✓

---

## SC-002 — Pro Purchase Flow (US2)

**Validates**: SC-002, FR-001, FR-002, FR-010, FR-015 — purchase flow, immediate entitlement, ads disappear.

**Prerequisites**: Sandbox test account configured and signed in to the device's App Store / Play Store.

**Steps**:

1. Start with a fresh free-tier install. Confirm banner is visible on Home.
2. Navigate to **Settings**.
3. Tap **Upgrade to Pro**.
4. **Expected**: The Pro purchase bottom sheet opens, showing a list of all Pro benefits and the $3.99 price.
5. Tap **Upgrade to Pro** on the sheet.
6. **Expected**: The platform's native payment sheet appears with the sandbox account.
7. Confirm the purchase using the sandbox credentials.
8. **Expected**: The sheet dismisses. The Settings screen updates — "Upgrade to Pro" tile is replaced by "Pro Active ✓" tile. No restart required.
9. Return to the **Home** screen.
10. **Expected**: No banner ad is visible anywhere on the Home screen.
11. Navigate to the **Tools** screen.
12. **Expected**: No banner ad on Tools.
13. Complete a full game session and dismiss the summary.
14. **Expected**: No interstitial ad appears.

**Pass criteria**: Purchase completes in sandbox ✓ | Entitlement granted immediately without restart ✓ | All ads gone on all screens ✓

---

## SC-003 — Restore Purchases (US2)

**Validates**: FR-003, SC-003 — restore flow reinstates Pro entitlement.

**Prerequisites**: A sandbox account that has previously completed the SC-002 purchase.

**Steps**:

1. Uninstall and reinstall the app (or clear all app data to simulate a fresh install).
2. Confirm the user is in free tier (banner visible on Home).
3. Navigate to **Settings** → **Upgrade to Pro** (or tap "Restore Purchases" if visible as a separate tile).
4. If the purchase sheet is shown, tap **Restore Purchases** at the bottom.
5. **Expected**: A loading indicator appears. Within 10 seconds, the restore completes.
6. **Expected**: The "Upgrade to Pro" tile is replaced by "Pro Active ✓". No restart required.
7. Return to Home.
8. **Expected**: No banner ad visible.

**Edge case — no prior purchase**:

1. Attempt restore with a sandbox account that has **no** prior purchase.
2. **Expected**: A neutral confirmation message ("No purchases found for this account") is shown. No crash. No entitlement change. App returns to Settings normally.

**Pass criteria**: Pro restored within 10 seconds ✓ | Ads suppressed immediately after restore ✓ | Empty restore handled gracefully ✓

---

## SC-004 — Offline Pro Entitlement (US2)

**Validates**: FR-004, SC-004 — cached entitlement honored offline.

**Prerequisites**: The device must have previously completed a Pro purchase (SC-002) or restore (SC-003) while online so the RevenueCat cache is populated.

**Steps**:

1. With Pro active and network available, close and reopen the app. Confirm "Pro Active ✓" shows in Settings and no ads are visible — cache is populated.
2. Enable **Airplane Mode** (or disable all network interfaces).
3. Kill the app completely (swipe away from recent apps).
4. Relaunch the app with Airplane Mode still enabled.
5. **Expected**: The app launches to the Home screen within the normal cold-start time. No banner ad is visible. No network spinner or loading indicator related to entitlement is shown.
6. Navigate to **Settings**.
7. **Expected**: "Pro Active ✓" tile is visible.
8. Complete a full game session and dismiss the summary.
9. **Expected**: No interstitial ad.

**Pass criteria**: Pro entitlement honored within 1 second of cold launch while offline ✓ | No ads shown ✓ | No crash or degraded UI ✓

---

## SC-005 — Free User History Cap at 20 Sessions (US3)

**Validates**: FR-021, FR-022, FR-023 — 20-session cap, oldest pruned, upgrade prompt.

**Setup**: Use a device/emulator with the database seeded to 19 completed sessions. (If seeding is unavailable, manually complete 19 short games — use the fastest game type, e.g., Tally or Custom with 1 round.)

**Steps**:

1. Confirm the user is in free tier.
2. Navigate to **History**.
3. **Expected**: 19 sessions are listed.
4. Complete one more game session (this is session #20).
5. **Expected**: History shows 20 sessions. No prompt yet — 20 is at the cap, not over it.
6. Complete one more game session (this is session #21, which triggers the prune).
7. **Expected**: History shows 20 sessions. The oldest session from step 3 is no longer in the list.
8. **Expected**: An informational banner or prompt is visible on the History screen indicating the 20-session cap and offering an upgrade path. The prompt is non-blocking (user can dismiss and continue).
9. Confirm the upgrade path from the prompt opens the Pro purchase sheet.

**Pro user validation**:

1. Grant Pro entitlement (sandbox purchase or test override).
2. With 20+ sessions in history, complete additional sessions.
3. **Expected**: All sessions remain visible. No session is pruned. No cap prompt is shown.

**Pass criteria**: 21st session prunes oldest ✓ | Exactly 20 sessions remain ✓ | Upgrade prompt shown (non-blocking) ✓ | Pro user: unlimited sessions, no prompt ✓

---

## SC-006 — Pro CSV Export (US4)

**Validates**: FR-024, FR-025, SC-005 — CSV export with filtering, Pro-gated.

**Prerequisites**: Pro entitlement active. At least 5 sessions in history across at least 2 different game types.

**Steps — Export All**:

1. Navigate to **History**.
2. **Expected**: An export icon/button is visible in the AppBar.
3. Tap the export button.
4. **Expected**: A bottom sheet opens with "Export All" and "Filter by Game Type" options.
5. Tap **Export All**.
6. **Expected**: The platform native share sheet opens within 3 seconds with a `.csv` file attachment.
7. Open the file (e.g., in Files app or a text editor).
8. **Expected**: First row is a header: `date,game_type,players,winner,final_scores,duration_seconds`. Each subsequent row represents one completed session. Row count equals the number of history sessions. All fields are valid UTF-8.

**Steps — Filter by Game Type**:

1. Tap the export button.
2. Tap **Filter by Game Type**.
3. **Expected**: A list of available game types appears (only types that exist in history are shown).
4. Select one game type (e.g., **Cribbage**).
5. Tap **Export**.
6. **Expected**: Share sheet opens with a CSV file containing only Cribbage sessions. Sessions of other types are not included.

**Free user validation**:

1. With a free-tier account, navigate to History.
2. Tap the export button (if visible) or verify it shows a lock icon / Pro upgrade prompt.
3. **Expected**: The export action is not available or opens the Pro purchase sheet. No CSV is generated.

**Edge case — zero sessions**:

1. As a Pro user with an empty history, trigger export.
2. **Expected**: Share sheet opens with a CSV file containing only the header row. No crash.

**Pass criteria**: Share sheet opens with valid CSV within 3 seconds ✓ | Filter correctly limits rows ✓ | Header row always present ✓ | Free user cannot export ✓

---

## SC-007 — Theme Picker: Free and Pro User (US5, US6)

**Validates**: FR-026, FR-027 — locked themes for free users, all themes unlocked for Pro.

**Steps — Free User**:

1. Navigate to **Settings** → **Color Theme**.
2. **Expected**: Theme Picker screen opens with a grid of 8 theme cards.
3. **Expected**: Midnight Wolves has no lock overlay and is selected (checkmark visible).
4. **Expected**: The 7 Pro themes each have a lock overlay.
5. Tap **Midnight Wolves** card.
6. **Expected**: A live preview of Midnight Wolves is applied (already active — no visible change). A "Keep" / "Cancel" action bar may appear or the card is simply confirmed.
7. Tap a locked **Pro theme card** (e.g., Purple Reign).
8. **Expected**: A live preview of Purple Reign is applied to the entire app UI immediately.
9. **Expected**: A "Keep this theme" / "Cancel" or similar action bar appears.
10. Tap **Cancel** (or the equivalent dismiss gesture).
11. **Expected**: The app reverts to Midnight Wolves. The Pro purchase sheet does NOT automatically open (cancel means cancel).
12. Tap the same locked theme again and this time tap **Keep this theme** (or "Upgrade to Pro").
13. **Expected**: The Pro purchase sheet opens.

**Steps — Pro User**:

1. With Pro active, navigate to Settings → Color Theme.
2. **Expected**: All 8 theme cards are shown with no lock overlays.
3. Tap **Golden Hour 🏆**.
4. **Expected**: Live preview applies immediately. Action bar appears.
5. Tap **Keep this theme**.
6. **Expected**: Golden Hour is now the active theme. The Theme Picker shows Golden Hour with a checkmark. The app's entire color scheme has changed.
7. Return to Home.
8. **Expected**: Home screen, game cards, and all UI reflect the Golden Hour palette.
9. Kill and reopen the app.
10. **Expected**: Golden Hour is still active (persisted to `shared_preferences`).

**Pass criteria**: Free user sees 7 locked themes ✓ | Live preview applies on tap ✓ | Cancel reverts correctly ✓ | Pro user can select and persist any theme ✓ | Theme survives app restart ✓

---

## SC-008 — Default Player Colors (US5)

**Validates**: `defaultPlayerColors` persisted in preferences and carried through to game session setup.

**Steps**:

1. Navigate to **Settings** → **Player Defaults** (or equivalent section with Default Player Names).
2. **Expected**: Default player color chips are visible alongside default name fields, one per player seat (up to 10).
3. Tap the color chip for Player 1.
4. **Expected**: A color picker opens.
5. Select a distinctive color (e.g., bright red `#FF0000`).
6. Confirm.
7. **Expected**: The Player 1 color chip updates to the selected color.
8. Kill and reopen the app.
9. **Expected**: The selected color for Player 1 is still shown in Settings — it persisted.
10. Start a new game (any module with multiple players).
11. **Expected**: On the game setup / player entry screen, Player 1's color is pre-populated with the saved red color `#FF0000`.
12. Proceed without changing any colors. Start the game.
13. **Expected**: Player 1's score display, leaderboard row, and any color-coded UI elements reflect the red color throughout the session.

**Pass criteria**: Color saved to prefs ✓ | Color persists across restart ✓ | Color pre-populated in session setup ✓ | Color used in active game UI ✓

---

## SC-009 — Sound Pack Selection (US5)

**Validates**: Sound pack catalog, Pro gating, and asset path switching.

**Prerequisites**: Sound is enabled in Settings. Device is not on silent/mute.

**Steps — Free User**:

1. Navigate to **Settings** → **Sound Pack**.
2. **Expected**: Classic pack is available and selected. The 7 Pro packs are visible with lock overlays.
3. Tap a locked Pro pack (e.g., **Arcade**).
4. **Expected**: An upgrade prompt or the Pro purchase sheet opens. The Arcade pack is NOT selected.
5. Close the prompt. Confirm Classic is still selected.
6. Start a game and perform a scoreable action.
7. **Expected**: Classic sound effect plays.

**Steps — Pro User**:

1. With Pro active, navigate to Settings → Sound Pack.
2. **Expected**: All 8 packs are shown with no lock overlays.
3. Tap **Arcade** to select it.
4. **Expected**: Arcade is now selected (checkmark visible). A brief preview sound may play.
5. Start a new game and perform a scoreable action (e.g., roll dice, record a score).
6. **Expected**: The Arcade sound effect plays (audibly different from Classic).
7. Kill and reopen the app.
8. Navigate back to Sound Pack settings.
9. **Expected**: Arcade is still selected — persisted to `shared_preferences`.

**Pass criteria**: Free user cannot select Pro packs ✓ | Pro user can select and persist any pack ✓ | Correct sounds play for the active pack ✓

---

## SC-010 — Tip Jar (Voluntary IAP)

**Validates**: Tip Jar opens, 3 tiers shown, cancel is graceful, no features gated.

**Prerequisites**: Sandbox account signed in. No Pro purchase required (Tip Jar is available to all users).

**Steps**:

1. Navigate to **Settings** → **Support the Developer** (or **Tip Jar** tile).
2. **Expected**: The Tip Jar bottom sheet opens with three tier options:
   - $0.99 — "Buy a Coffee" (or equivalent)
   - $2.99 — "Buy a Snack" (or equivalent)
   - $4.99 — "Buy a Meal" (or equivalent)
3. Tap the **$0.99** tier.
4. **Expected**: The platform payment sheet appears for the sandbox tip product.
5. Tap **Cancel** on the payment sheet.
6. **Expected**: The Tip Jar sheet is still shown (or dismissed gracefully). No error message. No entitlement change. No crash.
7. Tap the **$2.99** tier and complete the sandbox purchase.
8. **Expected**: A "Thank you" or gratitude message is shown. The sheet closes or shows a confirmation state.
9. Confirm that no app features changed — the tip grants nothing. The user's free/Pro status is unchanged.

**Pass criteria**: Sheet opens with 3 tiers ✓ | Cancel is graceful ✓ | Successful purchase shows gratitude ✓ | No features gated or unlocked ✓

---

## SC-011 — Ad Banner Placement Verification

**Validates**: FR-007, FR-008, FR-009, FR-010 — banners on correct screens, absent on game screens, collapse offline, absent for Pro.

**Steps — Free User, Network Available**:

1. Home screen → **Expected**: Banner visible.
2. History screen → **Expected**: Banner visible.
3. Settings screen → **Expected**: Banner visible (or per implementation — verify FR-007 placement list).
4. Tools screen → **Expected**: Banner visible.
5. Open any game module setup screen → **Expected**: No banner.
6. Start a game; navigate to the active game session screen → **Expected**: No banner.
7. Reach the session summary screen → **Expected**: No banner.

**Steps — Offline Collapse**:

1. With the Home screen visible and banner loaded, enable **Airplane Mode**.
2. **Expected**: The banner area collapses to zero height within 500 ms. No error message, no spinner, no placeholder visible. The game module grid shifts up (no empty gap).
3. Disable Airplane Mode.
4. **Expected**: Banner reloads and becomes visible again (may take a few seconds for ad fill).

**Steps — Pro User**:

1. With Pro active, check every screen listed above.
2. **Expected**: No banner ad is visible on any screen.

**Pass criteria**: Banners on all 4 ambient screens ✓ | No banner on game screens ✓ | Collapse on offline ✓ | Zero banners for Pro ✓

---

## SC-012 — History Sorting

**Validates**: Sort controls for date, game type, and duration.

**Prerequisites**: At least 5 completed sessions in history, with at least 2 different game types and varying durations.

**Steps**:

1. Navigate to **History**.
2. **Expected**: A sort control bar is visible (e.g., chips or a sort button).
3. Select **Date: Newest First** (should be the default).
4. **Expected**: Sessions are ordered by `played_at` descending. The most recent session is at the top.
5. Select **Date: Oldest First**.
6. **Expected**: Sessions reorder — oldest session is at the top.
7. Select **Game Type**.
8. **Expected**: Sessions are grouped or sorted alphabetically by game type (e.g., all Bowling before Cribbage before Darts).
9. Select **Duration**.
10. **Expected**: Sessions are sorted by `duration_seconds` ascending (shortest session first). Sessions with no recorded duration appear last or first consistently.
11. Switch back to **Date: Newest First**.
12. **Expected**: List returns to chronological descending order.

**Pass criteria**: All sort modes produce correct ordering ✓ | Sort changes are immediate (no loading spinner) ✓ | Sort selection is session-scoped (does not persist across app restarts unless intentionally designed to) ✓
