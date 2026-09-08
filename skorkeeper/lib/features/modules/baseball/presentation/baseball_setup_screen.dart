import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../../sports_hub/application/sports_entitlement_notifier.dart';
import '../../shared/roster_editor.dart';
import '../../shared/sport_session_helper.dart';
import '../domain/baseball_state.dart';

class BaseballSetupScreen extends ConsumerStatefulWidget {
  const BaseballSetupScreen({super.key});

  @override
  ConsumerState<BaseballSetupScreen> createState() => _BaseballSetupScreenState();
}

class _BaseballSetupScreenState extends ConsumerState<BaseballSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _homeController = TextEditingController(text: 'Home');
  final _awayController = TextEditingController(text: 'Away');
  final _homeLineup = RosterEditController();
  final _awayLineup = RosterEditController();
  int _innings = 9;
  bool _scrimmage = false;
  bool _addLineup = false;

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    _homeLineup.dispose();
    _awayLineup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entitlement = ref.watch(sportsEntitlementNotifierProvider).valueOrNull;
    final canUseLineup = entitlement?.canAccessProFeatures ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Baseball Setup')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).padding.bottom,
          ),
          children: [
            TextFormField(
              controller: _homeController,
              maxLength: 40,
              decoration: const InputDecoration(
                labelText: 'Home team',
                border: OutlineInputBorder(),
              ),
              validator: _validateName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _awayController,
              maxLength: 40,
              decoration: const InputDecoration(
                labelText: 'Away team',
                border: OutlineInputBorder(),
              ),
              validator: _validateName,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _innings,
              decoration: const InputDecoration(
                labelText: 'Number of innings',
                border: OutlineInputBorder(),
              ),
              items: [
                for (var i = 1; i <= 9; i++)
                  DropdownMenuItem(value: i, child: Text('$i inning${i == 1 ? '' : 's'}')),
              ],
              onChanged: _scrimmage
                  ? null
                  : (value) => setState(() => _innings = value ?? _innings),
            ),
            SwitchListTile(
              title: const Text('Scrimmage'),
              subtitle: const Text('No inning limit — end the game manually.'),
              value: _scrimmage,
              onChanged: (value) => setState(() => _scrimmage = value),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Enter Batting Lineup'),
              subtitle: Text(
                canUseLineup
                    ? 'Track each batter\'s stats through the order.'
                    : 'Sports Pro required.',
              ),
              value: _addLineup && canUseLineup,
              onChanged: canUseLineup ? (value) => setState(() => _addLineup = value) : null,
            ),
            if (_addLineup && canUseLineup) ...[
              RosterEditorField(
                controller: _homeLineup,
                label: 'Home lineup',
                addLabel: 'Add Batter',
              ),
              const SizedBox(height: 12),
              RosterEditorField(
                controller: _awayLineup,
                label: 'Away lineup',
                addLabel: 'Add Batter',
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _startGame,
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startGame() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final useLineup = _addLineup &&
        (ref.read(sportsEntitlementNotifierProvider).valueOrNull?.canAccessProFeatures ?? false);
    final format = _scrimmage ? 'scrimmage' : 'innings_$_innings';
    final state = SportGameState(
      sportType: SportType.baseball,
      trackingMode: useLineup ? TrackingMode.inDepth : TrackingMode.basic,
      homeTeam: SportTeam(
        id: 'home',
        name: _homeController.text.trim(),
        roster: useLineup ? _homeLineup.buildRoster('home') : null,
        stats: BaseballStateHelper.initialTeamStats(),
      ),
      awayTeam: SportTeam(
        id: 'away',
        name: _awayController.text.trim(),
        roster: useLineup ? _awayLineup.buildRoster('away') : null,
        stats: BaseballStateHelper.initialTeamStats(),
      ),
      gameFormat: format,
      gamePhase: GamePhase.active,
      sportSpecific: BaseballStateHelper.initial(format: format),
    );
    final sessionId = await createSportSession(
      ref,
      gameType: SportType.baseball.gameTypeId,
      sessionName: '${_awayController.text.trim()} at ${_homeController.text.trim()}',
      participants: createTeamSessionPlayers(
        _homeController.text.trim(),
        _awayController.text.trim(),
      ),
      state: state,
    );
    if (mounted) {
      context.go('/sports/baseball/game?sessionId=$sessionId');
    }
  }

  String? _validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.length > 40) {
      return 'Enter 1-40 characters';
    }
    return null;
  }
}
