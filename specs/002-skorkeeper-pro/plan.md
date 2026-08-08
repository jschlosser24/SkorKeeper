# Implementation Plan: SkorKeeper Pro — Monetization Layer

**Branch**: `002-skorkeeper-pro` | **Date**: 2026-08-05 | **Spec**: [`spec.md`](./spec.md)

**Input**: Feature specification from `specs/002-skorkeeper-pro/spec.md`

---

## Summary

SkorKeeper Pro layers a complete monetization system onto the existing SkorKeeper app without touching any game module logic. The feature adds:

- **One-time IAP** ("SkorKeeper Pro", $3.99 USD) via RevenueCat, granting permanent ad-free status and Pro features.
- **Banner + interstitial ads** via Google AdMob for free users, with strict placement rules that keep game screens 100% ad-free.
- **8 color themes** (1 free: Midnight Wolves; 7 Pro: Purple Reign, Sunset Blitz, Arctic Fox, Neon Jungle, Royal Crimson, Ocean Deep, Golden Hour 🏆), with a live theme-preview tap interaction and full light/dark ColorScheme per theme.
- **8 sound packs** (1 free: Classic; 7 Pro: Arcade, Nature, Jazz, Minimal, Epic, Neon, Sports), matching the theme count for a symmetric marketing story.
- **Unlimited history** and **CSV export** (with game-type filtering) for Pro users; free users are capped at 20 sessions pruned oldest-first.
- **History sorting** controls (date, game type, duration).
- **Default player colors** stored in `UserPreferences` and carried through to game sessions.
- **Themed dice** — the dice widget uses the active theme's color scheme instead of hard-coded colors.
- **Tip Jar** — voluntary consumable IAP at $0.99 / $2.99 / $4.99 with no feature gates.
- **Pro Active info sheet** — tapping the "Pro Active" tile in Settings opens a sheet listing all Pro benefits.
- **FAQ screen** — moved from inline Settings section to a dedicated `/settings/faq` route.

All game modules and tools remain fully functional for free users. The ≤3-tap score entry path is unmodified.

---

## Technical Context

**Language/Version**: Dart 3.x (null-safe) via Flutter SDK 3.22+

**New Dependencies**:

| Package | Version | Purpose |
|---|---|---|
| `purchases_flutter` | `^8.0.0` | RevenueCat IAP + entitlement management |
| `google_mobile_ads` | `^5.2.0` | AdMob banner, interstitial, rewarded ads |
| `connectivity_plus` | `^6.1.3` | Ad banner offline collapse detection |
| `app_tracking_transparency` | `^6.0.1` | iOS ATT permission prompt |

**Platform Changes**:

- **Android** `AndroidManifest.xml`: Added `INTERNET` permission, AdMob App ID meta-data.
- **iOS** `Info.plist`: Added `GADApplicationIdentifier`, `SKAdNetworkItems`, `NSUserTrackingUsageDescription`.

**No new Drift tables.** Entitlement state is owned by RevenueCat's local cache. History cap enforcement is implemented at write time in the existing `HistoryDao`. Theme and sound-pack selection uses existing `shared_preferences` keys. No schema migration was required.

**Existing Dependencies Used**:
- `flutter_riverpod` — `ProStateNotifier` (keepAlive) managing entitlement state app-wide.
- `shared_preferences` — `selectedThemeId` and `defaultPlayerColors` keys added.
- `go_router` — `/settings/themes` and `/settings/faq` routes added.
- `connectivity_plus` — `MonetizedBanner` subscribes to connectivity stream.

---

## Constitution Check

*GATE: Must pass before implementation.*

| Principle | Status | Evidence |
|-----------|--------|----------|
| **I. Cross-Platform First** | ✅ PASS | `purchases_flutter` and `google_mobile_ads` both target iOS and Android. Platform-specific ATT request (`app_tracking_transparency`) is guarded by `Platform.isIOS` in `AdService` — no iOS-only crash path on Android. |
| **II. Game-Agnostic Modular Scoring Engine** | ✅ PASS | Zero changes to any `GameModule` implementation, `GameModuleRegistry`, or scoring logic. The monetization layer is entirely in `lib/core/monetization/` and `lib/features/settings/`. |
| **III. Offline-First, No Account Required** | ✅ PASS | RevenueCat caches the entitlement locally (FR-004). `AdService` and `PurchaseService` are initialized non-fatally at startup — failures are swallowed and the app continues fully functional offline. No SkorKeeper account required (FR-005). Tip Jar uses the same store account as Pro — no new account type. |
| **IV. Speed & Minimal Friction** | ✅ PASS | Entitlement query is synchronous from cache (FR-006) — no launch delay. `MonetizedBanner` collapses within 500 ms on offline detection (SC-006). The ≤3-tap score entry path is not modified (FR-031, SC-010). Interstitial is pre-loaded; navigation to Home proceeds immediately if load fails (FR-014). |
| **V. Extensibility & Simplicity** | ✅ PASS | Adding a 9th theme = one `AppThemeDefinition` entry in `theme_catalog.dart`. Adding a 9th sound pack = one `SoundPackDefinition` entry + asset subdirectory. Pro features are gated by `ref.watch(proStateProvider).isPro` — a single boolean; no scattered conditionals in game logic. |
| **No Unnecessary Permissions** | ✅ PASS | `INTERNET` permission is now required and declared (AdMob + RevenueCat). ATT (`NSUserTrackingUsageDescription`) is iOS-only, shown once at first launch, required by Apple policy. No new sensitive permissions (camera, location, contacts). |
| **Accessible by Default** | ✅ PASS | Purple Reign contrast fix (`secondaryContainer` / `onSecondaryContainer`) resolved a WCAG AA failure. All 8 themes pass WCAG AA at their primary/onPrimary color pairs. `MonetizedBanner` collapses to zero height (no empty accessible region). |

**Gate result: ALL PASS — no violations.** ✅

---

## Project Structure

### New Files (`lib/core/monetization/`)

```text
lib/core/monetization/
├── app_theme_id.dart          # enum AppThemeId { midnightWolves, purpleReign, ... }
├── theme_definition.dart      # AppThemeDefinition data class
├── theme_catalog.dart         # ThemeCatalog.all — 8 full light+dark ColorScheme definitions
├── sound_pack_catalog.dart    # SoundPacks.all — 8 SoundPackDefinition entries
├── purchase_service.dart      # PurchaseKeys, PurchaseService (configure, isProUnlocked, purchasePro, restorePurchases, tip product IDs)
├── ad_service.dart            # AdService.instance singleton (initialize, createBannerAd, loadInterstitial, ATT)
└── monetized_banner.dart      # MonetizedBanner widget (auto-collapses for Pro + offline)
```

### New Files (`lib/core/providers/`)

```text
lib/core/providers/
└── pro_state_provider.dart    # @Riverpod(keepAlive: true) ProStateNotifier
```

### New Files (`lib/features/settings/`)

```text
lib/features/settings/
├── pro_purchase_sheet.dart    # showProPurchaseSheet() bottom sheet (benefit list, Buy, Restore)
├── tip_jar_sheet.dart         # showTipJarSheet() bottom sheet ($0.99 / $2.99 / $4.99 tiers)
├── theme_picker_screen.dart   # ThemePickerScreen (grid, lock overlays, live preview, Pro upsell)
└── faq_screen.dart            # Dedicated FAQ screen (moved from Settings inline section)
```

### Modified Files

```text
lib/main.dart                                        # PurchaseService.configure() + AdService.initialize() at startup
lib/ui/theme/app_theme.dart                          # Parameterized: AppTheme.light/dark(AppThemeDefinition?)
lib/ui/theme/color_tokens.dart                       # Added princePrimary, princeViolet constants
lib/core/models/user_preferences.dart               # Added selectedThemeId (String), defaultPlayerColors (List<String>)
lib/core/providers/preferences_provider.dart        # Added updateSelectedTheme(), updateDefaultPlayerColors()
lib/core/providers/prefs_keys.dart                  # Added selectedThemeId, defaultPlayerColors keys
lib/core/router/app_router.dart                     # Added /settings/themes and /settings/faq routes
lib/features/settings/settings_screen.dart          # Pro section, Color Theme tile, Tip Jar, FAQ route, default player colors
lib/features/history/history_list_screen.dart       # Sort controls, CSV export (Pro-gated)
lib/features/home/presentation/home_screen.dart     # MonetizedBanner added
lib/features/tools/tools_screen.dart                # MonetizedBanner added
lib/features/shared_session/session_summary_screen.dart  # Interstitial trigger on dismissal
lib/features/tools/dice/dice_roller_screen.dart     # Dice widget uses active theme colors
android/app/src/main/AndroidManifest.xml            # INTERNET permission, AdMob App ID
ios/Runner/Info.plist                               # GADApplicationIdentifier, SKAdNetworkItems, NSUserTrackingUsageDescription
pubspec.yaml                                        # 4 new dependencies
```

---

## Phased Implementation Approach

### Phase 1: Monetization Infrastructure

**Purpose**: All packages installed, platform manifests configured, `PurchaseService` and `AdService` wired up, `ProStateNotifier` available app-wide. No UI yet — but the entitlement signal and ad SDK are live and testable.

**Outputs**: `pubspec.yaml` updated, `AndroidManifest.xml` updated, `Info.plist` updated, `purchase_service.dart`, `ad_service.dart`, `pro_state_provider.dart`, `main.dart` updated.

**Checkpoint**: `flutter analyze` passes. `PurchaseService.configure()` and `AdService.instance.initialize()` complete without crash. `ProStateNotifier` returns `isPro = false` for a fresh install.

---

### Phase 2: Theme System

**Purpose**: All 8 themes defined, `AppTheme` refactored to accept an `AppThemeDefinition`, `UserPreferences` extended with `selectedThemeId`, preferences provider updated, router updated with `/settings/themes` route.

**Outputs**: `app_theme_id.dart`, `theme_definition.dart`, `theme_catalog.dart`, `app_theme.dart` updated, `color_tokens.dart` updated, `user_preferences.dart` updated, `preferences_provider.dart` updated, `prefs_keys.dart` updated, `app_router.dart` updated.

**Checkpoint**: App builds and runs with Midnight Wolves theme by default. All 8 `ThemeData` light+dark pairs render without assertion errors.

---

### Phase 3: Ad Integration

**Purpose**: `MonetizedBanner` widget built and placed on Home, History, Settings, and Tools screens. Interstitial ad pre-loaded and triggered once on session-summary dismissal for free users.

**Outputs**: `monetized_banner.dart`, `home_screen.dart` updated, `tools_screen.dart` updated, `session_summary_screen.dart` updated.

**Checkpoint**: Free user sees banner on Home and Tools screens. Banner collapses immediately when airplane mode is enabled. One interstitial appears at session-summary dismissal; a second game completion in the same session does not trigger a second interstitial. Pro user sees no banner and no interstitial.

---

### Phase 4: Purchase & Settings UI

**Purpose**: All purchase-related UI built: Pro purchase bottom sheet, Theme Picker screen (with live preview), Tip Jar sheet, FAQ dedicated screen, Settings screen updated with all new tiles.

**Outputs**: `pro_purchase_sheet.dart`, `theme_picker_screen.dart`, `tip_jar_sheet.dart`, `faq_screen.dart`, `settings_screen.dart` updated.

**Checkpoint**: Free user taps "Upgrade to Pro" → purchase sheet opens with benefit list. Theme Picker shows locked themes with lock overlay and "Watch to preview" option. Tip Jar shows 3 tiers. FAQ opens as a standalone screen.

---

### Phase 5: Pro Features

**Purpose**: History cap (20 sessions, prune oldest at write time), CSV export with game-type filtering, history sorting controls, default player colors in preferences and carried through to session setup.

**Outputs**: `history_dao.dart` updated (cap enforcement), `history_list_screen.dart` updated (sort + export), `preferences_provider.dart` updated (defaultPlayerColors), `settings_screen.dart` updated (default colors alongside names).

**Checkpoint**: Free user's 21st session causes oldest to be pruned. Pro user exports CSV; share sheet opens with valid file. History list sorts by date/game type/duration. Default player colors appear pre-filled in session setup.

---

### Phase 6: Sound Pack System

**Purpose**: `SoundPackDefinition` data class and `SoundPacks.all` catalog created. Sound pack picker added to Settings. Active pack ID persisted in `shared_preferences`. Audio service loads the correct asset subdirectory.

**Outputs**: `sound_pack_catalog.dart`, `settings_screen.dart` updated (sound pack picker tile), audio service updated (pack-aware asset path resolution).

**Checkpoint**: Classic pack plays on a fresh install. Pro user changes to Arcade pack; sounds update immediately. Free user cannot select Pro packs (shown locked with upgrade prompt).

---

### Phase 7: Post-Spec Fixes and Additions

**Purpose**: Purple Reign contrast fix, Pro Active info sheet, theme live preview in Theme Picker, themed dice widget.

**Outputs**: `theme_catalog.dart` updated (corrected Purple Reign `secondaryContainer` / `onSecondaryContainer`), `settings_screen.dart` updated (Pro Active tile opens info sheet), `theme_picker_screen.dart` updated (live preview tap), `dice_roller_screen.dart` updated (theme-aware colors).

**Checkpoint**: Purple Reign radio buttons are readable in both light and dark mode. Tapping "Pro Active" shows benefit list. Tapping a locked theme card in the picker temporarily applies the theme. Dice faces use the active theme's accent color.

---

## Key Design Decisions

### Offline Entitlement Caching

RevenueCat's SDK persists the last verified entitlement to its own SQLite store. `ProStateNotifier.build()` calls `Purchases.getCustomerInfo()` which returns the cached value synchronously if offline. This means the app never shows ads to a Pro user on a device with no network, even on first launch after a reinstall, provided the SDK cache is populated from a prior online session.

### ATT on iOS — One-Shot Request at First Launch

`AdService.initialize()` in `main.dart` calls `AppTrackingTransparency.requestTrackingAuthorization()` before `MobileAds.instance.initialize()`. This ensures the ATT prompt fires before any ad network makes a tracking call. The ATT result is not stored by the app — AdMob reads the system authorization state directly. Users who deny tracking still receive ads; only personalized ad targeting is disabled.

### Session Interstitial Frequency Cap

`AdService.instance` holds a single `bool _interstitialShownThisSession` flag initialized to `false` at app start. `SessionSummaryScreen` calls `AdService.instance.showInterstitialIfEligible()`, which checks `isPro` and `_interstitialShownThisSession` before showing. The flag is set to `true` after the first show and never reset until the process is killed. This satisfies FR-013 with no persistence layer and no risk of double-firing.

### History Cap Enforcement at Write Time

The 20-session cap is enforced in `HistoryDao.insertHistoryRecord()` immediately after the insert, not as a periodic cleanup job. After inserting the new record the DAO queries the total free-tier session count; if it exceeds 20, it deletes the oldest `(count - 20)` records by `played_at ASC`. This avoids a background pruning task and ensures the cap is always respected exactly at the moment a session is written.

### Theme Live Preview — Ephemeral `shared_preferences` Key

The Theme Picker's "tap to preview" interaction writes a temporary `selectedThemeId` to `shared_preferences` and immediately notifies `PreferencesNotifier`. The preview is undone by either confirming (making it permanent) or tapping outside the card (restoring the previous value). This approach reuses the existing theme-switching path without introducing a separate ephemeral state layer.
