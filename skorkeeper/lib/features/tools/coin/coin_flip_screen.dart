import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/audio_provider.dart';
import '../../../core/providers/preferences_provider.dart';

class CoinFlipScreen extends ConsumerStatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  ConsumerState<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends ConsumerState<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _random = Random();
  final List<String> _history = <String>[];
  String _result = 'Heads';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _flip() async {
    final result = _random.nextBool() ? 'Heads' : 'Tails';
    final prefs = ref.read(preferencesNotifierProvider).valueOrNull;
    if (prefs?.hapticEnabled ?? true) {
      HapticFeedback.lightImpact();
    }
    final audio = await ref.read(audioServiceProvider.future);
    await audio.playCoinFlip();
    await _controller.forward(from: 0);
    setState(() {
      _result = result;
      _history.insert(0, result);
      if (_history.length > 5) _history.removeRange(5, _history.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coin Flip')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _flip,
        icon: const Icon(Icons.monetization_on),
        label: const Text('Flip'),
        tooltip: 'Flip coin',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final angle = _controller.value * pi * 8;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(angle),
                child: child,
              );
            },
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              alignment: Alignment.center,
              child: Text(
                _result,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '$_result!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text('Recent flips', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final item in _history) ListTile(title: Text(item)),
        ],
      ),
    );
  }
}
