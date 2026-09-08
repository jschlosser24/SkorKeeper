import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/monetization/purchase_service.dart';
import '../../../core/monetization/sports_entitlement.dart';

part 'sports_entitlement_notifier.g.dart';

@riverpod
class SportsEntitlementNotifier extends _$SportsEntitlementNotifier {
  @override
  Future<SportsEntitlement> build() async {
    final cached = PurchaseService.currentSportsEntitlement;
    if (cached != SportsEntitlement.none) {
      return cached;
    }
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<SportsEntitlement> _load() async {
    final hasSportsPlan = await PurchaseService.isSportsPlanUnlocked();
    final hasSportsPro = await PurchaseService.isSportsProUnlocked();
    return PurchaseService.cacheSportsEntitlement(
      SportsEntitlement(
        hasSportsPlan: hasSportsPlan,
        hasSportsPro: hasSportsPro,
      ),
    );
  }
}
