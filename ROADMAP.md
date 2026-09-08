# SkorKeeper — Post-Launch Feature Roadmap

**Purpose**: Track planned features and enhancements across all specs that are deferred from their initial launch or identified during development. Each item includes the originating feature, scope, business value, and implementation status.

**How to Use**:
- Any spec can contribute items here for features deferred from v1.
- Mark items as **PLANNED** (not yet started), **IN_PROGRESS** (actively being built), or **SHIPPED** (deployed to production).
- Link to the originating spec and GitHub issue/PR for traceability.
- Update this file when a feature ships or its status changes.
- Reference this roadmap during planning to prevent scope creep into current sprints.

---

## How to Add Items

When deferring a feature from a spec, add an entry here using this template:

```markdown
### [Feature Name]

**Origin**: `specs/XXX-feature-name`
**Status**: PLANNED
**Scope**: One sentence describing what this adds.
**Details**: Bullet list of specifics.
**Business Value**: Why this matters.
**Estimated Effort**: Small / Medium / High / Very High (story points if known).
**Blocked By**: None, or list of prerequisites.
**GitHub Issue**: [Placeholder: Link when created]
```

---

## How to Close Out Items

When a feature moves to SHIPPED:

1. Update status from PLANNED/IN_PROGRESS → SHIPPED.
2. Add shipped date and version number.
3. Link to the corresponding GitHub release or PR.

**Example**:
```markdown
**Status**: SHIPPED (v1.2.0, released 2026-09-15)
**GitHub Release**: [v1.2.0](link)
```

---

## Active Roadmap Items

### Football — Enhanced Tracking

**Origin**: `specs/003-sports-tracking-tier`
**Status**: PLANNED

**Scope**: Extend Football module with turnover tracking, penalty flags, and detailed field position.

**Details**:
- Turnover events: Interception, Fumble (recovered by offense/defense, touchdown).
- Penalty tracking: Holding, False Start, Offsides, Pass Interference, etc. with yard impact.
- Field position memory: Track yard-line and momentum for each team.
- Stats expansion: Turnover ratio, penalty yards, time of possession.

**Business Value**: Attracts serious football fans and fantasy football crossover users; increases time-in-app.

**Estimated Effort**: Medium (15–20 story points).

**Blocked By**: None. Can begin post-v1 sports launch.

**GitHub Issue**: [Placeholder: Link when created]

---

### Multi-Sport Tournament Brackets

**Origin**: `specs/003-sports-tracking-tier`
**Status**: PLANNED

**Scope**: Support tournament play across all sports (Basketball, Baseball, Soccer, Football, etc.).

**Details**:
- Tournament types: Single elimination, double elimination, round-robin.
- Automatic advancement: Winners automatically advance; losers drop to consolation if applicable.
- Bracket visualization: Display current and upcoming matchups.
- Stats aggregation: Track individual player/team performance across games.

**Business Value**: Increases engagement for group play (local leagues, friend groups); strong retention driver. Enables social sharing of brackets.

**Estimated Effort**: High (25–30 story points).

**Blocked By**: Individual game tracking (Sports Tier v1).

**GitHub Issue**: [Placeholder: Link when created]

---

### League Leaderboards & Season Tracking

**Origin**: `specs/003-sports-tracking-tier`
**Status**: PLANNED

**Scope**: Track season-long performance across multiple games for players and teams.

**Details**:
- Season management: Create, join, manage league seasons.
- Leaderboard display: Win-loss record, point differential, individual player stats.
- Standings: Auto-calculate based on game results.
- Award tracking: MVP, most improved, leading scorer, etc.

**Business Value**: Strong retention and engagement multiplier; social/competitive element drives daily active users.

**Estimated Effort**: High (20–25 story points).

**Blocked By**: Tournament Brackets (recommended to ship before full league management).

**GitHub Issue**: [Placeholder: Link when created]

---

### Real-Time Cloud Sync & Multi-Device Play

**Origin**: `specs/003-sports-tracking-tier`
**Status**: PLANNED

**Scope**: Synchronize game state across devices and enable co-scoring (one person tracks on tablet, another on phone).

**Details**:
- Cloud backup: Game history synced to backend after each game.
- Session linking: Scorekeepers on different devices can join the same live game.
- Conflict resolution: Last-write-wins or conflict UI if simultaneous score updates occur.

**Business Value**: Enables remote coaching use cases; increases accessibility for larger groups.

**Estimated Effort**: High (30+ story points, requires backend infrastructure).

**Blocked By**: Individual game tracking (Sports Tier v1).

**Note**: Offline-first architecture from v1 should facilitate this; avoid adding sync logic to core game modules until this feature is greenlit.

**GitHub Issue**: [Placeholder: Link when created]

---

### Player Management & Reusable Rosters

**Origin**: `specs/003-sports-tracking-tier`
**Status**: PLANNED

**Scope**: Allow users to save player profiles, create reusable rosters, and track individual player stats across seasons.

**Details**:
- Player profiles: Name, number, position, cumulative stats view.
- Roster templates: Save a roster (e.g., "Team A 2026 Season") and reuse across games.
- Career stats: Track a player's performance across all games.

**Business Value**: Simplifies repeated game setup; increases data richness for coaches and league admins.

**Estimated Effort**: Medium (12–18 story points).

**Blocked By**: None. Can be implemented independently post-v1.

**GitHub Issue**: [Placeholder: Link when created]

---

### Live Commentary & Timestamped Game Notes

**Origin**: `specs/003-sports-tracking-tier`
**Status**: PLANNED

**Scope**: Allow scorekeepers to add text/voice notes during live play, tied to the game clock.

**Details**:
- Free-form notes: "Great defensive play by #5", "Coach called timeout", etc.
- Timestamped: Notes tied to game clock for in-context playback.
- Export/share: Notes included in game summary and shareable exports.

**Business Value**: Enriches game records; enables storytelling beyond raw stats; drives social sharing.

**Estimated Effort**: Small (8–12 story points).

**Blocked By**: None. Can be added post-v1.

**GitHub Issue**: [Placeholder: Link when created]

---

### Mobile Push Notifications & Game Reminders

**Origin**: `specs/003-sports-tracking-tier`
**Status**: PLANNED

**Scope**: Notify users of upcoming games, team announcements, or league milestones.

**Details**:
- Reminder notifications: "Game starts in 1 hour" (for scheduled games).
- League updates: "Tournament bracket finalized," "New player joined your league."
- Leaderboard milestones: "You're now #1 in the league!"

**Business Value**: Increases engagement and daily active user return rate.

**Estimated Effort**: Small (6–10 story points, assumes backend notification system exists).

**Blocked By**: Cloud Sync (recommended; avoids silent notifications without cloud context).

**GitHub Issue**: [Placeholder: Link when created]

---

### Export & Share (Image, Video)

**Origin**: `specs/003-sports-tracking-tier`
**Status**: PLANNED

**Scope**: Export game summaries to shareable image and video formats (PDF/CSV/JSON export already included in Sports Pro v1).

**Details**:
- Image export: Social-media ready stat card (e.g., "Final: Team A 72 vs Team B 68").
- Video export: Animated highlight reel with score graphic overlays.

**Business Value**: Drives social sharing and word-of-mouth marketing.

**Estimated Effort**: Medium–High (image: 10–15 story points; video: 20+ story points).

**Blocked By**: None for image. Video may require cloud processing.

**GitHub Issue**: [Placeholder: Link when created]

---

## Prioritization Guidance

**High Value, Lower Effort** (Consider sooner):
- Player Management & Reusable Rosters
- Live Commentary & Timestamped Game Notes

**High Value, Higher Effort** (Plan for mid-term):
- Tournament Brackets
- League Leaderboards & Season Tracking
- Export & Share (Image, Video)

**Strategic / Infrastructure** (Plan for long-term or contingent on business goals):
- Real-Time Cloud Sync & Multi-Device Play
- Mobile Push Notifications
- Football Enhanced Tracking

---

## Shipped Features

*Nothing shipped yet. Items will be moved here as they are released.*
