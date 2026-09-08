import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'sports_entitlement.dart';

abstract class PurchaseKeys {
  static const String entitlementPro = 'pro';

  // ─── Sports entitlement IDs (RevenueCat Dashboard) ───────────────────────
  /// RevenueCat entitlement identifier for the Sports Plan tier.
  static const String entitlementSportsPlan = 'sports_plan';

  /// RevenueCat entitlement identifier for the Sports Pro tier.
  static const String entitlementSportsPro = 'sports_pro';

  // ─── Sports product IDs (App Store Connect / Google Play Console) ─────────
  /// One-time IAP product ID for Sports Plan ($6.99).
  static const String productSportsPlan = 'sports_plan_lifetime';

  /// One-time IAP product ID for Sports Pro ($19.99).
  static const String productSportsPro = 'sports_pro_lifetime';

  // Get these from RevenueCat Dashboard → Project Settings → API Keys
  // Android key starts with "goog_", iOS key starts with "appl_"
  static const String androidApiKey = 'test_qKIGfqJdAhRGkgmKmMlqefYOQYR';
  static const String iosApiKey = 'test_qKIGfqJdAhRGkgmKmMlqefYOQYR';

  // Consumable tip products — configure these as one-time, consumable
  // products in App Store Connect / Google Play Console and RevenueCat.
  static const String tipSmall = 'tip_small';    // $0.99
  static const String tipMedium = 'tip_medium';  // $2.99
  static const String tipLarge = 'tip_large';    // $4.99
}

class PurchaseService {
  static SportsEntitlement _cachedSportsEntitlement = SportsEntitlement.none;

  static SportsEntitlement get currentSportsEntitlement => _cachedSportsEntitlement;

  static SportsEntitlement cacheSportsEntitlement(
    SportsEntitlement entitlement,
  ) {
    _cachedSportsEntitlement = entitlement;
    return entitlement;
  }

  static bool get _isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static Future<void> configure() async {
    if (!_isSupportedPlatform) {
      return;
    }
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);
    final config = PurchasesConfiguration(
      defaultTargetPlatform == TargetPlatform.android
          ? PurchaseKeys.androidApiKey
          : PurchaseKeys.iosApiKey,
    );
    await Purchases.configure(config);
  }

  static Future<bool> isProUnlocked() async {
    if (!_isSupportedPlatform) {
      return false;
    }
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey(PurchaseKeys.entitlementPro);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> purchasePro() async {
    if (!_isSupportedPlatform) {
      return false;
    }
    final offerings = await Purchases.getOfferings();
    final package =
        offerings.current?.lifetime ??
        offerings.current?.annual ??
        offerings.current?.availablePackages.firstOrNull;
    if (package == null) {
      return false;
    }
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo.entitlements.active.containsKey(
      PurchaseKeys.entitlementPro,
    );
  }

  static Future<bool> restorePurchases() async {
    if (!_isSupportedPlatform) {
      return false;
    }
    final info = await Purchases.restorePurchases();
    return info.entitlements.active.containsKey(PurchaseKeys.entitlementPro);
  }

  /// Purchases a consumable tip product. Returns true if the transaction
  /// completed without error (RevenueCat processes consumables automatically).
  static Future<bool> purchaseTip(String productId) async {
    if (!_isSupportedPlatform) {
      return false;
    }
    await Purchases.purchaseProduct(productId, type: PurchaseType.inapp);
    return true;
  }

  // ─── Sports Plan ──────────────────────────────────────────────────────────

  /// Returns true when the device has an active Sports Plan entitlement.
  static Future<bool> isSportsPlanUnlocked() async {
    if (!_isSupportedPlatform) return _cachedSportsEntitlement.hasSportsPlan;
    try {
      final info = await Purchases.getCustomerInfo();
      final value = info.entitlements.active.containsKey(
        PurchaseKeys.entitlementSportsPlan,
      );
      cacheSportsEntitlement(
        _cachedSportsEntitlement.copyWith(hasSportsPlan: value),
      );
      return value;
    } catch (_) {
      return _cachedSportsEntitlement.hasSportsPlan;
    }
  }

  /// Returns true when the device has an active Sports Pro entitlement.
  static Future<bool> isSportsProUnlocked() async {
    if (!_isSupportedPlatform) return _cachedSportsEntitlement.hasSportsPro;
    try {
      final info = await Purchases.getCustomerInfo();
      final value = info.entitlements.active.containsKey(
        PurchaseKeys.entitlementSportsPro,
      );
      cacheSportsEntitlement(
        _cachedSportsEntitlement.copyWith(hasSportsPro: value),
      );
      return value;
    } catch (_) {
      return _cachedSportsEntitlement.hasSportsPro;
    }
  }

  /// Locates the [Package] to purchase for a sports tier, tolerating
  /// RevenueCat dashboard misconfiguration (e.g. missing/renamed offering).
  ///
  /// Falls back through: 1) the named offering's lifetime/matching/first
  /// package, 2) any offering containing a package for [productId], 3) the
  /// current default offering. This avoids failing purchases with
  /// "Purchase could not be completed" when the named offering is absent.
  static Package? _findSportsPackage(
    Offerings offerings,
    String offeringId,
    String productId,
  ) {
    final named = offerings.getOffering(offeringId);
    final namedPackage = named?.lifetime ??
        named?.availablePackages.firstWhereOrNull(
          (p) => p.storeProduct.identifier == productId,
        ) ??
        named?.availablePackages.firstOrNull;
    if (namedPackage != null) return namedPackage;

    for (final offering in offerings.all.values) {
      final match = offering.availablePackages.firstWhereOrNull(
        (p) => p.storeProduct.identifier == productId,
      );
      if (match != null) return match;
    }

    final current = offerings.current;
    return current?.lifetime ?? current?.availablePackages.firstOrNull;
  }

  /// Initiates the Sports Plan ($6.99) purchase flow.
  ///
  /// Returns true on successful purchase. Throws on cancellation or error so
  /// the caller can distinguish between the two.
  static Future<bool> purchaseSportsPlan() async {
    if (!_isSupportedPlatform) return false;
    final offerings = await Purchases.getOfferings();
    final package = _findSportsPackage(
      offerings,
      'sports_plan',
      PurchaseKeys.productSportsPlan,
    );
    if (package == null) return false;
    final result = await Purchases.purchase(PurchaseParams.package(package));
    final success = result.customerInfo.entitlements.active.containsKey(
      PurchaseKeys.entitlementSportsPlan,
    );
    cacheSportsEntitlement(
      _cachedSportsEntitlement.copyWith(hasSportsPlan: success),
    );
    return success;
  }

  /// Initiates the Sports Pro ($19.99) purchase flow.
  ///
  /// Returns true on successful purchase. Throws on cancellation or error.
  static Future<bool> purchaseSportsPro() async {
    if (!_isSupportedPlatform) return false;
    final offerings = await Purchases.getOfferings();
    final package = _findSportsPackage(
      offerings,
      'sports_pro',
      PurchaseKeys.productSportsPro,
    );
    if (package == null) return false;
    final result = await Purchases.purchase(PurchaseParams.package(package));
    final success = result.customerInfo.entitlements.active.containsKey(
      PurchaseKeys.entitlementSportsPro,
    );
    cacheSportsEntitlement(
      _cachedSportsEntitlement.copyWith(
        hasSportsPlan: _cachedSportsEntitlement.hasSportsPlan || success,
        hasSportsPro: success,
      ),
    );
    return success;
  }

  /// Restores sports purchases and returns the updated entitlement state.
  ///
  /// Returns a record of (hasSportsPlan, hasSportsPro) after restoration.
  static Future<({bool hasSportsPlan, bool hasSportsPro})>
      restoreSportsPurchases() async {
    if (!_isSupportedPlatform) {
      return (hasSportsPlan: false, hasSportsPro: false);
    }
    final info = await Purchases.restorePurchases();
    final entitlement = SportsEntitlement(
      hasSportsPlan: info.entitlements.active.containsKey(
        PurchaseKeys.entitlementSportsPlan,
      ),
      hasSportsPro: info.entitlements.active.containsKey(
        PurchaseKeys.entitlementSportsPro,
      ),
    );
    cacheSportsEntitlement(entitlement);
    return (
      hasSportsPlan: entitlement.hasSportsPlan,
      hasSportsPro: entitlement.hasSportsPro,
    );
  }
}
