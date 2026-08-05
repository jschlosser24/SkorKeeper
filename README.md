# SkorKeeper

**The all-in-one scoring & game tools app** — replaces scorecards, notepads, dice, timers, and
more for board games, card games, darts, golf, cribbage, Yahtzee, and beyond.

Available on **iOS** and **Android**. Works fully offline. No account required.

---

## Documentation

| Document | Description |
|----------|-------------|
| [App README](skorkeeper/README.md) | Setup, build, run, and project structure |
| [Feature Spec](specs/001-skorkeeper-app/spec.md) | Full product requirements and user stories |
| [Implementation Plan](specs/001-skorkeeper-app/plan.md) | Architecture decisions and phased build plan |
| [Tasks](specs/001-skorkeeper-app/tasks.md) | Ordered implementation task list |
| [Data Model](specs/001-skorkeeper-app/data-model.md) | SQLite schema, storage layers, and entity relationships |
| [Quickstart / QA Guide](specs/001-skorkeeper-app/quickstart.md) | Runnable validation scenarios for each feature |
| [Contracts](specs/001-skorkeeper-app/contracts/) | Interface contracts (GameModule, navigation routes, storage schema) |
| [Constitution](.specify/memory/constitution.md) | Project principles and non-negotiable engineering standards |

---

## What It Does

SkorKeeper is a cross-platform mobile app that replaces every physical game accessory you'd bring
to a game night.

### Scoring Modules

| Game | Notes |
|------|-------|
| Custom / Freeform | Spreadsheet-style grid for any game, 1–10 players |
| Darts | 301, 501, 701, Cricket, Cut-Throat Cricket, Around the Clock, Shanghai, Killer, Halve It |
| Yahtzee | Full official scorecard with upper/lower bonuses |
| Golf / Mini Golf | 9 or 18 holes, par tracking, eagle/birdie/bogey labels |
| Cribbage | Visual board with two-peg system, wins at 121 |
| Bowling | 10-frame state machine, spare/strike/perfect game |
| Farkle | 6-dice, opening threshold, bank/farkle actions |
| Dominoes | Pip-count rounds, low score wins |
| UNO / Card Penalty | High-score-loses tracker with configurable target |

### Tools

Dice Roller (shake-to-roll, all die types) · Coin Flipper · Spinner (customizable segments) ·
Timer / Hourglass · Stopwatch · Lives Counter · Notepad · Tally Counter · Random Team Picker

---

## Quick Start

See the **[App README](skorkeeper/README.md)** for full setup instructions. The short version:

```bash
git clone <repo-url>
cd SkorKeeper/skorkeeper
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Flutter 3.22+ and Dart 3.8+ are required.

---

## Repository Structure

```
SkorKeeper/
├── skorkeeper/          # Flutter app source (lib/, test/, android/, ios/, assets/)
├── specs/
│   └── 001-skorkeeper-app/
│       ├── spec.md              # Product specification
│       ├── plan.md              # Implementation plan
│       ├── tasks.md             # Task list
│       ├── data-model.md        # Data model & schema
│       ├── quickstart.md        # QA validation guide
│       ├── research.md          # Technical research notes
│       ├── updates.md           # Change log
│       ├── contracts/           # Interface contracts
│       │   ├── game_module_interface.md
│       │   ├── navigation_routes.md
│       │   └── storage_schema.md
│       └── checklists/          # Feature checklists
├── .github/
│   ├── agents/          # Copilot agent definitions
│   └── prompts/         # Copilot prompt templates
└── .specify/
    └── memory/
        └── constitution.md      # Project principles
```

---

## Core Principles

The project is governed by a [constitution](.specify/memory/constitution.md). Key tenets:

- **Cross-platform first** — single Flutter codebase, identical behavior on iOS and Android
- **Offline-first** — all data persists locally; no account or network required for any core feature
- **Speed & minimal friction** — score entry in ≤ 3 taps; screen transitions within 300 ms
- **Modular** — each game is a self-contained module; new games are addable without touching existing code
- **Tested** — all scoring logic requires unit test coverage; no untested business logic merges

---

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.22+ / Dart 3.8+ |
| Navigation | go_router |
| State management | Riverpod 2.x (app-wide) + BLoC/Cubit (game state machines) |
| Local database | Drift (SQLite) |
| Animations | flutter_animate · Rive · Lottie |
| Audio | just_audio + audio_session |

See [Key Dependencies](skorkeeper/README.md#key-dependencies) in the App README for the full list.

---

## Platform Support

| Platform | Minimum version |
|----------|----------------|
| Android | 8.0 (API 26) |
| iOS | 14.0 |
