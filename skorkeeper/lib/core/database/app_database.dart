import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/history_dao.dart';
import 'daos/session_dao.dart';
import 'daos/tools_dao.dart';
import 'tables/game_sessions.dart';
import 'tables/history_records.dart';
import 'tables/notepad_entries.dart';
import 'tables/score_entries.dart';
import 'tables/tally_counters.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    GameSessions,
    ScoreEntries,
    HistoryRecords,
    NotepadEntries,
    TallyCounters,
  ],
  daos: [SessionDao, HistoryDao, ToolsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Future migrations go here.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'skorkeeper.db'));
    return NativeDatabase.createInBackground(file);
  });
}
