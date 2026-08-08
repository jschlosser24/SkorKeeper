import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../../../features/shared_session/session_setup_scaffold.dart';
import '../domain/yahtzee_module.dart';
import '../domain/yahtzee_state.dart';

class YahtzeeSetupScreen extends ConsumerStatefulWidget {
  const YahtzeeSetupScreen({super.key});

  @override
  ConsumerState<YahtzeeSetupScreen> createState() => _YahtzeeSetupScreenState();
}

class _YahtzeeSetupScreenState extends ConsumerState<YahtzeeSetupScreen> {
  bool _useRealDice = false;

  @override
  Widget build(BuildContext context) {
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
      module: const YahtzeeModule(),
      initialPlayerNames: names,
      initialPlayerColors: colors,
      extraContent: _buildDiceModeToggle(context),
      onStartGame: (result) async {
        final initialState = YahtzeeState(
          currentPlayerIndex: 0,
          currentRollNumber: 0,
          diceValues: const [1, 1, 1, 1, 1],
          diceHeld: const [false, false, false, false, false],
          scorecards: {
            for (final player in result.players)
              player.id: const YahtzeeScorecard(),
          },
          playerOrder: result.players.map((p) => p.id).toList(),
          useRealDice: _useRealDice,
        ).toJson();
        final sessionId = await ref
            .read(activeSessionsNotifierProvider.notifier)
            .createSession(
              gameType: const YahtzeeModule().gameTypeId,
              sessionName: result.sessionName,
              players: result.players,
              initialModuleState: initialState,
            );
        if (context.mounted) {
          context.go('/home/session/$sessionId');
        }
      },
    );
  }

  Widget _buildDiceModeToggle(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dice Mode', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            RadioListTile<bool>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: false,
              groupValue: _useRealDice,
              onChanged: (v) => setState(() => _useRealDice = v!),
              title: const Text('App dice (default)'),
              subtitle: const Text('Roll dice on your phone'),
            ),
            RadioListTile<bool>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: true,
              groupValue: _useRealDice,
              onChanged: (v) => setState(() => _useRealDice = v!),
              title: const Text('Real dice'),
              subtitle: const Text('Enter scores manually — no on-screen dice'),
            ),
          ],
        ),
      ),
    );
  }
}
