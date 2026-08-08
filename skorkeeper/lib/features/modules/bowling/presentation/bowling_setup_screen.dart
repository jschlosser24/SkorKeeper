import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../../shared_session/session_setup_scaffold.dart';
import '../domain/bowling_module.dart';

class BowlingSetupScreen extends ConsumerWidget {
  const BowlingSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names =
        ref
            .watch(preferencesNotifierProvider)
            .valueOrNull
            ?.defaultPlayerNames ??
        const <String>[];
    final colors =
        ref
            .watch(preferencesNotifierProvider)
            .valueOrNull
            ?.defaultPlayerColors ??
        const <String>[];
    return SessionSetupScaffold(
      module: const BowlingModule(),
      initialPlayerNames: names,
      initialPlayerColors: colors,
      onStartGame: (result) async {
        final module = const BowlingModule();
        final sessionId = await ref
            .read(activeSessionsNotifierProvider.notifier)
            .createSession(
              gameType: module.gameTypeId,
              sessionName: result.sessionName,
              players: result.players,
              initialModuleState: module.initialState(result.players),
            );
        if (context.mounted) {
          context.go('/home/session/$sessionId');
        }
      },
    );
  }
}
