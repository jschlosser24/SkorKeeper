import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/sport_enums.dart';
import '../../../../core/modules/sport_game_state.dart';
import '../../shared/sport_game_storage.dart';
import '../domain/baseball_module.dart';

part 'baseball_game_notifier.g.dart';

@riverpod
class BaseballGameNotifier extends _$BaseballGameNotifier {
  final BaseballModule _module = const BaseballModule();

  @override
  Future<SportGameState> build(int sessionId) {
    return loadSportState(ref, sessionId);
  }

  Future<void> dispatch(ScoreAction action) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final updated = _module.applyAction(current, action);
    state = AsyncData(updated);
    await persistSportState(ref, sessionId, updated);
    if (action is SportNoteUpdated) {
      await saveSportNotes(ref, sessionId, updated);
    }
    if (action is SportGameEnded || updated.gamePhase == GamePhase.completed) {
      await finalizeSportGame(ref, sessionId, updated);
    }
  }
}
