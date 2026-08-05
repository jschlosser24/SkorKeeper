# Feature Specification: SkorKeeper — All-In-One Scoring & Game Tools App

**Feature Branch**: `001-skorkeeper-app`

**Created**: 2026-08-04

**Status**: Draft

**Input**: User description: "I want to build a modern all around score keeping/tools app called SkorKeeper that will allow users to keep track of their scores and remove the needing of having a notepad or any other physical way of keeping track of score and instead use this app."

---

## Overview

SkorKeeper is a mobile application for iOS and Android that replaces the need for physical scorecards, notebooks, timers, dice, and other analog game accessories. It provides a fast, polished, and always-available companion for board games, card games, darts, golf, and casual gaming with friends and family. The app is entirely self-contained and works without any internet connection or user account.

The visual identity uses the Minnesota Timberwolves color palette as the primary theme:

| Role | Color             | Hex |
|------|-------------------|-----|
| Navy (primary) | Midnight Navy     | `#0C2340` |
| Blue (accent) | Lighter Lake Blue | `#7CB4DF` |
| Silver (neutral) | Moonlight Silver  | `#9ea2a2` |
| Green (action) | Association Green | `#78BE20` |
| Deep Purple (alt) | Prince Purple     | `#221C35` |
| Violet (alt accent) | Prince Violet     | `#981D97` |

The app supports both light and dark modes, adapting the palette accordingly while maintaining brand consistency.

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Start and Score a Freeform Game Session (Priority: P1)

A group of friends sits down to play a card game not explicitly listed in the app. One player opens SkorKeeper, creates a new "Custom Scoring" session, adds 4 player names, and records round-by-round scores in a spreadsheet-style grid. At the end, the app displays the winner and final standings.

**Why this priority**: This is the broadest, most universally useful feature. If someone can do nothing else, they can replace a notepad. It delivers standalone value for any game.

**Independent Test**: Fully testable by creating a custom session, entering player names, recording 3 rounds of scores, and verifying the totals and winner are correctly displayed.

**Acceptance Scenarios**:

1. **Given** the home screen is open, **When** the user taps "New Game" → "Custom / Freeform", **Then** they are prompted to enter player names and an optional game name.
2. **Given** an active custom session with 4 players, **When** the user enters a score for each player in a round and taps "Confirm", **Then** running totals update instantly and the leading player is highlighted.
3. **Given** a completed session, **When** the user taps "End Game", **Then** the app displays a summary screen showing final standings and the winner.
4. **Given** the app is closed mid-session, **When** the user reopens SkorKeeper, **Then** the session is fully restored to its last saved state.

---

### User Story 2 — Play a Darts Game (Priority: P2)

Two players start a game of 501 darts. They take turns entering scores after each throw. The app automatically calculates remaining scores, flags bust throws, and calls "game over" when a player hits exactly zero with a double.

**Why this priority**: Darts has complex, rules-driven scoring that is the most difficult to replicate on a notepad and delivers the most convenience value.

**Independent Test**: Testable by starting a 501 game, recording several rounds of throws, triggering a bust, and completing the game to verify the winner is declared correctly.

**Acceptance Scenarios**:

1. **Given** a new darts session, **When** the user selects a game type (e.g., 501, 301, Cricket, Around the Clock, Shanghai, Killer), **Then** the correct starting scores, rules, and input UI are applied.
2. **Given** an active 501 game, **When** a player enters a throw that would bring their score below zero, **Then** the throw is marked as a "bust" and the player's score reverts to the pre-throw value.
3. **Given** a Cricket game, **When** a player closes a number and then scores additional hits on it, **Then** points are awarded to that player only while the number is open for opponents.
4. **Given** any darts game, **When** a player reaches the winning condition, **Then** the app immediately displays a win screen with game statistics.

---

### User Story 3 — Use Game Tools During Play (Priority: P3)

Mid-game, a player needs to roll two dice, flip a coin to decide who goes first, and set a 30-second sand timer for a word game. They access all of these from the Tools tab without leaving the app.

**Why this priority**: Tools are lightweight, high-frequency-use features that make the app a one-stop companion. They require no game setup and work in isolation.

**Independent Test**: Testable by opening the Tools tab and exercising each tool independently.

**Acceptance Scenarios**:

1. **Given** the Tools tab is open, **When** the user taps "Dice" and shakes the device or taps the roll button, **Then** a random result is displayed with a satisfying visual animation within 500ms.
2. **Given** the Tools tab is open, **When** the user taps "Coin Flip" and taps flip, **Then** a coin-flip animation plays and lands on heads or tails.
3. **Given** the Tools tab is open, **When** the user configures a timer for 30 seconds and starts it, **Then** a countdown runs with visual and audio feedback when time expires.
4. **Given** the Tools tab is open, **When** the user opens the Spinner and customizes the segments, **Then** a spin animation plays and highlights the winning segment.
5. **Given** the Tools tab is open, **When** the user opens "Lives Counter" and sets a starting life count for each player, **Then** each player's lives can be incremented or decremented with a single tap.

---

### User Story 4 — Score a Game of Golf (Priority: P4)

A foursome finishes a round of 9-hole mini golf. Each player enters their strokes per hole. The app tracks scores relative to par, displays a live leaderboard, and shows the final scorecard.

**Why this priority**: Golf scoring has well-defined structure (holes, par, stroke count) that benefits from a structured template rather than a blank grid.

**Independent Test**: Testable by starting a golf session, entering 9 holes of scores, and verifying that under/over par calculations and the final leaderboard are correct.

**Acceptance Scenarios**:

1. **Given** a new Golf session, **When** the user selects hole count (9 or 18 for golf, 1–18 for mini golf) and enters par values, **Then** a structured scorecard grid is presented with par totals.
2. **Given** an active golf scorecard, **When** a player's stroke count is entered for a hole, **Then** the score relative to par (eagle, birdie, par, bogey, etc.) is displayed and color-coded.
3. **Given** a completed golf round, **When** the user views the final scorecard, **Then** it shows each player's score per hole, total strokes, and total relative to par, with the lowest score highlighted as the winner.

---

### User Story 5 — Play Yahtzee (Priority: P5)

Up to 6 players take turns rolling five dice, selecting scoring categories, and tallying their scores. The app enforces Yahtzee rules (bonus scores, which categories have been used) and calculates the final score automatically.

**Why this priority**: Yahtzee has a fixed, well-known scorecard with complex sub-totals and bonuses that are tedious to calculate manually.

**Independent Test**: Testable by playing a full Yahtzee game with 2 players, filling all scoring categories, and verifying that the app calculates upper/lower section bonuses and the final winner correctly.

**Acceptance Scenarios**:

1. **Given** a Yahtzee session, **When** all scoring categories for all players are filled, **Then** the app automatically calculates sub-totals, the upper section bonus, the Yahtzee bonus, and final totals.
2. **Given** a player's turn, **When** they attempt to assign a score to a category they have already used, **Then** the app prevents the action and highlights the locked category.
3. **Given** any player rolls a Yahtzee after the Yahtzee box is already scored, **When** additional Yahtzees are rolled, **Then** the 100-point Yahtzee bonus is applied automatically.

---

### User Story 6 — Score Cribbage (Priority: P6)

Two players play cribbage. The app displays a virtual cribbage board with pegs that advance as players enter their scored points per hand, including pegging, nobs, heels, and flush scoring.

**Why this priority**: Cribbage has a unique board-style tracking mechanism that doesn't map well to a simple number table.

**Independent Test**: Testable by starting a cribbage session, recording several hands of points, and verifying that the peg positions advance correctly to 121.

**Acceptance Scenarios**:

1. **Given** a new Cribbage session, **When** a player enters their scored points for a hand, **Then** their peg advances on the visual board representation by the correct number of holes.
2. **Given** a cribbage game in progress, **When** a player's peg reaches or passes hole 121, **Then** the game ends and that player is declared the winner.
3. **Given** a cribbage session, **When** a player scores nobs (jack matching the starter suit), **Then** a single point is added to their score with a visual indicator.

---

### User Story 7 — View Game History (Priority: P7)

A user wants to see who won the last three times they played Yahtzee. They open the History tab, filter by game type, and see a chronological list of past sessions with final scores and winners.

**Why this priority**: History adds long-term value but does not block any core functionality. Sessions are usable without it.

**Independent Test**: Testable by completing 2 sessions, navigating to History, and verifying both sessions are listed with correct metadata.

**Acceptance Scenarios**:

1. **Given** at least one completed session, **When** the user opens the History tab, **Then** completed sessions are listed in reverse chronological order with game type, date, players, and winner.
2. **Given** the History list, **When** the user filters by game type, **Then** only sessions matching that type are shown.
3. **Given** a history entry, **When** the user taps it, **Then** the full scorecard/session summary is displayed in read-only view.

---

### User Story 8 — Apply Theming and Accessibility Preferences (Priority: P8)

A user prefers dark mode. They open Settings, confirm dark mode is active, and optionally switch the accent color between the primary Timberwolves palette and the Prince-themed palette. The entire app updates instantly.

**Why this priority**: Theming enhances experience but is not a blocking feature.

**Independent Test**: Testable by toggling dark/light mode in Settings and verifying every screen reflects the change correctly.

**Acceptance Scenarios**:

1. **Given** the device is set to dark mode, **When** the user opens SkorKeeper, **Then** the app defaults to the dark theme using the navy/blue palette.
2. **Given** Settings is open, **When** the user switches from the primary palette to the Prince palette, **Then** accent colors update across the entire app immediately.
3. **Given** any screen, **When** the user increases font size via OS accessibility settings, **Then** all text in the app scales accordingly without layout breaking.

---

### Edge Cases

- What happens when a single player is added to a multiplayer game (e.g., solo practice)?
- How does the app behave when the device runs out of storage and a session cannot be saved?
- What happens if a user enters a non-numeric value in a score field?
- How are ties handled in final standings (e.g., two players with identical total scores)?
- What happens if the app is force-closed mid-turn in a game with complex state (e.g., Yahtzee dice rolls)?
- What happens when a darts player enters a score that would leave a non-checkable remainder (e.g., 1 remaining in a double-out game)?
- How does the coin flip and dice behave if device audio is muted (silent mode)?

---

## Requirements *(mandatory)*

### Functional Requirements

**App Shell & Navigation**

- **FR-001**: The app MUST provide a bottom navigation bar with at minimum: Home/Games, Tools, History, and Settings tabs.
- **FR-002**: The app MUST support both iOS and Android platforms with identical functionality.
- **FR-003**: The app MUST support system light mode and dark mode, defaulting to the device setting.
- **FR-004**: The app MUST apply the Timberwolves color palette (`#0C2340`, `#236192`, `#9ea2a2`, `#78BE20`) as the primary theme, with the Prince palette (`#221C35`, `#981D97`) as an alternate accent option in Settings.
- **FR-005**: The app MUST function fully offline with no network connection required for any core feature.
- **FR-006**: The app MUST NOT require users to create an account or log in.
- **FR-007**: All active sessions MUST be automatically persisted so they survive app closure, device restart, and OS-triggered background kills.

**Scoring Modules**

- **FR-008**: The app MUST provide a "Custom / Freeform" scoring mode presenting a spreadsheet-style grid where rows represent rounds/categories and columns represent players; totals MUST update in real time.
- **FR-009**: Custom scoring MUST support 1–10 players and unlimited rounds.
- **FR-010**: Custom scoring MUST allow the user to name the game session and each player.
- **FR-011**: The app MUST provide a Darts module supporting the following game types: 301, 501, 701, Cricket, Cut-Throat Cricket, Around the Clock, Shanghai, Killer, and Halve It.
- **FR-012**: The Darts module MUST enforce game rules including bust detection (score resets on over-shoot in X01 games) and double-out and double-in options for X01 games.
- **FR-013**: The Darts module MUST display remaining score, average per dart/round, and darts thrown for each player.
- **FR-014**: The app MUST provide a Yahtzee module with the official Yahtzee scorecard (upper section, lower section, bonuses, Yahtzee bonus tracking) supporting 1–6 players.
- **FR-015**: The Yahtzee module MUST include an optional built-in dice roller so players can roll and score within the app.
- **FR-016**: The app MUST provide a Golf scoring module supporting 9-hole and 18-hole rounds with configurable par per hole, and a Mini Golf mode with 1–18 holes without par tracking.
- **FR-017**: The Golf module MUST display scores relative to par using standard terminology (eagle, birdie, par, bogey, double bogey, etc.) and color-coding.
- **FR-018**: The app MUST provide a Cribbage module with a visual cribbage board (two-player and optionally three/four-player variants), tracking peg positions and declaring a winner at 121 points.
- **FR-019**: The app MUST provide the following additional scoring modules: Bowling (automatic spare/strike calculation across 10 frames), Farkle, Sequence/Tile games (generic point accumulation with round tracking), UNO/Card game point penalty tracker, and Dominoes.
- **FR-020**: Each scoring module MUST display a live leaderboard during play, updated after every score entry.
- **FR-021**: Each session MUST have an "End Game" action that locks the session, shows a summary/winner screen, and moves the session to History.

**Tools**

- **FR-022**: The Tools tab MUST include: Dice Roller, Coin Flipper, Spinner (customizable segments), Timer/Countdown (with hourglass visual option), Stopwatch, Lives/Health Counter, Notepad, and Tally Counter.
- **FR-023**: The Dice Roller MUST support rolling 1–10 dice simultaneously, support standard die types (d4, d6, d8, d10, d12, d20, d100), and display individual die results plus a total.
- **FR-024**: The Dice Roller MUST support a shake-to-roll gesture as an optional input method.
- **FR-025**: The Spinner MUST allow users to add, remove, rename, and color-code up to 20 segments; the last spin result MUST be displayed after animation completes.
- **FR-026**: The Timer MUST support countdown from a user-set duration (up to 99 hours), display a sand-hourglass animation mode, and trigger an audible and haptic alert when time expires (respecting device silent/mute settings with haptic-only fallback).
- **FR-027**: The Lives/Health Counter MUST support 1–10 players, a configurable starting life count (1–999), and single-tap increment/decrement.
- **FR-028**: The Notepad tool MUST support free-text entry persisted locally and allow multiple named notes.
- **FR-029**: The Tally Counter MUST support a single counter with increment, decrement, and reset; optionally support multiple named counters.
- **FR-030**: The app MUST include a Random Team Picker tool that accepts a list of player names and divides them into a specified number of teams randomly.

**History**

- **FR-031**: Completed sessions MUST be saved to local History indefinitely until manually deleted by the user.
- **FR-032**: History MUST be filterable by game type and searchable by player name or session name.
- **FR-033**: Individual history entries MUST be viewable in full read-only detail and MUST be deletable.

**Performance**

- **FR-034**: Score entry confirmation (tap to next state) MUST complete within 300ms on mid-range devices (devices with 3GB RAM or more released after 2019).
- **FR-035**: App launch to home screen MUST complete within 2 seconds on the same class of device.

### Key Entities

- **GameSession**: A single instance of play for a given game type; has a type, status (active/completed), start time, end time, list of participants, and an ordered list of score records.
- **Player**: A named participant within a session; has a display name, color assignment, and a list of score entries or a current score state depending on the game type.
- **ScoreEntry**: A single recorded score event; has a round number, player reference, value, timestamp, and optional notes.
- **GameModule**: The definition and rules engine for a specific game type; defines player count bounds, scoring logic, win conditions, and UI layout requirements.
- **ToolSession**: A lightweight transient state for an active tool (e.g., dice, timer); may be persisted between uses but does not constitute a game session.
- **HistoryRecord**: An immutable snapshot of a completed GameSession used for display in History.
- **UserPreferences**: Persisted app-wide settings including theme (light/dark), accent palette, sound/haptic preferences, and default player names.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can open the app, start a new custom scoring session with 4 players, and record the first round of scores in under 30 seconds from a cold launch.
- **SC-002**: Completing a score entry action (confirming a score, rolling dice, flipping a coin) produces a visible result within 300ms with no perceptible lag.
- **SC-003**: All core features (scoring, tools, history browsing) are accessible and fully functional with no internet connection.
- **SC-004**: The app correctly enforces all darts bust and win rules across all 9 supported game types with zero known rule violations after QA pass.
- **SC-005**: A returning user can locate a specific past session in History in under 15 seconds using filtering.
- **SC-006**: The app renders correctly and all interactive elements are reachable on screen sizes from 4.7" to 6.9" (iPhone SE through Pro Max / equivalent Android).
- **SC-007**: Switching between light and dark mode produces a fully themed result across every screen with no un-themed elements visible.
- **SC-008**: The Yahtzee scorecard automatically computes correct final totals (including all bonuses) in 100% of tested complete game scenarios.
- **SC-009**: A user who has never used the app can start scoring any supported game type within 60 seconds without reading documentation.

---

## Assumptions

- The app targets end users who are non-technical casual gamers; UI copy and flows MUST be jargon-free and self-explanatory.
- Sessions are local to the device; cloud sync, multi-device sync, and real-time remote multiplayer are explicitly out of scope for v1.
- Physical dice, cards, and boards are still used by players; the app tracks scores and provides supplemental tools, not a full digital game engine.
- The Timberwolves palette is the permanent primary brand identity; the Prince palette is an alternate accent, not a full separate theme.
- Audio effects for dice rolls, coin flips, and timer alerts are desired but MUST respect the device's mute/silent switch via haptic-only fallback.
- Player names within a session are ephemeral and NOT tied to any stored profile or account system in v1.
- The maximum practical number of players per session is 10; no multi-team tournament bracket management is required for v1.
- Cribbage will support 2-player as the primary implementation; 3- and 4-player variants are a stretch goal for v1.
