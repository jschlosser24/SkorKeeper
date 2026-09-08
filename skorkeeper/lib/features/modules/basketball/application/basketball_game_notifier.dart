import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../../../core/providers/audio_provider.dart';
import '../../shared/sport_game_storage.dart';
import '../../shared/sport_module_utils.dart';
import '../../shared/sport_timer_notifier.dart';
import '../domain/basketball_module.dart';

part 'basketball_game_notifier.g.dart';

@riverpod
class BasketballGameNotifier extends _$BasketballGameNotifier {
  final BasketballModule _module = const BasketballModule();

  @override
  Future<SportGameState> build(int sessionId) async {
    final current = await loadSportState(ref, sessionId);
    ref.read(sportTimerNotifierProvider(sessionId).notifier).attach(
      onTick: _handleTick,
      onPaused: _persistCurrent,
      onStopped: _persistCurrent,
      onBuzzer: _handleBuzzer,
    );
    return _withPercentages(current);
  }

  Future<void> dispatch(ScoreAction action) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final updated = _withPercentages(_module.applyAction(current, action));
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

  /// Manually corrects the home/away score.
  Future<void> editScore(int homeScore, int awayScore) {
    return dispatch(SportScoreEdited(homeScore: homeScore, awayScore: awayScore));
  }

  /// Manually corrects the current quarter/period number.
  Future<void> editPeriod(int period) {
    return dispatch(SportPeriodEdited(period: period));
  }

  /// Manually corrects the remaining countdown clock time (seconds).
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
    final updated = _withPercentages(
      current.copyWith(
        elapsedSeconds: current.elapsedSeconds + 1,
        sportSpecific: sportSpecific,
      ),
    );
    state = AsyncData(updated);
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

  SportGameState _withPercentages(SportGameState state) {
    return state.copyWith(
      homeTeam: _teamPercentages(state.homeTeam),
      awayTeam: _teamPercentages(state.awayTeam),
    );
  }

  SportTeam _teamPercentages(SportTeam team) {
    final stats = Map<String, dynamic>.from(team.stats);
    final fgMade = SportModuleUtils.asInt(stats['fieldGoalsMade']);
    final fgAttempted = SportModuleUtils.asInt(stats['fieldGoalsAttempted']);
    final threesMade = SportModuleUtils.asInt(stats['threesMade']);
    final threesAttempted = SportModuleUtils.asInt(stats['threesAttempted']);
    final ftMade = SportModuleUtils.asInt(stats['ftMade']);
    final ftAttempted = SportModuleUtils.asInt(stats['ftAttempted']);
    stats['fgPercentage'] = fgAttempted == 0 ? 0.0 : fgMade / fgAttempted;
    stats['threePercentage'] =
        threesAttempted == 0 ? 0.0 : threesMade / threesAttempted;
    stats['ftPercentage'] = ftAttempted == 0 ? 0.0 : ftMade / ftAttempted;
    return team.copyWith(stats: stats);
  }
}
