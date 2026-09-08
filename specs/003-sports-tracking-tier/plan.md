# Implementation Plan: SkorKeeper Sports Monetization Tiers

**Branch**: `003-sports-tracking-tier` | **Date**: 2026-08-08 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/003-sports-tracking-tier/spec.md`

---

## Summary

Add a dual-tier sports monetization system (Sports Plan $6.99 + Sports Pro $19.99, both one-time IAP) that unlocks 6–8 sport-specific scoring modules with real-time timer and team-based scoring, in-depth player tracking (Pro), game history with a 100-game limit (Plan) or unlimited (Pro), and PDF/CSV/JSON export with an Advanced Analytics dashboard (Pro). The feature integrates with the existing RevenueCat `PurchaseService`, extends the `GameModule` protocol with two new sports-specific layout types, and persists all state in Drift SQLite — maintaining the offline-first, no-account-required constraints of the SkorKeeper Constitution.

---

## Technical Context

**Language/Version**: Dart 3 / Flutter SDK `>=3.8.0 <4.0.0`

**Primary Dependencies**:
- `flutter_riverpod` ^2.6.1 + `riverpod_generator` ^2.6.1 — state management for new sport feature providers
- `drift` ^2.25.0 + `sqlite3_flutter_libs` ^0.5.28 — SQLite persistence; all sport game state and history stored via existing `GameSessions` / `HistoryRecords` tables plus two new sport metadata tables
- `purchases_flutter` ^10.7.0 — RevenueCat IAP; two new entitlements (`sports_plan`, `sports_pro`) added alongside existing `pro` entitlement
- `freezed` ^3.0.0 + `json_serializable` ^6.9.5 — immutable sport state models; all `SportGameState` subtypes are Freezed classes
- `go_router` ^14.6.3 — routing to sport setup screens, game screens, history, analytics dashboard
- `share_plus` ^10.1.4 — export file sharing (PDF/CSV/JSON) on both platforms
- `path_provider` ^2.1.4 — temp file system access for export generation
- **New**: `pdf` ^3.10.x — PDF document generation for game report exports

**Storage**: Drift/SQLite on-device. Two new tables added alongside existing `GameSessions`, `HistoryRecords`, `ScoreEntries`, `NotepadEntries`: `sport_history_meta` (sport type, tracking mode, tier required, export status) and `sport_game_notes` (free-form notes per sport game session).

**Testing**: `flutter_test`, `mocktail` ^1.0.4, `bloc_test` ^10.0.0

**Target Platform**: iOS 14.0+ and Android 8.0+ (API 26+); both platforms via single Flutter codebase

**Project Type**: Mobile application (Flutter cross-platform)

**Performance Goals**:
- Screen transitions ≤300ms on mid-range devices (2GB+ RAM)
- Game save/load ≤500ms
- Score entry ≤3 taps from active game screen
- Real-time score display update: immediate (no perceptible lag after input)

**Constraints**:
- Offline-first: all game sessions playable and saved without network connectivity
- No account required: entitlements verified via RevenueCat device-level IAP
- Sports Plan: 100-game history limit for sport games; Pro: unlimited
- Timer precision: 1-second resolution is sufficient; millisecond precision not required

**Scale/Scope**:
- 8 sport modules (6 Plan, 2 Pro-exclusive)
- 3 export formats (PDF, CSV, JSON)
- 2 new IAP entitlements + 2 RevenueCat product IDs
- ~15–20 new Dart files (modules, state, providers, screens)
- 2 new Drift tables, 2 new DAOs

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design ✅ — all principles confirmed satisfied by design artifacts.*

| Principle | Status | Evidence |
|-----------|--------|----------|
| **I. Cross-Platform First** | ✅ PASS | All sport modules are pure Dart; no platform-specific code in module logic. Export via `share_plus` + `path_provider` are cross-platform abstractions. IAP via RevenueCat Flutter SDK targets both iOS and Android with the same API surface. |
| **II. Game-Agnostic, Modular Scoring Engine** | ✅ PASS | Each sport (Baseball, Basketball, Football, Soccer, Tennis, Volleyball, Hockey, Lacrosse) implements the existing `GameModule` interface. No sport-specific logic leaks into shared UI or app-level code. `ScoringLayoutType` is extended with `sportsBasic` and `sportsInDepth` to accommodate timer/team layouts without modifying the interface contract. |
| **III. Offline-First, No Account Required** | ✅ PASS | All sport game state stored in Drift SQLite on-device. RevenueCat entitlement check is used for purchase verification only — games are playable offline with previously-verified entitlements cached by RevenueCat SDK. Cloud sync is not required nor planned for v1. |
| **IV. Speed & Minimal Friction (NON-NEGOTIABLE)** | ✅ PASS | FR-026 mandates ≤3 taps for score entry, directly matching the constitution. FR-027 mandates 300ms transitions. Both are spec-level acceptance criteria. Large tap targets and high-contrast UI required by spec User Stories 2–6. |
| **V. Extensibility & Simplicity** | ✅ PASS | Modules are self-contained. Adding a new sport module (e.g., Lacrosse v2, Cricket) requires no changes to shared code. In-depth mode is a flag within module state, not a parallel class hierarchy. Dead code (if any modules not yet implemented) is gated behind entitlement check and excluded from release build via feature flags. |

**Gate result: PASS — no violations. Proceeding to Phase 0.**

---

## Project Structure

### Documentation (this feature)

```text
specs/003-sports-tracking-tier/
├── plan.md              ← This file
├── research.md          ← Phase 0 output
├── data-model.md        ← Phase 1 output
├── quickstart.md        ← Phase 1 output
├── contracts/
│   ├── entitlements.md  ← RevenueCat product + entitlement IDs
│   ├── game-module.md   ← SportModule protocol extension
│   ├── score-actions.md ← Sport-specific ScoreAction subclasses
│   ├── export-formats.md← PDF/CSV/JSON export schema
│   └── game-state-schema.md ← SportGameState JSON serialization contract
└── tasks.md             ← Phase 2 output (via /speckit.tasks — NOT created here)
```

### Source Code (repository root)

```text
skorkeeper/lib/
├── core/
│   ├── modules/
│   │   ├── game_module.dart               (existing — no changes)
│   │   ├── score_action.dart              (existing — sport actions appended)
│   │   └── scoring_layout_descriptor.dart (existing — sportsBasic/sportsInDepth added)
│   ├── monetization/
│   │   ├── purchase_service.dart          (existing — sports entitlement methods added)
│   │   └── sports_entitlement.dart        (NEW — SportsEntitlement value object)
│   └── database/
│       ├── tables/
│       │   ├── sport_history_meta.dart    (NEW)
│       │   └── sport_game_notes.dart      (NEW)
│       └── daos/
│           ├── sport_history_dao.dart     (NEW)
│           └── sport_export_dao.dart      (NEW)
├── features/
│   ├── modules/
│   │   ├── baseball/
│   │   │   ├── domain/
│   │   │   │   ├── baseball_module.dart
│   │   │   │   └── baseball_state.dart (.freezed.dart, .g.dart)
│   │   │   ├── application/
│   │   │   │   └── baseball_game_notifier.dart
│   │   │   └── presentation/
│   │   │       ├── baseball_setup_screen.dart
│   │   │       └── baseball_game_screen.dart
│   │   ├── basketball/   (same structure)
│   │   ├── football/     (same structure)
│   │   ├── soccer/       (same structure)
│   │   ├── tennis/       (same structure)
│   │   ├── volleyball/   (same structure)
│   │   ├── hockey/       (Pro-only; same structure)
│   │   └── lacrosse/     (Pro-only; same structure)
│   ├── sports_hub/
│   │   ├── presentation/
│   │   │   ├── sports_hub_screen.dart         (sport tile grid, lock icons)
│   │   │   └── sports_purchase_sheet.dart     (IAP pitch + purchase CTA)
│   │   └── application/
│   │       └── sports_entitlement_notifier.dart
│   ├── sports_history/
│   │   └── presentation/
│   │       └── sports_history_screen.dart     (100-game limit UI, delete, notes)
│   ├── sports_analytics/                      (Pro only)
│   │   ├── domain/
│   │   │   └── analytics_calculator.dart
│   │   ├── application/
│   │   │   └── analytics_notifier.dart
│   │   └── presentation/
│   │       └── analytics_dashboard_screen.dart
│   └── sports_export/                         (Pro only)
│       ├── domain/
│       │   ├── pdf_export_service.dart
│       │   ├── csv_export_service.dart
│       │   └── json_export_service.dart
│       └── application/
│           └── export_notifier.dart

skorkeeper/test/
├── unit/
│   ├── modules/
│   │   ├── baseball_module_test.dart
│   │   ├── basketball_module_test.dart
│   │   ├── football_module_test.dart
│   │   ├── soccer_module_test.dart
│   │   ├── tennis_module_test.dart
│   │   ├── volleyball_module_test.dart
│   │   ├── hockey_module_test.dart
│   │   └── lacrosse_module_test.dart
│   ├── monetization/
│   │   └── sports_entitlement_test.dart
│   └── export/
│       ├── csv_export_service_test.dart
│       └── json_export_service_test.dart
└── integration/
    └── sports/
        ├── baseball_game_flow_test.dart
        ├── basketball_game_flow_test.dart
        └── sports_purchase_flow_test.dart
```

**Structure Decision**: Option 3 (Mobile app) — each sport is a feature module under `features/modules/` following the existing `bowling/`, `darts/` structure with `domain/`, `application/`, `presentation/` layers. Shared sport infrastructure lives in `core/`.

---

## Complexity Tracking

> No constitution violations — this section is informational only.

| Decision | Complexity Added | Justification |
|----------|-----------------|---------------|
| Two new entitlements alongside existing `pro` | Low | RevenueCat supports multiple entitlements per product; existing `PurchaseService` pattern extended, not replaced |
| Sport timer in Riverpod `StateNotifier` | Medium | `Timer.periodic` with `ref.invalidateSelf()` is idiomatic Riverpod; must handle lifecycle (pause on app background) |
| PDF generation via `pdf` package | Medium | New dependency; PDF rendering is complex but well-contained in `PdfExportService` |
| In-depth mode as a state flag (vs. separate module) | Low | Single module class, single state class, `trackingMode` gates feature access within one coherent unit |
