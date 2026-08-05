import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../../../features/shared_session/session_setup_scaffold.dart';
import '../domain/darts_301_module.dart';
import '../domain/darts_501_module.dart';
import '../domain/darts_701_module.dart';
import '../domain/darts_around_the_clock_module.dart';
import '../domain/darts_cricket_module.dart';
import '../domain/darts_cut_throat_module.dart';
import '../domain/darts_halve_it_module.dart';
import '../domain/darts_killer_module.dart';
import '../domain/darts_shanghai_module.dart';
import '../domain/darts_module_base.dart';

class DartsSetupScreen extends ConsumerStatefulWidget {
  const DartsSetupScreen({required this.gameTypeId, super.key});

  final String gameTypeId;

  @override
  ConsumerState<DartsSetupScreen> createState() => _DartsSetupScreenState();
}

class _DartsSetupScreenState extends ConsumerState<DartsSetupScreen> {
  bool _doubleIn = false;
  bool _doubleOut = false;

  bool get _isX01 =>
      {'darts301', 'darts501', 'darts701'}.contains(widget.gameTypeId);

  DartsModuleBase _buildModule() {
    switch (widget.gameTypeId) {
      case 'darts301':
        return Darts301Module(doubleIn: _doubleIn, doubleOut: _doubleOut);
      case 'darts701':
        return Darts701Module(doubleIn: _doubleIn, doubleOut: _doubleOut);
      case 'dartsCricket':
        return const DartsCricketModule();
      case 'dartsCutThroat':
        return const DartsCutThroatModule();
      case 'dartsAroundTheClock':
        return const DartsAroundTheClockModule();
      case 'dartsShanghai':
        return const DartsShanghaiModule();
      case 'dartsKiller':
        return const DartsKillerModule();
      case 'dartsHalveIt':
        return const DartsHalveItModule();
      default:
        return Darts501Module(doubleIn: _doubleIn, doubleOut: _doubleOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final names =
        ref
            .watch(preferencesNotifierProvider)
            .valueOrNull
            ?.defaultPlayerNames ??
        const <String>[];
    final module = _buildModule();
    return SessionSetupScaffold(
      module: module,
      initialPlayerNames: names,
      extraContent: !_isX01
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  value: _doubleIn,
                  onChanged: (value) => setState(() => _doubleIn = value),
                  title: const Text('Double in'),
                ),
                SwitchListTile(
                  value: _doubleOut,
                  onChanged: (value) => setState(() => _doubleOut = value),
                  title: const Text('Double out'),
                ),
              ],
            ),
      onStartGame: (result) async {
        final liveModule = _buildModule();
        final sessionId = await ref
            .read(activeSessionsNotifierProvider.notifier)
            .createSession(
              gameType: liveModule.gameTypeId,
              sessionName: result.sessionName,
              players: result.players,
              initialModuleState: liveModule.initialState(result.players),
            );
        if (context.mounted) {
          context.go('/home/session/$sessionId');
        }
      },
    );
  }
}
