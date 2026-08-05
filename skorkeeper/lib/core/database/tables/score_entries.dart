import 'package:drift/drift.dart';

import 'game_sessions.dart';

@TableIndex(name: 'idx_score_entries_session', columns: {#sessionId})
@TableIndex(
  name: 'idx_score_entries_session_player',
  columns: {#sessionId, #playerId},
)
@TableIndex(
  name: 'idx_score_entries_session_round',
  columns: {#sessionId, #roundNumber},
)
class ScoreEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId =>
      integer().references(GameSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get playerId => text()();
  IntColumn get roundNumber => integer()();
  IntColumn get value => integer()();
  TextColumn get notes => text().nullable()();
  IntColumn get recordedAt => integer()();
}
