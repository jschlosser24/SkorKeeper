import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../../../features/shared_session/session_setup_scaffold.dart';
import '../domain/custom_game_module.dart';
import '../domain/custom_game_state.dart';

class CustomSetupScreen extends ConsumerStatefulWidget {
  const CustomSetupScreen({super.key});

  @override
  ConsumerState<CustomSetupScreen> createState() => _CustomSetupScreenState();
}

class _CustomSetupScreenState extends ConsumerState<CustomSetupScreen> {
  ScoreDirection _scoreDirection = ScoreDirection.highWins;

  @override
  Widget build(BuildContext context) {
    final names =
        ref
            .watch(preferencesNotifierProvider)
            .valueOrNull
            ?.defaultPlayerNames ??
        const <String>[];
    return SessionSetupScaffold(
      module: const CustomGameModule(),
      appBarTitle: 'Custom Scoring Setup',
      initialPlayerNames: names,
      sessionNameLabel: 'Game name (optional)',
      initialSessionName: 'Custom Game',
      extraContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score direction',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<ScoreDirection>(
            style: SegmentedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
              selectedForegroundColor: Theme.of(
                context,
              ).colorScheme.onSecondaryContainer,
              selectedBackgroundColor: Theme.of(
                context,
              ).colorScheme.secondaryContainer,
            ),
            segments: const [
              ButtonSegment(
                value: ScoreDirection.highWins,
                label: Text('High Wins'),
              ),
              ButtonSegment(
                value: ScoreDirection.lowWins,
                label: Text('Low Wins'),
              ),
            ],
            selected: <ScoreDirection>{_scoreDirection},
            onSelectionChanged: (value) {
              setState(() => _scoreDirection = value.first);
            },
          ),
        ],
      ),
      onStartGame: (result) async {
        final gameName = result.sessionName?.trim().isNotEmpty == true
            ? result.sessionName!.trim()
            : 'Custom Game';
        final sessionId = await ref
            .read(activeSessionsNotifierProvider.notifier)
            .createSession(
              gameType: const CustomGameModule().gameTypeId,
              sessionName: result.sessionName,
              players: result.players,
              initialModuleState: CustomGameState(
                gameName: gameName,
                roundLabels: const <String>[],
                scoreDirection: _scoreDirection,
              ).toJson(),
            );
        if (context.mounted) {
          context.go('/home/session/$sessionId');
        }
      },
    );
  }
}
