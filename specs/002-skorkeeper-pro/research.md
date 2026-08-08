# Research Report: SkorKeeper Pro — Monetization Tech Stack

**Branch**: `002-skorkeeper-pro` | **Phase**: 0 — Pre-Design Research
**Spec**: `specs/002-skorkeeper-pro/spec.md`

---

## Summary

Six technology decisions were required before implementation could begin: IAP provider, ad SDK, ad placement policy, monetization model, theme architecture, and sound pack architecture. All six are resolved below with rationale and alternatives rejected.

---

## Decision 1 — IAP Provider

**Decision**: **RevenueCat (`purchases_flutter ^8.0.0`)**

**Rationale**:

1. **Offline entitlement cache is a first-class feature.** RevenueCat's SDK persists the last verified entitlement state to its own local cache. On every subsequent cold launch the app can call `Purchases.getCustomerInfo()` synchronously from that cache — resolving FR-004 and FR-006 with zero additional code. Rolling a direct StoreKit 2 / Play Billing integration would require building and maintaining this cache layer manually.

2. **Single API for both platforms.** `purchases_flutter` wraps StoreKit 2 on iOS and Google Play Billing v5 on Android behind one Dart interface: `Purchases.purchaseProduct()`, `Purchases.restorePurchases()`, `Purchases.getCustomerInfo()`. Maintaining separate platform plugins would double the integration surface and the test matrix.

3. **Sandbox + production parity.** RevenueCat's dashboard provides a unified sandbox vs. production entitlement view with a real-time debug overlay, dramatically reducing QA time for SC-002 and SC-003 compared to raw Store testing with sandboxed Apple IDs.

4. **Free tier is sufficient for launch.** RevenueCat charges 0% up to $2,500 MRR. A v1 indie app with a $3.99 one-time purchase is highly unlikely to exceed this threshold before the team has time to evaluate SDK cost vs. revenue.

5. **Tip jar support.** Consumable products (tip tiers) are handled identically to non-consumables in the RevenueCat API — `Purchases.purchaseProduct(tipSmall)` — with no additional SDK integration. This unlocked the post-spec Tip Jar feature at zero marginal cost.

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| Direct StoreKit 2 (iOS only) | Platform-specific — requires a second full integration for Android Play Billing; no unified cache; sandbox UX is poor |
| Direct Google Play Billing v5 (`in_app_purchase` Flutter plugin) | Low-level — no offline cache, no unified receipt validation, separate restore flow; doubles implementation and test effort |
| `in_app_purchase` Flutter plugin (cross-platform) | Maintained by the Flutter team but provides raw billing primitives only; entitlement cache, restore logic, and sandbox validation all remain the developer's responsibility |
| RevenueCat paid tier pre-launch | Unnecessary — free tier covers launch revenue range; can migrate later |

---

## Decision 2 — Ad SDK

**Decision**: **Google AdMob (`google_mobile_ads ^5.2.0`)**

**Rationale**:

1. **Market share and fill rate.** AdMob has the highest fill rate for mobile game apps globally. For a mobile gaming utility targeting English-speaking markets, AdMob consistently outperforms alternatives on eCPM for banner and interstitial formats.

2. **Single SDK covers all required ad formats.** Banner ads (FR-007–FR-010), interstitial ads (FR-011–FR-015), and the Phase 2 rewarded ads (FR-016–FR-020) are all natively supported by `google_mobile_ads` without an additional mediation SDK.

3. **Native Flutter plugin.** `google_mobile_ads` is the official Google-maintained Flutter plugin. There is no wrapper or bridge maintenance concern; the API surface is stable and documented.

4. **App Transparency Tracking (ATT) compliance.** The `app_tracking_transparency` package integrates with the same `GADMobileAds.sharedInstance().start()` initialization flow and delivers the ATT request before any ad network call — satisfying Apple App Store Review Guidelines §5.1.2 with a known, well-documented pattern.

5. **`connectivity_plus` collapse behavior.** Pairing AdMob with `connectivity_plus ^6.1.3` allows `MonetizedBanner` to listen to the connectivity stream and collapse the ad container before an ad-load attempt occurs when offline — satisfying FR-009 cleanly without waiting for an SDK timeout.

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| IronSource (Unity LevelPlay) | Mediation-focused; strongest for gaming but requires heavier SDK initialization and a mediation adapter network; fill rate advantage over AdMob is unproven at launch-scale revenue; adds complexity during v1 launch |
| AppLovin MAX | Also mediation-focused; excellent eCPM ceiling but adds ~5 MB to binary size and requires network partner adapter setup — disproportionate for an indie app at launch |
| Facebook Audience Network (Meta) | Requires user identity graph data to function well; conflicts with the no-account, privacy-first positioning; ATT opt-out rate reduces fill rate significantly |
| Unity Ads | Better suited to midcore/hardcore gaming; rewarded-only format dominance; banner/interstitial fill rate is weaker for utility/casual games |

---

## Decision 3 — Ad Frequency and Placement Policy

**Decision**: **Banners on Home, History, Settings, and Tools screens only; one interstitial per app session at session-summary dismissal; no ads on any active game screen.**

**Rationale**:

The core product promise is uninterrupted score entry. This is non-negotiable (FR-030, FR-031) and was enforced as an explicit architectural constraint before any ad SDK integration began.

The placement policy was derived from this constraint:

1. **Banner placement**: The four ambient screens (Home, History, Settings, Tools) are browsing contexts — the user is not mid-game, not entering a score, and is not time-pressured. Banner impressions here monetize idle navigation without competing with gameplay. Game setup screens, session screens, and score-entry screens are **explicitly excluded** by FR-008.

2. **Interstitial placement**: A single interstitial at session-summary dismissal is the highest-value placement that still respects the game boundary. The summary screen is already a "pause state" — the game has ended, the user is reviewing results. The transition to Home is a natural break point. The one-per-session cap (FR-013) is enforced by a boolean flag on `AdService.instance` that survives the session lifecycle.

3. **Tools screen addition (post-spec)**: The Tools screen was added as a banner location because it shares the same "ambient browsing" context as Home/History/Settings. Tools are used between games, not during active scoring.

4. **Frequency cap over fill rate**: Maximizing ad impressions per session would harm retention for a scoring app that users open repeatedly during a game night. One interstitial per session and banners only on ambient screens was chosen to maximize long-term eCPM value (retained free users > churned users who saw too many ads).

---

## Decision 4 — Monetization Model

**Decision**: **One-time non-consumable IAP ("SkorKeeper Pro") at $3.99 USD**

**Rationale**:

Research into monetization models for mobile utility apps (scoring, note-taking, productivity) consistently shows that one-time purchase outperforms subscription for apps with no server-side component and a use case that doesn't require continuous content updates.

1. **No recurring value delivery = no subscription justification.** Subscriptions are defensible when the developer continuously delivers new content or server-hosted services. SkorKeeper is offline-first; a subscription would feel extractive to users who correctly observe that their paid Pro features don't require ongoing cloud resources.

2. **Frictionless unlock story.** "Pay once, own forever" is the clearest possible value proposition on an App Store product page and in the in-app purchase sheet. It reduces decision fatigue at the conversion moment.

3. **No churn management complexity.** Subscription retention, lapsed subscription re-engagement, and partial-period refund handling are engineering and UX problems that add sprint scope without delivering game features. A one-time IAP is purchased, cached, and then never an issue again.

4. **Tip Jar for recurring revenue exploration.** Rather than forcing a subscription model prematurely, the Tip Jar (three voluntary consumable tiers at $0.99/$2.99/$4.99) was added post-spec to allow users who want to support development to do so. This provides a lightweight recurring revenue signal without gating any features behind a subscription.

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| Monthly/annual subscription | No recurring server value delivered; would feel dishonest to users; adds lapsed-subscription UX complexity |
| Freemium module gating (e.g., only Cribbage/Bowling locked) | Violates FR-030 (all 10 game modules must be free); splitting modules would fragment the user base and harm ratings |
| Consumable "game credits" | Unsuitable for a deterministic scoring utility — users would resent running out of credits mid-game |
| Free with paid feature bundles (multiple SKUs) | IAP store complexity; version management overhead; single Pro SKU simplifies app store submission and user communication |
| Ads-only, no IAP | Insufficient conversion lever; no high-value user segment engagement; leaves power users under-monetized |

---

## Decision 5 — Theme Architecture

**Decision**: **`AppThemeDefinition` data class + `ThemeCatalog` static list, parameterized into `AppTheme.light(AppThemeDefinition?)` / `AppTheme.dark(AppThemeDefinition?)`**

**Rationale**:

1. **Complete ColorScheme ownership.** Each `AppThemeDefinition` carries a full `ColorScheme lightScheme` and `ColorScheme darkScheme`. This is the cleanest possible model: a theme is its color schemes, nothing more. No partial overrides, no inheritance chains.

2. **`ThemeCatalog.all` is the single source of truth.** All 8 theme definitions live in `lib/core/monetization/theme_catalog.dart`. The Theme Picker screen, the Pro gate logic, and the preferences layer all reference this same list. Adding a 9th theme in a future update requires one new `AppThemeDefinition` entry in the catalog — no changes anywhere else.

3. **Parameterized factory over ThemeExtension.** Flutter's `ThemeExtension` mechanism is designed for injecting *extra* typed data into a `ThemeData` via `ThemeData.extensions`. It is not designed for swapping complete color schemes. Using it for theme selection would require `Theme.of(context).extension<MyThemeExtension>()` call sites throughout the widget tree, increasing coupling and making theme-aware widgets harder to test in isolation.

4. **`previewPrimary` and `previewAccent` enable the theme picker UI.** These two `Color` fields on `AppThemeDefinition` power the theme card's preview swatch without needing to instantiate a full `ThemeData` for rendering each card cell in the grid.

5. **Entitlement gate is a data field, not a branch.** `isPro (bool)` on `AppThemeDefinition` is evaluated at the `ThemePickerScreen` call site and nowhere else. The catalog itself has no knowledge of the current entitlement state.

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| `ThemeExtension` mechanism | Designed for augmenting an existing theme, not selecting among complete color schemes; requires callsite boilerplate across the widget tree |
| Map of `ThemeData` keyed by enum | Instantiates all 8 `ThemeData` objects at catalog load time, all light + dark = 16 objects; wasteful; `AppThemeDefinition` defers full `ThemeData` construction to `AppTheme.light/dark()` which is called at most twice (once per light/dark mode) |
| JSON-driven theme catalog | Over-engineering for v1: 8 hand-authored themes with static assets; a JSON catalog adds a parser, validation, and an asset loading step for no gain |
| Per-theme separate Dart files | Correct approach for very large theme libraries; at 8 themes, a single `theme_catalog.dart` file is readable and maintainable |

---

## Decision 6 — Sound Pack Architecture

**Decision**: **`SoundPackDefinition` data class + `SoundPacks.all` static catalog; selected pack ID persisted in `shared_preferences`; audio assets pre-loaded at session start.**

**Rationale**:

1. **Mirrors the theme architecture for consistency.** `SoundPackDefinition` (id, name, emoji, description, isPro) is structurally identical to `AppThemeDefinition`'s metadata portion. The same `isPro` gate pattern applies, keeping the settings UI symmetrical: one row for themes, one row for sound packs, identical lock/unlock behavior.

2. **Static catalog, no dynamic asset loading.** All sound pack audio files are bundled as app assets in `assets/sounds/<pack_id>/`. There is no network download, no asset cache, and no partial-download failure state. The catalog declares the pack metadata; the audio player loads the appropriate subdirectory path at game session start.

3. **Pre-loaded at session start, not on demand.** Sound effects must play within ~50 ms of a user action (score entry, dice roll). Dynamic `setAsset()` on first play introduces 100–300 ms first-play latency on iOS. Pre-loading all SFX for the active pack during the game setup loading screen eliminates this latency, consistent with the audio strategy established in `001-skorkeeper-app/research.md` Decision 7.

4. **Free: Classic. Pro: Arcade, Nature, Jazz, Minimal, Epic, Neon, Sports.** The Classic pack maps 1:1 to the existing `assets/sounds/` files already in the app, requiring zero asset changes for the free tier. All 7 Pro packs add new asset subdirectories.

**Alternatives Considered**:

| Alternative | Rejected Because |
|---|---|
| Single sound pack, no Pro gating | Leaves a high-perceived-value customization feature unmonetized; sound packs are a natural Pro parallel to color themes |
| Dynamic OTA asset download for Pro packs | Adds server infrastructure, CDN, version management, and offline failure modes — all inconsistent with the offline-first constitution |
| Per-module sound packs (different sounds per game type) | High asset authoring burden (10 modules × 7 packs = 70 asset sets); out of scope for v1 |
| More than 8 packs | Chose 8 to match the number of color themes — makes the "8 themes, 8 sound packs" story clean and symmetric for App Store marketing |

---

## Resolved Unknowns Checklist

| # | Unknown | Resolution |
|---|---|---|
| 1 | IAP provider: RevenueCat or direct StoreKit 2 / Play Billing? | RevenueCat `purchases_flutter` — offline cache, cross-platform single API, free tier |
| 2 | Ad SDK: AdMob, IronSource, or AppLovin MAX? | Google AdMob `google_mobile_ads` — fill rate, single SDK covers all formats, official Flutter plugin |
| 3 | Ad frequency / placement policy? | Banners on ambient screens only; one interstitial per session at summary dismissal; never on game screens |
| 4 | Monetization model: one-time IAP, subscription, or modules? | One-time non-consumable $3.99 Pro + voluntary Tip Jar consumables |
| 5 | Theme architecture: AppThemeDefinition or ThemeExtension? | AppThemeDefinition data class + ThemeCatalog static list |
| 6 | Sound pack architecture: static catalog or dynamic loading? | Static bundled catalog, pre-loaded at session start |

---

## New Dependencies Added (`pubspec.yaml`)

```yaml
dependencies:
  # Monetization
  purchases_flutter: ^8.0.0          # RevenueCat IAP + entitlement management
  google_mobile_ads: ^5.2.0          # AdMob banner + interstitial + rewarded
  connectivity_plus: ^6.1.3          # Ad banner collapse on offline detection
  app_tracking_transparency: ^6.0.1  # ATT permission prompt (iOS 14+)
```

---

## Platform Changes Required

### Android (`android/app/src/main/AndroidManifest.xml`)

- `<uses-permission android:name="android.permission.INTERNET"/>` — required for AdMob and RevenueCat SDK network calls; was not present in v1.
- `<meta-data android:name="com.google.android.gms.ads.APPLICATION_ID" android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>` — AdMob App ID; absent causes runtime crash on launch.

### iOS (`ios/Runner/Info.plist`)

- `GADApplicationIdentifier` — AdMob App ID for iOS; absent causes runtime crash.
- `SKAdNetworkItems` — Required by Apple for ad attribution; absence generates App Store validation warning.
- `NSUserTrackingUsageDescription` — ATT usage string; required before `AppTrackingTransparency.requestTrackingAuthorization()` can be called; absence causes App Store rejection.
