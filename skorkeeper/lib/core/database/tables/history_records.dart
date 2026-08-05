import 'package:drift/drift.dart';

import 'game_sessions.dart';

@TableIndex(name: 'idx_history_game_type', columns: {#gameType})
@TableIndex.sql(
  'CREATE INDEX idx_history_played_at ON history_records (played_at DESC)',
)
@TableIndex(name: 'idx_history_player_names', columns: {#playerNames})
class HistoryRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().unique().references(GameSessions, #id)();
  TextColumn get gameType => text()();
  TextColumn get sessionName => text().nullable()();
  TextColumn get playerNames => text()();
  TextColumn get winnerDisplayName => text().nullable()();
  TextColumn get finalScoresJson => text()();
  IntColumn get playedAt => integer()();
  IntColumn get durationSeconds => integer().nullable()();
}
