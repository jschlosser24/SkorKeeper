import 'dart:convert';

import 'package:bloc/bloc.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/session_dao.dart';
import '../../../../core/modules/score_action.dart';
import '../domain/cribbage_module.dart';
import '../domain/cribbage_state.dart';

class CribbageCubit extends Cubit<CribbageState> {
  CribbageCubit({
    required this.sessionDao,
    required this.sessionId,
    required this.module,
    required CribbageState initialState,
  }) : super(initialState);

  final SessionDao sessionDao;
  final int sessionId;
  final CribbageModule module;

  Future<void> _persist() async {
    await sessionDao.updateModuleState(sessionId, jsonEncode(state.toJson()));
  }

  Future<void> scorePoints(String playerId, int points) async {
    final previous = state;
    emit(
      module.applyAction(
            previous,
            CribbagePointsScored(playerId: playerId, points: points),
          )
          as CribbageState,
    );
    final now = DateTime.now().millisecondsSinceEpoch;
    await sessionDao.transaction(() async {
      await _persist();
      await sessionDao.insertScoreEntry(
        ScoreEntriesCompanion.insert(
          sessionId: sessionId,
          playerId: playerId,
          roundNumber: previous.handNumber,
          value: points,
          recordedAt: now,
        ),
      );
    });
  }

  Future<void> advanceDealer() async {
    final playerIds = state.pegPositions.keys.toList();
    final currentIndex = playerIds.indexOf(state.dealerId);
    emit(
      state.copyWith(
        dealerId: playerIds[(currentIndex + 1) % playerIds.length],
        handNumber: state.handNumber + 1,
      ),
    );
    await _persist();
  }
}
