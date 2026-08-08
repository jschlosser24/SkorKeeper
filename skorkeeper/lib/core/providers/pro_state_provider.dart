import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../monetization/purchase_service.dart';

part 'pro_state_provider.g.dart';

@Riverpod(keepAlive: true)
class ProStateNotifier extends _$ProStateNotifier {
  @override
  Future<bool> build() async {
    return PurchaseService.isProUnlocked();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(PurchaseService.isProUnlocked);
  }

  Future<bool> purchasePro() async {
    state = const AsyncLoading();
    try {
      final success = await PurchaseService.purchasePro();
      state = AsyncData(success);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    state = const AsyncLoading();
    try {
      final success = await PurchaseService.restorePurchases();
      state = AsyncData(success);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
