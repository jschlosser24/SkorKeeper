# Contract: Storage Schema

**Branch**: `001-skorkeeper-app` | **Layer**: Data — Drift SQLite
**Spec ref**: FR-005, FR-007, FR-031, Constitution Principle III

---

## Overview

All structured data is stored in a single Drift SQLite database (`skorkeeper.db`) created in the app's documents directory. The database uses a `MigrationStrategy` with explicit version steps starting at schema version **1**.

`shared_preferences` stores only scalar user preferences (no structured data).

---

## Schema Version History

| Version | Change |
|---------|--------|
| 1 | Initial schema: `game_sessions`, `score_entries`, `history_records`, `notepad_entries`, `tally_counters` |

---

## Drift Table Definitions (Dart DSL)

### `GameSessions`

```dart
class GameSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get gameType => text()();
  TextColumn get sessionName => text().nullable()();
  IntColumn get status => integer().withDefault(const Constant(0))();
  // 0 = active, 1 = completed

  IntColumn get startedAt => integer()();
  // Unix timestamp milliseconds

  IntColumn get endedAt => integer().nullable()();
  TextColumn get participantsJson => text()();
  TextColumn get moduleStateJson => text()();
  TextColumn get winnerDisplayName => text().nullable()();

  @override
  List<Index> get indexes => [
    Index('idx_sessions_status', [status]),
    Index('idx_sessions_game_type_status', [gameType, status]),
    Index('idx_sessions_started_at', [startedAt], unique: false),
  ];
}
```

### `ScoreEntries`

```dart
class ScoreEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(GameSessions, #id,
      onDelete: KeyAction.cascade)();
  TextColumn get playerId => text()();
  IntColumn get roundNumber => integer()();
  IntColumn get value => integer()();
  TextColumn get notes => text().nullable()();
  IntColumn get recordedAt => integer()();

  @override
  List<Index> get indexes => [
    Index('idx_entries_session', [sessionId]),
    Index('idx_entries_session_player', [sessionId, playerId]),
    Index('idx_entries_session_round', [sessionId, roundNumber]),
  ];
}
```

### `HistoryRecords`

```dart
class HistoryRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(GameSessions, #id,
      onDelete: KeyAction.cascade).unique()();
  TextColumn get gameType => text()();
  TextColumn get sessionName => text().nullable()();
  TextColumn get playerNames => text()();
  // Comma-separated display names for LIKE search (FR-032)
  TextColumn get winnerDisplayName => text().nullable()();
  TextColumn get finalScoresJson => text()();
  IntColumn get playedAt => integer()();
  IntColumn get durationSeconds => integer().nullable()();

  @override
  List<Index> get indexes => [
    Index('idx_history_game_type', [gameType]),
    Index('idx_history_played_at', [playedAt], unique: false),
  ];
}
```

### `NotepadEntries`

```dart
class NotepadEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withDefault(const Constant('Note'))();
  TextColumn get body => text().withDefault(const Constant(''))();
  IntColumn get updatedAt => integer()();
}
```

### `TallyCounters`

```dart
class TallyCounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant('Counter'))();
  IntColumn get value => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
}
```

---

## `AppDatabase` Class

```dart
// lib/core/database/app_database.dart

@DriftDatabase(tables: [
  GameSessions,
  ScoreEntries,
  HistoryRecords,
  NotepadEntries,
  TallyCounters,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Version-gated migration steps go here.
      // Example (schema version 2):
      // if (from < 2) {
      //   await m.addColumn(gameSessionsTable, gameSessionsTable.someNewColumn);
      // }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
      // WAL mode: concurrent reads don't block writes — critical for reactive streams
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'skorkeeper.db'));
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    return NativeDatabase.createInBackground(file);
  });
}
```

---

## DAO Contracts

### `SessionDao`

```dart
// lib/core/database/daos/session_dao.dart

@DriftAccessor(tables: [GameSessions, ScoreEntries])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(AppDatabase db) : super(db);

  // Create a new session; returns the auto-incremented ID.
  Future<int> insertSession(GameSessionsCompanion session);

  // Persist module state after every score action.
  Future<void> updateModuleState(int sessionId, String moduleStateJson);

  // Complete a session; sets status=1, endedAt, winnerDisplayName.
  Future<void> completeSession(int sessionId, DateTime endedAt, String? winnerName);

  // Restore all active sessions on app launch (for session recovery).
  Future<List<GameSession>> getActiveSessions();

  // Reactive stream of a single active session (for live scoring screen).
  Stream<GameSession> watchSession(int sessionId);

  // Insert a score entry (Custom, Golf, Farkle, UNO, Dominoes modules).
  Future<int> insertScoreEntry(ScoreEntriesCompanion entry);

  // Get all score entries for a session, ordered by round then recorded_at.
  Future<List<ScoreEntry>> getScoreEntries(int sessionId);

  // Delete a session and cascade to score_entries (via FK cascade).
  Future<void> deleteSession(int sessionId);
}
```

### `HistoryDao`

```dart
// lib/core/database/daos/history_dao.dart

@DriftAccessor(tables: [HistoryRecords])
class HistoryDao extends DatabaseAccessor<AppDatabase> with _$HistoryDaoMixin {
  HistoryDao(AppDatabase db) : super(db);

  // Called when a session is completed; creates the immutable history record.
  Future<int> insertHistoryRecord(HistoryRecordsCompanion record);

  // Reactive stream for History tab — reverse chronological, optional game type filter.
  Stream<List<HistoryRecord>> watchHistory({String? gameTypeFilter});

  // Search by player name using LIKE '%name%' on player_names column.
  Future<List<HistoryRecord>> searchByPlayerName(String query);

  // Get single history record for detail view.
  Future<HistoryRecord?> getHistoryRecord(int sessionId);

  // Delete a history record and its parent session.
  Future<void> deleteHistoryRecord(int id);
}
```

### `ToolsDao`

```dart
// lib/core/database/daos/tools_dao.dart

@DriftAccessor(tables: [NotepadEntries, TallyCounters])
class ToolsDao extends DatabaseAccessor<AppDatabase> with _$ToolsDaoMixin {
  ToolsDao(AppDatabase db) : super(db);

  // Notepad
  Stream<List<NotepadEntry>> watchAllNotes();
  Future<int> insertNote(NotepadEntriesCompanion note);
  Future<void> updateNote(int id, String title, String body);
  Future<void> deleteNote(int id);

  // Tally
  Stream<List<TallyCounter>> watchAllCounters();
  Future<int> insertCounter(TallyCountersCompanion counter);
  Future<void> updateCounterValue(int id, int newValue);
  Future<void> deleteCounter(int id);
}
```

---

## `shared_preferences` Key Registry

All `shared_preferences` keys are centralized to prevent typo-based bugs:

```dart
// lib/core/providers/prefs_keys.dart

abstract final class PrefsKeys {
  static const themeMode           = 'theme_mode';           // 'system'|'light'|'dark'
  static const useAlternatePalette = 'use_alternate_palette'; // bool
  static const soundEnabled        = 'sound_enabled';         // bool
  static const hapticEnabled       = 'haptic_enabled';        // bool
  static const shakeToRollEnabled  = 'shake_to_roll_enabled'; // bool
  static const shakeSensitivity    = 'shake_sensitivity';     // double
  static const defaultPlayerNames  = 'default_player_names';  // JSON String
}
```

---

## Data Integrity Rules

1. **Foreign keys are enforced** via `PRAGMA foreign_keys = ON` in `beforeOpen`.
2. **Cascade deletes** are configured: deleting a `game_session` cascades to `score_entries` and `history_records`.
3. **WAL journal mode** is enabled to allow concurrent reads during active game writes.
4. **No orphaned score entries**: `session_id` must reference a valid `game_sessions.id`.
5. **Session state is always valid JSON**: `moduleStateJson` is validated by `GameModule.stateFromJson()` before every read. If invalid (app crash mid-write), the session recovery UI presents an option to discard.
6. **History records are immutable**: once inserted, `history_records` rows are never updated, only deleted.
7. **Preferences keys are never renamed** after first release without a migration helper that reads the old key and writes the new key.
