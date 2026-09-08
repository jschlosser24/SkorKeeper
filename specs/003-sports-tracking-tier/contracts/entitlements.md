# Contract: IAP Entitlements & RevenueCat Configuration

**Feature**: 003-sports-tracking-tier | **Contract Type**: External IAP / RevenueCat

---

## Overview

This contract defines the RevenueCat product identifiers, entitlement keys, and `PurchaseService` API extension. These identifiers must be configured in:
1. **RevenueCat Dashboard** — Products + Entitlements
2. **App Store Connect** — In-App Purchase products (iOS)
3. **Google Play Console** — In-App Products (Android)
4. **`purchase_service.dart`** — New constants + methods

---

## Product Identifiers

| Product ID | Platform | Type | Price | Display Name |
|---|---|---|---|---|
| `sports_plan` | iOS + Android | Non-consumable one-time | $6.99 | Sports Plan |
| `sports_pro` | iOS + Android | Non-consumable one-time | $19.99 | Sports Pro Plan |

> **Note**: These are product identifiers used in App Store Connect and Google Play Console. The same ID must be used on both platforms (RevenueCat maps to a cross-platform entitlement).

---

## RevenueCat Entitlement Keys

| Entitlement ID | Grants Access To | Products Attached |
|---|---|---|
| `sports_plan` | Baseball, Basketball, Football, Soccer, Tennis, Volleyball modules; basic tracking; 100-game history | `sports_plan` product |
| `sports_pro` | Hockey, Lacrosse modules; in-depth tracking; unlimited history; PDF/CSV/JSON export; Advanced Analytics | `sports_pro` product |
| `pro` | Cosmetic themes (existing) | *(existing — unchanged)* |

> A user purchasing `sports_pro` does NOT automatically receive `sports_plan` from RevenueCat's perspective. The app-level `SportsEntitlement.canAccessPlanFeatures` computed property returns `true` when `hasSportsPro == true`, covering the "Pro ⊇ Plan" rule in application code.

---

## Offering Configuration

Configure a RevenueCat Offering named `sports_tiers` with two packages:
| Package Identifier | Package Type | Product |
|---|---|---|
| `$rc_lifetime` (for sports_plan) | Lifetime | `sports_plan` |
| `$rc_lifetime` (for sports_pro) | Lifetime | `sports_pro` |

> Use separate offerings or a single offering with two lifetime packages. The app fetches offerings by entitlement, not by offering name.

---

## `PurchaseKeys` Constants Extension

Add to `lib/core/monetization/purchase_service.dart`:

```dart
abstract class PurchaseKeys {
  // --- Existing (unchanged) ---
  static const String entitlementPro = 'pro';
  static const String androidApiKey = '...';
  static const String iosApiKey = '...';
  static const String tipSmall = 'tip_small';
  static const String tipMedium = 'tip_medium';
  static const String tipLarge = 'tip_large';

  // --- New: Sports Tiers ---
  static const String entitlementSportsPlan = 'sports_plan';
  static const String entitlementSportsPro  = 'sports_pro';
  static const String productSportsPlan     = 'sports_plan';
  static const String productSportsPro      = 'sports_pro';
}
```

---

## `PurchaseService` API Extension

New static methods added to `PurchaseService` (following existing pattern):

```dart
/// Returns true if the user has an active Sports Plan entitlement.
static Future<bool> isSportsPlanUnlocked() async { ... }

/// Returns true if the user has an active Sports Pro entitlement.
static Future<bool> isSportsProUnlocked() async { ... }

/// Initiates purchase of the Sports Plan product.
/// Returns true if the entitlement is active after purchase.
static Future<bool> purchaseSportsPlan() async { ... }

/// Initiates purchase of the Sports Pro product.
/// Returns true if the entitlement is active after purchase.
static Future<bool> purchaseSportsPro() async { ... }

/// Restores purchases and returns the current SportsEntitlement state.
static Future<SportsEntitlement> restoreSportsPurchases() async { ... }
```

---

## `SportsEntitlement` Value Object

New file: `lib/core/monetization/sports_entitlement.dart`

```dart
/// Immutable snapshot of the user's current sports tier access.
@freezed
class SportsEntitlement with _$SportsEntitlement {
  const factory SportsEntitlement({
    required bool hasSportsPlan,
    required bool hasSportsPro,
    DateTime? planPurchaseDate,
    DateTime? proPurchaseDate,
  }) = _SportsEntitlement;

  const SportsEntitlement._();

  /// Pro users can also access all Plan features.
  bool get canAccessPlanFeatures => hasSportsPlan || hasSportsPro;

  /// Only Sports Pro gives access to Pro-exclusive features.
  bool get canAccessProFeatures => hasSportsPro;

  /// Convenience: can this user access a given SportType?
  bool canAccess(SportType sport) =>
      sport.requiresPro ? canAccessProFeatures : canAccessPlanFeatures;

  static const SportsEntitlement none = SportsEntitlement(
    hasSportsPlan: false,
    hasSportsPro: false,
  );
}
```

---

## Error States

| Scenario | App Behavior |
|---|---|
| Purchase sheet dismissed / cancelled | Return to calling screen; `SportsEntitlement` unchanged; no error shown |
| Purchase failed (network error) | Show generic "Purchase failed. Please try again." snackbar; no entitlement change |
| Restore finds no purchases | Show "No purchases found" message; entitlement remains as-is |
| Platform IAP unavailable (simulator, web) | `isSupportedPlatform == false`; all entitlement checks return `false`; purchase buttons show "Not available on this device" |
| Double-purchase attempt | App Store / Play Store handles gracefully; user sees "You've already purchased this item" native dialog; entitlement remains valid |
