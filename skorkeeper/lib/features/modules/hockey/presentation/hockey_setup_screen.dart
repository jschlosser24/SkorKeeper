import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../../sports_hub/application/sports_entitlement_notifier.dart';
import '../../shared/roster_editor.dart';
import '../../shared/sport_session_helper.dart';
import '../domain/hockey_state.dart';

class HockeySetupScreen extends ConsumerStatefulWidget {
  const HockeySetupScreen({super.key});

  @override
  ConsumerState<HockeySetupScreen> createState() => _HockeySetupScreenState();
}

class _HockeySetupScreenState extends ConsumerState<HockeySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _homeController = TextEditingController(text: 'Home');
  final _awayController = TextEditingController(text: 'Away');
  final _homeRoster = RosterEditController();
  final _awayRoster = RosterEditController();
  final _periodMinutesController = TextEditingController(
    text: '${HockeyStateHelper.defaultPeriodDurationSeconds ~/ 60}',
  );
  String _format = 'full';
  bool _addRoster = false;

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    _homeRoster.dispose();
    _awayRoster.dispose();
    _periodMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entitlement = ref.watch(sportsEntitlementNotifierProvider).valueOrNull;
    final canUseRoster = entitlement?.canAccessProFeatures ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Hockey Setup')),
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
              decoration: const InputDecoration(
                labelText: 'Home team',
                border: OutlineInputBorder(),
              ),
              validator: _validateName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _awayController,
              decoration: const InputDecoration(
                labelText: 'Away team',
                border: OutlineInputBorder(),
              ),
              validator: _validateName,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _format,
              decoration: const InputDecoration(
                labelText: 'Game format',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'full', child: Text('Full Game')),
                DropdownMenuItem(
                  value: 'recreational',
                  child: Text('Recreational'),
                ),
                DropdownMenuItem(value: 'scrimmage', child: Text('Scrimmage')),
              ],
              onChanged: (value) => setState(() => _format = value ?? _format),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _periodMinutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Period length (minutes)',
                border: OutlineInputBorder(),
              ),
              validator: _validateMinutes,
            ),
            SwitchListTile(
              title: const Text('Add Roster'),
              subtitle: Text(
                canUseRoster ? 'Enable in-depth player tracking.' : 'Sports Pro required.',
              ),
              value: _addRoster && canUseRoster,
              onChanged: canUseRoster ? (value) => setState(() => _addRoster = value) : null,
            ),
            if (_addRoster && canUseRoster) ...[
              const SizedBox(height: 12),
              RosterEditorField(controller: _homeRoster, label: 'Home roster'),
              const SizedBox(height: 12),
              RosterEditorField(controller: _awayRoster, label: 'Away roster'),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: _startGame, child: const Text('Start Game')),
          ],
        ),
      ),
    );
  }

  Future<void> _startGame() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final useRoster = _addRoster && (ref.read(sportsEntitlementNotifierProvider).valueOrNull?.canAccessProFeatures ?? false);
    final state = SportGameState(
      sportType: SportType.hockey,
      trackingMode: useRoster ? TrackingMode.inDepth : TrackingMode.basic,
      homeTeam: SportTeam(
        id: 'home',
        name: _homeController.text.trim(),
        roster: useRoster ? _homeRoster.buildRoster('home') : null,
        stats: HockeyStateHelper.initialTeamStats(),
      ),
      awayTeam: SportTeam(
        id: 'away',
        name: _awayController.text.trim(),
        roster: useRoster ? _awayRoster.buildRoster('away') : null,
        stats: HockeyStateHelper.initialTeamStats(),
      ),
      gameFormat: _format,
      gamePhase: GamePhase.active,
      sportSpecific: HockeyStateHelper.initial(
        periodDurationSeconds: _periodMinutes() * 60,
      ),
    );
    final sessionId = await createSportSession(
      ref,
      gameType: SportType.hockey.gameTypeId,
      sessionName: '${_awayController.text.trim()} at ${_homeController.text.trim()}',
      participants: createTeamSessionPlayers(
        _homeController.text.trim(),
        _awayController.text.trim(),
      ),
      state: state,
    );
    if (mounted) {
      context.go('/sports/hockey/game?sessionId=$sessionId');
    }
  }

  String? _validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.length > 40) {
      return 'Enter 1-40 characters';
    }
    return null;
  }

  String? _validateMinutes(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed < 1 || parsed > 60) {
      return 'Enter 1-60 minutes';
    }
    return null;
  }

  int _periodMinutes() {
    return int.tryParse(_periodMinutesController.text.trim()) ??
        (HockeyStateHelper.defaultPeriodDurationSeconds ~/ 60);
  }
}
