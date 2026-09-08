import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../../../core/providers/audio_provider.dart';
import '../../shared/sport_game_storage.dart';
import '../../shared/sport_module_utils.dart';
import '../../shared/sport_timer_notifier.dart';
import '../domain/lacrosse_module.dart';

part 'lacrosse_game_notifier.g.dart';

@riverpod
class LacrosseGameNotifier extends _$LacrosseGameNotifier {
  final LacrosseModule _module = const LacrosseModule();

  @override
  Future<SportGameState> build(int sessionId) async {
    final current = await loadSportState(ref, sessionId);
    ref.read(sportTimerNotifierProvider(sessionId).notifier).attach(
      onTick: _handleTick,
      onPaused: _persistCurrent,
      onStopped: _persistCurrent,
      onBuzzer: _handleBuzzer,
    );
    return current;
  }

  Future<void> dispatch(ScoreAction action) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final updated = _module.applyAction(current, action);
    state = AsyncData(updated);
    final timerNotifier = ref.read(sportTimerNotifierProvider(sessionId).notifier);
    if (updated.timerRunning) {
      timerNotifier.setRemaining(
        SportModuleUtils.asInt(updated.sportSpecific['remainingSeconds']),
      );
      timerNotifier.startTimer(countdown: true);
    } else {
      timerNotifier.pauseTimer();
    }
    await persistSportState(ref, sessionId, updated);
    if (action is SportNoteUpdated) {
      await saveSportNotes(ref, sessionId, updated);
    }
    if (action is SportGameEnded || updated.gamePhase == GamePhase.completed) {
      await finalizeSportGame(ref, sessionId, updated);
    }
  }

  Future<void> editScore(int homeScore, int awayScore) {
    return dispatch(SportScoreEdited(homeScore: homeScore, awayScore: awayScore));
  }

  Future<void> editPeriod(int period) {
    return dispatch(SportPeriodEdited(period: period));
  }

  Future<void> editClock(int remainingSeconds) {
    return dispatch(SportClockEdited(remainingSeconds: remainingSeconds));
  }

  Future<void> _handleTick() async {
    final current = state.valueOrNull;
    if (current == null || !current.timerRunning) {
      return;
    }
    final remaining = ref.read(sportTimerNotifierProvider(sessionId));
    final sportSpecific = SportModuleUtils.mapCopy(current.sportSpecific);
    sportSpecific['remainingSeconds'] = remaining;
    state = AsyncData(
      current.copyWith(
        elapsedSeconds: current.elapsedSeconds + 1,
        sportSpecific: sportSpecific,
      ),
    );
  }

  Future<void> _handleBuzzer() async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final updated = current.copyWith(timerRunning: false);
    state = AsyncData(updated);
    await persistSportState(ref, sessionId, updated);
    try {
      final audio = await ref.read(audioServiceProvider.future);
      await audio.playBuzzer();
    } catch (_) {}
  }

  Future<void> _persistCurrent() async {
    final current = state.valueOrNull;
    if (current != null) {
      await persistSportState(ref, sessionId, current);
    }
  }
}
