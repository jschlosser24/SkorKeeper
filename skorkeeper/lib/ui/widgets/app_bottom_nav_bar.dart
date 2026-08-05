import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(index, initialLocation: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary;
    return Scaffold(
      body: TweenAnimationBuilder<double>(
        key: ValueKey<int>(navigationShell.currentIndex),
        tween: Tween<double>(begin: 0.96, end: 1),
        duration: const Duration(milliseconds: 150),
        builder: (context, value, child) =>
            Opacity(opacity: value.clamp(0, 1), child: child),
        child: navigationShell,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: theme.brightness == Brightness.light
              ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.55)
              : const Color(0xFF2A2A3E),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            return IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? selectedColor
                  : theme.colorScheme.onSurfaceVariant,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            return theme.textTheme.labelMedium!.copyWith(
              color: states.contains(WidgetState.selected)
                  ? selectedColor
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: [
            NavigationDestination(
              icon: Semantics(
                label: 'Games tab',
                child: const Icon(Icons.sports_esports),
              ),
              selectedIcon: const Icon(Icons.sports_esports),
              label: 'Games',
            ),
            NavigationDestination(
              icon: Semantics(
                label: 'Tools tab',
                child: const Icon(Icons.build_circle_outlined),
              ),
              selectedIcon: const Icon(Icons.build_circle),
              label: 'Tools',
            ),
            NavigationDestination(
              icon: Semantics(
                label: 'History tab',
                child: const Icon(Icons.history),
              ),
              selectedIcon: const Icon(Icons.history_rounded),
              label: 'History',
            ),
            NavigationDestination(
              icon: Semantics(
                label: 'Settings tab',
                child: const Icon(Icons.settings),
              ),
              selectedIcon: const Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
