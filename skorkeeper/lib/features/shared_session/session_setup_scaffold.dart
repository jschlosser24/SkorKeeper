import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/models/session_player.dart';
import '../../core/modules/game_module.dart';
import '../../ui/widgets/player_chip.dart';

class SessionSetupResult {
  const SessionSetupResult({required this.players, this.sessionName});

  final List<SessionPlayer> players;
  final String? sessionName;
}

class SessionSetupScaffold extends StatefulWidget {
  const SessionSetupScaffold({
    required this.module,
    required this.onStartGame,
    super.key,
    this.initialPlayerNames = const <String>[],
    this.appBarTitle,
    this.extraContent,
    this.sessionNameLabel = 'Session name (optional)',
    this.initialSessionName,
    this.participantPluralLabel = 'Players',
    this.participantSingularLabel = 'Player',
  });

  final GameModule module;
  final FutureOr<void> Function(SessionSetupResult result) onStartGame;
  final List<String> initialPlayerNames;
  final String? appBarTitle;
  final Widget? extraContent;
  final String sessionNameLabel;
  final String? initialSessionName;
  final String participantPluralLabel;
  final String participantSingularLabel;

  @override
  State<SessionSetupScaffold> createState() => _SessionSetupScaffoldState();
}

class _SessionSetupScaffoldState extends State<SessionSetupScaffold> {
  late final TextEditingController _sessionNameController;
  late final List<TextEditingController> _playerControllers;
  late int _playerCount;

  @override
  void initState() {
    super.initState();
    _playerCount = widget.module.minPlayers;
    _sessionNameController = TextEditingController(
      text: widget.initialSessionName,
    );
    _playerControllers = List<TextEditingController>.generate(10, (index) {
      final initial = index < widget.initialPlayerNames.length
          ? widget.initialPlayerNames[index]
          : widget.participantSingularLabel + ' ' + (index + 1).toString();
      return TextEditingController(text: initial);
    });
  }

  @override
  void dispose() {
    _sessionNameController.dispose();
    for (final controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _startGame() async {
    if (_playerCount < widget.module.minPlayers ||
        _playerCount > widget.module.maxPlayers) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Choose between ' +
                widget.module.minPlayers.toString() +
                ' and ' +
                widget.module.maxPlayers.toString() +
                ' ' +
                widget.participantPluralLabel.toLowerCase() +
                '.',
          ),
        ),
      );
      return;
    }
    final players = List<SessionPlayer>.generate(_playerCount, (index) {
      final name = _playerControllers[index].text.trim();
      return SessionPlayer(
        id: 'player_' + index.toString(),
        displayName: name.isEmpty
            ? widget.participantSingularLabel + ' ' + (index + 1).toString()
            : name,
        colorHex: kDefaultPlayerColors[index % kDefaultPlayerColors.length],
        seatOrder: index,
      );
    });
    await widget.onStartGame(
      SessionSetupResult(
        players: players,
        sessionName: _sessionNameController.text.trim().isEmpty
            ? null
            : _sessionNameController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarTitle ?? (widget.module.displayName + ' Setup'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.module.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _sessionNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ).copyWith(labelText: widget.sessionNameLabel),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                widget.participantPluralLabel,
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                onPressed: _playerCount > widget.module.minPlayers
                    ? () => setState(() => _playerCount--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(_playerCount.toString(), style: theme.textTheme.titleLarge),
              IconButton(
                onPressed:
                    _playerCount < widget.module.maxPlayers && _playerCount < 10
                    ? () => setState(() => _playerCount++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _playerCount; i++) ...[
            Row(
              children: [
                PlayerChip(
                  displayName: _playerControllers[i].text,
                  colorHex:
                      kDefaultPlayerColors[i % kDefaultPlayerColors.length],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _playerControllers[i],
                    maxLength: 30,
                    decoration: InputDecoration(
                      labelText:
                          widget.participantSingularLabel +
                          ' ' +
                          (i + 1).toString(),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ],
          if (widget.extraContent != null) ...[
            const SizedBox(height: 8),
            widget.extraContent!,
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _startGame,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start Game'),
          ),
        ],
      ),
    );
  }
}
