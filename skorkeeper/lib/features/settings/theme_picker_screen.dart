import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/monetization/theme_catalog.dart';
import '../../core/monetization/theme_definition.dart';
import '../../core/providers/preferences_provider.dart';
import '../../core/providers/pro_state_provider.dart';
import 'pro_purchase_sheet.dart';

class ThemePickerScreen extends ConsumerWidget {
  const ThemePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesNotifierProvider).valueOrNull;
    final isPro = ref.watch(proStateNotifierProvider).valueOrNull ?? false;
    final selectedId = prefs?.selectedThemeId ?? 'midnightWolves';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Theme'),
        actions: [
          if (!isPro)
            TextButton.icon(
              onPressed: () => showProPurchaseSheet(context),
              icon: const Icon(Icons.star_outline),
              label: const Text('Get Pro'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!isPro) ...[
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Unlock All Themes with Pro'),
                subtitle: const Text(
                  'One-time \$3.99 — ad-free + 6 themes + more',
                ),
                trailing: FilledButton(
                  onPressed: () => showProPurchaseSheet(context),
                  child: const Text('Get Pro'),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: ThemeCatalog.all.length,
            itemBuilder: (context, index) {
              final theme = ThemeCatalog.all[index];
              final isSelected = theme.id.name == selectedId;
              final isLocked = theme.isPro && !isPro;
              return _ThemeCard(
                definition: theme,
                isSelected: isSelected,
                isLocked: isLocked,
                onTap: () => _onThemeTap(context, ref, theme, isLocked),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onThemeTap(
    BuildContext context,
    WidgetRef ref,
    AppThemeDefinition theme,
    bool isLocked,
  ) {
    if (isLocked) {
      showProPurchaseSheet(context);
      return;
    }
    ref
        .read(preferencesNotifierProvider.notifier)
        .updateSelectedTheme(theme.id.name);
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.definition,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  final AppThemeDefinition definition;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final previewScheme = definition.schemeFor(brightness);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2.5 : 1,
          ),
          color: isSelected ? cs.primary.withValues(alpha: 0.08) : cs.surface,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(definition.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text(
                    definition.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    definition.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _ThemeMiniPreview(scheme: previewScheme),
                ],
              ),
            ),
            if (isLocked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock, size: 14, color: cs.onSurfaceVariant),
                ),
              ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, size: 14, color: cs.onPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ThemeMiniPreview extends StatelessWidget {
  const _ThemeMiniPreview({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fake app bar
          Container(
            height: 22,
            color: scheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                Text(
                  'SkorKeeper',
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 30,
                  height: 11,
                  decoration: BoxDecoration(
                    color: scheme.tertiary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          // Fake body
          Container(
            color: scheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FakePlayerRow(scheme: scheme, name: 'Player 1', score: '12'),
                const SizedBox(height: 3),
                _FakePlayerRow(scheme: scheme, name: 'Player 2', score: '8'),
                const SizedBox(height: 6),
                Center(
                  child: Container(
                    height: 13,
                    width: 52,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Score',
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FakePlayerRow extends StatelessWidget {
  const _FakePlayerRow({
    required this.scheme,
    required this.name,
    required this.score,
  });

  final ColorScheme scheme;
  final String name;
  final String score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          style: TextStyle(color: scheme.onSurface, fontSize: 7),
        ),
        const Spacer(),
        Text(
          score,
          style: TextStyle(
            color: scheme.tertiary,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
