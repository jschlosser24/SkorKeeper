import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../shared/sport_game_storage.dart';
import '../../shared/sport_module_utils.dart';
import '../../shared/sport_timer_notifier.dart';
import '../domain/soccer_module.dart';

part 'soccer_game_notifier.g.dart';

@riverpod
class SoccerGameNotifier extends _$SoccerGameNotifier {
  final SoccerModule _module = const SoccerModule();

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
    var updated = _module.applyAction(current, action);
    if (action is SoccerHalfAdvanced && current.gamePhase == GamePhase.active) {
      updated = _snapshotHalf(updated);
    }
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
    final sportSpecific = SportModuleUtils.mapCopy(current.sportSpecific);
    final possessingTeamId = SportModuleUtils.asString(
      sportSpecific['possessingTeamId'],
      fallback: 'home',
    );
    final teamSecondsKey =
        possessingTeamId == 'home' ? 'homePossessionSeconds' : 'awayPossessionSeconds';
    sportSpecific[teamSecondsKey] =
        SportModuleUtils.asInt(sportSpecific[teamSecondsKey]) + 1;
    var updated = current.copyWith(
      elapsedSeconds: current.elapsedSeconds + 1,
      sportSpecific: sportSpecific,
    );
    updated = updated.copyWith(
      homeTeam: _setPossession(updated.homeTeam, sportSpecific['homePossessionSeconds']),
      awayTeam: _setPossession(updated.awayTeam, sportSpecific['awayPossessionSeconds']),
    );
    state = AsyncData(updated);
  }

  SportTeam _setPossession(SportTeam team, dynamic value) {
    final stats = Map<String, dynamic>.from(team.stats);
    stats['possessionSeconds'] = SportModuleUtils.asInt(value);
    return team.copyWith(stats: stats);
  }

  SportGameState _snapshotHalf(SportGameState state) {
    final sportSpecific = SportModuleUtils.mapCopy(state.sportSpecific);
    final snapshots = SportModuleUtils.mapList(sportSpecific['halfPossessionSnapshots']);
    snapshots.add({
      'half': SportModuleUtils.asInt(sportSpecific['currentHalf']),
      'home': SportModuleUtils.asInt(sportSpecific['homePossessionSeconds']),
      'away': SportModuleUtils.asInt(sportSpecific['awayPossessionSeconds']),
    });
    sportSpecific['halfPossessionSnapshots'] = snapshots;
    return state.copyWith(sportSpecific: sportSpecific);
  }

  Future<void> _persistCurrent() async {
    final current = state.valueOrNull;
    if (current != null) {
      await persistSportState(ref, sessionId, current);
    }
  }
}
