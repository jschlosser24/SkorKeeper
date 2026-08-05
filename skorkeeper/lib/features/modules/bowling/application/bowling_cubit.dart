import 'dart:convert';

import 'package:bloc/bloc.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/session_dao.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../domain/bowling_module.dart';
import '../domain/bowling_state.dart';

class BowlingCubit extends Cubit<BowlingState> {
  BowlingCubit({
    required this.sessionDao,
    required this.sessionId,
    required this.module,
    required BowlingState initialState,
  }) : super(initialState);

  final SessionDao sessionDao;
  final int sessionId;
  final BowlingModule module;

  Future<String?> recordRoll(int pins) async {
    final validation = module.validateScore(state, '', pins);
    if (validation is InvalidScore) {
      return validation.reason;
    }
    final previous = state;
    final playerId = previous.playerOrder[previous.currentPlayerIndex];
    final frameNumber = previous.currentFrame;
    emit(
      module.applyAction(previous, BowlingRollEntered(pins: pins))
          as BowlingState,
    );
    final now = DateTime.now().millisecondsSinceEpoch;
    await sessionDao.transaction(() async {
      await sessionDao.updateModuleState(sessionId, jsonEncode(state.toJson()));
      await sessionDao.insertScoreEntry(
        ScoreEntriesCompanion.insert(
          sessionId: sessionId,
          playerId: playerId,
          roundNumber: frameNumber,
          value: pins,
          recordedAt: now,
        ),
      );
    });
    return null;
  }
}
