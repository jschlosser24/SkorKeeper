import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/history_dao.dart';
import 'daos/session_dao.dart';
import 'daos/sport_export_dao.dart';
import 'daos/sport_history_dao.dart';
import 'daos/tools_dao.dart';
import 'tables/game_sessions.dart';
import 'tables/history_records.dart';
import 'tables/notepad_entries.dart';
import 'tables/score_entries.dart';
import 'tables/sport_game_notes.dart';
import 'tables/sport_history_meta.dart';
import 'tables/tally_counters.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    GameSessions,
    ScoreEntries,
    HistoryRecords,
    NotepadEntries,
    TallyCounters,
    SportHistoryMeta,
    SportGameNotes,
  ],
  daos: [SessionDao, HistoryDao, ToolsDao, SportHistoryDao, SportExportDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(sportHistoryMeta);
        await m.createTable(sportGameNotes);
        await m.createIndex(
          Index(
            'idx_sport_meta_tier',
            'CREATE INDEX idx_sport_meta_tier ON sport_history_meta (tier_required)',
          ),
        );
      }
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
