import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';

import '../../../../core/database/daos/session_dao.dart';
import '../../../../core/modules/score_action.dart';
import '../domain/darts_game_state.dart';
import '../domain/darts_module_base.dart';

abstract class DartsEvent {
  const DartsEvent();
}

class DartThrownEvent extends DartsEvent {
  const DartThrownEvent({required this.score, required this.multiplier});

  final int score;
  final int multiplier;
}

class UndoLastDart extends DartsEvent {
  const UndoLastDart();
}

class EndTurnEvent extends DartsEvent {
  const EndTurnEvent();
}

class NewGame extends DartsEvent {
  const NewGame();
}

class DartsState {
  const DartsState({required this.gameState, this.lastBust = false});

  final DartsGameState gameState;
  final bool lastBust;

  DartsState copyWith({DartsGameState? gameState, bool? lastBust}) {
    return DartsState(
      gameState: gameState ?? this.gameState,
      lastBust: lastBust ?? this.lastBust,
    );
  }
}

class DartsBloc extends Bloc<DartsEvent, DartsState> {
  DartsBloc({
    required this.sessionDao,
    required this.sessionId,
    required this.module,
    required DartsGameState initialState,
  }) : _resetState = initialState,
       super(DartsState(gameState: initialState)) {
    on<DartThrownEvent>(_onDartThrown, transformer: _sequential());
    on<UndoLastDart>(_onUndo, transformer: _sequential());
    on<EndTurnEvent>(_onEndTurn, transformer: _sequential());
    on<NewGame>(_onNewGame, transformer: _sequential());
  }

  final SessionDao sessionDao;
  final int sessionId;
  final DartsModuleBase module;
  final DartsGameState _resetState;
  final List<DartsGameState> _history = <DartsGameState>[];

  EventTransformer<T> _sequential<T>() {
    return (events, mapper) => events.asyncExpand(mapper);
  }

  Future<void> _persist(DartsGameState state) async {
    await sessionDao.updateModuleState(sessionId, jsonEncode(state.toJson()));
  }

  Future<void> _onDartThrown(
    DartThrownEvent event,
    Emitter<DartsState> emit,
  ) async {
    final previous = state.gameState;
    _history.add(previous);
    final next =
        module.applyAction(
              previous,
              DartThrown(score: event.score, multiplier: event.multiplier),
            )
            as DartsGameState;
    final previousPlayer = previous.playerStates[previous.currentPlayerId];
    final nextPlayer = next.playerStates[previous.currentPlayerId];
    final bust =
        previous.currentPlayerId != next.currentPlayerId &&
        previousPlayer != null &&
        nextPlayer != null &&
        previousPlayer.scoreRemaining == nextPlayer.scoreRemaining &&
        !next.gameOver;
    await _persist(next);
    emit(DartsState(gameState: next, lastBust: bust));
  }

  Future<void> _onUndo(UndoLastDart event, Emitter<DartsState> emit) async {
    if (_history.isEmpty) {
      return;
    }
    final restored = _history.removeLast();
    await _persist(restored);
    emit(DartsState(gameState: restored));
  }

  Future<void> _onEndTurn(EndTurnEvent event, Emitter<DartsState> emit) async {
    _history.add(state.gameState);
    final next = module.advanceTurn(state.gameState);
    await _persist(next);
    emit(DartsState(gameState: next));
  }

  Future<void> _onNewGame(NewGame event, Emitter<DartsState> emit) async {
    _history.clear();
    await _persist(_resetState);
    emit(DartsState(gameState: _resetState));
  }
}
