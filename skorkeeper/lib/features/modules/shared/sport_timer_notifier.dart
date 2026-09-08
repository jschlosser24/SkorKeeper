import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sportTimerNotifierProvider =
    NotifierProviderFamily<SportTimerNotifier, int, int>(
      SportTimerNotifier.new,
    );

class SportTimerNotifier extends FamilyNotifier<int, int>
    with WidgetsBindingObserver {
  Timer? _timer;
  Future<void> Function()? _onTick;
  Future<void> Function()? _onPaused;
  Future<void> Function()? _onStopped;
  Future<void> Function()? _onBuzzer;

  /// Whether the timer is currently counting down to zero (e.g. a period
  /// clock) rather than counting up (elapsed time).
  bool _isCountdown = false;

  @override
  int build(int arg) {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _timer?.cancel();
    });
    return 0;
  }

  void attach({
    required Future<void> Function() onTick,
    Future<void> Function()? onPaused,
    Future<void> Function()? onStopped,
    Future<void> Function()? onBuzzer,
  }) {
    _onTick = onTick;
    _onPaused = onPaused;
    _onStopped = onStopped;
    _onBuzzer = onBuzzer;
  }

  /// Starts ticking. When [countdown] is true, [state] decrements each
  /// second until it reaches zero, at which point [_onBuzzer] fires and the
  /// timer stops automatically (used for period/quarter countdown clocks).
  /// When false (default), [state] increments each second (elapsed time).
  void startTimer({bool countdown = false}) {
    _isCountdown = countdown;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isCountdown) {
        if (state <= 0) {
          _timer?.cancel();
          _timer = null;
          _onBuzzer?.call();
          _onStopped?.call();
          return;
        }
        state = state - 1;
        if (state <= 0) {
          _timer?.cancel();
          _timer = null;
          _onTick?.call();
          _onBuzzer?.call();
          _onStopped?.call();
          return;
        }
      } else {
        state = state + 1;
      }
      _onTick?.call();
    });
  }

  /// Directly overrides the current timer value (e.g. manual clock edits or
  /// resetting a countdown clock to a new period duration).
  void setRemaining(int seconds) {
    state = seconds < 0 ? 0 : seconds;
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    _onPaused?.call();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _onStopped?.call();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      pauseTimer();
    } else if (state == AppLifecycleState.detached) {
      stopTimer();
    }
  }
}
