import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../core/monetization/purchase_service.dart';

Future<void> showTipJarSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _TipJarSheet(),
  );
}

class _TipJarSheet extends StatefulWidget {
  const _TipJarSheet();

  @override
  State<_TipJarSheet> createState() => _TipJarSheetState();
}

class _TipJarSheetState extends State<_TipJarSheet> {
  static const _tiers = <({String productId, String emoji, String label, String price, String subtitle})>[
    (
      productId: PurchaseKeys.tipSmall,
      emoji: '☕',
      label: 'Small Tip',
      price: r'$0.99',
      subtitle: 'Buy me a coffee',
    ),
    (
      productId: PurchaseKeys.tipMedium,
      emoji: '🍕',
      label: 'Medium Tip',
      price: r'$2.99',
      subtitle: 'Buy me a slice',
    ),
    (
      productId: PurchaseKeys.tipLarge,
      emoji: '🎉',
      label: 'Big Tip',
      price: r'$4.99',
      subtitle: 'You\'re amazing!',
    ),
  ];

  String? _loadingProductId;
  String? _errorMessage;
  bool _thanked = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
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
          const Text('❤️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            'Support SkorKeeper',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'SkorKeeper is built by one developer. If it\'s made game night more fun, a tip means the world.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          if (_thanked) ...[
            Icon(Icons.favorite, color: cs.error, size: 48),
            const SizedBox(height: 12),
            Text(
              'Thank you so much! 🙏',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your support keeps this app alive.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ] else ...[
            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: TextStyle(color: cs.error)),
              const SizedBox(height: 12),
            ],
            for (final tier in _tiers) ...[
              _TipTile(
                emoji: tier.emoji,
                label: tier.label,
                price: tier.price,
                subtitle: tier.subtitle,
                loading: _loadingProductId == tier.productId,
                disabled: _loadingProductId != null,
                onTap: () => _tip(tier.productId),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _tip(String productId) async {
    if (!await _hasConnection()) {
      setState(
        () => _errorMessage = 'Connect to the internet to send a tip.',
      );
      return;
    }
    setState(() {
      _loadingProductId = productId;
      _errorMessage = null;
    });
    try {
      final success = await PurchaseService.purchaseTip(productId);
      if (mounted && success) {
        setState(() => _thanked = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Could not complete tip: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _loadingProductId = null);
      }
    }
  }

  Future<bool> _hasConnection() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}

class _TipTile extends StatelessWidget {
  const _TipTile({
    required this.emoji,
    required this.label,
    required this.price,
    required this.subtitle,
    required this.loading,
    required this.disabled,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final String price;
  final String subtitle;
  final bool loading;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: disabled ? null : onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          side: BorderSide(color: cs.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
              )
            : Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
