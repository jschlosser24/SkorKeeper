import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/audio_provider.dart';
import '../../../core/providers/preferences_provider.dart';
import '../../../ui/widgets/die_widget.dart';
import 'shake_provider.dart';

class DiceRollerScreen extends ConsumerStatefulWidget {
  const DiceRollerScreen({super.key});

  @override
  ConsumerState<DiceRollerScreen> createState() => _DiceRollerScreenState();
}

class _DiceRollerScreenState extends ConsumerState<DiceRollerScreen> {
  final _random = Random();
  DieType _dieType = DieType.d6;
  int _dieCount = 2;
  List<int> _values = const [1, 1];
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(shakeTriggerProvider, (previous, next) {
      next.whenData((_) => _rollDice());
    });
  }

  int get _maxValue {
    switch (_dieType) {
      case DieType.d4:
        return 4;
      case DieType.d6:
        return 6;
      case DieType.d8:
        return 8;
      case DieType.d10:
        return 10;
      case DieType.d12:
        return 12;
      case DieType.d20:
        return 20;
      case DieType.d100:
        return 100;
    }
  }

  Future<void> _rollDice() async {
    setState(() => _animate = true);
    final prefs = ref.read(preferencesNotifierProvider).valueOrNull;
    if (prefs?.hapticEnabled ?? true) {
      HapticFeedback.mediumImpact();
    }
    final audio = await ref.read(audioServiceProvider.future);
    unawaited(audio.playDiceRoll());
    await Future<void>.delayed(const Duration(milliseconds: 350));
    setState(() {
      _values = List<int>.generate(
        _dieCount,
        (_) => _random.nextInt(_maxValue) + 1,
      );
      _animate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _values.fold<int>(0, (sum, value) => sum + value);
    return Scaffold(
      appBar: AppBar(title: const Text('Dice Roller')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _rollDice,
        icon: const Icon(Icons.casino),
        label: Text('Roll $_dieCount ${_dieType.name}'),
        tooltip: 'Roll $_dieCount ${_dieType.name} dice',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<DieType>(
            value: _dieType,
            decoration: const InputDecoration(
              labelText: 'Die type',
              border: OutlineInputBorder(),
            ),
            items: DieType.values
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _dieType = value;
                _values = List<int>.filled(_dieCount, 1);
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Dice count',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                onPressed: _dieCount > 1
                    ? () => setState(() {
                        _dieCount--;
                        _values = List<int>.filled(_dieCount, 1);
                      })
                    : null,
                tooltip: 'Decrement dice count',
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(_dieCount.toString()),
              IconButton(
                onPressed: _dieCount < 10
                    ? () => setState(() {
                        _dieCount++;
                        _values = List<int>.filled(_dieCount, 1);
                      })
                    : null,
                tooltip: 'Increment dice count',
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final value in _values)
                DieWidget(value: value, type: _dieType, animateRoll: _animate),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Total', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    total.toString(),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
