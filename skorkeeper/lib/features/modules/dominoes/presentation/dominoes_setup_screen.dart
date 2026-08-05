import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../../shared_session/session_setup_scaffold.dart';
import '../domain/dominoes_module.dart';

class DominoesSetupScreen extends ConsumerWidget {
  const DominoesSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names =
        ref
            .watch(preferencesNotifierProvider)
            .valueOrNull
            ?.defaultPlayerNames ??
        const <String>[];
    final module = const DominoesModule();
    return SessionSetupScaffold(
      module: module,
      initialPlayerNames: names,
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
          context.go('/home/session/$sessionId');
        }
      },
    );
  }
}
