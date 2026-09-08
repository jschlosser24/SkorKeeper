import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../shared/sport_game_storage.dart';
import '../../shared/sport_timer_notifier.dart';
import '../domain/volleyball_module.dart';

part 'volleyball_game_notifier.g.dart';

@riverpod
class VolleyballGameNotifier extends _$VolleyballGameNotifier {
  final VolleyballModule _module = const VolleyballModule();

  @override
  Future<SportGameState> build(int sessionId) async {
    final current = await loadSportState(ref, sessionId);
    ref.read(sportTimerNotifierProvider(sessionId).notifier).attach(
      onTick: _handleTick,
      onPaused: _persistCurrent,
      onStopped: _persistCurrent,
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
    if (updated.timerRunning) {
      ref.read(sportTimerNotifierProvider(sessionId).notifier).startTimer();
    } else {
      ref.read(sportTimerNotifierProvider(sessionId).notifier).pauseTimer();
    }
    await persistSportState(ref, sessionId, updated);
    if (action is SportNoteUpdated) {
      await saveSportNotes(ref, sessionId, updated);
    }
    if (action is SportGameEnded || updated.gamePhase == GamePhase.completed) {
      await finalizeSportGame(ref, sessionId, updated);
    }
  }

  Future<void> _handleTick() async {
    final current = state.valueOrNull;
    if (current == null || !current.timerRunning) {
      return;
    }
    state = AsyncData(current.copyWith(elapsedSeconds: current.elapsedSeconds + 1));
  }

  Future<void> _persistCurrent() async {
    final current = state.valueOrNull;
    if (current != null) {
      await persistSportState(ref, sessionId, current);
    }
  }
}
