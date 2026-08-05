import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final _stopwatch = Stopwatch();
  final _laps = <Duration>[];
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hundredths = (duration.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds.$hundredths';
  }

  void _start() {
    _stopwatch.start();
    _ticker ??= Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (mounted) {
        setState(() {});
      }
    });
    setState(() {});
  }

  void _stop() {
    _stopwatch.stop();
    setState(() {});
  }

  void _reset() {
    _stopwatch
      ..stop()
      ..reset();
    _laps.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _format(_stopwatch.elapsed),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _stopwatch.isRunning ? _stop : _start,
                  child: Text(_stopwatch.isRunning ? 'Stop' : 'Start'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _laps.insert(0, _stopwatch.elapsed);
                    setState(() {});
                  },
                  child: const Text('Lap'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < _laps.length; i++)
            ListTile(
              leading: Text('#${i + 1}'),
              title: Text(_format(_laps[i])),
            ),
        ],
      ),
    );
  }
}
