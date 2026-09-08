import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/monetization/monetized_banner.dart';
import '../../../core/modules/game_module.dart';
import '../../../core/modules/game_module_registry.dart';
import '../../../core/modules/sport_enums.dart';
import '../../../core/providers/active_sessions_provider.dart';
import '../../modules/shared/sport_module_utils.dart';
import '../../sports_hub/application/sports_entitlement_notifier.dart';
import '../../sports_hub/presentation/sports_purchase_sheet.dart';
import '../../../ui/theme/color_tokens.dart';

// -- Game groups ------------------------------------------------------------

class _GameGroup {
  const _GameGroup({
    required this.title,
    required this.icon,
    required this.color,
    required this.gameTypeIds,
  });
  final String title;
  final IconData icon;
  final Color color;
  final List<String> gameTypeIds;
}

const _groups = [
  _GameGroup(
    title: 'Darts',
    icon: Icons.adjust_rounded,
    color: Color(0xFF981D97),
    gameTypeIds: [
      'darts501',
      'darts301',
      'darts701',
      'dartsCricket',
      'dartsCutThroat',
      'dartsAroundTheClock',
      'dartsShanghai',
      'dartsKiller',
      'dartsHalveIt',
    ],
  ),
  _GameGroup(
    title: 'Golf',
    icon: Icons.sports_golf_rounded,
    color: ColorTokens.lakeBlue,
    gameTypeIds: ['golf9', 'minigolf'],
  ),
  _GameGroup(
    title: 'Classic Games',
    icon: Icons.casino_rounded,
    color: ColorTokens.associationGreen,
    gameTypeIds: [
      'yahtzee',
      'cribbage',
      'bowling',
      'farkle',
      'dominoes',
      'uno',
    ],
  ),
  // Sports is kept last so it always appears at the bottom of the list.
  _GameGroup(
    title: 'Sports',
    icon: Icons.sports_baseball_rounded,
    color: Color(0xFFCF5C36),
    gameTypeIds: [
      'sport_baseball',
      'sport_basketball',
      'sport_football',
      'sport_soccer',
      'sport_tennis',
      'sport_volleyball',
      'sport_hockey',
      'sport_lacrosse',
    ],
  ),
];

// -- Screen -----------------------------------------------------------------

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _welcomeChecked = false;
  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final activeSessions = ref.watch(activeSessionsNotifierProvider);
    final allModules = GameModuleRegistry.all;
    _showWelcomeIfNeeded();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkorKeeper'),
      ),
      bottomNavigationBar: const MonetizedBanner(),
      body: activeSessions.when(
        data: (sessions) {
          final activeSession = sessions.isEmpty ? null : sessions.first;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              // Active session resume card
              if (activeSession != null) ...[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.play_circle_fill_rounded),
                    title: const Text('Resume active session'),
                    subtitle: Text(
                      activeSession.sessionName ??
                          _formatGameLabel(activeSession.gameType),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        context.go('/home/session/${activeSession.id}'),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Custom Scoring � always visible, no accordion
              _CustomScoringCard(
                module: allModules.firstWhere(
                  (m) => m.gameTypeId == 'custom',
                  orElse: () => allModules.first,
                ),
              ),
              const SizedBox(height: 8),

              // Accordion groups
              for (final group in _groups) ...[
                _buildGroup(context, group, allModules),
                const SizedBox(height: 4),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }

  Widget _buildGroup(
    BuildContext context,
    _GameGroup group,
    List<GameModule> allModules,
  ) {
    final modules = allModules
        .where((m) => group.gameTypeIds.contains(m.gameTypeId))
        .toList();
    if (modules.isEmpty) return const SizedBox.shrink();

    final isExpanded = _expanded.contains(group.title);
    final iconColor = group.color;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // Remove the default divider that ExpansionTile adds
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (val) {
            setState(() {
              if (val) {
                _expanded.add(group.title);
              } else {
                _expanded.remove(group.title);
              }
            });
          },
          leading: CircleAvatar(
            backgroundColor: iconColor.withValues(alpha: 0.15),
            child: Icon(group.icon, color: iconColor, size: 20),
          ),
          title: Text(
            group.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            '${modules.length} ${modules.length == 1 ? 'game' : 'games'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          children: [
            const Divider(height: 1),
            for (final module in modules) _GameModuleListTile(module: module),
          ],
        ),
      ),
    );
  }

  Future<void> _showWelcomeIfNeeded() async {
    if (_welcomeChecked) return;
    _welcomeChecked = true;
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('welcome_snackbar_seen') ?? false;
    if (seen || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Welcome to SkorKeeper � no account needed, works offline',
          ),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label: 'Got it', onPressed: () {}),
        ),
      );
    });
    await prefs.setBool('welcome_snackbar_seen', true);
  }

  String _formatGameLabel(String gameType) {
    return gameType
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        )
        .split('_')
        .expand((part) => part.split(' '))
        .where((part) => part.isNotEmpty)
        .map((part) {
          final lower = part.toLowerCase();
          if (RegExp(r'^\d+$').hasMatch(lower)) {
            return lower;
          }
          return lower[0].toUpperCase() + lower.substring(1);
        })
        .join(' ');
  }
}

// -- Module list tile --------------------------------------------------------

class _GameModuleListTile extends ConsumerWidget {
  const _GameModuleListTile({required this.module});

  final GameModule module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final entitlement = ref.watch(sportsEntitlementNotifierProvider).valueOrNull;
    final isSport = module.gameTypeId.startsWith('sport_');
    final sport = isSport
        ? SportType.values.firstWhere(
            (value) => value.gameTypeId == module.gameTypeId,
          )
        : null;
    final locked = sport != null && !(entitlement?.canAccess(sport) ?? false);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: sport == null
          ? null
          : CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                SportModuleUtils.iconForSport(sport),
                color: colorScheme.onPrimaryContainer,
              ),
            ),
      title: Text(
        module.displayName,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        module.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${module.minPlayers}-${module.maxPlayers} players',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(locked ? Icons.lock_outline : Icons.chevron_right),
        ],
      ),
      onTap: () {
        if (sport == null) {
          GoRouter.of(context).go('/home/new/${module.gameTypeId}');
          return;
        }
        if (locked) {
          showSportsPurchaseSheet(
            context,
            tier: sport.requiresPro
                ? SportsPurchaseTier.sportsPro
                : SportsPurchaseTier.sportsPlan,
            showUpgradePitch: sport.requiresPro,
          );
          return;
        }
        GoRouter.of(context).go('/sports/${sport.name}/setup');
      },
    );
  }
}

// -- Custom Scoring card -----------------------------------------------------

class _CustomScoringCard extends StatelessWidget {
  const _CustomScoringCard({required this.module});
  final GameModule module;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => GoRouter.of(context).go('/home/new/${module.gameTypeId}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  Icons.table_chart_rounded,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      module.displayName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      module.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
