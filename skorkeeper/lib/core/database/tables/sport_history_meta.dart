import 'package:drift/drift.dart';

import 'game_sessions.dart';

/// New Drift table that augments [GameSessions] with sports-specific metadata.
///
/// One row per sport game session. Used for history limit enforcement,
/// analytics queries, and export tracking.
@TableIndex(name: 'idx_sport_meta_tier', columns: {#tierRequired})
class SportHistoryMeta extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → [GameSessions.id]. UNIQUE — one meta row per game session.
  IntColumn get sessionId =>
      integer().unique().references(GameSessions, #id)();

  /// Mirrors [GameSessions.gameType]; denormalized for query efficiency.
  /// Values: 'sport_baseball', 'sport_basketball', etc.
  TextColumn get sportType => text()();

  /// 'basic' or 'in_depth'
  TextColumn get trackingMode => text()();

  /// 'sports_plan' or 'sports_pro'. Drives the 100-game limit count query.
  TextColumn get tierRequired => text()();

  /// Unix timestamp (ms) of last export; null if never exported.
  IntColumn get exportedAt => integer().nullable()();

  /// Comma-separated export formats used (e.g. 'pdf,csv'); null if not exported.
  TextColumn get exportFormats => text().nullable()();
}
