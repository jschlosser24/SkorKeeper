import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../../shared_session/session_setup_scaffold.dart';
import '../domain/uno_module.dart';

class UnoSetupScreen extends ConsumerStatefulWidget {
  const UnoSetupScreen({super.key});

  @override
  ConsumerState<UnoSetupScreen> createState() => _UnoSetupScreenState();
}

class _UnoSetupScreenState extends ConsumerState<UnoSetupScreen> {
  double _targetScore = 500;

  @override
  Widget build(BuildContext context) {
    final names =
        ref
            .watch(preferencesNotifierProvider)
            .valueOrNull
            ?.defaultPlayerNames ??
        const <String>[];
    final module = UnoModule(targetScore: _targetScore.round());
    return SessionSetupScaffold(
      module: module,
      initialPlayerNames: names,
      extraContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Target score', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _targetScore,
            min: 100,
            max: 1000,
            divisions: 18,
            label: _targetScore.round().toString(),
            onChanged: (value) => setState(() => _targetScore = value),
          ),
          Text(_targetScore.round().toString()),
        ],
      ),
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
