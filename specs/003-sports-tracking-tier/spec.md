# Feature Specification: SkorKeeper Sports Monetization Tiers

**Feature Branch**: `003-sports-tracking-tier`

**Created**: 2026-08-08

**Status**: Draft

**Input**: User description: "Create a comprehensive updated specification for the SkorKeeper Sports monetization tiers. The user has provided detailed requirements: Pricing Model with two-tier system (Sports Plan $4.99-$9.99, Sports Pro Plan $14.99-$24.99), Core Sports Requirements (Baseball with full bookkeeping, Basketball/Football/Soccer/Tennis/Volleyball with basic and advanced modes, recommend Hockey and Lacrosse), Common Features (add notes, save games locally), and tier-specific features (basic stats tracking for Sports Plan, unlimited storage and export for Sports Pro)."

---

## Overview

SkorKeeper Sports Monetization Tiers is a dual-tier monetization system that unlocks sport-specific scoring modules for real sports tracking. The **Sports Plan** ($6.99 one-time purchase) provides access to core sport modules with fundamental tracking capabilities, real-time game state management, and basic statistics. The **Sports Pro Plan** ($19.99 one-time purchase) extends Sports Plan with unlimited storage, advanced/in-depth tracking modes for each sport, export functionality (PDF/CSV/JSON), and advanced analytics.

Both tiers operate as one-time in-app purchases (separate from any free tier or Pro cosmetic tier), granting lifetime access to purchased features. A user may own both tiers simultaneously; features stack without conflict.

This specification updates and incorporates clarifications from initial specification with expanded sport coverage, detailed tier differentiation, explicit pricing strategy, and comprehensive feature matrices.

---

## Feature Matrix: Sports Plan vs Sports Pro Plan

| Feature | Sports Plan | Sports Pro Plan | Notes |
|---------|------------|-----------------|-------|
| **Sport Modules (Access)** |
| Baseball Module | âœ“ | âœ“ | Full bookkeeping in both tiers |
| Basketball Module | âœ“ | âœ“ | Basic in Plan; In-depth optional in Pro |
| Football Module | âœ“ | âœ“ | Basic in Plan; In-depth optional in Pro |
| Soccer Module | âœ“ | âœ“ | Basic in Plan; In-depth optional in Pro |
| Tennis Module | âœ“ | âœ“ | Basic and advanced available in both |
| Volleyball Module | âœ“ | âœ“ | Basic and advanced available in both |
| Hockey Module (Recommended) | âœ“ | âœ“ | Included in Sports Plan; periods, goals, assists, penalties. Pro adds in-depth tracking |
| Lacrosse Module (Recommended) | âœ“ | âœ“ | Included in Sports Plan; field position, ground balls, clears. Pro adds in-depth tracking |
| **Data & Storage** |
| Local Game Save | âœ“ | âœ“ | All games saved locally; offline-first |
| Game History Limit | 100 games | Unlimited | Plan users can archive/export to clear history |
| Add Game Notes | âœ“ | âœ“ | Free-form notes on any game |
| Basic Statistics | âœ“ | âœ“ | Standard calculations (averages, totals) |
| **In-Depth Tracking** |
| Sport-Specific Advanced Modes | âœ— | âœ“ | Player-by-player stats, possession tracking, advanced metrics |
| **Export & Analytics** |
| Export to PDF | âœ— | âœ“ | Export single or multiple games |
| Export to CSV | âœ— | âœ“ | For spreadsheet/data analysis |
| Export to JSON | âœ— | âœ“ | For data portability and custom analysis |
| Advanced Analytics Dashboard | âœ— | âœ“ | Trends, season summaries, performance insights |

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 â€” Free User Discovers and Purchases Sports Plan Access (Priority: P1)

A free or existing user browses the app's Home screen and discovers a "Sports" section with locked game tiles (Baseball, Basketball, etc.) marked with a lock icon and "Sports Plan" label. The user taps to unlock, views a clear pitch describing real-time game tracking, timers, and score-keeping capabilities, reviews the $6.99 one-time purchase offer, completes the payment, and immediately gains lifetime access to all Sports Plan modules.

**Why this priority**: This is the critical monetization path. Frictionless discovery, a compelling pitch, and a seamless purchase experience are essential for conversion.

**Independent Test**: Testable on a fresh account by discovering a locked sports module, viewing the purchase prompt with feature description and price, completing payment, and immediately launching a sport without app restart.

**Acceptance Scenarios**:

1. **Given** a free user on the Home screen, **When** the user views available game tiles, **Then** locked sports tiles (Baseball, Basketball, Football, Soccer, Tennis, Volleyball) are visible with a lock icon, label "Sports Plan," and a clear tap-to-unlock prompt.
2. **Given** a free user who taps a locked sports tile, **When** the purchase prompt is displayed, **Then** the user sees a concise description of what Sports Plan includes (list of sports, real-time timers, score tracking, game notes) and the $6.99 one-time purchase price.
3. **Given** a free user who completes the Sports Plan purchase, **When** payment is processed, **Then** the Sports Plan entitlement is granted immediately and all locked tiles are now unlocked without requiring app restart.
4. **Given** a free user who cancels the payment sheet mid-purchase, **When** the sheet is dismissed, **Then** the app returns to Home screen with no entitlement change and no error.
5. **Given** a user on Home screen with Sports Plan access, **When** they view sports tiles, **Then** all sports tiles display as unlocked and selectable; the lock icon is gone.

---

### User Story 2 â€” Sports Plan User Tracks a Live Baseball Game with Full Bookkeeping (Priority: P1)

A Sports Plan user opens the Baseball module for a live game, enters team names and player rosters, and starts the game. The app displays inning (e.g., "Top of 3rd"), outs count, current score, and contextual buttons to record events: run, out, hit, strikeout, ball, strike. After each recorded event, the app auto-updates inning state, outs, and score. At game-end, the user sees a box score with runs, hits, errors, and an inning-by-inning breakdown. The game is automatically saved locally.

**Why this priority**: Baseball with full bookkeeping is a core differentiator for Sports Plan. The sport's complexity (outs, innings, varied event types) tests the app's event handling and state management.

**Independent Test**: Testable by starting a baseball game with Sports Plan access, recording a sequence of hits, runs, outs, and balls/strikes through multiple innings, verifying outs advance and innings auto-transition, and confirming final stats are correct and game is saved locally.

**Acceptance Scenarios**:

1. **Given** a user with Sports Plan access on Home screen, **When** the user taps Baseball, **Then** they are prompted to enter team names, select player roster size, and choose a game format (full 9-inning, 7-inning, scrimmage).
2. **Given** an active baseball game, **When** the user taps "Out," **Then** outs increment, displayed prominently; when outs reach 3, the half-inning auto-transitions and display updates to show the next inning state.
3. **Given** an active game in progress, **When** the user records a run by tapping "Run," **Then** the score updates instantly, the running total shows the new score, and previous state is maintained.
4. **Given** a completed baseball game, **When** the user views the game summary, **Then** final scores, runs, hits, errors per team, and inning-by-inning breakdown are displayed with accuracy.
5. **Given** a baseball game played offline, **When** the game ends, **Then** the game is persisted locally and appears in the game history (within the 100-game limit for Sports Plan) without requiring network connectivity.

---

### User Story 3 â€” Sports Plan User Plays Basketball with Real-Time Timers and Quick Score Entry (Priority: P1)

A Sports Plan user opens the Basketball module, enters team names and player rosters, selects a game format (full game, quarters, scrimmage), and starts live play. The app displays an on-court timer, current score for each team, and large buttons for quick score entry (2-Pointer, 3-Pointer, Free Throw). After each score, the display updates instantly. At each quarter break, the app pauses and shows quarter summary; play resumes by tapping "Start Q[N]." At game-end, a summary displays final scores, field goal %, and free throw %.

**Why this priority**: Basketball with real-time scoring and timer is a core use case. The on-court experience (minimal taps, high contrast UI, fast response) is essential for user satisfaction.

**Independent Test**: Testable by opening a basketball game with Sports Plan, recording 2-pointers, 3-pointers, and free throws in rapid succession, pausing/resuming the timer mid-quarter, and verifying the game summary statistics are correct.

**Acceptance Scenarios**:

1. **Given** a user with Sports Plan access, **When** the user taps Basketball and selects a game format, **Then** they are prompted to enter team names and can choose to add player rosters (optional).
2. **Given** an active basketball game with timer running, **When** the user taps "2-Pointer," **Then** the score updates instantly, the timer continues without interruption, and the display remains readable.
3. **Given** a basketball game mid-second quarter, **When** the game timer reaches the end of Q2, **Then** the timer pauses, a quarter-break prompt is displayed, and play resumes by tapping "Start Q3."
4. **Given** a completed basketball game, **When** the user views the summary, **Then** final scores, total points per team, field goal %, free throw %, and quarter-by-quarter breakdown are shown.
5. **Given** a basketball game with no network connection, **When** scores are recorded, **Then** all scores are saved locally and the game continues without sync delay or errors.

---

### User Story 4 â€” Sports Pro User Tracks Soccer with In-Depth Mode and Possession Tracking (Priority: P1)

A Sports Pro user opens the Soccer module and selects "In-Depth Mode" (available only in Pro). The app displays team names, real-time score, game timer in minutes, and a possession toggle showing which team currently has the ball. The user records goals using a dedicated button, which triggers a player-selection dialog to assign the goal to a specific scorer. The app tracks possession percentage in real-time. At match-end, the user sees a match summary with final scores, goal timeline (who scored, when), goal-scorers with counts, and possession percentage breakdown by quarter.

**Why this priority**: In-depth Soccer mode showcases the value of Sports Pro tier with player-level stats and possession analytics. This differentiates Pro from Plan and justifies the pricing.

**Independent Test**: Testable by starting a soccer match with Sports Pro, selecting in-depth mode, recording multiple goals for different players, toggling possession, advancing through first and second halves, and verifying the match summary shows all advanced stats.

**Acceptance Scenarios**:

1. **Given** a user with Sports Pro access on Home screen, **When** the user taps Soccer, **Then** they are prompted to select game format and given an option to enable "In-Depth Mode" (highlighting Pro feature).
2. **Given** an in-depth soccer match, **When** the user taps "Goal," **Then** a player-selection dialog appears, the user selects the scorer, the score updates, and the goal is attributed to that specific player.
3. **Given** an in-depth soccer match, **When** the user toggles the possession indicator, **Then** a visual element (color highlight, icon change, or text label) clearly shows which team currently holds the ball.
4. **Given** an in-depth soccer match in progress, **When** the first half timer reaches 45 minutes, **Then** the timer pauses, a halftime prompt is shown, and play can resume with the second half starting at 45.
5. **Given** a completed in-depth soccer match, **When** the user views the match summary, **Then** final scores, goal-by-goal timeline with timestamps and player names, goal-scorers ranked by count, and possession percentage breakdown are all displayed.

---

### User Story 5 â€” Sports Pro User Exports Game Data and Analyzes Trends (Priority: P2)

A Sports Pro user completes several baseball and basketball games over a season. In the Sports Pro dashboard, the user accesses the "Advanced Analytics" section where they can view season summaries, performance trends (scoring, efficiency metrics), and export individual or multiple games to PDF (game report format), CSV (for spreadsheet analysis), or JSON (for custom tooling). The exported files are available for download or email.

**Why this priority**: Export and analytics are key differentiators for Sports Pro. These features provide long-term value and justify the premium pricing by enabling deeper data insights and record-keeping.

**Independent Test**: Testable by playing multiple games across different sports, accessing the Advanced Analytics dashboard, exporting a selection of games to each format, and verifying the exports contain accurate, complete data.

**Acceptance Scenarios**:

1. **Given** a Sports Pro user with multiple completed games in history, **When** the user navigates to "Advanced Analytics," **Then** they see season summaries (total games, average scores, performance trends) and a visual dashboard with key metrics.
2. **Given** a Sports Pro user on the Advanced Analytics screen, **When** the user selects games to export and chooses "PDF," **Then** a well-formatted PDF report is generated containing game details, final scores, and statistics.
3. **Given** a Sports Pro user exporting games to CSV, **When** the export completes, **Then** the CSV file is properly formatted for spreadsheet import with columns for team names, dates, scores, and detailed stats for each game.
4. **Given** a Sports Pro user exporting games to JSON, **When** the export completes, **Then** the JSON file is valid and contains all raw game data in a portable format suitable for custom analysis or integration with external tools.
5. **Given** a Sports Pro user with an active export, **When** the export completes, **Then** the user can download the file or (if configured) receive it via email.

---

### User Story 6 â€” Sports Pro User Upgrades from Sports Plan and Gains Access to Hockey (Priority: P2)

A user currently holding a Sports Plan entitlement discovers the Sports Pro tier. They purchase Sports Pro ($19.99), and immediately gain access to all Pro-exclusive sports (Hockey, Lacrosse) and advanced tracking modes for all other sports. They can now track a hockey game with full period tracking, goal attribution, assists, and penalty logging â€” features not available in Sports Plan.

**Why this priority**: The upgrade path and Pro-exclusive sports (Hockey, Lacrosse) demonstrate tier differentiation and upsell value. This scenario is important for monetization strategy but secondary to core experience.

**Independent Test**: Testable by starting with a Sports Plan account, purchasing Sports Pro, verifying Hockey and Lacrosse modules appear and are selectable, starting a hockey game, and recording goals, assists, and penalties.

**Acceptance Scenarios**:

1. **Given** a user with Sports Plan access, **When** they view the Sports section, **Then** Hockey and Lacrosse tiles are visible with a lock icon labeled "Sports Pro Only" and an "Upgrade" button.
2. **Given** a Sports Plan user who completes the Sports Pro purchase, **When** payment is processed, **Then** the Sports Pro entitlement is granted immediately, Hockey and Lacrosse tiles unlock, and all sports display in-depth mode options.
3. **Given** a newly Pro-tier user opening the Hockey module, **When** they start a game, **Then** they are prompted to enter team names and roster, and the app provides dedicated buttons for recording goals, assists, penalties, and period changes.
4. **Given** an active hockey game, **When** the user records a goal with an assist, **Then** both the goal-scorer and assist-maker are logged, and the display updates to reflect both contributions.
5. **Given** a Hockey game with recorded penalties, **When** the user views the game summary, **Then** penalty log (player, type, duration) is displayed alongside goals and assists.

---

### Edge Cases

- What happens when a user with 100-game history (Sports Plan limit) records a new game? â†’ **Plan**: App should either alert the user that they must archive/export a game before recording a new one, or automatically prompt to export and clear the oldest game to make room. Pro users have unlimited storage, so this doesn't apply.
- How does the system handle sport-specific data consistency when a user downgrades from Pro to Plan? â†’ **Plan**: Pro-exclusive sports (Hockey, Lacrosse) remain in local storage but are not accessible; in-depth mode games revert to basic view. Upon Pro re-purchase, Pro features are restored for those games.
- What happens if a user plays a game offline and then purchases a tier while offline? â†’ **Plan**: The purchase is pending until connectivity is restored; once online, the entitlement is verified and confirmed. Offline games are already saved locally and continue to be accessible.
- Can a user delete a single game from history? â†’ **Plan**: Yes, users can delete individual games. This is useful for Plan users to clear space for new games.

---

## Requirements *(mandatory)*

### Functional Requirements

#### Monetization & Entitlements

- **FR-001**: System MUST provide two one-time in-app purchase tiers: Sports Plan ($6.99) and Sports Pro Plan ($19.99), each granting lifetime access to purchased features.
- **FR-002**: System MUST verify and restore entitlements on app launch, allowing users who previously purchased to access their tier without re-purchasing.
- **FR-003**: System MUST allow users to hold both Sports Plan and Sports Pro simultaneously; features MUST stack without conflict.
- **FR-004**: System MUST display tier-appropriate UI elements (lock icons, upgrade prompts, feature highlights) on all sport tiles and feature screens.
- **FR-005**: System MUST gracefully handle failed or canceled purchases, returning to Home screen with no partial entitlement state.

#### Core Sport Modules (Both Tiers)

- **FR-006**: System MUST provide Baseball module with full bookkeeping: real-time inning tracking, outs counter (0-3), runs, hits, errors, strikeouts, and auto-calculation of standard batting averages and ERA.
- **FR-007**: System MUST provide Basketball module with real-time quarter/half timer, score tracking, and buttons for 2-Pointer, 3-Pointer, Free Throw quick entry; basic stats (points, FG%, FT%) MUST display at game-end.
- **FR-008**: System MUST provide Football module with real-time quarter timer, score tracking, and down/yardage tracking; basic stats (total yards, TDs) MUST display at game-end.
- **FR-009**: System MUST provide Soccer module with real-time half timer, score tracking, possession indicator toggle, and goal attribution to specific players; basic stats (goals, possession %) MUST display at match-end.
- **FR-010**: System MUST provide Tennis module with score tracking by set and game, tie-break detection, and deuce handling; stats MUST show sets won, games won per set, and match summary.
- **FR-011**: System MUST provide Volleyball module with set tracking, point-by-point scoring, and rally win attribution; stats MUST show points, sets won, and serving/receiving side attribution.

#### In-Depth/Advanced Tracking (Sports Pro Only)

- **FR-012**: System MUST provide in-depth mode for Basketball, Football, and Soccer (available in Sports Pro), enabling player-by-player stat tracking (points, assists, rebounds, passing yards, etc.) beyond basic totals.
- **FR-013**: System MUST provide advanced tracking for Tennis and Volleyball, including shot-type tracking, rally analysis, and player-specific performance metrics.
- **FR-014**: System MUST provide Hockey module (Pro-only) with period tracking (1-3 for regulation, OT, shootout), goal attribution, primary/secondary assists, and penalty logging (type, duration).
- **FR-015**: System MUST provide Lacrosse module (Pro-only) with field position tracking, ground ball counts, clears, and player-specific scoring (goals, ground balls won).

#### Game Save & Storage

- **FR-016**: System MUST save all games locally in offline-first architecture; no cloud sync required for core functionality (optional enhancement).
- **FR-017**: System MUST limit Sports Plan game history to 100 saved games; Pro users have unlimited storage.
- **FR-018**: System MUST provide a game history view listing all saved games with date, teams, final score, and sport type.
- **FR-019**: System MUST allow users to delete individual games from history to manage storage.
- **FR-020**: System MUST allow users to add free-form notes to any game (before, during, or after); notes MUST persist with the game record.

#### Export & Analytics (Sports Pro Only)

- **FR-021**: System MUST provide export functionality for Sports Pro users to download games in PDF format (human-readable game report with scores, stats, timeline).
- **FR-022**: System MUST provide export functionality for Sports Pro users to download games in CSV format (tabular data for spreadsheet analysis and custom processing).
- **FR-023**: System MUST provide export functionality for Sports Pro users to download games in JSON format (complete raw data for data portability and integration).
- **FR-024**: System MUST provide an Advanced Analytics dashboard for Pro users showing season summaries (games played, average scores, trends, efficiency metrics).
- **FR-025**: System MUST allow Pro users to export single or multiple games (bulk export) in one action.

#### User Experience & Performance

- **FR-026**: System MUST ensure score entry requires no more than 3 taps from the active game screen; UI MUST be optimized for large tap targets and one-handed operation.
- **FR-027**: System MUST ensure all screen transitions complete within 300ms on mid-range devices (minimum target: 2-second battery life devices with 2GB+ RAM).
- **FR-028**: System MUST provide a real-time timer display for all timed sports (Basketball, Football, Soccer, Tennis, Volleyball, Hockey) with start/pause/reset controls.
- **FR-029**: System MUST display real-time score updates on screen immediately after user input with no perceptible lag.
- **FR-030**: System MUST handle offline scenarios gracefully; all games MUST be playable offline and synced (if applicable) when connectivity is restored.

### Key Entities

- **Game Session**: Represents a single completed or in-progress game for any sport. Attributes: sport type, team names, date/time, final score, game state (active/paused/complete), local game ID, list of recorded events, game notes.
- **Event**: Represents a single recorded action during a game (score, out, goal, etc.). Attributes: event type (sport-specific), timestamp, player involved (if applicable), points added, event state pre/post.
- **Sport Module**: Encapsulates sport-specific rules, scoring logic, state transitions, and UI. Attributes: sport name, supported game formats, tier requirement (Plan or Pro), tracking modes (basic, in-depth), statistics calculators.
- **User Entitlement**: Tracks user's purchased tiers and access rights. Attributes: Sports Plan purchased (bool), Sports Pro purchased (bool), purchase date, lifetime access flag.
- **Game History**: Persisted collection of saved games for a user. Attributes: list of Game Sessions, storage limit (100 for Plan, unlimited for Pro), archival metadata (export status, deletion timestamp).
- **Export**: Represents a downloadable export of one or more games. Attributes: export format (PDF/CSV/JSON), included games, export timestamp, file metadata.

---

## Success Criteria *(mandatory)*

### Monetization & Conversion

- **SC-001**: At least 30% of free users who discover the Sports Plan unlock/upsell prompt complete a purchase within 7 days of first seeing it.
- **SC-002**: Sports Pro tier achieves a 15% attach rate among Sports Plan users (i.e., 15% of Plan users also purchase Pro within 30 days).
- **SC-003**: Average revenue per paying user (ARPPU) for Sports tiers meets or exceeds $8 within the first 6 months post-launch.

### User Experience & Engagement

- **SC-004**: Users complete a full basketball game (start to finish) in under 10 minutes, with no more than 60 total taps across the entire game session.
- **SC-005**: 95% of recorded scores are entered successfully on the first attempt without error correction or user frustration.
- **SC-006**: Game save/load time for any sport is under 500ms on mid-range devices.
- **SC-007**: At least 80% of users with Sports Plan access play at least one game within 7 days of purchase.

### Feature Adoption & Satisfaction

- **SC-008**: Users who purchase Sports Pro and export games do so at least once per season; export success rate is 99% (minimal failed exports).
- **SC-009**: Advanced Analytics dashboard is accessed by at least 50% of Sports Pro users who have played 5+ games.
- **SC-010**: In-depth tracking modes for Basketball, Football, and Soccer are enabled by at least 40% of Sports Pro users who play those sports.

### Data Accuracy & Reliability

- **SC-011**: All exported game data (PDF, CSV, JSON) matches the source game record with 100% accuracy; no data loss or corruption in export process.
- **SC-012**: Game history persists across app updates and device reboots with no data loss; recovery from failed app sessions is 100% successful.
- **SC-013**: All stats calculations (batting average, ERA, FG%, FT%, possession %, etc.) are verified against sport-specific formulas; accuracy is 99.9%.

### Cross-Platform Consistency

- **SC-014**: Both Sports Plan and Sports Pro features behave identically on iOS and Android; no platform-specific discrepancies in UI, scoring, or data export.
- **SC-015**: Exported game files from iOS are readable and editable on Android devices and desktop; no format incompatibilities.

---

## Pricing Strategy & Positioning

### Price Justification

**Sports Plan ($6.99)**:
- Entry-level real-time scoring for casual users
- Access to 6 core sports (Baseball, Basketball, Football, Soccer, Tennis, Volleyball)
- Lifetime access, no subscriptions
- Local game save with 100-game history limit
- Competitive with popular scorekeeping apps (ESPN ScoreCenter, ESPN Fantasy, etc.)
- Justification: Low barrier to entry, high accessibility, core value proposition

**Sports Pro ($19.99)**:
- Premium tier for serious sports enthusiasts and coaches
- Includes all Sports Plan features plus unlimited storage, in-depth tracking, and exports
- 2 exclusive sports (Hockey, Lacrosse) for tier differentiation
- Advanced Analytics and data export enable coaching insights, record-keeping, and integration
- Premium pricing targets power users and professional contexts (youth coaches, league managers)
- Justification: Significant feature expansion (3x core feature set), unique sports, professional-grade data tools, limited target audience reduces price sensitivity

### Market Positioning

- **Sports Plan** competes with basic free scorekeeping apps and low-cost alternatives (e.g., ESPNScoreCenter free, Yahoo Sports free) by offering better UX, offline-first, and sport-specific modules
- **Sports Pro** targets niche power users and professionals; pricing is comparable to professional sports statistics software (e.g., Synergy Sports $100+/year, but Sports Pro is one-time with offline-first design)
- **Bundle Perception**: Users purchasing both tiers will perceive value at the combined $26.98 cost compared to annual subscriptions ($50-100+/year for professional apps)

### Monetization Model Rationale

- **One-time purchase** (vs. subscription): Aligns with SkorKeeper's core principle of Offline-First, No Account Required. Users own their data and don't pay ongoing fees for offline functionality.
- **Tier separation** (vs. single all-in-one tier): Allows price discrimination: casual users purchase Plan, enthusiasts/professionals purchase Pro, reducing user acquisition friction while capturing higher revenue from power users.
- **No paywall on core free experience**: Free users can use freeform scoring and board games; Sports Tier modules are opt-in purchases. This maximizes lifetime value (free â†’ Plan â†’ Pro progression) without alienating casual users.

---

## Assumptions

- **Target User Profiles**: Sports Plan targets casual sports fans (parents, friends, pickup players) looking for quick scorekeeping. Sports Pro targets serious enthusiasts, coaches, and league organizers.
- **Pricing Acceptance**: Assumes users value lifetime access and offline-first functionality enough to justify one-time payments over free ad-supported alternatives or subscriptions.
- **Sport Coverage Completeness**: Assumes the 6 core sports (Baseball, Basketball, Football, Soccer, Tennis, Volleyball) + 2 Pro-exclusive (Hockey, Lacrosse) cover >85% of intended user base. Other sports can be added post-launch.
- **Game History Limits**: 100-game limit for Sports Plan is assumed sufficient for casual users (>2.5 games/day for a year); Pro unlimited storage addresses power users and seasonal record-keeping.
- **Export Format Popularity**: Assumes PDF, CSV, and JSON are sufficient; other formats (Excel macros, custom integration APIs) are out of scope v1.
- **Cross-Platform Parity**: Assumes iOS and Android builds are maintained in parallel with feature parity; platform-specific code is minimized per SkorKeeper Constitution.
- **Offline-First Architecture**: Assumes all game saves and statistics are computed locally; cloud sync (optional future feature) does not block Sports Tier v1 launch.
- **Performance Targets**: Assumes mid-range devices (2GB+ RAM, 2-3 second battery life typical mobile) as baseline; optimization for budget devices is secondary.
- **No Account Required**: Assumes purchases are tied to device/App Store account (native iOS/Android IAP mechanisms) and do not require user registration or cloud-based entitlements.

