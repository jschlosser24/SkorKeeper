import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../../shared_session/session_setup_scaffold.dart';
import '../domain/farkle_module.dart';

class FarkleSetupScreen extends ConsumerStatefulWidget {
  const FarkleSetupScreen({super.key});

  @override
  ConsumerState<FarkleSetupScreen> createState() => _FarkleSetupScreenState();
}

class _FarkleSetupScreenState extends ConsumerState<FarkleSetupScreen> {
  double _targetScore = 10000;

  @override
  Widget build(BuildContext context) {
    final names =
        ref
            .watch(preferencesNotifierProvider)
            .valueOrNull
            ?.defaultPlayerNames ??
        const <String>[];
    final module = FarkleModule(targetScore: _targetScore.round());
    return SessionSetupScaffold(
      module: module,
      initialPlayerNames: names,
      extraContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Target Score', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _targetScore,
            min: 2000,
            max: 20000,
            divisions: 36,
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
