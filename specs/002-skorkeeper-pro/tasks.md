# Tasks: SkorKeeper Pro — Monetization Layer

**Feature Branch**: `002-skorkeeper-pro`
**Input**: `specs/002-skorkeeper-pro/` — spec.md, plan.md, data-model.md, research.md, quickstart.md
**Constitution**: `.specify/memory/constitution.md` — Cross-platform, game-agnostic modules, offline-first, speed, extensibility

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Parallelizable (operates on different files, no dependency on a sibling in-progress task)
- **[US#]**: User story label mapping to spec.md priorities (US1–US6)
- All file paths are relative to the Flutter project root (`SkorKeeper/`)
- All tasks are retroactively marked `[x]` (completed)

---

## Phase 1: Monetization Infrastructure

**Purpose**: Add all new packages and platform configuration, implement `PurchaseService` and `AdService`, wire `ProStateNotifier` into the provider graph, and initialize both services non-fatally at app startup. No UI — just the foundational signal that all later phases depend on.

- [x] T001 [P] Add `purchases_flutter: ^8.0.0`, `google_mobile_ads: ^5.2.0`, `connectivity_plus: ^6.1.3`, `app_tracking_transparency: ^6.0.1` to `pubspec.yaml` and run `flutter pub get`
- [x] T002 [P] Update `android/app/src/main/AndroidManifest.xml`: add `<uses-permission android:name="android.permission.INTERNET"/>` and `<meta-data android:name="com.google.android.gms.ads.APPLICATION_ID" android:value="..."/>` (AdMob App ID)
- [x] T003 [P] Update `ios/Runner/Info.plist`: add `GADApplicationIdentifier`, `SKAdNetworkItems` array, and `NSUserTrackingUsageDescription` string
- [x] T004 Implement `lib/core/monetization/purchase_service.dart`: define `abstract class PurchaseKeys` with `static const` strings for `entitlementPro`, `androidApiKey`, `iosApiKey`, `tipSmall`, `tipMedium`, `tipLarge`; implement `PurchaseService` with `static Future<void> configure()` (calls `Purchases.setLogLevel` + `Purchases.configure`), `static Future<bool> isProUnlocked()` (queries `CustomerInfo.entitlements`), `static Future<PurchasesStoreProduct?> getProProduct()`, `static Future<void> purchasePro()` (calls `Purchases.purchaseProduct`), `static Future<void> restorePurchases()` (calls `Purchases.restorePurchases`)
- [x] T005 [P] [US2] Implement `lib/core/monetization/ad_service.dart`: `AdService` singleton with `AdService.instance` factory; `Future<void> initialize()` — requests ATT on iOS via `AppTrackingTransparency.requestTrackingAuthorization()` before `MobileAds.instance.initialize()`; `BannerAd createBannerAd(String adUnitId)` — creates `BannerAd` with `AdSize.banner`; `Future<void> loadInterstitial(String adUnitId)` — loads and caches `InterstitialAd`; `Future<void> showInterstitialIfEligible()` — checks `isPro` and `_interstitialShownThisSession` flag before showing; resets flag is not reset until process termination
- [x] T006 [P] [US2] Implement `lib/core/providers/pro_state_provider.dart`: `@Riverpod(keepAlive: true) class ProStateNotifier extends _$ProStateNotifier`; `build()` calls `PurchaseService.isProUnlocked()` and returns `ProState(isPro: bool)`; expose `Future<void> refresh()`, `Future<void> purchasePro()`, `Future<void> restorePurchases()` methods; each mutating method calls `PurchaseService.*` then `ref.invalidateSelf()` to rebuild state
- [x] T007 [US1] [US2] Update `lib/main.dart`: call `PurchaseService.configure()` and `AdService.instance.initialize()` in parallel inside `runApp`'s async setup block; wrap both in `try/catch` (non-fatal — app must launch even if either SDK call fails); ensure `ProviderScope` wraps `MaterialApp.router` after service init

**Checkpoint**: `flutter analyze` passes. Fresh install: `ProStateNotifier` resolves to `isPro = false`. Neither startup service call crashes the app when network is unavailable.

---

## Phase 2: Theme System

**Purpose**: Define all 8 themes as data, refactor `AppTheme` to accept a theme definition, extend `UserPreferences` and the preferences provider with `selectedThemeId`, and add the `/settings/themes` router entry. The app should display Midnight Wolves by default with no visual regression.

- [x] T008 [P] Implement `lib/core/monetization/app_theme_id.dart`: `enum AppThemeId { midnightWolves, purpleReign, sunsetBlitz, arcticFox, neonJungle, royalCrimson, oceanDeep, goldenHour }`; add `extension AppThemeIdX on AppThemeId` with `String get id` (snake_case string for prefs storage) and `static AppThemeId fromId(String id)` factory
- [x] T009 Implement `lib/core/monetization/theme_definition.dart`: plain Dart class `AppThemeDefinition` with final fields `AppThemeId id`, `String name`, `String description`, `String emoji`, `bool isPro`, `ColorScheme lightScheme`, `ColorScheme darkScheme`, `Color previewPrimary`, `Color previewAccent`; `const` constructor; no codegen required
- [x] T010 [P] Update `lib/ui/theme/color_tokens.dart`: add `static const Color princePrimary = Color(0xFF221C35)` and `static const Color princeViolet = Color(0xFF981D97)` (already used in existing palette; now named constants referenced by ThemeCatalog)
- [x] T011 Implement `lib/core/monetization/theme_catalog.dart`: `abstract class ThemeCatalog` with `static final List<AppThemeDefinition> all` containing all 8 `AppThemeDefinition` instances with complete `ColorScheme lightScheme` and `ColorScheme darkScheme` per theme (Midnight Wolves, Purple Reign, Sunset Blitz, Arctic Fox, Neon Jungle, Royal Crimson, Ocean Deep, Golden Hour); include `static AppThemeDefinition byId(AppThemeId id)` lookup
- [x] T012 [P] [US5] Update `lib/core/models/user_preferences.dart`: add `selectedThemeId (String)` field with `@Default('midnight_wolves')` and `defaultPlayerColors (List<String>)` field with `@Default([])` annotation; run `dart run build_runner build --delete-conflicting-outputs` to regenerate `.freezed.dart`
- [x] T013 [P] [US5] Update `lib/core/providers/prefs_keys.dart`: add `static const String selectedThemeId = 'selected_theme_id'` and `static const String defaultPlayerColors = 'default_player_colors'`
- [x] T014 [P] [US5] Update `lib/core/providers/preferences_provider.dart`: add `Future<void> updateSelectedTheme(String themeId)` (writes to `SharedPreferences`, rebuilds state) and `Future<void> updateDefaultPlayerColors(List<String> colors)` (JSON-encodes list, writes, rebuilds)
- [x] T015 Update `lib/ui/theme/app_theme.dart`: change `AppTheme.light(bool useAlternatePalette)` signature to `AppTheme.light(AppThemeDefinition? theme)` and `AppTheme.dark(AppThemeDefinition? theme)`; when `theme != null` use `theme.lightScheme` / `theme.darkScheme` directly; when `null` fall back to existing Midnight Wolves defaults; ensure no existing call sites break (update callers in `main.dart`)
- [x] T016 [P] Update `lib/core/router/app_router.dart`: add `GoRoute(path: '/settings/themes', builder: (_, __) => const ThemePickerScreen())` and `GoRoute(path: '/settings/faq', builder: (_, __) => const FaqScreen())` under the `/settings` shell branch

**Checkpoint**: App builds and runs. Default theme is Midnight Wolves. `flutter analyze` passes. All 8 `ThemeData` objects construct without assertion errors (verify with a unit test against `ThemeCatalog.all`).

---

## Phase 3: Ad Integration

**Purpose**: Build `MonetizedBanner` and place it on all four ambient screens. Wire the interstitial trigger to session-summary dismissal. Verify the frequency cap.

- [x] T017 [US1] Implement `lib/core/monetization/monetized_banner.dart`: `MonetizedBanner` stateful widget; reads `proStateProvider` — if `isPro`, renders `SizedBox.shrink()`; subscribes to `connectivity_plus` stream — if offline, renders `SizedBox.shrink()`; otherwise creates and loads a `BannerAd` via `AdService.instance.createBannerAd(adUnitId)`, renders `AdWidget(ad: _bannerAd)` inside a `SizedBox(height: 50)` container; `dispose()` calls `_bannerAd.dispose()`
- [x] T018 [P] [US1] Update `lib/features/home/presentation/home_screen.dart`: add `MonetizedBanner(adUnitId: AdUnitIds.homeBanner)` in a `Column` above or below the game module grid; must not overlap grid content; renders at zero height for Pro users and offline
- [x] T019 [P] [US1] Update `lib/features/tools/tools_screen.dart`: add `MonetizedBanner(adUnitId: AdUnitIds.toolsBanner)` in the tools screen layout; same collapse behavior as Home
- [x] T020 [US1] Update `lib/features/shared_session/session_summary_screen.dart`: in the "Done" button handler, before calling `context.go('/home')`, call `AdService.instance.showInterstitialIfEligible()`; pre-load the interstitial ad on `initState()` via `AdService.instance.loadInterstitial(AdUnitIds.sessionInterstitial)` so it is ready before the user reaches the summary screen

**Checkpoint**: Free user sees banner on Home and Tools. Airplane mode collapses banner within 500 ms. Session summary "Done" triggers one interstitial for free users; second game in same session does not trigger second interstitial. Pro user: no banners, no interstitial.

---

## Phase 4: Purchase & Settings UI

**Purpose**: Build all purchase-related UI. Update Settings screen with Pro section, theme picker tile, tip jar tile, default player color fields, and FAQ link.

- [x] T021 [P] [US2] Implement `lib/features/settings/pro_purchase_sheet.dart`: `showProPurchaseSheet(BuildContext)` function that calls `showModalBottomSheet`; sheet body lists all Pro benefits (ad-free, 8 themes, 8 sound packs, unlimited history, CSV export, custom player colors, themed dice); shows price from `PurchaseService.getProProduct()`; primary action "Upgrade to Pro" calls `ref.read(proStateProvider.notifier).purchasePro()`; secondary action "Restore Purchases" calls `ref.read(proStateProvider.notifier).restorePurchases()`; loading indicator while purchase is in-flight; error snackbar on failure
- [x] T022 [P] [US2] Implement `lib/features/settings/tip_jar_sheet.dart`: `showTipJarSheet(BuildContext)` function that calls `showModalBottomSheet`; sheet shows three tier buttons ($0.99 "Buy a Coffee", $2.99 "Buy a Snack", $4.99 "Buy a Meal"); each button calls `PurchaseService.purchaseTip(tier)`; gratitude message shown on successful purchase; cancel is always available with no error
- [x] T023 [US5] [US6] Implement `lib/features/settings/theme_picker_screen.dart`: `ThemePickerScreen` with grid of 8 theme cards; each card shows `previewPrimary` + `previewAccent` swatch, theme name, emoji, and lock overlay if `isPro` is false and `theme.isPro` is true; free user tapping a locked card shows "Watch to preview" option (rewarded ad, Phase 2) or a temporary live preview for a configurable duration; Pro user tapping any card calls `preferencesNotifier.updateSelectedTheme(theme.id.id)` immediately; currently selected theme has a checkmark indicator; upsell card at bottom for free users linking to Pro purchase
- [x] T024 [P] Implement `lib/features/settings/faq_screen.dart`: `FaqScreen` with organized sections (Getting Started, Game Scoring, History & Export, Pro & Purchases, Feedback & About); each section is an `ExpansionTile` group; content migrated from the inline FAQ section in `settings_screen.dart`; new FAQ entries added for Pro features, CSV export, and sound packs
- [x] T025 [US2] [US5] Update `lib/features/settings/settings_screen.dart`:
  - Add **Pro section**: if free user, show "Upgrade to Pro" `ListTile` (opens `showProPurchaseSheet`); if Pro user, show "Pro Active ✓" `ListTile` (opens info sheet listing all benefits)
  - Add **Color Theme** `ListTile` navigating to `/settings/themes`; shows current theme name as subtitle
  - Add **Sound Pack** picker `ListTile` (opens sound pack bottom sheet); shows current pack name as subtitle; locked packs shown with lock icon for free users
  - Add **Tip Jar** `ListTile` in Support section (opens `showTipJarSheet`)
  - Move **FAQ** to a `ListTile` navigating to `/settings/faq`
  - Add **Default Player Colors** row alongside Default Player Names in Player Defaults section; `ColorChip` tappable widgets (one per seat up to 10) backed by `updateDefaultPlayerColors`

**Checkpoint**: Free user taps "Upgrade to Pro" → purchase sheet opens. Theme picker shows 8 themes with correct lock states. Tip Jar shows 3 tiers. FAQ opens as standalone screen. Default player colors save and persist across app restarts.

---

## Phase 5: Pro Features

**Purpose**: History cap enforcement, CSV export with filtering, history sorting, default player colors carried through to session setup, themed dice.

- [x] T026 [P] [US3] Update `lib/core/database/daos/history_dao.dart`: in `insertHistoryRecord()`, after the insert, if the user is not Pro, query `SELECT COUNT(*) FROM history_records` and if count exceeds 20, `DELETE FROM history_records WHERE id IN (SELECT id FROM history_records ORDER BY played_at ASC LIMIT (count - 20))`; `ProStateNotifier` is injected as a dependency or the cap check is a parameter; ensure the operation runs in a transaction
- [x] T027 [P] [US3] Update `lib/features/history/history_list_screen.dart` — sort controls: add a `SortBar` widget at the top of the history list with three sort options (Date ↓, Date ↑, Game Type A→Z, Duration ↑); sort is applied in-memory on the Riverpod `HistoryNotifier` stream result; selected sort option persisted in local widget state (session-scoped, not persisted across app restarts)
- [x] T028 [P] [US4] Update `lib/features/history/history_list_screen.dart` — CSV export: add export `IconButton` in AppBar; for free users, tapping shows upgrade prompt via `showProPurchaseSheet`; for Pro users, shows bottom sheet with "Export All" and "Filter by Game Type" options; "Filter" shows a `ChoiceChip` game-type picker; on confirm, calls `HistoryNotifier.exportToCsv(gameType?)` which generates a CSV string (header: `date,game_type,players,winner,final_scores,duration_seconds`) and opens the platform share sheet via `Share.shareXFiles`
- [x] T029 [P] [US5] Carry `defaultPlayerColors` through session setup: update `lib/features/shared_session/session_setup_scaffold.dart` to read `preferencesProvider` and pre-populate each player's `colorHex` from `defaultPlayerColors[seatIndex]` when the list is non-empty; seats beyond the list length fall back to `kDefaultPlayerColors`
- [x] T030 [P] [US5] Theme dice: update `lib/features/tools/dice/dice_roller_screen.dart` to watch `preferencesProvider` and pass the active theme's `previewPrimary` and `previewAccent` colors to `DieWidget`'s face-color and pip-color parameters instead of using hard-coded values

**Checkpoint**: 21st session for free user prunes oldest. Pro user CSV exports with correct headers and valid UTF-8. History sorts correctly by all three criteria. Default player colors appear pre-populated in new game setup. Dice faces reflect active theme color.

---

## Phase 6: Sound Pack System

**Purpose**: Define all 8 sound packs as a static catalog. Persist the selected pack ID. Route audio asset loading through the active pack's subdirectory. Add a sound pack picker to Settings.

- [x] T031 Implement `lib/core/monetization/sound_pack_catalog.dart`: `class SoundPackDefinition` with final fields `String id`, `String name`, `String emoji`, `String description`, `bool isPro`; `abstract class SoundPacks` with `static final List<SoundPackDefinition> all` containing Classic (free), Arcade, Nature, Jazz, Minimal, Epic, Neon, Sports (all 7 Pro); include `static SoundPackDefinition byId(String id)` lookup with fallback to Classic
- [x] T032 [P] Add sound pack assets: create `assets/sounds/classic/`, `assets/sounds/arcade/`, `assets/sounds/nature/`, `assets/sounds/jazz/`, `assets/sounds/minimal/`, `assets/sounds/epic/`, `assets/sounds/neon/`, `assets/sounds/sports/` subdirectories; populate each with the required SFX files (`dice_roll.wav`, `coin_flip.wav`, `timer_alert.wav`, `score_confirm.wav`, `bust.wav`); register all paths in `pubspec.yaml` under `flutter.assets`
- [x] T033 [P] [US5] Update `lib/core/providers/prefs_keys.dart`: add `static const String selectedSoundPackId = 'selected_sound_pack_id'`
- [x] T034 [P] [US5] Update `lib/core/providers/preferences_provider.dart`: add `selectedSoundPackId (String)` field to `UserPreferences` (default `'classic'`) and `updateSelectedSoundPack(String packId)` method; update `prefs_keys.dart` accordingly; run `dart run build_runner build`
- [x] T035 Update audio service / sound player to resolve asset paths as `assets/sounds/<selectedSoundPackId>/<sfx_file>`; pre-load all SFX for the active pack during game session setup (consistent with `001-skorkeeper-app` audio pre-loading strategy)

**Checkpoint**: Classic sounds play on a fresh install. Pro user switches to Arcade pack; sounds change on next game session. Free user sees locked Pro packs in picker with upgrade prompt.

---

## Phase 7: Post-Spec Fixes and Additions

**Purpose**: Purple Reign contrast fix, Pro Active info sheet, theme live preview interaction in Theme Picker.

- [x] T036 [US5] Fix Purple Reign contrast in `lib/core/monetization/theme_catalog.dart`: update `secondaryContainer` and `onSecondaryContainer` color values for the `purpleReign` light and dark schemes so the radio button selected-item background meets WCAG AA (minimum 4.5:1 contrast ratio for body text); verify in both light and dark mode
- [x] T037 [US2] Add Pro Active info sheet: in `lib/features/settings/settings_screen.dart`, when `isPro` is true, replace "Upgrade to Pro" tile with "Pro Active ✓" tile; tapping it calls `showProActiveSheet(context)` (defined inline or in `pro_purchase_sheet.dart`) which displays a modal bottom sheet listing all Pro benefits as checkmarked rows — ad-free, 7 Pro themes, 7 Pro sound packs, unlimited history, CSV export, custom player colors, themed dice
- [x] T038 [P] [US6] Add live theme preview to `lib/features/settings/theme_picker_screen.dart`: tapping any theme card (locked or unlocked) writes the theme ID to a temporary `ValueNotifier<AppThemeId>` that is passed to the root `MaterialApp` as an override; the preview is live (entire app reflects the theme); a floating "Keep this theme" / "Cancel" action bar appears at the bottom; "Keep" calls `updateSelectedTheme` (Pro only) or opens `showProPurchaseSheet` (free user); "Cancel" restores the previous theme

**Checkpoint**: Purple Reign radio buttons are readable at ≥ 4.5:1 contrast in both modes. "Pro Active" tile opens benefit sheet. Tapping any theme card applies a live preview; Cancel restores previous theme.

---

## Phase 8: Regression Verification

**Purpose**: Confirm no existing functionality was broken by the monetization layer.

- [x] T039 [P] Run `flutter analyze` — zero errors, zero warnings (excluding info-level hints)
- [x] T040 [P] Run `flutter test` — all unit and widget tests pass; no new test failures introduced
- [x] T041 [P] Manual regression: complete a full game session on each of the 10 game modules as a free user — verify no ads appear on game screens, the ≤3-tap score entry path is unchanged, and `flutter analyze` still passes after the session
- [x] T042 [P] Manual regression: verify all 9 Tools work correctly for both free and Pro users — dice roller uses active theme colors, all other tools are unaffected
- [x] T043 [P] Verify `pubspec.yaml` asset declarations are complete for all new sound pack subdirectories; `flutter build apk --debug` and `flutter build ios --debug` succeed without missing asset errors

**Checkpoint**: All regression tests pass. App Store / Play Store build succeeds for both platforms.
