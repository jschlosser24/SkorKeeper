import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../../../features/shared_session/session_setup_scaffold.dart';
import '../domain/cribbage_module.dart';

class CribbageSetupScreen extends ConsumerWidget {
  const CribbageSetupScreen({super.key});

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
      module: const CribbageModule(),
      initialPlayerNames: names.take(3).toList(),
      initialPlayerColors: colors.take(3).toList(),
      participantPluralLabel: 'Teams',
      participantSingularLabel: 'Team',
      onStartGame: (result) async {
        final teams = result.players.take(3).toList();
        final sessionId = await ref
            .read(activeSessionsNotifierProvider.notifier)
            .createSession(
              gameType: const CribbageModule().gameTypeId,
              sessionName: result.sessionName,
              players: teams,
              initialModuleState: const CribbageModule().initialState(teams),
            );
        if (context.mounted) {
          context.go('/home/session/$sessionId');
        }
      },
    );
  }
}
