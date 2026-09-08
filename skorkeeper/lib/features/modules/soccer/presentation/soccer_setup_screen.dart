import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../../sports_hub/application/sports_entitlement_notifier.dart';
import '../../shared/roster_editor.dart';
import '../../shared/sport_session_helper.dart';
import '../domain/soccer_state.dart';

class SoccerSetupScreen extends ConsumerStatefulWidget {
  const SoccerSetupScreen({super.key});

  @override
  ConsumerState<SoccerSetupScreen> createState() => _SoccerSetupScreenState();
}

class _SoccerSetupScreenState extends ConsumerState<SoccerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _homeController = TextEditingController(text: 'Home');
  final _awayController = TextEditingController(text: 'Away');
  final _homeRoster = RosterEditController();
  final _awayRoster = RosterEditController();
  String _format = 'full';
  bool _inDepth = false;

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    _homeRoster.dispose();
    _awayRoster.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entitlement = ref.watch(sportsEntitlementNotifierProvider).valueOrNull;
    final pro = entitlement?.canAccessProFeatures ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Soccer Setup')),
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
                labelText: 'Match format',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'full', child: Text('Full Match')),
                DropdownMenuItem(value: 'short', child: Text('Short Match')),
                DropdownMenuItem(value: 'scrimmage', child: Text('Scrimmage')),
              ],
              onChanged: (value) => setState(() => _format = value ?? _format),
            ),
            Tooltip(
              message: pro ? 'Enable player attribution.' : 'Sports Pro required',
              child: SwitchListTile(
                title: const Text('In-Depth Mode'),
                subtitle: Text(pro ? 'Track scorers and assists.' : 'Sports Pro required'),
                value: _inDepth && pro,
                onChanged: pro ? (value) => setState(() => _inDepth = value) : null,
              ),
            ),
            if (_inDepth && pro) ...[
              RosterEditorField(controller: _homeRoster, label: 'Home roster'),
              const SizedBox(height: 12),
              RosterEditorField(controller: _awayRoster, label: 'Away roster'),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: _startGame, child: const Text('Start Match')),
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
      sportType: SportType.soccer,
      trackingMode: trackingMode,
      homeTeam: SportTeam(
        id: 'home',
        name: _homeController.text.trim(),
        roster: _inDepth ? _homeRoster.buildRoster('home') : null,
        stats: SoccerStateHelper.initialTeamStats(),
      ),
      awayTeam: SportTeam(
        id: 'away',
        name: _awayController.text.trim(),
        roster: _inDepth ? _awayRoster.buildRoster('away') : null,
        stats: SoccerStateHelper.initialTeamStats(),
      ),
      gameFormat: _format,
      gamePhase: GamePhase.active,
      sportSpecific: SoccerStateHelper.initial(),
    );
    final sessionId = await createSportSession(
      ref,
      gameType: SportType.soccer.gameTypeId,
      sessionName: '${_awayController.text.trim()} at ${_homeController.text.trim()}',
      participants: createTeamSessionPlayers(
        _homeController.text.trim(),
        _awayController.text.trim(),
      ),
      state: state,
    );
    if (mounted) {
      context.go('/sports/soccer/game?sessionId=$sessionId');
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
