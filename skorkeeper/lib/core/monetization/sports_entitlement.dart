import 'package:freezed_annotation/freezed_annotation.dart';

import '../modules/sport_enums.dart';

part 'sports_entitlement.freezed.dart';

/// Value object representing a user's current sports IAP entitlements.
///
/// Loaded from RevenueCat via [PurchaseService] and cached as an in-memory
/// Riverpod state. Neither entitlement implies the other — they must be
/// checked independently (though Pro ⊇ Plan for feature access).
@freezed
abstract class SportsEntitlement with _$SportsEntitlement {
  const SportsEntitlement._();

  const factory SportsEntitlement({
    /// True when the user owns the Sports Plan ($6.99 one-time IAP).
    @Default(false) bool hasSportsPlan,

    /// True when the user owns Sports Pro ($19.99 one-time IAP).
    @Default(false) bool hasSportsPro,
  }) = _SportsEntitlement;

  /// No sports entitlements — used for unauthenticated / free users.
  static const SportsEntitlement none = SportsEntitlement();

  /// Whether the user can access Sports Plan features.
  ///
  /// Pro users always have access to Plan features (Pro ⊇ Plan).
  bool get canAccessPlanFeatures => hasSportsPlan || hasSportsPro;

  /// Whether the user can access Sports Pro features (in-depth mode,
  /// Hockey, Lacrosse, export, analytics).
  bool get canAccessProFeatures => hasSportsPro;

  /// Whether the user can access a specific [SportType].
  ///
  /// Hockey and Lacrosse require Pro; all other sports require the Plan.
  bool canAccess(SportType sport) {
    if (sport.requiresPro) return canAccessProFeatures;
    return canAccessPlanFeatures;
  }
}
