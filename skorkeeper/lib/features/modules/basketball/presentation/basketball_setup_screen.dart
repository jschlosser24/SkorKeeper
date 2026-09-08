import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../../sports_hub/application/sports_entitlement_notifier.dart';
import '../../shared/roster_editor.dart';
import '../../shared/sport_session_helper.dart';
import '../domain/basketball_state.dart';

class BasketballSetupScreen extends ConsumerStatefulWidget {
  const BasketballSetupScreen({super.key});

  @override
  ConsumerState<BasketballSetupScreen> createState() =>
      _BasketballSetupScreenState();
}

class _BasketballSetupScreenState extends ConsumerState<BasketballSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _homeController = TextEditingController(text: 'Home');
  final _awayController = TextEditingController(text: 'Away');
  final _homeRoster = RosterEditController();
  final _awayRoster = RosterEditController();
  final _periodMinutesController = TextEditingController(
    text: '${BasketballStateHelper.defaultPeriodDurationSeconds ~/ 60}',
  );
  final _timeoutsController = TextEditingController(text: '5');
  String _format = 'full';
  bool _addRoster = false;

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    _homeRoster.dispose();
    _awayRoster.dispose();
    _periodMinutesController.dispose();
    _timeoutsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entitlement = ref.watch(sportsEntitlementNotifierProvider).valueOrNull;
    final canUseRoster = entitlement?.canAccessProFeatures ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Basketball Setup')),
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
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'full', label: Text('Full')),
                ButtonSegment(value: 'halves', label: Text('Halves')),
                ButtonSegment(value: 'scrimmage', label: Text('Scrimmage')),
              ],
              selected: {_format},
              onSelectionChanged: (value) => setState(() => _format = value.first),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _periodMinutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quarter length (minutes)',
                border: OutlineInputBorder(),
              ),
              validator: _validateMinutes,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _timeoutsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Timeouts per team',
                border: OutlineInputBorder(),
              ),
              validator: _validateTimeouts,
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
    final trackingMode = _addRoster ? TrackingMode.inDepth : TrackingMode.basic;
    final timeoutsPerTeam = _timeoutsValue();
    final state = SportGameState(
      sportType: SportType.basketball,
      trackingMode: trackingMode,
      homeTeam: SportTeam(
        id: 'home',
        name: _homeController.text.trim(),
        roster: _addRoster ? _homeRoster.buildRoster('home') : null,
        stats: BasketballStateHelper.initialTeamStats(timeoutsPerTeam: timeoutsPerTeam),
      ),
      awayTeam: SportTeam(
        id: 'away',
        name: _awayController.text.trim(),
        roster: _addRoster ? _awayRoster.buildRoster('away') : null,
        stats: BasketballStateHelper.initialTeamStats(timeoutsPerTeam: timeoutsPerTeam),
      ),
      gameFormat: _format,
      gamePhase: GamePhase.active,
      sportSpecific: BasketballStateHelper.initial(
        format: _format,
        periodDurationSeconds: _periodMinutes() * 60,
      ),
    );
    final sessionId = await createSportSession(
      ref,
      gameType: SportType.basketball.gameTypeId,
      sessionName: '${_awayController.text.trim()} at ${_homeController.text.trim()}',
      participants: createTeamSessionPlayers(
        _homeController.text.trim(),
        _awayController.text.trim(),
      ),
      state: state,
    );
    if (mounted) {
      context.go('/sports/basketball/game?sessionId=$sessionId');
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

  String? _validateTimeouts(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed < 0 || parsed > 20) {
      return 'Enter 0-20 timeouts';
    }
    return null;
  }

  int _periodMinutes() {
    return int.tryParse(_periodMinutesController.text.trim()) ??
        (BasketballStateHelper.defaultPeriodDurationSeconds ~/ 60);
  }

  int _timeoutsValue() {
    return int.tryParse(_timeoutsController.text.trim()) ?? 5;
  }
}
