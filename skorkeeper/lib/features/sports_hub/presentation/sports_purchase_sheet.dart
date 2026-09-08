import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/monetization/purchase_service.dart';
import '../../../core/monetization/sports_entitlement.dart';
import '../application/sports_entitlement_notifier.dart';

enum SportsPurchaseTier { sportsPlan, sportsPro }

Future<void> showSportsPurchaseSheet(
  BuildContext context, {
  required SportsPurchaseTier tier,
  bool showUpgradePitch = false,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => SportsPurchaseSheet(
      tier: tier,
      showUpgradePitch: showUpgradePitch,
    ),
  );
}

class SportsPurchaseSheet extends ConsumerStatefulWidget {
  const SportsPurchaseSheet({
    required this.tier,
    this.showUpgradePitch = false,
    super.key,
  });

  final SportsPurchaseTier tier;
  final bool showUpgradePitch;

  @override
  ConsumerState<SportsPurchaseSheet> createState() => _SportsPurchaseSheetState();
}

class _SportsPurchaseSheetState extends ConsumerState<SportsPurchaseSheet> {
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final entitlement = ref.watch(sportsEntitlementNotifierProvider).valueOrNull ??
        SportsEntitlement.none;
    final isPlan = widget.tier == SportsPurchaseTier.sportsPlan;
    final title = widget.showUpgradePitch || (!isPlan && entitlement.hasSportsPlan)
        ? 'Unlock Sports Pro'
        : isPlan
            ? 'Unlock Sports Plan'
            : 'Unlock Sports Pro';
    final price = isPlan ? '\$6.99' : '\$19.99';
    final features = isPlan
        ? const [
            'All 8 sports modules (incl. Hockey & Lacrosse)',
            'Real-time timers',
            'Game notes',
            'Saved game history',
          ]
        : const [
            'In-depth player tracking for every sport',
            'Export to PDF / CSV / JSON',
            'Season analytics dashboard',
            'Unlimited game history',
          ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              widget.showUpgradePitch
                  ? 'Upgrade once and keep every premium sports feature forever.'
                  : 'One-time purchase. Yours forever.',
            ),
            const SizedBox(height: 16),
            for (final feature in features)
              ListTile(
                dense: true,
                leading: const Icon(Icons.check_circle_outline),
                title: Text(feature),
              ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 16),
            Semantics(
              label: isPlan ? 'Purchase Sports Plan' : 'Purchase Sports Pro',
              button: true,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _loading ? null : _purchase,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Purchase $price'),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _loading ? null : _restore,
                child: const Text('Restore Purchases'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchase() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final success = widget.tier == SportsPurchaseTier.sportsPlan
          ? await PurchaseService.purchaseSportsPlan()
          : await PurchaseService.purchaseSportsPro();
      if (!success) {
        setState(() => _error = 'Purchase could not be completed.');
        return;
      }
      await ref.read(sportsEntitlementNotifierProvider.notifier).refresh();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sports unlocked.')),
        );
      }
    } on PlatformException catch (error) {
      final cancelled = error.code.toLowerCase().contains('cancel');
      if (!cancelled) {
        setState(() => _error = 'Purchase failed. Please try again.');
      }
    } catch (_) {
      setState(() => _error = 'Purchase failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _restore() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final restored = await PurchaseService.restoreSportsPurchases();
      PurchaseService.cacheSportsEntitlement(
        SportsEntitlement(
          hasSportsPlan: restored.hasSportsPlan,
          hasSportsPro: restored.hasSportsPro,
        ),
      );
      await ref.read(sportsEntitlementNotifierProvider.notifier).refresh();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchases restored.')),
        );
      }
    } catch (_) {
      setState(() => _error = 'Unable to restore purchases.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
}

class SportsPurchaseScreen extends StatelessWidget {
  const SportsPurchaseScreen({
    required this.tier,
    this.showUpgradePitch = false,
    super.key,
  });

  final SportsPurchaseTier tier;
  final bool showUpgradePitch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sports Purchase')),
      body: SportsPurchaseSheet(tier: tier, showUpgradePitch: showUpgradePitch),
    );
  }
}
