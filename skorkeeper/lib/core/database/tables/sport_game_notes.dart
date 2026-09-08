import 'package:drift/drift.dart';

import 'game_sessions.dart';

/// New Drift table that stores free-form game notes for sport sessions.
///
/// Separate from [NotepadEntries] to keep sport notes scoped.
/// One row per sport game session.
class SportGameNotes extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → [GameSessions.id]. UNIQUE — one notes row per game session.
  IntColumn get sessionId =>
      integer().unique().references(GameSessions, #id)();

  /// Free-form note text. Empty string when no note has been entered.
  TextColumn get content => text().withDefault(const Constant(''))();

  /// Unix timestamp (ms) of last edit.
  IntColumn get updatedAt => integer()();
}
