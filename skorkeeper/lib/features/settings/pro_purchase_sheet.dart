import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/pro_state_provider.dart';

Future<void> showProPurchaseSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _ProPurchaseSheet(),
  );
}

class _ProPurchaseSheet extends ConsumerStatefulWidget {
  const _ProPurchaseSheet();

  @override
  ConsumerState<_ProPurchaseSheet> createState() => _ProPurchaseSheetState();
}

class _ProPurchaseSheetState extends ConsumerState<_ProPurchaseSheet> {
  bool _loading = false;
  String? _errorMessage;

  static const _benefits = [
    (
      icon: Icons.block,
      label: 'Ad-Free Experience',
      detail: 'No banners, no interruptions',
    ),
    (
      icon: Icons.palette,
      label: 'All 7 Premium Themes',
      detail:
          'Purple Reign, Sunset Blitz, Arctic Fox, Neon Jungle, Royal Crimson, Ocean Deep, Golden Hour',
    ),
    (
      icon: Icons.history,
      label: 'Unlimited History',
      detail: 'Keep every game session forever',
    ),
    (
      icon: Icons.share,
      label: 'Export to CSV',
      detail: 'Share scorecards via your system share sheet',
    ),
    (
      icon: Icons.color_lens,
      label: 'Custom Player Colors',
      detail: 'Personalize each player across all modules',
    ),
    (
      icon: Icons.music_note,
      label: 'Sound Pack Customization',
      detail: 'Choose your vibe',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isPro = ref.watch(proStateNotifierProvider).valueOrNull ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '⭐ SkorKeeper Pro',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'One-time purchase. Yours forever.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            ..._benefits.map(
              (b) => ListTile(
                dense: true,
                leading: Icon(b.icon, color: cs.tertiary),
                title: Text(
                  b.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(b.detail),
              ),
            ),
            const SizedBox(height: 16),
            if (isPro) ...[
              Icon(Icons.check_circle, color: cs.tertiary, size: 32),
              const SizedBox(height: 8),
              Text(
                'You already have SkorKeeper Pro!',
                style: TextStyle(
                  color: cs.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else ...[
              if (_errorMessage != null) ...[
                Text(_errorMessage!, style: TextStyle(color: cs.error)),
                const SizedBox(height: 8),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _loading ? null : _purchase,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Unlock Pro — \$3.99'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _loading ? null : _restore,
                  child: const Text('Restore Purchases'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _purchase() async {
    if (!await _hasConnection()) {
      setState(
        () =>
            _errorMessage = 'Connect to the internet to unlock SkorKeeper Pro.',
      );
      return;
    }
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final success = await ref
          .read(proStateNotifierProvider.notifier)
          .purchasePro();
      if (mounted && success) {
        Navigator.of(context).pop();
      } else if (mounted) {
        setState(() => _errorMessage = 'Purchase could not be completed.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _restore() async {
    if (!await _hasConnection()) {
      setState(
        () => _errorMessage = 'Connect to the internet to restore purchases.',
      );
      return;
    }
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final success = await ref
          .read(proStateNotifierProvider.notifier)
          .restorePurchases();
      if (mounted && success) {
        Navigator.of(context).pop();
      } else if (mounted) {
        setState(() => _errorMessage = 'No previous purchase found.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<bool> _hasConnection() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
