import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/history/history_detail_screen.dart';
import '../../features/history/history_list_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/modules/bowling/presentation/bowling_setup_screen.dart';
import '../../features/modules/dominoes/presentation/dominoes_setup_screen.dart';
import '../../features/modules/custom/presentation/custom_setup_screen.dart';
import '../../features/modules/darts/presentation/darts_setup_screen.dart';
import '../../features/modules/darts/presentation/darts_variant_picker_screen.dart';
import '../../features/modules/farkle/presentation/farkle_setup_screen.dart';
import '../../features/modules/golf/presentation/golf_setup_screen.dart';
import '../../features/modules/uno/presentation/uno_setup_screen.dart';
import '../../features/modules/yahtzee/presentation/yahtzee_setup_screen.dart';
import '../../features/modules/cribbage/presentation/cribbage_setup_screen.dart';
import '../../features/settings/faq_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/theme_picker_screen.dart';
import '../../features/settings/updates_screen.dart';
import '../../features/shared_session/game_session_scaffold.dart';
import '../../features/shared_session/session_setup_scaffold.dart';
import '../../features/shared_session/session_summary_screen.dart';
import '../../features/tools/coin/coin_flip_screen.dart';
import '../../features/tools/dice/dice_roller_screen.dart';
import '../../features/tools/lives/lives_counter_screen.dart';
import '../../features/tools/notepad/notepad_detail_screen.dart';
import '../../features/tools/notepad/notepad_list_screen.dart';
import '../../features/tools/spinner/spinner_screen.dart';
import '../../features/tools/stopwatch/stopwatch_screen.dart';
import '../../features/tools/tally/tally_counter_screen.dart';
import '../../features/tools/team_picker/team_picker_screen.dart';
import '../../features/tools/timer/timer_screen.dart';
import '../../features/tools/tools_screen.dart';
import '../../ui/widgets/app_bottom_nav_bar.dart';
import '../modules/game_module_registry.dart';
import '../providers/active_sessions_provider.dart';
import '../providers/database_provider.dart';
import '../providers/preferences_provider.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) async {
      final database = ref.read(appDatabaseProvider);
      final path = state.uri.path;
      final sessionIdParam = state.pathParameters['sessionId'];
      if (sessionIdParam != null) {
        final sessionId = int.tryParse(sessionIdParam);
        if (sessionId == null) {
          return '/home';
        }
        final session = await database.sessionDao.getSession(sessionId);
        if (path.startsWith('/history/')) {
          if (session == null) {
            final history = await database.historyDao.getHistoryRecord(
              sessionId,
            );
            return history == null ? '/home' : null;
          }
          if (session.status != 1) {
            return '/home/session/' + sessionId.toString();
          }
        } else if (session == null) {
          return '/home';
        }
      }
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppBottomNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'new/darts',
                    pageBuilder: (context, state) =>
                        _slideUpPage(state, const DartsVariantPickerScreen()),
                  ),
                  GoRoute(
                    path: 'new/:gameTypeId',
                    pageBuilder: (context, state) => _slideUpPage(
                      state,
                      _SetupRouteScreen(
                        gameTypeId:
                            state.pathParameters['gameTypeId'] ?? 'custom',
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'session/:sessionId',
                    pageBuilder: (context, state) => _slideUpPage(
                      state,
                      GameSessionScaffold(
                        sessionId: int.parse(
                          state.pathParameters['sessionId']!,
                        ),
                      ),
                    ),
                    routes: [
                      GoRoute(
                        path: 'summary',
                        pageBuilder: (context, state) => _fadePage(
                          state,
                          SessionSummaryScreen(
                            sessionId: int.parse(
                              state.pathParameters['sessionId']!,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tools',
                builder: (context, state) => const ToolsScreen(),
                routes: [
                  GoRoute(
                    path: 'dice',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const DiceRollerScreen()),
                  ),
                  GoRoute(
                    path: 'coin',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const CoinFlipScreen()),
                  ),
                  GoRoute(
                    path: 'spinner',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const SpinnerScreen()),
                  ),
                  GoRoute(
                    path: 'timer',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const TimerScreen()),
                  ),
                  GoRoute(
                    path: 'stopwatch',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const StopwatchScreen()),
                  ),
                  GoRoute(
                    path: 'lives',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const LivesCounterScreen()),
                  ),
                  GoRoute(
                    path: 'tally',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const TallyCounterScreen()),
                  ),
                  GoRoute(
                    path: 'notepad',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const NotepadListScreen()),
                    routes: [
                      GoRoute(
                        path: ':noteId',
                        pageBuilder: (context, state) => _slideRightPage(
                          state,
                          NotepadDetailScreen(
                            noteId: int.parse(state.pathParameters['noteId']!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'team-picker',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const TeamPickerScreen()),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryListScreen(),
                routes: [
                  GoRoute(
                    path: ':sessionId',
                    pageBuilder: (context, state) => _slideRightPage(
                      state,
                      HistoryDetailScreen(
                        sessionId: int.parse(
                          state.pathParameters['sessionId']!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'themes',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const ThemePickerScreen()),
                  ),
                  GoRoute(
                    path: 'updates',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const UpdatesScreen()),
                  ),
                  GoRoute(
                    path: 'faq',
                    pageBuilder: (context, state) =>
                        _slideRightPage(state, const FaqScreen()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

CustomTransitionPage<void> _slideUpPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 250),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        ),
      );
    },
  );
}

CustomTransitionPage<void> _slideRightPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 200),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.06, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    },
  );
}

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 300),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

class _SetupRouteScreen extends ConsumerWidget {
  const _SetupRouteScreen({required this.gameTypeId});

  final String gameTypeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (gameTypeId == 'custom') {
      return const CustomSetupScreen();
    }
    if (gameTypeId.startsWith('darts')) {
      return DartsSetupScreen(gameTypeId: gameTypeId);
    }
    if (gameTypeId.startsWith('golf') || gameTypeId == 'minigolf') {
      return GolfSetupScreen(gameTypeId: gameTypeId);
    }
    if (gameTypeId == 'yahtzee') {
      return const YahtzeeSetupScreen();
    }
    if (gameTypeId == 'cribbage') {
      return const CribbageSetupScreen();
    }
    if (gameTypeId == 'bowling') {
      return const BowlingSetupScreen();
    }
    if (gameTypeId == 'farkle') {
      return const FarkleSetupScreen();
    }
    if (gameTypeId == 'uno') {
      return const UnoSetupScreen();
    }
    if (gameTypeId == 'dominoes') {
      return const DominoesSetupScreen();
    }
    final module = GameModuleRegistry.get(gameTypeId);
    if (module == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Unknown game')),
        body: Center(child: Text('No module found for ' + gameTypeId)),
      );
    }
    final preferences = ref.watch(preferencesNotifierProvider);
    final names =
        preferences.valueOrNull?.defaultPlayerNames ?? const <String>[];
    final colors =
        preferences.valueOrNull?.defaultPlayerColors ?? const <String>[];
    return SessionSetupScaffold(
      module: module,
      initialPlayerNames: names,
      initialPlayerColors: colors,
      onStartGame: (result) async {
        final sessionId = await ref
            .read(activeSessionsNotifierProvider.notifier)
            .createSession(
              gameType: module.gameTypeId,
              sessionName: result.sessionName,
              players: result.players,
              initialModuleState: module.initialState(result.players),
            );
        if (context.mounted) {
          context.go('/home/session/' + sessionId.toString());
        }
      },
    );
  }
}
