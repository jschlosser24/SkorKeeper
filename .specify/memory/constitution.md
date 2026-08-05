<!-- Sync Impact Report
  Version change: N/A → 1.0.0 (initial constitution)
  Added sections: Core Principles, Technology & Platform Standards, Quality & Testing Standards, Governance
  Modified principles: none (initial authoring)
  Removed sections: none
  Follow-up TODOs: none
-->

# SkorKeeper Constitution

## Core Principles

### I. Cross-Platform First

SkorKeeper MUST target both Android and iOS from a single shared codebase. Platform-specific code
is permitted only when required by OS APIs or native UX conventions, and MUST be isolated behind
a clear abstraction boundary. Shipping a feature on one platform while breaking the other is
never acceptable. All UI components and game logic MUST behave identically across platforms.

### II. Game-Agnostic, Modular Scoring Engine

Every game type (board games, card games, golf, darts, etc.) MUST be implemented as a
self-contained scoring module that conforms to a shared `GameSession` interface. Modules MUST
encapsulate their own rules, scoring logic, player configuration, and state transitions. No
game-specific logic MUST leak into shared UI or app-level code. New game types MUST be addable
without modifying existing modules.

### III. Offline-First, No Account Required

SkorKeeper MUST function completely offline. All game sessions, scores, and history MUST be
persisted locally on-device with no dependency on a remote service for core functionality.
Cloud sync and account features are optional enhancements and MUST degrade gracefully when
unavailable. Users MUST never be required to create an account to use any core feature.

### IV. Speed & Minimal Friction (NON-NEGOTIABLE)

Score entry MUST require the fewest possible taps. A player's score for a round/turn MUST be
recordable in no more than 3 taps from the active game screen. UI flows MUST be optimized for
use on a table or in the field (golf course, dart board, etc.) — large tap targets, high
contrast, and one-handed operation are REQUIRED. Performance: screen transitions MUST complete
within 300ms on mid-range devices.

### V. Extensibility & Simplicity

New game modes, tools (e.g., timers, randomizers, stat calculators), and features MUST be
added without restructuring existing code. YAGNI applies: features are built when needed, not
speculatively. Every feature addition MUST justify its complexity cost. Dead code and unused
dependencies MUST be removed promptly.

## Technology & Platform Standards

- **Framework**: React Native (or Flutter — to be decided at project kickoff). The chosen
  framework MUST be applied consistently; mixing cross-platform frameworks is prohibited.
- **State Management**: A single, well-established state management library MUST be used
  project-wide (e.g., Redux Toolkit, Zustand, or Riverpod for Flutter). Ad-hoc local state
  is permitted only for purely presentational components.
- **Local Persistence**: All session data MUST be stored using a structured local database
  (e.g., SQLite via `expo-sqlite`, `react-native-mmkv`, or `sqflite`). Raw file I/O for
  structured data is prohibited.
- **Minimum OS Targets**: Android 8.0 (API 26) and iOS 14.0 or newer.
- **No Unnecessary Permissions**: The app MUST request only permissions strictly required.
  Network access, camera, and location permissions MUST be justified per feature.

## Quality & Testing Standards

- **Unit Tests Required**: All scoring logic, rule enforcement, and stat calculations MUST
  have unit test coverage. Business logic untested in isolation MUST NOT be merged.
- **UI Smoke Tests**: Each game module MUST have at least one end-to-end or integration test
  covering the happy-path game flow (start session → record scores → end session).
- **No Regression Policy**: A bug fix MUST include a test that would have caught the regression.
- **Code Review**: All changes MUST be reviewed before merge. The reviewer MUST verify
  compliance with these principles, not just correctness.
- **Accessible by Default**: UI MUST meet WCAG AA contrast standards and support OS-level
  font scaling. Accessibility labels are REQUIRED on all interactive elements.

## Governance

This constitution supersedes all other informal practices or prior conventions. Any amendment
MUST be documented with a rationale, approved by at least one additional contributor, and
reflected in an incremented version number following semantic versioning:

- **MAJOR**: Removal or fundamental redefinition of a principle.
- **MINOR**: Addition of a new principle or material expansion of guidance.
- **PATCH**: Clarifications, wording improvements, or non-semantic refinements.

All pull requests and design reviews MUST include a brief check confirming the proposed change
does not violate these principles. Violations MUST be resolved before merge. If a principle
proves impractical, it MUST be amended here rather than silently ignored.

**Version**: 1.0.0 | **Ratified**: 2026-08-04 | **Last Amended**: 2026-08-04
