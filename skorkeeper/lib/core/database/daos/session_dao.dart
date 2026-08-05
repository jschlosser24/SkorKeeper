import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/game_sessions.dart';
import '../tables/score_entries.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [GameSessions, ScoreEntries])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  Stream<List<GameSession>> watchActiveSessions() =>
      (select(gameSessions)..where((t) => t.status.equals(0))).watch();

  Future<GameSession?> getSession(int id) =>
      (select(gameSessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertSession(GameSessionsCompanion companion) =>
      into(gameSessions).insert(companion);

  Future<int> restoreSession(GameSession session) => into(gameSessions).insert(
    GameSessionsCompanion(
      id: Value(session.id),
      gameType: Value(session.gameType),
      sessionName: Value(session.sessionName),
      status: Value(session.status),
      startedAt: Value(session.startedAt),
      endedAt: Value(session.endedAt),
      participantsJson: Value(session.participantsJson),
      moduleStateJson: Value(session.moduleStateJson),
      winnerDisplayName: Value(session.winnerDisplayName),
    ),
  );

  Future<void> updateModuleState(int sessionId, String stateJson) =>
      (update(gameSessions)..where((t) => t.id.equals(sessionId))).write(
        GameSessionsCompanion(moduleStateJson: Value(stateJson)),
      );

  Future<void> completeSession(int id, String winnerName, int endedAtMs) =>
      transaction(() async {
        await (update(gameSessions)..where((t) => t.id.equals(id))).write(
          GameSessionsCompanion(
            status: const Value(1),
            winnerDisplayName: Value(winnerName),
            endedAt: Value(endedAtMs),
          ),
        );
      });

  Future<int> insertScoreEntry(ScoreEntriesCompanion companion) =>
      into(scoreEntries).insert(companion);

  Stream<List<ScoreEntry>> watchScoreEntriesForSession(int sessionId) =>
      (select(
        scoreEntries,
      )..where((t) => t.sessionId.equals(sessionId))).watch();

  Future<List<ScoreEntry>> getScoreEntriesForSession(int sessionId) =>
      (select(scoreEntries)..where((t) => t.sessionId.equals(sessionId))).get();

  Future<void> deleteScoreEntry(int scoreEntryId) =>
      (delete(scoreEntries)..where((t) => t.id.equals(scoreEntryId))).go();

  Future<void> deleteSession(int sessionId) =>
      (delete(gameSessions)..where((t) => t.id.equals(sessionId))).go();
}
