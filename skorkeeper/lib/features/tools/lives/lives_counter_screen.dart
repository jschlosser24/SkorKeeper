import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/preferences_provider.dart';

class LivesCounterScreen extends ConsumerStatefulWidget {
  const LivesCounterScreen({super.key});

  @override
  ConsumerState<LivesCounterScreen> createState() => _LivesCounterScreenState();
}

class _LivesCounterScreenState extends ConsumerState<LivesCounterScreen> {
  int _startingLives = 10;
  late final TextEditingController _startCtrl;
  bool _appliedDefaultNames = false;
  final _players = <_LifePlayer>[
    _LifePlayer(name: 'Player 1', lives: 10),
    _LifePlayer(name: 'Player 2', lives: 10),
  ];

  @override
  void initState() {
    super.initState();
    _startCtrl = TextEditingController(text: '10');
  }

  @override
  void dispose() {
    _startCtrl.dispose();
    super.dispose();
  }

  void _applyStartingLives() {
    setState(() {
      for (final player in _players) {
        player.lives = _startingLives;
      }
    });
  }

  void _setStartingLives(int value) {
    final clamped = value.clamp(1, 999);
    setState(() => _startingLives = clamped);
    _startCtrl.text = clamped.toString();
  }

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesNotifierProvider);
    final defaultPlayerNames =
        preferences.valueOrNull?.defaultPlayerNames ?? const <String>[];
    if (!_appliedDefaultNames && preferences.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _appliedDefaultNames) {
          return;
        }
        setState(() {
          _players[0].name = _defaultNameFor(defaultPlayerNames, 0);
          _players[1].name = _defaultNameFor(defaultPlayerNames, 1);
          _appliedDefaultNames = true;
        });
      });
    }
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Lives Counter')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _players.length >= 10
            ? null
            : () => setState(
                () => _players.add(
                  _LifePlayer(
                    name: _defaultNameFor(defaultPlayerNames, _players.length),
                    lives: _startingLives,
                  ),
                ),
              ),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Player'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // -- Starting lives config ----------------------------------
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Starting lives', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Minus
                      IconButton(
                        onPressed: _startingLives > 1
                            ? () => _setStartingLives(_startingLives - 1)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        tooltip: 'Decrease',
                      ),
                      // Direct text entry
                      SizedBox(
                        width: 72,
                        child: TextField(
                          controller: _startCtrl,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          style: theme.textTheme.headlineSmall,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (v) {
                            final n = int.tryParse(v);
                            if (n != null && n >= 1) {
                              setState(() => _startingLives = n.clamp(1, 999));
                            }
                          },
                          onTap: () => _startCtrl.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _startCtrl.text.length,
                          ),
                          onSubmitted: (v) {
                            final n = int.tryParse(v) ?? 1;
                            _setStartingLives(n);
                          },
                        ),
                      ),
                      // Plus
                      IconButton(
                        onPressed: _startingLives < 999
                            ? () => _setStartingLives(_startingLives + 1)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        tooltip: 'Increase',
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: _applyStartingLives,
                        child: const Text('Apply to all'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // -- Player rows -------------------------------------------
          for (var i = 0; i < _players.length; i++)
            _PlayerCard(
              key: ValueKey<String>('player_${i}_${_players[i].name}'),
              player: _players[i],
              onDecrement: () => setState(() => _players[i].lives--),
              onIncrement: () => setState(() => _players[i].lives++),
              onRemove: _players.length > 1
                  ? () => setState(() => _players.removeAt(i))
                  : null,
              onNameChanged: (v) => _players[i].name = v,
            ),
        ],
      ),
    );
  }

  String _defaultNameFor(List<String> names, int index) {
    if (index < names.length && names[index].trim().isNotEmpty) {
      return names[index].trim();
    }
    return 'Player ${index + 1}';
  }
}

// -- Player card --------------------------------------------------------------

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.player,
    required this.onDecrement,
    required this.onIncrement,
    required this.onNameChanged,
    this.onRemove,
    super.key,
  });

  final _LifePlayer player;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final ValueChanged<String> onNameChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDead = player.lives <= 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isDead
          ? theme.colorScheme.errorContainer.withValues(alpha: 0.4)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            // Dead icon or remove button
            SizedBox(
              width: 36,
              child: isDead
                  ? Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: theme.colorScheme.error,
                    )
                  : onRemove != null
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close, size: 18),
                      tooltip: 'Remove player',
                      onPressed: onRemove,
                    )
                  : const SizedBox.shrink(),
            ),
            // Player name
            Expanded(
              child: TextFormField(
                initialValue: player.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  decoration: isDead
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
                decoration: const InputDecoration(border: InputBorder.none),
                onChanged: onNameChanged,
              ),
            ),
            // Lives controls
            IconButton(
              onPressed: onDecrement,
              icon: Icon(
                Icons.remove_circle,
                color: isDead ? theme.colorScheme.error : null,
              ),
              tooltip: 'Remove life',
            ),
            SizedBox(
              width: 44,
              child: Text(
                player.lives.toString(),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: isDead ? theme.colorScheme.error : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle),
              tooltip: 'Add life',
            ),
          ],
        ),
      ),
    );
  }
}

class _LifePlayer {
  _LifePlayer({required this.name, required this.lives});
  String name;
  int lives;
}
