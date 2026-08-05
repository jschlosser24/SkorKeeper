import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';

import '../../../../core/database/daos/session_dao.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../domain/yahtzee_module.dart';
import '../domain/yahtzee_state.dart';

class YahtzeeCubit extends Cubit<YahtzeeState> {
  YahtzeeCubit({
    required this.sessionDao,
    required this.sessionId,
    required this.module,
    required YahtzeeState initialState,
  }) : _random = Random(),
       super(initialState);

  final SessionDao sessionDao;
  final int sessionId;
  final YahtzeeModule module;
  final Random _random;

  // Track which roll each die was held on (0 = not held)
  final List<int> _diceHeldAtRoll = List.filled(5, 0);
  List<int> get diceHeldAtRoll => List.unmodifiable(_diceHeldAtRoll);

  Future<void> _persist() async {
    await sessionDao.updateModuleState(sessionId, jsonEncode(state.toJson()));
  }

  Future<void> rollDice() async {
    if (state.currentRollNumber >= 3) {
      return;
    }
    final nextValues = List<int>.generate(5, (index) {
      if (state.currentRollNumber > 0 && state.diceHeld[index]) {
        return state.diceValues[index];
      }
      return _random.nextInt(6) + 1;
    });
    emit(
      state.copyWith(
        diceValues: nextValues,
        currentRollNumber: state.currentRollNumber + 1,
      ),
    );
    await _persist();
  }

  Future<void> toggleHold(int index) async {
    if (state.currentRollNumber == 0) {
      return;
    }
    final nextHeld = [...state.diceHeld];
    nextHeld[index] = !nextHeld[index];
    _diceHeldAtRoll[index] = nextHeld[index] ? state.currentRollNumber : 0;
    emit(state.copyWith(diceHeld: nextHeld));
    await _persist();
  }

  Future<void> selectCategory(
    String playerId,
    YahtzeeCategory category, {
    int? manualScore,
    bool yahtzeeBonus = false,
  }) async {
    // In real dice mode there's no roll requirement; otherwise need at least 1 roll.
    if (!state.useRealDice && state.currentRollNumber == 0) {
      return;
    }
    final validation = module.validateScore(
      state,
      playerId,
      YahtzeeScoreSelected(
        playerId: playerId,
        category: category,
        manualScore: manualScore,
        yahtzeeBonus: yahtzeeBonus,
      ),
    );
    if (validation is InvalidScore) {
      return;
    }
    final nextState =
        module.applyAction(
              state,
              YahtzeeScoreSelected(
                playerId: playerId,
                category: category,
                manualScore: manualScore,
                yahtzeeBonus: yahtzeeBonus,
              ),
            )
            as YahtzeeState;
    // Reset per-die hold tracking for the next player's turn.
    for (var i = 0; i < _diceHeldAtRoll.length; i++) {
      _diceHeldAtRoll[i] = 0;
    }
    // Module already resets dice to [1,1,1,1,1] and currentRollNumber to 0.
    emit(nextState);
    await _persist();
  }
}
