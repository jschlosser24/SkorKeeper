import 'package:drift/drift.dart';

@TableIndex(name: 'idx_sessions_status', columns: {#status})
@TableIndex(
  name: 'idx_sessions_game_type_status',
  columns: {#gameType, #status},
)
@TableIndex.sql(
  'CREATE INDEX idx_sessions_started_at ON game_sessions (started_at DESC)',
)
class GameSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get gameType => text()();
  TextColumn get sessionName => text().nullable()();
  IntColumn get status => integer().withDefault(const Constant(0))();
  IntColumn get startedAt => integer()();
  IntColumn get endedAt => integer().nullable()();
  TextColumn get participantsJson => text()();
  TextColumn get moduleStateJson => text()();
  TextColumn get winnerDisplayName => text().nullable()();
}
