import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/modules/game_module_registry.dart';
import '../../../core/modules/sport_enums.dart';
import '../../modules/shared/sport_module_utils.dart';
import '../application/sports_entitlement_notifier.dart';
import 'sports_purchase_sheet.dart';

class SportsHubScreen extends ConsumerWidget {
  const SportsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlement = ref.watch(sportsEntitlementNotifierProvider);
    final modules = GameModuleRegistry.sportModules;
    return Scaffold(
      appBar: AppBar(title: const Text('Sports')),
      body: entitlement.when(
        data: (entitlementValue) => GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: modules.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final module = modules[index];
            final sport = SportType.values.firstWhere(
              (value) => value.gameTypeId == module.gameTypeId,
            );
            final locked = !entitlementValue.canAccess(sport);
            return Semantics(
              label: locked
                  ? 'Locked — ${sport.requiresPro ? 'Sports Pro only' : 'Sports Plan required'}'
                  : '${sport.displayName} unlocked',
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    if (locked) {
                      showSportsPurchaseSheet(
                        context,
                        tier: sport.requiresPro
                            ? SportsPurchaseTier.sportsPro
                            : SportsPurchaseTier.sportsPlan,
                        showUpgradePitch: sport.requiresPro,
                      );
                    } else {
                      context.go('/sports/${sport.name}/setup');
                    }
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(SportModuleUtils.iconForSport(sport), size: 44),
                            const SizedBox(height: 12),
                            Text(
                              sport.displayName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      if (locked)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.35),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.lock, color: Colors.white),
                                const SizedBox(height: 8),
                                Text(
                                  sport.requiresPro
                                      ? 'Sports Pro Only'
                                      : 'Sports Plan',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}
