import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../../sports_hub/application/sports_entitlement_notifier.dart';
import '../../shared/roster_editor.dart';
import '../../shared/sport_session_helper.dart';
import '../domain/tennis_state.dart';

class TennisSetupScreen extends ConsumerStatefulWidget {
  const TennisSetupScreen({super.key});

  @override
  ConsumerState<TennisSetupScreen> createState() => _TennisSetupScreenState();
}

class _TennisSetupScreenState extends ConsumerState<TennisSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _homeController = TextEditingController(text: 'Player 1');
  final _awayController = TextEditingController(text: 'Player 2');
  final _homeRoster = RosterEditController();
  final _awayRoster = RosterEditController();
  String _format = 'best_of_3';
  String _servingTeamId = 'home';
  bool _addRoster = false;

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
    final canUseRoster = entitlement?.canAccessProFeatures ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Tennis Setup')),
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
                labelText: 'Home player / team',
                border: OutlineInputBorder(),
              ),
              validator: _validateName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _awayController,
              decoration: const InputDecoration(
                labelText: 'Away player / team',
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
                DropdownMenuItem(value: 'best_of_3', child: Text('Best of 3')),
                DropdownMenuItem(value: 'best_of_5', child: Text('Best of 5')),
                DropdownMenuItem(value: 'best_of_7', child: Text('Best of 7')),
                DropdownMenuItem(value: 'one_set', child: Text('One Set')),
                DropdownMenuItem(value: 'pro_set', child: Text('Pro Set')),
              ],
              onChanged: (value) => setState(() => _format = value ?? _format),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _servingTeamId,
              decoration: const InputDecoration(
                labelText: 'Serving team',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'home', child: Text('Home')),
                DropdownMenuItem(value: 'away', child: Text('Away')),
              ],
              onChanged: (value) =>
                  setState(() => _servingTeamId = value ?? _servingTeamId),
            ),
            SwitchListTile(
              title: const Text('Add Roster'),
              subtitle: Text(
                canUseRoster
                    ? 'Enable in-depth player tracking (for doubles teams).'
                    : 'Sports Pro required.',
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
    final sportSpecific = TennisStateHelper.initial(format: _format);
    sportSpecific['servingTeamId'] = _servingTeamId;
    final trackingMode = _addRoster ? TrackingMode.inDepth : TrackingMode.basic;
    final state = SportGameState(
      sportType: SportType.tennis,
      trackingMode: trackingMode,
      homeTeam: SportTeam(
        id: 'home',
        name: _homeController.text.trim(),
        roster: _addRoster ? _homeRoster.buildRoster('home') : null,
        stats: TennisStateHelper.initialTeamStats(),
      ),
      awayTeam: SportTeam(
        id: 'away',
        name: _awayController.text.trim(),
        roster: _addRoster ? _awayRoster.buildRoster('away') : null,
        stats: TennisStateHelper.initialTeamStats(),
      ),
      gameFormat: _format,
      gamePhase: GamePhase.active,
      sportSpecific: sportSpecific,
    );
    final sessionId = await createSportSession(
      ref,
      gameType: SportType.tennis.gameTypeId,
      sessionName: '${_awayController.text.trim()} vs ${_homeController.text.trim()}',
      participants: createTeamSessionPlayers(
        _homeController.text.trim(),
        _awayController.text.trim(),
      ),
      state: state,
    );
    if (mounted) {
      context.go('/sports/tennis/game?sessionId=$sessionId');
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
