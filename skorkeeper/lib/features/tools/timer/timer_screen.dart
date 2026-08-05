import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/audio_provider.dart';
import '../../../core/providers/preferences_provider.dart';
import 'hourglass_widget.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  Timer? _ticker;
  Duration _duration = const Duration(minutes: 1);
  Duration _remaining = const Duration(minutes: 1);
  bool _running = false;

  // Time input controllers
  late final TextEditingController _hoursCtrl;
  late final TextEditingController _minutesCtrl;
  late final TextEditingController _secondsCtrl;

  @override
  void initState() {
    super.initState();
    _hoursCtrl = TextEditingController(text: '00');
    _minutesCtrl = TextEditingController(text: '01');
    _secondsCtrl = TextEditingController(text: '00');
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _hoursCtrl.dispose();
    _minutesCtrl.dispose();
    _secondsCtrl.dispose();
    super.dispose();
  }

  // Parse current field values into a Duration.
  Duration _parseDuration() {
    final h = int.tryParse(_hoursCtrl.text) ?? 0;
    final m = int.tryParse(_minutesCtrl.text) ?? 0;
    final s = int.tryParse(_secondsCtrl.text) ?? 0;
    final clamped = Duration(
      hours: h.clamp(0, 99),
      minutes: m.clamp(0, 59),
      seconds: s.clamp(0, 59),
    );
    return clamped.inSeconds > 0 ? clamped : const Duration(seconds: 5);
  }

  // Keep fields consistent with a Duration value.
  void _syncFields(Duration d) {
    _hoursCtrl.text = d.inHours.toString().padLeft(2, '0');
    _minutesCtrl.text = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    _secondsCtrl.text = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  }

  void _start() {
    final d = _parseDuration();
    _ticker?.cancel();
    setState(() {
      _duration = d;
      _remaining = d;
      _running = true;
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remaining <= const Duration(seconds: 1)) {
        timer.cancel();
        setState(() {
          _remaining = Duration.zero;
          _running = false;
        });
        await _alert();
        return;
      }
      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  void _reset() {
    _ticker?.cancel();
    final d = _parseDuration();
    setState(() {
      _running = false;
      _duration = d;
      _remaining = d;
    });
  }

  Future<void> _alert() async {
    final prefs = ref.read(preferencesNotifierProvider).valueOrNull;
    for (var i = 0; i < 3; i++) {
      if (prefs?.hapticEnabled ?? true) HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 160));
    }
    final audio = await ref.read(audioServiceProvider.future);
    await audio.playTimerAlert();
  }

  String _format(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    final s = duration.inSeconds.remainder(60);
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _duration.inSeconds == 0
        ? 0.0
        : 1 - (_remaining.inSeconds / _duration.inSeconds);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HourglassWidget(progress: progress),
          const SizedBox(height: 16),

          // -- Countdown display --------------------------------------
          Text(
            _format(_remaining),
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 24),

          // -- Time input (disabled while running) -------------------
          if (!_running) ...[
            Text(
              'Set time',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _TimeField(
                  controller: _hoursCtrl,
                  label: 'HH',
                  max: 99,
                  onChanged: (_) {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(':', style: theme.textTheme.headlineMedium),
                ),
                _TimeField(
                  controller: _minutesCtrl,
                  label: 'MM',
                  max: 59,
                  onChanged: (_) {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(':', style: theme.textTheme.headlineMedium),
                ),
                _TimeField(
                  controller: _secondsCtrl,
                  label: 'SS',
                  max: 59,
                  onChanged: (_) {},
                ),
              ],
            ),

            // Quick-set chips
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final preset in _presets)
                  ActionChip(
                    label: Text(preset.label),
                    onPressed: () {
                      setState(() {
                        _syncFields(preset.duration);
                        _duration = preset.duration;
                        _remaining = preset.duration;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // -- Controls -----------------------------------------------
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _running ? null : _start,
                  child: const Text('Start'),
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

          // Pause / resume
          if (_running) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                _ticker?.cancel();
                setState(() => _running = false);
              },
              icon: const Icon(Icons.pause),
              label: const Text('Pause'),
            ),
          ],
        ],
      ),
    );
  }
}

// -- Preset chips ------------------------------------------------------------

class _Preset {
  const _Preset(this.label, this.duration);
  final String label;
  final Duration duration;
}

const _presets = [
  _Preset('30s', Duration(seconds: 30)),
  _Preset('1m', Duration(minutes: 1)),
  _Preset('2m', Duration(minutes: 2)),
  _Preset('5m', Duration(minutes: 5)),
  _Preset('10m', Duration(minutes: 10)),
  _Preset('15m', Duration(minutes: 15)),
  _Preset('30m', Duration(minutes: 30)),
  _Preset('1h', Duration(hours: 1)),
];

// -- Time field widget --------------------------------------------------------

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.controller,
    required this.label,
    required this.max,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final int max;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 2,
            style: theme.textTheme.headlineMedium,
            decoration: InputDecoration(
              counterText: '',
              labelText: label,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) {
              final n = int.tryParse(v) ?? 0;
              if (n > max) {
                controller.text = max.toString().padLeft(2, '0');
                controller.selection = TextSelection.collapsed(
                  offset: controller.text.length,
                );
              } else if (v.length == 2) {
                // Auto-pad and move focus
                controller.text = n.toString().padLeft(2, '0');
                controller.selection = TextSelection.collapsed(
                  offset: controller.text.length,
                );
              }
              onChanged(controller.text);
            },
            onTap: () => controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            ),
          ),
        ],
      ),
    );
  }
}
