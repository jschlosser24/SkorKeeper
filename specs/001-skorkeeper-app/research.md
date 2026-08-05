# Research Report: SkorKeeper Tech Stack

**Branch**: `001-skorkeeper-app` | **Phase**: 0 — Pre-Design Research
**Spec**: `specs/001-skorkeeper-app/spec.md`

---

## Summary

All unknowns from the Technical Context have been resolved. The framework, state management, persistence, animation, sensor, audio, and navigation decisions are finalized below with rationale and alternatives rejected.

---

## Decision 1 — Cross-Platform Framework

**Decision**: **Flutter (Dart)**

**Rationale**:

1. **Custom painting is load-bearing.** The cribbage board with animated pegs, the bowling scoresheet with strike/spare cells, and the pie-chart spinner wheel are *core game interfaces*. Flutter's `CustomPainter` + Impeller renders these at GPU speed with no external dependencies. React Native requires `@shopify/react-native-skia` (~15 MB native library) — a separate dependency to version and maintain.

2. **Impeller eliminates jank that would violate FR-034.** Flutter's Impeller rendering engine (default on Android and iOS as of Flutter 3.22+) pre-compiles all shaders at startup. Screen transitions are consistently 100–140 ms on mid-range devices (Pixel 6a, Samsung A52), well under the 300 ms budget. React Native's Fabric/Hermes architecture still processes state updates on the JS thread; GC pauses on a dense Yahtzee scorecard (78 mutable cells, 6 players) can intermittently breach 300 ms on constrained devices.

3. **Dart's sound type system enforces game rule correctness.** Dart sealed classes + exhaustive `switch` + null safety from day one mean a missing case in a Cricket darts scoring function is a **compile error**. TypeScript's structural typing with `any` escape hatches makes rule completeness harder to enforce automatically.

4. **Widget tests run in < 10 ms each.** For 10 rule engines with correctness requirements (SC-004, SC-008), running 200+ widget + unit tests in < 30 seconds is a force multiplier. No device or simulator required.

5. **Cohesion at scale.** One language, one rendering pipeline, one CLI (`flutter`). No JS→native bridge threading model, no worklet threading rules.

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| React Native + Expo SDK 57 | Custom painting requires react-native-skia add-on (+15 MB); GC jank risk on dense grid screens; JS thread involvement on every state update |
| React Native bare workflow | Same rendering concerns as above, plus manual Android/iOS build config |
| Kotlin Multiplatform Mobile (KMM) | Shared logic only — still requires separate iOS (SwiftUI) and Android (Compose) UI code, doubling UI work |
| Native iOS (Swift) + Native Android (Kotlin) | Two full codebases, doubles all maintenance |

---

## Decision 2 — State Management

**Decision**: **Riverpod 2.x (app-wide) + BLoC/Cubit (complex game state machines)**

**Rationale**:

Riverpod is the right default: it is a Flutter Favorite, has `autoDispose` behavior that cleans up game state automatically on navigation away, and maps naturally to per-session scoped state. `ProviderScope.overrides` makes testing scoring logic trivial without mocking.

BLoC/Cubit is layered on top **only** for game modules with complex explicit state machines — specifically Darts (bust detection, turn cycling, finish suggestions) and Bowling (frame state: open/spare/strike, 10th-frame logic). The event→state model maps directly to the game's state machine semantics, and BLoC's strict "no bloc-to-bloc dependencies" rule enforces clean module boundaries, which directly supports Constitution Principle II.

**Mapping**:

| Concern | Tool | Rationale |
|---|---|---|
| App-wide theme, palette, sound prefs | Riverpod `Notifier` (keepAlive) | Global, reactive, trivial to test |
| Session CRUD, history list, active sessions | Riverpod `AsyncNotifier` + Drift streams | Reactive — UI auto-updates |
| Simple counters (tally, lives) | Riverpod `Notifier` (autoDispose) | Lightweight, no boilerplate |
| Darts rules engine (bust, turn, finish) | BLoC | Explicit event→state, rule correctness enforced |
| Bowling frame state (open/spare/strike) | Cubit | Simpler event model, same boundaries |
| Yahtzee dice + category locking | Cubit | Category state map, bonus tracking |

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| GetX | Mixes routing + DI + state in one system; opaque lifecycle; not a Flutter Favorite; not appropriate for production game apps |
| Riverpod-only (no BLoC) | Notifier lacks explicit event modeling for complex darts/bowling state machines; state machine logic bleeds into Notifier methods |
| BLoC-only | Heavy boilerplate for simple counters (tally: `IncrementTallyEvent`, `DecrementTallyEvent` — excessive for a single int) |
| Provider (legacy) | Superseded by Riverpod; no compile-time safety, global scope leaks |

---

## Decision 3 — Local Persistence

**Decision**: **Drift 2.x (relational game data) + shared_preferences (user settings)**

**Rationale**:

Drift provides a type-safe SQLite ORM with reactive `watch()` streams. This is the critical feature: score tables auto-update the live leaderboard widget without polling or manual refresh — score is entered, Drift emits a new stream event, Riverpod propagates it to the `LeaderboardWidget`. Drift also runs queries in a background isolate with zero boilerplate, preventing UI jank on history loads.

`shared_preferences` handles the handful of scalar preferences (theme choice, palette, sound/haptic flags) without the overhead of Drift table definitions for simple key-value data.

**Warning — Isar eliminated**: Isar v3 is the last stable release. Isar v4 underwent a full rewrite; the original maintainer's activity slowed significantly. pub.dev score shows 40/50 with 41 analysis issues (as of research date). Isar carries active maintenance risk for a v1 production app.

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| Isar | Active maintenance uncertainty; 40/50 pub score; 41 lint issues; do not use for new projects |
| Hive / Hive CE | Non-relational — can't efficiently query "all score entries for session X" or join sessions→players→scores; better suited to simple KV which shared_preferences covers |
| Floor | Less maintained than Drift; smaller community; no reactive watch() streams |
| expo-sqlite (React Native) | N/A — React Native not chosen |
| Raw file I/O | Explicitly prohibited by Constitution Principle III |

---

## Decision 4 — Animation Libraries

**Decision**: **flutter_animate (code-driven) + Rive (interactive state machines) + Lottie (one-shot AE exports)**

**Layering strategy** (each tool has a defined scope):

| Animation | Tool | Reason |
|---|---|---|
| Dice roll — shake + tumble + reveal | `flutter_animate` | `.shake()` + `.scale()` + `.rotate()` chain; no assets needed |
| Screen transitions | `flutter_animate` | `.fadeIn().slideY()` declarative chain |
| Score entry confirmation | `flutter_animate` `.scale()` + `.shake()` | Instant feedback on score tap |
| Coin flip (heads/tails state machine) | `Rive` | 2-state machine; designer owns the asset |
| Spinner wheel (spin → decelerate → land) | `Rive` | Complex spring deceleration + landing state |
| Win/celebration screen | `Lottie` | After Effects confetti export; one-shot, no interactivity |
| Hourglass sand timer | `Lottie` | Looping AE export; progress driven via controller |
| Cribbage peg movement | `CustomPainter` + `AnimatedBuilder` | Built-in Flutter animation; pegs animated by `Tween<Offset>` |
| Bowling scoresheet | `CustomPainter` | Static paint; frame cells rendered in raster thread |

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| Rive for everything | Rive requires designer-authored .riv files; code-driven effects (dice shake) are simpler and faster with flutter_animate |
| Lottie for interactive animations | Lottie does not support state machines; cannot branch "coin → heads vs tails" |
| react-native-reanimated | N/A — React Native not chosen |

---

## Decision 5 — Navigation

**Decision**: **go_router 14.x** with `StatefulShellRoute.indexedStack`

**Rationale**:

go_router is maintained by the Flutter team inside `flutter/packages`. `StatefulShellRoute.indexedStack` preserves each bottom-nav tab's navigator stack independently — critical for keeping an active game session alive when a user briefly visits the Tools tab. The package is declared "feature-complete" by the Flutter team, meaning it receives bug fixes and stability maintenance; API churn is minimal.

`StatefulShellRoute` handles deep linking into a session (`/game/darts/session/42`) and route guards (redirect to home if no active session).

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| auto_route | Requires code generation for routing; adds build_runner complexity when Drift + Freezed already use it; go_router achieves same result without codegen |
| Navigator 2.0 (manual) | High boilerplate; no tab-state preservation without significant custom work |
| GetX routing | Tightly coupled to GetX state management system; rejected in Decision 2 |

---

## Decision 6 — Shake Gesture Detection

**Decision**: **sensors_plus 6.x** (Flutter Favorite) with manual shake detection logic on the `UserAccelerometerEvent` stream

**Rationale**:

`sensors_plus` is a Flutter Favorite maintained by the Flutter Community organization. Using `UserAccelerometerEvent` (gravity-filtered) rather than raw `AccelerometerEvent` avoids the constant ~9.8 m/s² gravity offset that would make threshold math incorrect.

A lightweight shake detector is implemented directly using the stream with a cooldown timer, rather than depending on `shake` or `shake_detector` packages whose maintenance trajectories are less certain.

**Platform requirements**:
- **iOS**: `NSMotionUsageDescription` key required in `Info.plist` — omitting this crashes the app on first motion access.
- **Android**: `onError` callback required — some low-end devices lack accelerometers; error must be handled gracefully with shake disabled (not crashed).

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| `shake_detector` package wrapper | Adds another dependency with uncertain maintenance; wrapping sensors_plus directly is trivial and more controllable |
| `shake` package | Older package; maintenance uncertain; sensors_plus is the canonical source |

---

## Decision 7 — Audio (Sound Effects + Mute-Switch Compliance)

**Decision**: **just_audio 0.9.x** + **audio_session 0.1.x** for mute-switch-compliant SFX

**Rationale**:

`just_audio` + `audio_session` correctly configure `AVAudioSessionCategory.ambient` on iOS, which causes audio to stop automatically when the device's physical mute/silent switch is flipped — satisfying FR-026 without any additional logic. On Android, `AndroidAudioUsage.game` routes audio through the game stream, which respects device volume independently of media.

`audioplayers` is simpler for fire-and-forget but has WASM compatibility issues (`dart:io` import) and less reliable first-play latency behavior. `just_audio` pre-loading via `setAsset()` at game startup eliminates the 100–300 ms first-play delay on iOS.

**Fallback**: When audio is muted/silent, haptic feedback (via `HapticFeedback.mediumImpact()` from Flutter's services package) provides tactile confirmation of dice rolls, coin flips, and timer expiry. No additional package required — this is a Flutter SDK primitive.

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| audioplayers | WASM dart:io import issue; less reliable first-play latency; just_audio covers all same use cases with better iOS session control |
| Flutter built-in audio | No built-in audio playback in Flutter SDK; must use a package |
| System sound only | Insufficient for satisfying dice roll and timer alert UX requirements |

---

## Decision 8 — Data Modeling Approach

**Decision**: **`freezed` 3.x** for all game domain models + **`json_serializable`** for serialization

**Rationale**:

`freezed` generates immutable data classes with `copyWith`, `==`, `hashCode`, and `toString`. For game state (e.g., `DartsGameState`, `YahtzeeScorecard`) this is critical: BLoC and Riverpod Notifiers emit new immutable state objects, and the framework relies on `==` to detect changes and trigger rebuilds. Mutable objects shared by reference would produce silent bugs where UI doesn't update after a state change.

`json_serializable` produces the `toJson`/`fromJson` needed for Drift's `moduleStateJson` column — each game module serializes its own state blob using a known JSON schema.

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| Hand-written data classes | Error-prone `==` and `copyWith` implementations at scale (10+ game models); freezed is a Flutter Favorite with proven reliability |
| `equatable` only | Provides `==` but not `copyWith` or sealed union support; freezed is a superset |

---

## Decision 9 — Minimum OS Targets

**Decision**: **Android 8.0 (API 26)** and **iOS 14.0** (matching Constitution § Technology & Platform Standards)

**Rationale**:

Android API 26+ ensures access to the `HapticFeedback` composition API for high-quality tactile responses. iOS 14+ covers > 97% of active iOS devices and supports all required APIs (`AVAudioSessionCategory.ambient`, `UIImpactFeedbackGenerator`, `CoreMotion`). Flutter 3.x officially supports both.

---

## Resolved Unknowns Checklist

| # | Unknown | Resolution |
|---|---|---|
| 1 | Framework: Flutter or React Native? | Flutter — custom painting, Impeller, Dart soundness |
| 2 | State management library? | Riverpod 2.x + BLoC/Cubit for complex modules |
| 3 | Local database? | Drift 2.x (relational) + shared_preferences (settings) |
| 4 | Animation libraries? | flutter_animate + Rive + Lottie |
| 5 | Navigation package? | go_router 14.x with StatefulShellRoute |
| 6 | Shake detection? | sensors_plus 6.x + custom stream logic |
| 7 | Audio with mute-switch compliance? | just_audio 0.9.x + audio_session 0.1.x |
| 8 | Data class generation? | freezed 3.x + json_serializable |
| 9 | Minimum OS? | Android 8.0 (API 26) + iOS 14.0 |

---

## Complete Dependency Stack (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Navigation
  go_router: ^14.6.3

  # State Management
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  flutter_bloc: ^9.0.0
  bloc: ^9.0.0

  # Persistence
  drift: ^2.25.0
  sqlite3_flutter_libs: ^0.5.28
  shared_preferences: ^2.5.3

  # Animation
  flutter_animate: ^4.5.2
  lottie: ^3.3.1
  rive: ^0.13.20

  # Sensors
  sensors_plus: ^6.1.1

  # Audio + Haptics
  just_audio: ^0.9.46
  audio_session: ^0.1.22
  # Note: HapticFeedback is Flutter SDK built-in (flutter/services.dart)

  # Data Models
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0

  # Utilities
  collection: ^1.19.1       # groupBy, maxBy for leaderboard logic
  intl: ^0.20.2             # date/time formatting in History
  flutter_svg: ^2.0.17      # SVG icons

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.15
  riverpod_generator: ^2.6.1
  drift_dev: ^2.25.0
  freezed: ^3.0.0
  json_serializable: ^6.9.5

  # Testing
  mocktail: ^1.0.4
  bloc_test: ^9.1.7
```

---

## Known Risks and Mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| Rive visual discrepancies with Impeller (iOS) | Medium | Test all Rive assets with `--no-enable-impeller`; consider `Factory.rive` renderer if issues persist |
| Drift migration complexity on schema changes | Medium | Define schema carefully before v1 launch; write migration tests; never use `destroyEverything` strategy in production |
| sensors_plus iOS crash (missing Info.plist key) | High (if forgotten) | Add `NSMotionUsageDescription` to iOS template immediately; CI lint for required plist keys |
| sensors_plus Android — device without accelerometer | Low-Medium | Wrap accelerometer stream in `onError` handler; disable shake feature gracefully |
| just_audio first-play latency (100–300 ms) | Medium | Pre-warm `AudioPlayer` instances during game start loading screen via `setAsset()` |
| Riverpod autoDispose loses game state on tab switch | Medium | Use `keepAlive: true` on active session providers; test tab-switching during active games |
| BLoC bloc-to-bloc dependency temptation | Medium | Enforce via code review: blocs communicate only through shared Repository streams |
