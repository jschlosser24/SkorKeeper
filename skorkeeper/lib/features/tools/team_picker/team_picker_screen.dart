import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/preferences_provider.dart';

class TeamPickerScreen extends ConsumerStatefulWidget {
  const TeamPickerScreen({super.key});

  @override
  ConsumerState<TeamPickerScreen> createState() => _TeamPickerScreenState();
}

class _TeamPickerScreenState extends ConsumerState<TeamPickerScreen> {
  final _controllers = <TextEditingController>[
    TextEditingController(text: 'Player 1'),
    TextEditingController(text: 'Player 2'),
    TextEditingController(text: 'Player 3'),
    TextEditingController(text: 'Player 4'),
  ];
  final _random = Random();
  int _teamCount = 2;
  List<List<String>> _teams = const <List<String>>[];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _pickTeams() {
    final names = _controllers
        .map((controller) => controller.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    names.shuffle(_random);
    final teams = List<List<String>>.generate(_teamCount, (_) => <String>[]);
    for (var i = 0; i < names.length; i++) {
      teams[i % _teamCount].add(names[i]);
    }
    setState(() => _teams = teams);
  }

  @override
  Widget build(BuildContext context) {
    final defaults =
        ref
            .watch(preferencesNotifierProvider)
            .valueOrNull
            ?.defaultPlayerNames ??
        const <String>[];
    return Scaffold(
      appBar: AppBar(title: const Text('Team Picker')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickTeams,
        icon: const Icon(Icons.shuffle),
        label: const Text('Pick Teams'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: defaults.isEmpty
                      ? null
                      : () {
                          setState(() {
                            for (final controller in _controllers) {
                              controller.dispose();
                            }
                            _controllers
                              ..clear()
                              ..addAll(
                                defaults.map(
                                  (name) => TextEditingController(text: name),
                                ),
                              );
                          });
                        },
                  child: const Text('Load defaults'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(
                    () => _controllers.add(
                      TextEditingController(
                        text: 'Player ${_controllers.length + 1}',
                      ),
                    ),
                  ),
                  child: const Text('Add player'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final controller in _controllers)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          Row(
            children: [
              Text('Teams', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              IconButton(
                onPressed: _teamCount > 2
                    ? () => setState(() => _teamCount--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(_teamCount.toString()),
              IconButton(
                onPressed: _teamCount < 10
                    ? () => setState(() => _teamCount++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _teams.length; i++)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team ${i + 1}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    for (final name in _teams[i]) Text(name),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
