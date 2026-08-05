import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/history_records.dart';

part 'history_dao.g.dart';

@DriftAccessor(tables: [HistoryRecords])
class HistoryDao extends DatabaseAccessor<AppDatabase> with _$HistoryDaoMixin {
  HistoryDao(super.db);

  Stream<List<HistoryRecord>> watchHistory() => (select(
    historyRecords,
  )..orderBy([(t) => OrderingTerm.desc(t.playedAt)])).watch();

  Stream<List<HistoryRecord>> watchHistoryByGameType(String gameType) =>
      (select(historyRecords)
            ..where((t) => t.gameType.equals(gameType))
            ..orderBy([(t) => OrderingTerm.desc(t.playedAt)]))
          .watch();

  Future<List<HistoryRecord>> searchHistory(String query) {
    final pattern = '%$query%';
    return (select(historyRecords)
          ..where(
            (t) => t.playerNames.like(pattern) | t.sessionName.like(pattern),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.playedAt)]))
        .get();
  }

  Future<int> insertHistoryRecord(HistoryRecordsCompanion companion) =>
      into(historyRecords).insert(companion);

  Future<int> restoreHistoryRecord(HistoryRecord record) =>
      into(historyRecords).insert(
        HistoryRecordsCompanion(
          id: Value(record.id),
          sessionId: Value(record.sessionId),
          gameType: Value(record.gameType),
          sessionName: Value(record.sessionName),
          playerNames: Value(record.playerNames),
          winnerDisplayName: Value(record.winnerDisplayName),
          finalScoresJson: Value(record.finalScoresJson),
          playedAt: Value(record.playedAt),
          durationSeconds: Value(record.durationSeconds),
        ),
      );

  Future<HistoryRecord?> getHistoryRecord(int sessionId) => (select(
    historyRecords,
  )..where((t) => t.sessionId.equals(sessionId))).getSingleOrNull();

  Future<HistoryRecord?> getHistoryRecordById(int id) =>
      (select(historyRecords)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> deleteHistoryRecord(int id) =>
      (delete(historyRecords)..where((t) => t.id.equals(id))).go();
}
