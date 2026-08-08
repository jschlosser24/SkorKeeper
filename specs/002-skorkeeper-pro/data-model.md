# Data Model: SkorKeeper Pro

**Branch**: `002-skorkeeper-pro` | **Phase**: 1 — Design
**Spec**: `specs/002-skorkeeper-pro/spec.md` | **Research**: `specs/002-skorkeeper-pro/research.md`

---

## Overview

The SkorKeeper Pro monetization layer introduces **no new Drift tables**. All data additions are:

1. **Two new fields on `UserPreferences`** (stored in `shared_preferences`) — `selectedThemeId` and `defaultPlayerColors`.
2. **Two new `PrefsKeys` constants** — `selected_theme_id` and `default_player_colors`.
3. **Two new pure-Dart data classes** — `AppThemeDefinition` (theme catalog entries) and `SoundPackDefinition` (sound pack catalog entries). These are in-memory static catalogs; they are not persisted to disk.
4. **`PurchaseKeys` constants** — string identifiers used by `PurchaseService` when calling the RevenueCat SDK.
5. **History cap enforcement** — enforced at write time in `HistoryDao`; no schema change to the existing `history_records` table.
6. **Ephemeral ad state** — `AdService` holds a `bool _interstitialShownThisSession` flag in memory only; not persisted.

---

## Storage Layers

| Layer | Contents |
|---|---|
| **Drift (SQLite)** | Unchanged from `001-skorkeeper-app`. No new tables, no schema migration. History cap is enforced by a `DELETE` in `HistoryDao.insertHistoryRecord()`. |
| **shared_preferences** | Two new scalar keys: `selected_theme_id` (String) and `default_player_colors` (JSON-encoded `List<String>`). Existing keys unchanged. |
| **RevenueCat local cache** | Owned entirely by the `purchases_flutter` SDK. Stores the last verified entitlement state. SkorKeeper reads this via `Purchases.getCustomerInfo()` — does not write or read it directly. |
| **In-memory only** | `AdService._interstitialShownThisSession` (bool), `ThemeCatalog.all` (List), `SoundPacks.all` (List). Ephemeral — reset on process termination. |

---

## Updated Entity: `UserPreferences`

`UserPreferences` is a `@freezed` Dart class persisted via `shared_preferences`. Two fields were added in this spec.

**File**: `lib/core/models/user_preferences.dart`

| Field | Type | Default | Prefs Key | Description |
|---|---|---|---|---|
| `themeMode` | `ThemeMode` | `ThemeMode.system` | `theme_mode` | Light / dark / system preference *(existing)* |
| `useAlternatePalette` | `bool` | `false` | `use_alternate_palette` | Legacy palette flag *(existing, superseded by selectedThemeId)* |
| `soundEnabled` | `bool` | `true` | `sound_enabled` | Global sound on/off *(existing)* |
| `hapticEnabled` | `bool` | `true` | `haptic_enabled` | Global haptics on/off *(existing)* |
| `shakeToRollEnabled` | `bool` | `true` | `shake_to_roll_enabled` | Shake-to-roll for dice *(existing)* |
| `shakeSensitivity` | `double` | `1.5` | `shake_sensitivity` | Shake detection threshold *(existing)* |
| `defaultPlayerNames` | `List<String>` | `[]` | `default_player_names` | Default player display names *(existing)* |
| `selectedThemeId` | `String` | `'midnight_wolves'` | `selected_theme_id` | **NEW** — ID of active `AppThemeDefinition`; matches `AppThemeId.id` extension value |
| `defaultPlayerColors` | `List<String>` | `[]` | `default_player_colors` | **NEW** — Hex color strings per player seat (e.g. `['#78BE20', '#981D97']`); seats beyond list length fall back to `kDefaultPlayerColors` |
| `selectedSoundPackId` | `String` | `'classic'` | `selected_sound_pack_id` | **NEW** — ID of active `SoundPackDefinition` |

---

## Updated Entity: `PrefsKeys`

**File**: `lib/core/providers/prefs_keys.dart`

All keys are `static const String` values on `abstract class PrefsKeys`.

| Constant | Key String | Added By |
|---|---|---|
| `themeMode` | `'theme_mode'` | spec 001 |
| `useAlternatePalette` | `'use_alternate_palette'` | spec 001 |
| `soundEnabled` | `'sound_enabled'` | spec 001 |
| `hapticEnabled` | `'haptic_enabled'` | spec 001 |
| `shakeToRollEnabled` | `'shake_to_roll_enabled'` | spec 001 |
| `shakeSensitivity` | `'shake_sensitivity'` | spec 001 |
| `defaultPlayerNames` | `'default_player_names'` | spec 001 |
| `selectedThemeId` | `'selected_theme_id'` | **spec 002** |
| `defaultPlayerColors` | `'default_player_colors'` | **spec 002** |
| `selectedSoundPackId` | `'selected_sound_pack_id'` | **spec 002** |

---

## New Entity: `AppThemeDefinition`

A pure-Dart data class (no codegen) representing a single color theme entry in `ThemeCatalog.all`.

**File**: `lib/core/monetization/theme_definition.dart`

| Field | Type | Description |
|---|---|---|
| `id` | `AppThemeId` | Enum value identifying this theme; `id.id` (String extension) is persisted to `shared_preferences` |
| `name` | `String` | Display name shown in the Theme Picker (e.g. `'Purple Reign'`) |
| `description` | `String` | Short marketing description shown as subtitle in the Theme Picker card |
| `emoji` | `String` | Single emoji shown alongside the name (e.g. `'👑'`, `'🏆'`) |
| `isPro` | `bool` | `true` for the 7 Pro themes; `false` for Midnight Wolves |
| `lightScheme` | `ColorScheme` | Full Material 3 `ColorScheme` for light mode |
| `darkScheme` | `ColorScheme` | Full Material 3 `ColorScheme` for dark mode |
| `previewPrimary` | `Color` | Primary swatch color for the theme card preview chip (not a full ColorScheme) |
| `previewAccent` | `Color` | Accent swatch color for the theme card preview chip |

**Catalog**: `lib/core/monetization/theme_catalog.dart` — `ThemeCatalog.all` is a `static final List<AppThemeDefinition>` containing all 8 entries. Order is: Midnight Wolves (free), Purple Reign, Sunset Blitz, Arctic Fox, Neon Jungle, Royal Crimson, Ocean Deep, Golden Hour.

---

## New Entity: `AppThemeId`

**File**: `lib/core/monetization/app_theme_id.dart`

```dart
enum AppThemeId {
  midnightWolves,
  purpleReign,
  sunsetBlitz,
  arcticFox,
  neonJungle,
  royalCrimson,
  oceanDeep,
  goldenHour,
}
```

**Extension** `AppThemeIdX on AppThemeId`:

| Method | Return | Description |
|---|---|---|
| `id` | `String` | Snake-case string used as the `shared_preferences` value (e.g. `'midnight_wolves'`) |
| `AppThemeIdX.fromId(String)` | `AppThemeId` | Parses a stored string back to the enum; throws `ArgumentError` on unknown value |

---

## New Entity: `SoundPackDefinition`

A pure-Dart data class representing a single sound pack entry in `SoundPacks.all`.

**File**: `lib/core/monetization/sound_pack_catalog.dart`

| Field | Type | Description |
|---|---|---|
| `id` | `String` | Unique identifier; also the asset subdirectory name under `assets/sounds/` (e.g. `'classic'`, `'arcade'`) |
| `name` | `String` | Display name shown in the Sound Pack picker (e.g. `'Classic'`, `'Arcade'`) |
| `emoji` | `String` | Single emoji shown alongside the name |
| `description` | `String` | Short description of the sound style |
| `isPro` | `bool` | `true` for the 7 Pro packs; `false` for Classic |

**Catalog**: `SoundPacks.all` — `static final List<SoundPackDefinition>` with 8 entries. Order: Classic (free), Arcade, Nature, Jazz, Minimal, Epic, Neon, Sports.

**Asset path convention**: `assets/sounds/<pack.id>/<sfx_file>` — e.g. `assets/sounds/arcade/dice_roll.wav`.

---

## New Constants: `PurchaseKeys`

**File**: `lib/core/monetization/purchase_service.dart`

`abstract class PurchaseKeys` — all values are `static const String`.

| Constant | Value | Description |
|---|---|---|
| `entitlementPro` | `'pro'` | RevenueCat entitlement identifier configured in the RevenueCat dashboard |
| `androidApiKey` | `'appl_...'` | RevenueCat Android public API key (loaded from `dart-define` or build config; not committed) |
| `iosApiKey` | `'appl_...'` | RevenueCat iOS public API key |
| `productPro` | `'skorkeeper_pro'` | App Store / Play Store product ID for the one-time Pro IAP |
| `tipSmall` | `'tip_small'` | Product ID for the $0.99 consumable tip |
| `tipMedium` | `'tip_medium'` | Product ID for the $2.99 consumable tip |
| `tipLarge` | `'tip_large'` | Product ID for the $4.99 consumable tip |

> ⚠️ **Security note**: Actual API key values are **not** committed to the repository. They are injected at build time via `--dart-define=REVENUECAT_ANDROID_KEY=...` or a secrets management system. The constants above reference environment variable reads, not literal strings.

---

## History Cap Enforcement

No schema changes were made to the `history_records` Drift table. The cap is enforced behaviorally at write time.

**Modified file**: `lib/core/database/daos/history_dao.dart`

**Logic** (inside `insertHistoryRecord()`, wrapped in a transaction):

```
1. INSERT the new HistoryRecord row.
2. IF the current user is NOT Pro:
   a. SELECT COUNT(*) FROM history_records → total
   b. IF total > 20:
      DELETE FROM history_records
      WHERE id IN (
        SELECT id FROM history_records
        ORDER BY played_at ASC
        LIMIT (total - 20)
      )
```

This approach has two properties:
- **Atomic**: The insert and prune happen in one transaction; no in-between state where the table temporarily holds 21 rows is visible to a stream listener.
- **No background job**: The prune runs exactly when needed (at write time), not on a timer, eliminating the possibility of a race condition between a background job and a user-visible history list reload.

**Pro user**: The `IF NOT Pro` condition is evaluated by passing the `isPro` boolean as a parameter to `insertHistoryRecord()`. The DAO itself has no Riverpod dependency — the caller (`ActiveSessionsNotifier.endSession()`) reads `proStateProvider` and passes the result down.

---

## Ephemeral / Runtime-Only State

These items are not persisted and reset on each app launch:

| State | Owner | Reset Trigger |
|---|---|---|
| `_interstitialShownThisSession` | `AdService.instance` | Process termination |
| Loaded `InterstitialAd` instance | `AdService.instance` | Process termination; also on show completion |
| Live theme preview override | `ThemePickerScreen` local `ValueNotifier` | Navigation away from Theme Picker (Cancel or confirm) |
| RevenueCat `CustomerInfo` in-memory cache | `purchases_flutter` SDK | SDK manages this; SkorKeeper does not control it |
