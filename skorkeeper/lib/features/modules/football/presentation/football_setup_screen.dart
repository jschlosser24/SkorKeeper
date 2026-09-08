import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../../sports_hub/application/sports_entitlement_notifier.dart';
import '../../shared/roster_editor.dart';
import '../../shared/sport_session_helper.dart';
import '../domain/football_state.dart';

class FootballSetupScreen extends ConsumerStatefulWidget {
  const FootballSetupScreen({super.key});

  @override
  ConsumerState<FootballSetupScreen> createState() =>
      _FootballSetupScreenState();
}

class _FootballSetupScreenState extends ConsumerState<FootballSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _homeController = TextEditingController(text: 'Home');
  final _awayController = TextEditingController(text: 'Away');
  final _homeRoster = RosterEditController();
  final _awayRoster = RosterEditController();
  final _periodMinutesController = TextEditingController(
    text: '${FootballStateHelper.defaultPeriodDurationSeconds ~/ 60}',
  );
  String _format = 'full';
  bool _inDepth = false;

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
    final entitlement = ref
        .watch(sportsEntitlementNotifierProvider)
        .valueOrNull;
    final pro = entitlement?.canAccessProFeatures ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Football Setup')),
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
                  value: 'two_minute_drill',
                  child: Text('Two Minute Drill'),
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
                labelText: 'Quarter length (minutes)',
                border: OutlineInputBorder(),
              ),
              validator: _validateMinutes,
            ),
            SwitchListTile(
              title: const Text('In-Depth Stats'),
              subtitle: Text(
                pro ? 'Track player stats.' : 'Sports Pro required',
              ),
              value: _inDepth && pro,
              onChanged: pro
                  ? (value) => setState(() => _inDepth = value)
                  : null,
            ),
            if (_inDepth && pro) ...[
              RosterEditorField(controller: _homeRoster, label: 'Home roster'),
              const SizedBox(height: 12),
              RosterEditorField(controller: _awayRoster, label: 'Away roster'),
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
    final trackingMode = _inDepth ? TrackingMode.inDepth : TrackingMode.basic;
    final state = SportGameState(
      sportType: SportType.football,
      trackingMode: trackingMode,
      homeTeam: SportTeam(
        id: 'home',
        name: _homeController.text.trim(),
        roster: _inDepth
            ? _homeRoster.buildRoster('home')
            : null,
        stats: FootballStateHelper.initialTeamStats(),
      ),
      awayTeam: SportTeam(
        id: 'away',
        name: _awayController.text.trim(),
        roster: _inDepth
            ? _awayRoster.buildRoster('away')
            : null,
        stats: FootballStateHelper.initialTeamStats(),
      ),
      gameFormat: _format,
      gamePhase: GamePhase.active,
      sportSpecific: FootballStateHelper.initial(
        format: _format,
        periodDurationSeconds: _periodMinutes() * 60,
      ),
    );
    final sessionId = await createSportSession(
      ref,
      gameType: SportType.football.gameTypeId,
      sessionName:
          '${_awayController.text.trim()} at ${_homeController.text.trim()}',
      participants: createTeamSessionPlayers(
        _homeController.text.trim(),
        _awayController.text.trim(),
      ),
      state: state,
    );
    if (mounted) {
      context.go('/sports/football/game?sessionId=$sessionId');
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
        (FootballStateHelper.defaultPeriodDurationSeconds ~/ 60);
  }
}
