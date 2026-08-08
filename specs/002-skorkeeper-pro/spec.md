# Feature Specification: SkorKeeper Pro — Monetization Layer

**Feature Branch**: `002-skorkeeper-pro`

**Created**: 2026-08-05

**Status**: Draft

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Free User Sees Ads, Core Game Stays Uninterrupted (Priority: P1)

A free user opens SkorKeeper, browses the Home screen, plays a full game of Cribbage, records every score in ≤3 taps per round, finishes the game, dismisses the session summary, and is returned to the Home screen. Throughout the entire play session no ad appears on any active game screen. A single interstitial ad appears exactly once — at the moment of transition from the session-summary dismissal to the Home screen. Banner ads are visible on the Home screen when the user is not in a game.

**Why this priority**: This story validates the foundational contract of the monetization layer — revenue is generated without breaking the core promise of uninterrupted, frictionless score entry. If ads ever appear mid-game, the feature fails entirely.

**Independent Test**: Can be fully tested by starting any game module with a fresh free-tier install, completing a session end-to-end, and confirming no ad appears on the game or score-entry screen; delivers ad-impression revenue validation.

**Acceptance Scenarios**:

1. **Given** a free user on the Home screen with network available, **When** the user views the Home screen, **Then** a banner ad is visible in a designated area that does not overlap or shift any scoring UI.
2. **Given** a free user actively recording scores, **When** any score-entry screen is displayed, **Then** no banner or interstitial ad is visible or loading.
3. **Given** a free user who has just dismissed the session summary, **When** the app transitions to the Home screen, **Then** exactly one interstitial ad is shown before or immediately upon arriving at the Home screen.
4. **Given** a free user who has already seen one interstitial ad in the current app session, **When** the user completes a second game in the same session, **Then** no second interstitial ad is shown for that session.
5. **Given** a free user with no network connection, **When** any ad-eligible screen is displayed, **Then** the banner container collapses gracefully with no error state visible to the user.

---

### User Story 2 — User Purchases SkorKeeper Pro (Priority: P1)

A free user navigates to Settings, taps "Upgrade to Pro," reviews the $3.99 one-time purchase offer, completes the purchase via the platform's native payment sheet, and immediately receives the Pro entitlement. All ads disappear for the remainder of the session and on every subsequent launch. Pro features (additional color themes, custom player colors, unlimited history, CSV export) become accessible immediately.

**Why this priority**: The one-time IAP is the primary revenue engine. The purchase flow must be reliable, fast, and confidence-inspiring, otherwise the entire monetization strategy fails.

**Independent Test**: Can be fully tested on a sandbox/test account by triggering the purchase flow from Settings and confirming entitlement is granted, ads are hidden, and Pro features are accessible — all within a single install.

**Acceptance Scenarios**:

1. **Given** a free user in Settings, **When** the user taps "Upgrade to Pro" and completes payment, **Then** the Pro entitlement is granted immediately without requiring an app restart.
2. **Given** a user who has just purchased Pro, **When** any ad-eligible screen is viewed, **Then** no banner or interstitial ad appears.
3. **Given** a Pro user who uninstalls and reinstalls the app on the same device with the same store account, **When** the user taps "Restore Purchases" in Settings, **Then** the Pro entitlement is restored without a new charge.
4. **Given** a Pro user with no network connection, **When** the app is launched, **Then** the previously cached Pro entitlement is honored and no ads are shown.
5. **Given** a free user who cancels the payment sheet mid-purchase, **When** the sheet is dismissed, **Then** the app returns to Settings with no entitlement change and no error crash.

---

### User Story 3 — Free User Approaches History Limit (Priority: P2)

A free user has accumulated 20 completed game sessions in history. When the user completes their 21st game, the oldest session is removed from local history to maintain the 20-session cap. A non-intrusive prompt or indicator informs the user that upgrading to Pro removes the history limit. The user can dismiss the prompt and continue using the app normally.

**Why this priority**: The history cap is the primary functional constraint distinguishing free from Pro, making it a natural conversion trigger. The UX around hitting the limit must be informative but never hostile.

**Independent Test**: Can be fully tested by seeding 20 sessions in the local store, completing one more game, and verifying the oldest session is pruned and the upgrade prompt appears.

**Acceptance Scenarios**:

1. **Given** a free user with exactly 20 sessions in history, **When** a 21st session is completed, **Then** the oldest session is removed from local history and only 20 sessions remain.
2. **Given** a free user who has just hit the history cap, **When** they view the History screen, **Then** an informational banner or indicator is shown explaining the 20-session limit and offering a path to upgrade.
3. **Given** a free user who dismisses the upgrade prompt, **When** they return to gameplay, **Then** the app resumes normally with no forced interruption.
4. **Given** a Pro user, **When** they view the History screen with more than 20 sessions, **Then** all sessions are visible with no cap applied and no upgrade prompt is shown.

---

### User Story 4 — Pro User Exports Game History to CSV (Priority: P2)

A Pro user navigates to the History screen, selects the export option, and the app generates a CSV file of all recorded game sessions. The platform's native share sheet appears, allowing the user to send the file to any app (email, Files, cloud storage, etc.). The operation works entirely on-device with no account or server required.

**Why this priority**: CSV export is a high-perceived-value Pro feature that differentiates the tier for power users who track stats externally.

**Independent Test**: Can be fully tested by granting Pro entitlement in a test environment, navigating to History, triggering export, and confirming the share sheet opens with a valid CSV file containing all session data.

**Acceptance Scenarios**:

1. **Given** a Pro user on the History screen, **When** the user triggers the export action, **Then** the native share sheet opens with a CSV file containing all recorded sessions.
2. **Given** a free user on the History screen, **When** the export action is presented, **Then** the action is either hidden or disabled with an indication that it requires Pro.
3. **Given** a Pro user with zero sessions in history, **When** the user triggers export, **Then** the share sheet opens with a CSV file containing only the header row (no error or crash).

---

### User Story 5 — Pro User Customizes Player Colors and Themes (Priority: P3)

A Pro user opens the settings for any game module and assigns a custom color to each player. The selected colors persist across sessions for that module. The Pro user also has access to the Prince Purple palette and any future color themes, while free users see only the default theme.

**Why this priority**: Visual customization is a delightful differentiator that reinforces the value of Pro without impacting core functionality.

**Independent Test**: Can be tested by granting Pro entitlement, opening a game module's settings, assigning a custom player color, completing a game, and confirming the color is applied and persists on the next session.

**Acceptance Scenarios**:

1. **Given** a Pro user in a game module's player setup, **When** the user selects a custom color for a player, **Then** that color is applied to the player's score display throughout the session and persisted for future sessions in that module.
2. **Given** a free user in a game module's player setup, **When** the user views color options, **Then** custom player color selection is not available (hidden or shown as locked with a Pro upgrade prompt).
3. **Given** a Pro user in the Themes settings, **When** the user views available themes, **Then** the Prince Purple palette and all other themes are selectable and applied immediately.
4. **Given** a free user in the Themes settings, **When** the user views available themes, **Then** only the default theme is available; premium themes are visible but locked with an upgrade prompt.

---

### User Story 6 — Rewarded Ad Grants Temporary Theme Unlock (Priority: P3)

A free user on the Themes settings screen sees a "Watch to unlock for 24 hours" option next to a premium theme. The user taps it, watches a rewarded video ad to completion, and the selected theme is unlocked for 24 hours. After the 24-hour window expires, the theme reverts to locked. The option is hidden entirely when the device is offline.

**Why this priority**: Rewarded ads are Phase 2 and optional, but they provide the highest CPM format and a natural funnel toward Pro conversion.

**Independent Test**: Can be tested by presenting a rewarded ad in a test environment, confirming the theme is unlocked for 24 hours on the device clock, and confirming it reverts after expiry.

**Acceptance Scenarios**:

1. **Given** a free user online on the Themes screen, **When** the user taps "Watch to unlock" and completes the rewarded ad, **Then** the selected premium theme is unlocked for exactly 24 hours from the time of completion.
2. **Given** a free user with a 24-hour unlock active, **When** the unlock window expires, **Then** the theme reverts to locked and the default theme is reapplied.
3. **Given** a free user with no network connection on the Themes screen, **When** the user views premium themes, **Then** the "Watch to unlock" option is hidden entirely (no error, no spinner).
4. **Given** a Pro user on the Themes screen, **When** the user views premium themes, **Then** no rewarded ad option is shown; all themes are unlocked permanently.

---

### Edge Cases

- What happens when a purchase is interrupted mid-flow due to network loss? The purchase must not be partially applied; the app must recover cleanly on next launch by re-querying entitlements.
- What happens when a user restores purchases on a device with no previous purchases? The "Restore Purchases" action completes silently with no entitlement change and shows a neutral confirmation (e.g., "No purchases found for this account").
- What happens when an interstitial ad fails to load before the session-end transition? The transition to the Home screen proceeds immediately without waiting; no error is shown.
- What happens when a Pro user's store account logs out mid-session? The cached entitlement continues to be honored until the next entitlement refresh; the user is not unexpectedly downgraded mid-session.
- What happens when the 24-hour theme unlock is active and the user purchases Pro? The permanent Pro entitlement supersedes the temporary unlock; no conflict occurs.
- What happens when a free user has exactly 20 sessions and deletes one manually, then completes a new game? History stays at 20 sessions (cap is a ceiling, not a forced 20-session floor).
- What happens if the AdMob SDK returns an error on a banner ad? The banner container collapses to zero height; no placeholder or error message is visible.

---

## Requirements *(mandatory)*

### Functional Requirements

#### Entitlement & Purchasing

- **FR-001**: The app MUST offer a single non-consumable in-app purchase ("SkorKeeper Pro") priced at $3.99 USD via the platform's native billing system.
- **FR-002**: The Pro entitlement MUST be granted immediately upon successful purchase completion without requiring an app restart.
- **FR-003**: The Settings screen MUST include a "Restore Purchases" action that re-validates and reinstates a previously purchased Pro entitlement linked to the user's store account.
- **FR-004**: The Pro entitlement MUST be honored offline after at least one successful online verification; no network connection is required for subsequent launches.
- **FR-005**: No SkorKeeper account creation, login, or registration MUST ever be required to complete a purchase, restore a purchase, or use any feature.
- **FR-006**: The entitlement state MUST be queryable synchronously from local cache on app launch to determine ad and feature visibility before the first screen renders.

#### Advertising — Banner Ads (Free Tier)

- **FR-007**: Banner ads MUST appear on the Home screen, History screen, and Settings screen only.
- **FR-008**: Banner ads MUST NOT appear on any active game screen, score-entry screen, or game-setup screen.
- **FR-009**: Banner ad containers MUST collapse to zero height when the device is offline or when an ad fails to load; no error state, spinner, or placeholder MUST be visible.
- **FR-010**: Pro users MUST see zero banner ads on all screens.

#### Advertising — Interstitial Ads (Free Tier)

- **FR-011**: One interstitial ad per app session MAY be shown to free users only at the transition from session-summary dismissal to the Home screen.
- **FR-012**: Interstitial ads MUST NOT be shown during active gameplay, score entry, game setup, or any screen other than the single approved transition point.
- **FR-013**: If an interstitial ad has already been shown in the current app session, no additional interstitial ads MUST be shown for the remainder of that session.
- **FR-014**: If an interstitial ad fails to load, the navigation transition to the Home screen MUST proceed immediately without delay.
- **FR-015**: Pro users MUST never be shown an interstitial ad.

#### Advertising — Rewarded Ads (Phase 2)

- **FR-016**: A "Watch to unlock for 24 hours" option MUST be displayed on the Themes screen next to each premium theme, but ONLY when a network connection is available.
- **FR-017**: Upon successful completion of a rewarded video ad, the selected premium theme MUST be unlocked for exactly 24 hours from the time of completion.
- **FR-018**: After the 24-hour temporary unlock expires, the theme MUST revert to a locked state and the default theme MUST be reapplied if the temporary theme was active.
- **FR-019**: The rewarded ad option MUST be hidden entirely when the device is offline; no error, disabled button, or spinner MUST be shown.
- **FR-020**: Pro users MUST NOT see rewarded ad options; all themes are permanently unlocked for Pro users.

#### Pro Features

- **FR-021**: Free users MUST have access to the last 20 completed game sessions in history; sessions beyond this cap MUST be pruned oldest-first.
- **FR-022**: Pro users MUST have unlimited game history with no pruning of completed sessions.
- **FR-023**: When a free user completes a game that causes history to exceed 20 sessions, the app MUST display a non-blocking informational prompt indicating the cap has been reached and offering an upgrade path.
- **FR-024**: Pro users MUST be able to export all game history as a CSV file via the platform's native share sheet, entirely on-device.
- **FR-025**: Free users MUST NOT have access to the CSV export feature; the export option MUST be hidden or visibly locked with a Pro upgrade indication.
- **FR-026**: Pro users MUST have access to all color themes including the Prince Purple palette and any themes added in future updates.
- **FR-027**: Free users MUST be limited to the default color theme; premium themes MUST be visible but locked with a Pro upgrade indication.
- **FR-028**: Pro users MUST be able to assign a custom color to each player within any game module; the selected color MUST persist across sessions for that module.
- **FR-029**: Free users MUST NOT have access to custom player colors; the option MUST be hidden or locked with a Pro upgrade indication.

#### Core Preservation Constraints

- **FR-030**: All 10 game modules and all 9 tools MUST remain fully functional for free users; no scoring feature, game rule, or in-game tool MUST be gated behind Pro.
- **FR-031**: The ≤3-tap score entry path from the active game screen MUST not be modified, overlaid, or interrupted by any monetization UI element.
- **FR-032**: All monetization features (ads, entitlement checks, purchase flows) MUST degrade gracefully offline; no monetization-related failure MUST prevent the user from completing a game session.

### Key Entities

- **Entitlement**: Represents whether a user holds the Pro tier. Attributes: tier (free | pro), source (purchase | restore | cache), last-verified timestamp, offline-valid flag. No PII is stored; the entitlement is tied to the platform store account.
- **AdPlacement**: Represents a configured ad slot. Attributes: placement type (banner | interstitial | rewarded), screen assignment, visibility rule (free-only), collapse behavior on failure.
- **GameSession** *(existing)*: Extended with a `exportable` flag and subject to the 20-session free-tier history cap. The cap is enforced at write time; sessions are pruned oldest-first.
- **ThemeUnlock**: Represents a temporary 24-hour rewarded-ad unlock. Attributes: theme ID, unlock timestamp, expiry timestamp, active flag. Stored locally on-device.
- **PurchaseRecord**: A local receipt of a completed or restored purchase used for offline entitlement caching. Contains no payment card data; stores only store transaction identifiers and grant timestamp.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Free users complete a full game session without encountering any ad on an active game or score-entry screen — validated in 100% of tested flows.
- **SC-002**: A Pro purchase is granted and reflected in the UI within 5 seconds of the platform confirming payment success.
- **SC-003**: A previously purchased Pro entitlement is restored within 10 seconds of tapping "Restore Purchases" when online.
- **SC-004**: A cached Pro entitlement is honored and ads are suppressed within 1 second of app launch without a network request.
- **SC-005**: The CSV export of a 100-session history is generated and the share sheet opens within 3 seconds on a mid-range device.
- **SC-006**: The banner ad container collapses within 500 milliseconds of an ad-load failure or offline detection, with no visible layout shift on score-display elements.
- **SC-007**: The interstitial ad is shown at most once per app session in 100% of tested free-tier flows; no second interstitial appears regardless of how many games are completed.
- **SC-008**: The 24-hour rewarded theme unlock is accurate to within 60 seconds of the stated expiry across device restarts and time-zone changes.
- **SC-009**: No monetization-related failure (ad SDK error, entitlement fetch timeout, purchase cancellation) produces a crash or prevents the user from recording a score — validated across all 10 game modules.
- **SC-010**: The ≤3-tap score entry path remains unmodified and achievable in exactly the same number of taps before and after the monetization layer is introduced — verified by regression test across all modules.

---

## Assumptions

- The app has already shipped or is near-shipping, with all 10 game modules and 9 tools implemented and tested. Monetization is being layered onto an existing, stable codebase.
- RevenueCat's `purchases_flutter` SDK is used for entitlement management; the free tier (up to $2,500 MRR) is sufficient for launch. Direct StoreKit 2 / Google Play Billing integration is not required initially.
- `google_mobile_ads` (AdMob) is the ad provider for both banner and interstitial formats. A valid AdMob account with approved app IDs is available before implementation begins.
- Rewarded ads (Phase 2) use the same AdMob SDK already installed for Layer 2; no additional SDK is required.
- The $3.99 USD price point is fixed for launch; regional pricing tiers (e.g., lower prices in emerging markets) are out of scope for v1 but may be configured via the App Store Connect / Play Console pricing matrix without code changes.
- "Session" for the interstitial ad frequency cap is defined as the period from app foreground to app background/termination; a new session begins each time the app is brought to the foreground after being fully backgrounded for more than 30 minutes.
- Free-tier history pruning (20-session cap) applies only to completed game sessions; in-progress or paused sessions are not counted toward the cap.
- The Prince Purple theme already exists in the design system; implementing it as a locked Pro theme requires only an entitlement gate, not new design work.
- CSV export format: one row per completed game session with columns for date, game type, player names, final scores, and winner. Detailed per-round score breakdowns are out of scope for v1.
- The "Upgrade to Pro" entry point in Settings is the primary purchase surface; additional contextual upgrade prompts (e.g., from locked theme cells) are desirable but their exact placement and copy are left to the UX design phase.
- INTERNET permission is not currently declared in the Android manifest; it must be added as part of this feature. iOS does not require an explicit permission for outbound network access.
- Both platform AdMob App IDs must be embedded in the respective platform manifests before any ad SDK calls are made; absent IDs cause a runtime crash on launch.
- Compliance with App Store Review Guidelines (Section 3.1.1 for IAP) and Google Play Monetization policy is assumed to be validated by the developer before submission; this spec does not cover legal or policy review.
