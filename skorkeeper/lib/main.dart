import 'dart:developer' as developer;

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/app_database.dart';
import 'core/models/game_type.dart';
import 'core/modules/game_module_registry.dart';
import 'core/providers/audio_provider.dart';
import 'core/providers/database_provider.dart';
import 'core/providers/preferences_provider.dart';
import 'core/router/app_router.dart';
import 'features/modules/bowling/domain/bowling_module.dart';
import 'features/modules/dominoes/domain/dominoes_module.dart';
import 'features/modules/custom/domain/custom_game_module.dart';
import 'features/modules/darts/domain/darts_301_module.dart';
import 'features/modules/darts/domain/darts_501_module.dart';
import 'features/modules/darts/domain/darts_701_module.dart';
import 'features/modules/darts/domain/darts_around_the_clock_module.dart';
import 'features/modules/darts/domain/darts_cricket_module.dart';
import 'features/modules/darts/domain/darts_cut_throat_module.dart';
import 'features/modules/darts/domain/darts_halve_it_module.dart';
import 'features/modules/darts/domain/darts_killer_module.dart';
import 'features/modules/darts/domain/darts_shanghai_module.dart';
import 'features/modules/farkle/domain/farkle_module.dart';
import 'features/modules/golf/domain/golf_module.dart';
import 'features/modules/cribbage/domain/cribbage_module.dart';
import 'features/modules/uno/domain/uno_module.dart';
import 'features/modules/yahtzee/domain/yahtzee_module.dart';
import 'ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerModules();
  developer.Timeline.startSync('AppDatabase.open');
  final database = AppDatabase();
  try {
    await database.customSelect('SELECT 1').get();
  } finally {
    developer.Timeline.finishSync();
  }
  final audioSession = await AudioSession.instance;
  await audioSession.configure(
    const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.ambient,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.sonification,
        usage: AndroidAudioUsage.game,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
      androidWillPauseWhenDucked: false,
    ),
  );
  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWith((ref) => database)],
      child: const SkorKeeperApp(),
    ),
  );
}

void _registerModules() {
  GameModuleRegistry.clear();
  final modules = [
    const CustomGameModule(),
    const Darts501Module(),
    const Darts301Module(),
    const Darts701Module(),
    const DartsCricketModule(),
    const DartsCutThroatModule(),
    const DartsAroundTheClockModule(),
    const DartsShanghaiModule(),
    const DartsKillerModule(),
    const DartsHalveItModule(),
    const YahtzeeModule(),
    const Golf9Module(),
    const Golf18Module(),
    const MiniGolfModule(),
    const CribbageModule(),
    const BowlingModule(),
    const FarkleModule(),
    const UnoModule(),
    const DominoesModule(),
  ];
  for (final module in modules) {
    GameModuleRegistry.register(module);
  }
  for (final gameType in GameType.values) {
    assert(GameModuleRegistry.get(gameType.name) != null);
  }
}

class SkorKeeperApp extends ConsumerWidget {
  const SkorKeeperApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Quickstart validation notes:
    // - Automated validation completed for analyze/test/format, history routing,
    //   settings theme wiring, and session persistence coverage placeholder.
    // - Manual spot checks implemented in code for custom, darts, tools,
    //   bowling, farkle, uno, dominoes, history, and theme scenarios.
    final preferences = ref.watch(preferencesNotifierProvider);
    final router = ref.watch(appRouterProvider);
    ref.watch(audioServiceProvider);
    final themeMode = preferences.valueOrNull?.themeMode ?? ThemeMode.system;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SkorKeeper',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
