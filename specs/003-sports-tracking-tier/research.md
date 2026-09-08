# Research: SkorKeeper Sports Monetization Tiers

**Feature**: 003-sports-tracking-tier | **Phase**: 0 — Pre-Design Research
**Date**: 2026-08-08

---

## 1. IAP Architecture — RevenueCat Multi-Entitlement Pattern

**Decision**: Add two new RevenueCat entitlements (`sports_plan`, `sports_pro`) orthogonal to the existing `pro` (cosmetic) entitlement. Each entitlement is backed by a non-consumable one-time in-app purchase product.

**RevenueCat Product Configuration**:
| Product ID | Type | Price | Entitlement |
|---|---|---|---|
| `sports_plan` | Non-consumable (iOS) / One-time (Android) | $6.99 | `sports_plan` |
| `sports_pro` | Non-consumable (iOS) / One-time (Android) | $19.99 | `sports_pro` |

**Rationale**:
- The app already uses `purchases_flutter` ^10.7.0 and `PurchaseService` with a single `entitlementPro` check. Extending with two new methods (`isSportsPlanUnlocked()`, `isSportsProUnlocked()`) follows the exact same pattern with zero architectural change.
- RevenueCat's `getCustomerInfo().entitlements.active` is a `Map<String, EntitlementInfo>` — checking for two keys is trivially low overhead.
- Offline entitlement caching: RevenueCat SDK caches the last-known `CustomerInfo` on-device. This means a user who purchased Sports Plan can launch the app offline and still get the cached entitlement — fully satisfying FR-016 (offline-first) and FR-002 (restore on launch).
- One-time non-consumable products cannot be re-purchased (App Store / Play Store prevents double-purchase automatically). FR-001 "lifetime access" is guaranteed by the platform.

**Alternatives Considered**:
- **StoreKit 2 / Google Play Billing directly**: Rejected. RevenueCat is already integrated and abstracts platform differences. Bypassing it would add significant platform-specific code, violating Constitution Principle I.
- **Single entitlement with product ID check**: Rejected. Mixing product IDs and entitlements breaks RevenueCat's clean entitlement model and makes pricing changes more fragile.
- **Subscription instead of one-time**: Rejected by spec. The spec explicitly mandates one-time IAP for both tiers.

---

## 2. Real-Time Sport Timer Architecture

**Decision**: Each sport game screen hosts a `SportTimerNotifier` (Riverpod `Notifier`) that wraps `dart:async Timer.periodic`. Timer state (elapsed seconds, isRunning) is held in the `SportGameState` Freezed model and persisted to SQLite on every pause/game-end.

**Key Design Points**:
- `Timer.periodic(const Duration(seconds: 1), ...)` increments a `elapsedSeconds` counter in the notifier.
- On `pause()`, `stop()`, or app lifecycle `AppLifecycleState.paused` — timer is cancelled and state is saved.
- On resume from background, state is rehydrated from DB; timer continues from where it left off.
- Count-up only (elapsed time tracked; for count-down sports like Basketball quarters, the UI computes `periodDuration - elapsed`).
- Timer is NOT part of the `GameModuleState` JSON for active sessions; it's an ephemeral notifier backed by persistent `elapsedSeconds` in state.

**Rationale**: Riverpod is the primary state management approach in the codebase (`riverpod_generator`, `riverpod_annotation` are active dev dependencies). BLoC is present for some existing features; keeping new sport screens on Riverpod maintains consistency for future contributors.

**Alternatives Considered**:
- **BLoC with `TimerBloc`**: Viable pattern (bloc_test is in dev deps) but BLoC would be inconsistent with Riverpod usage for new features.
- **Ticker/AnimationController**: AnimationControllers require a TickerProvider (BuildContext), making testing harder. Plain `Timer.periodic` is simpler and more easily unit-tested.
- **Isolate-based timer**: Overkill for 1-second resolution.

---

## 3. Team-Based Scoring Model (vs. Player-Turn Model)

**Decision**: Represent sport teams as two `SessionPlayer` entries (homeTeam, awayTeam) in `participantsJson` with `id = 'home'` and `id = 'away'`. Sport-specific roster data (for in-depth mode) lives inside `moduleStateJson` as `SportTeam.roster: List<SportPlayer>`.

**Rationale**:
- The existing `GameSessions` table stores `participantsJson` generically. Reusing `SessionPlayer` model for two teams avoids a new DB column and migration.
- `GameModule.leaderboard()` already returns `LeaderboardEntry` per player ID. Sports modules return two entries (home + away) — fits perfectly.
- In-depth player rosters are optional, variable-length, and sport-specific. Embedding them in `moduleStateJson` (Freezed / JSON) is appropriate: no fixed schema for player stats, and Drift's `TextColumn` with JSON serialization already handles this pattern throughout the codebase.

**Alternatives Considered**:
- **New `Teams` + `Rosters` DB tables**: Rejected for v1. Over-engineered for mobile-local storage. JSON embedding in `moduleStateJson` is the established pattern in this app for variable game state.
- **Separate `SportGameSession` Drift table**: Rejected. Would duplicate GameSessions. Extending via `sport_history_meta` FK table (as planned) is cleaner.

---

## 4. In-Depth Mode (Pro-Only) Module Architecture

**Decision**: A single `SportGameState` Freezed class per sport carries a `trackingMode: TrackingMode` field (`basic` | `inDepth`). In-depth mode enables:
- `SportTeam.roster: List<SportPlayer>` in state
- Additional `ScoreAction` subclasses (e.g., `BasketballPlayerPointsScored` vs. plain `BasketballTeamPointsScored`)
- Additional UI panels in the presentation layer (player selector dialogs, per-player stat rows)

Entitlement gating is **UI-side only** — the module itself does not check entitlements. The sport setup screen (`{sport}_setup_screen.dart`) reads `SportsEntitlementNotifier` and shows/hides the "In-Depth Mode" toggle.

**Rationale**: Separating entitlement checking from module logic respects the constitution's "no game-specific logic leaks into shared UI or app-level code" principle inversely — module logic doesn't need to know about monetization. The module simply responds to what state it's given.

**Alternatives Considered**:
- **Separate `{Sport}InDepthModule` class**: Would double the number of module files and duplicate all basic scoring logic. Rejected.
- **Module checks entitlement directly**: Would couple scoring logic to RevenueCat. Rejected (violates separation of concerns and testability).

---

## 5. Export Architecture (PDF / CSV / JSON)

**Decision**: Three separate service classes (`PdfExportService`, `CsvExportService`, `JsonExportService`) each implementing a `SportExportService` interface. Export flow: query game sessions → build data model → render to format → write to `path_provider` cache directory → share via `share_plus`.

**New Dependency — `pdf` package**:
- Package: `pdf` ^3.10.x (https://pub.dev/packages/pdf)
- Battle-tested Flutter PDF generation library; no native code; works on iOS and Android.
- Used only in `PdfExportService`; isolated behind the interface.

**CSV**: Pure Dart string building. No additional package needed. RFC 4180 compliant output with header row.

**JSON**: `dart:convert` `JsonEncoder.withIndent`. No additional package needed.

**File sharing**: `share_plus` `SharePlus.instance.shareXFiles([XFile(path)])` works identically on iOS and Android for both "Save to Files" (iOS) and filesystem sharing (Android).

**Rationale**: Isolation in separate service classes enables independent unit testing. The `pdf` package has no native dependencies, simplifying the build.

**Alternatives Considered**:
- **`printing` package**: Provides system print dialog, not file export. Doesn't satisfy the "download/share" requirement. Rejected.
- **Server-side PDF generation**: Violates offline-first constraint. Rejected.
- **Single export service with a format switch**: Would be a large class with mixed concerns. Rejected.

---

## 6. Game History Limit Enforcement (100 Games — Sports Plan)

**Decision**: A new `sport_history_meta` Drift table adds a `tierRequired TEXT` column (`'sports_plan'` or `'sports_pro'`) per sport game session. The `SportHistoryDao` enforces the limit with a query:

```sql
SELECT COUNT(*) FROM sport_history_meta 
WHERE tier_required = 'sports_plan';
```

If `count >= 100` and the user has only Sports Plan, insert is rejected with a `GameHistoryLimitReachedException`. The UI then shows: "You've reached your 100-game limit. Delete a game or upgrade to Sports Pro for unlimited storage."

**What the limit covers**: All sport game sessions combined (Baseball + Basketball + … + all 6 Plan sports), NOT per-sport.

**Rationale**: A single count query on a small table (max 100 rows for Plan users) is O(1) with an index. This is the simplest correct implementation.

**Alternatives Considered**:
- **Per-sport 100-game limit**: Rejected by spec — spec says "100 games" total, not per-sport.
- **Enforce limit in application layer only (no DB constraint)**: Acceptable but less safe. DB-level count enforcement in the DAO is preferred.

---

## 7. Advanced Analytics Query Strategy

**Decision**: `AnalyticsCalculator` performs all aggregations client-side via Dart from Drift query results. No pre-computed aggregate tables in v1.

**Queries needed**:
- Total games played per sport type
- Average final score (home + away) per sport type
- Scoring trend: scores per game over time (ordered by `played_at`)
- Performance metrics: sport-specific (batting avg for baseball, FG% for basketball, possession % for soccer)

**Performance**: For a typical Pro user with hundreds of games, a SELECT over `sport_history_meta` JOIN `game_sessions` with `ORDER BY played_at DESC` returning all rows for aggregation is well within SQLite's capability on mobile. A 1000-row join takes <10ms on mid-range devices.

**Rationale**: Pre-computing aggregates would require triggers or background jobs — significant complexity for v1. On-demand aggregation is simple, correct, and fast enough.

**Alternatives Considered**:
- **Separate analytics table with pre-computed metrics**: Overkill for v1. Post-launch optimization if needed.
- **Server-side analytics**: Violates offline-first. Rejected.

---

## 8. ScoringLayoutDescriptor Extension for Sports

**Decision**: Extend `ScoringLayoutType` enum with two new values:
- `ScoringLayoutType.sportsBasic` — timer display, team scoreboard, quick-entry action buttons
- `ScoringLayoutType.sportsInDepth` — all of basic + player selection drawer, per-player stat panel

The `config` map in `ScoringLayoutDescriptor` carries sport-specific UI hints:
```dart
config: {
  'sport': 'basketball',
  'periodLabel': 'Quarter',
  'periodCount': 4,
  'periodDurationSeconds': 600,  // 10 min quarters
  'scoreActions': ['2pt', '3pt', 'ft'],  // button labels
  'hasTimer': true,
  'hasPossessionToggle': false,
}
```

**Rationale**: Extends the existing interface without breaking it. All existing modules returning `ScoringLayoutType.standard`, `ScoringLayoutType.bowlingSheet`, etc. are unaffected.

**Alternatives Considered**:
- **Separate `SportModule` interface extending `GameModule`**: Would require separate registration and tile rendering logic. Rejected in favor of the simpler enum extension.
- **Hardcoded sport UI screens (no descriptor)**: Would bypass the module registry pattern and create tight coupling between home screen and each sport screen. Rejected.

---

## 9. Baseball Scoring Logic — Key Rules

**Decision**: Baseball module implements full bookkeeping per spec (FR-006):
- Outs 0→3 per half-inning, then auto-transition to next half-inning
- Inning state: `top` / `bottom` + inning number (1–9 for standard, 7-inning or scrimmage formats)
- Events: Run, Out, Hit, Strikeout, Ball, Strike, Error, Walk
- Stats computed at game-end: Runs per inning (box score), Hits (H), Errors (E), totals

**Batting Average & ERA**: Calculated from event counts in `SportEvent` log.
- `BA = hits / at-bats` (at-bat = plate appearance excluding walks)
- `ERA = (earned_runs / innings_pitched) * 9`

Both require counting specific event types from the event log — achievable from `List<SportEvent>` in module state.

---

## 10. Summary of New Dependencies

| Package | Version | Purpose | Already Present |
|---|---|---|---|
| `pdf` | ^3.10.x | PDF export generation | **NO — needs adding** |
| `purchases_flutter` | ^10.7.0 | RevenueCat IAP | YES |
| `share_plus` | ^10.1.4 | Export file sharing | YES |
| `path_provider` | ^2.1.4 | Temp file paths for export | YES |
| `drift` | ^2.25.0 | DB tables + DAOs | YES |
| `freezed` | ^3.0.0 | Sport state models | YES |
| `flutter_riverpod` | ^2.6.1 | Sport feature providers | YES |

**Only one new dependency required**: `pdf` ^3.10.x added to `pubspec.yaml`.

---

## All NEEDS CLARIFICATION Items — Resolved

| Original Unknown | Resolution |
|---|---|
| How to add sports entitlements without breaking existing `pro` entitlement | RevenueCat supports multiple entitlements; extend `PurchaseService` with two new check methods |
| Whether existing `GameModule` interface supports timer-based sports | Extend `ScoringLayoutType` enum; timer is an application-layer notifier, not in interface |
| How to enforce 100-game history limit cleanly | New `sport_history_meta` Drift table with a count query in DAO |
| Best approach for PDF export on Flutter | `pdf` package (pure Dart, no native code) + `share_plus` |
| How to represent in-depth mode without duplicating modules | `TrackingMode` flag in `SportGameState`; entitlement gate in UI only |
| How to handle team-based scoring vs. player-turn model | Map teams to two `SessionPlayer` entries; roster data in `moduleStateJson` |
