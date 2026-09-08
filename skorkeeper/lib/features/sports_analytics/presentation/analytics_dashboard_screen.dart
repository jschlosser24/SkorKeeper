import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sports_hub/application/sports_entitlement_notifier.dart';
import '../../sports_hub/presentation/sports_purchase_sheet.dart';
import '../application/analytics_notifier.dart';

class AnalyticsDashboardScreen extends ConsumerWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlement = ref.watch(sportsEntitlementNotifierProvider).valueOrNull;
    final isPro = entitlement?.canAccessProFeatures ?? false;
    final summaryAsync = ref.watch(analyticsNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Sports Analytics')),
      body: summaryAsync.when(
        data: (summary) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!isPro)
              Card(
                child: ListTile(
                  title: const Text('Sports Pro Required'),
                  subtitle: const Text(
                    'Upgrade to unlock analytics and advanced export tools.',
                  ),
                  trailing: FilledButton(
                    onPressed: () => showSportsPurchaseSheet(
                      context,
                      tier: SportsPurchaseTier.sportsPro,
                      showUpgradePitch: true,
                    ),
                    child: const Text('Upgrade'),
                  ),
                ),
              ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: summary.gamesPerSport.entries
                  .map(
                    (entry) => SizedBox(
                      width: 180,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(entry.key),
                              Text(
                                '${entry.value}',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                'Avg ${summary.averageScores[entry.key]?.toStringAsFixed(1) ?? '0.0'}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('Scoring Trend', style: Theme.of(context).textTheme.titleLarge),
            for (final item in summary.scoringTrend) ListTile(title: Text(item)),
            const SizedBox(height: 16),
            Text('Sport Metrics', style: Theme.of(context).textTheme.titleLarge),
            for (final entry in summary.sportMetrics.entries)
              ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value),
              ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}
