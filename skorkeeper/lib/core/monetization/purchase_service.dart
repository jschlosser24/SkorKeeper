import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class PurchaseKeys {
  static const String entitlementPro = 'pro';
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
}
