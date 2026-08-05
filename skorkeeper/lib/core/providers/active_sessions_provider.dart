import 'dart:convert';
import 'dart:developer' as developer;

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/app_database.dart';
import '../models/session_player.dart';
import '../modules/score_action.dart';
import 'database_provider.dart';

part 'active_sessions_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveSessionsNotifier extends _$ActiveSessionsNotifier {
  @override
  Stream<List<GameSession>> build() {
    final db = ref.watch(appDatabaseProvider);
    return db.sessionDao.watchActiveSessions();
  }

  Future<int> createSession({
    required String gameType,
    String? sessionName,
    required List<SessionPlayer> players,
    required Map<String, dynamic> initialModuleState,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    return db.sessionDao.insertSession(
      GameSessionsCompanion.insert(
        gameType: gameType,
        sessionName: Value(sessionName),
        startedAt: now,
        participantsJson: jsonEncode(
          players.map((player) => player.toJson()).toList(),
        ),
        moduleStateJson: jsonEncode(initialModuleState),
      ),
    );
  }

  Future<void> recordScore(
    int sessionId,
    ScoreAction action,
    String newStateJson,
  ) async {
    final db = ref.read(appDatabaseProvider);
    developer.Timeline.startSync('ActiveSessions.recordScore');
    try {
      await db.transaction(() async {
        await db.sessionDao.updateModuleState(sessionId, newStateJson);
        final companion = _scoreCompanion(sessionId, action);
        if (companion != null) {
          await db.sessionDao.insertScoreEntry(companion);
        }
      });
    } finally {
      developer.Timeline.finishSync();
    }
  }

  Future<void> endSession(
    int sessionId,
    String winnerName,
    String finalStateJson,
  ) async {
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.transaction(() async {
      final session = await db.sessionDao.getSession(sessionId);
      if (session == null) {
        return;
      }
      await db.sessionDao.updateModuleState(sessionId, finalStateJson);
      final completedAt = session.endedAt ?? now;
      if (session.status != 1 || session.endedAt == null) {
        await db.sessionDao.completeSession(sessionId, winnerName, now);
      }
      final players = (jsonDecode(session.participantsJson) as List<dynamic>)
          .map((item) => SessionPlayer.fromJson(item as Map<String, dynamic>))
          .toList();
      final record = HistoryRecordsCompanion.insert(
        sessionId: sessionId,
        gameType: session.gameType,
        sessionName: Value(session.sessionName),
        playerNames: players.map((player) => player.displayName).join(', '),
        winnerDisplayName: Value(winnerName),
        finalScoresJson: finalStateJson,
        playedAt: now,
        durationSeconds: Value((completedAt - session.startedAt) ~/ 1000),
      );
      final existing = await db.historyDao.getHistoryRecord(sessionId);
      if (existing == null) {
        await db.historyDao.insertHistoryRecord(record);
      }
    });
  }

  ScoreEntriesCompanion? _scoreCompanion(int sessionId, ScoreAction action) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (action is CustomRoundScoreEntered) {
      return ScoreEntriesCompanion.insert(
        sessionId: sessionId,
        playerId: action.playerId,
        roundNumber: action.roundNumber,
        value: action.value,
        recordedAt: now,
      );
    }
    if (action is GolfHoleScoreEntered) {
      return ScoreEntriesCompanion.insert(
        sessionId: sessionId,
        playerId: action.playerId,
        roundNumber: action.hole,
        value: action.strokes,
        recordedAt: now,
      );
    }
    if (action is CribbagePointsScored) {
      return ScoreEntriesCompanion.insert(
        sessionId: sessionId,
        playerId: action.playerId,
        roundNumber: 1,
        value: action.points,
        recordedAt: now,
      );
    }
    if (action is UnoRoundScoreEntered) {
      return ScoreEntriesCompanion.insert(
        sessionId: sessionId,
        playerId: action.playerId,
        roundNumber: now,
        value: action.points,
        recordedAt: now,
      );
    }
    if (action is DominoesRoundScoreEntered) {
      return ScoreEntriesCompanion.insert(
        sessionId: sessionId,
        playerId: action.playerId,
        roundNumber: now,
        value: action.pips,
        recordedAt: now,
      );
    }
    if (action is BowlingRollEntered) {
      return ScoreEntriesCompanion.insert(
        sessionId: sessionId,
        playerId: 'bowling',
        roundNumber: now,
        value: action.pins,
        recordedAt: now,
      );
    }
    if (action is FarkleBankScore) {
      return ScoreEntriesCompanion.insert(
        sessionId: sessionId,
        playerId: 'farkle',
        roundNumber: now,
        value: action.turnScore,
        recordedAt: now,
      );
    }
    return null;
  }
}
