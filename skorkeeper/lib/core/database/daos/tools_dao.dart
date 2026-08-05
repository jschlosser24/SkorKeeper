import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/notepad_entries.dart';
import '../tables/tally_counters.dart';

part 'tools_dao.g.dart';

@DriftAccessor(tables: [NotepadEntries, TallyCounters])
class ToolsDao extends DatabaseAccessor<AppDatabase> with _$ToolsDaoMixin {
  ToolsDao(super.db);

  Stream<List<NotepadEntry>> watchNotes() => (select(
    notepadEntries,
  )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();

  Future<NotepadEntry?> getNote(int id) =>
      (select(notepadEntries)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertNote(NotepadEntriesCompanion companion) =>
      into(notepadEntries).insert(companion);

  Future<void> updateNote(int id, String title, String body) =>
      (update(notepadEntries)..where((t) => t.id.equals(id))).write(
        NotepadEntriesCompanion(
          title: Value(title),
          body: Value(body),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  Future<void> deleteNote(int id) =>
      (delete(notepadEntries)..where((t) => t.id.equals(id))).go();

  Stream<List<TallyCounter>> watchTallyCounters() =>
      (select(tallyCounters)..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();

  Future<void> upsertTallyCounter(TallyCountersCompanion companion) =>
      into(tallyCounters).insertOnConflictUpdate(companion);

  Future<void> deleteTallyCounter(int id) =>
      (delete(tallyCounters)..where((t) => t.id.equals(id))).go();
}
