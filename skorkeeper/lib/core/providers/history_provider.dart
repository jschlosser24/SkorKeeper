import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/app_database.dart';
import 'database_provider.dart';

part 'history_provider.g.dart';

class DeletedHistoryEntry {
  const DeletedHistoryEntry({required this.record, required this.session});

  final HistoryRecord record;
  final GameSession session;
}

@Riverpod(keepAlive: true)
class HistoryNotifier extends _$HistoryNotifier {
  String? _gameTypeFilter;
  String _searchQuery = '';

  @override
  Stream<List<HistoryRecord>> build() {
    final db = ref.watch(appDatabaseProvider);
    if (_gameTypeFilter != null) {
      return db.historyDao.watchHistoryByGameType(_gameTypeFilter!);
    }
    return db.historyDao.watchHistory();
  }

  void filterByGameType(String? gameType) {
    _gameTypeFilter = gameType;
    ref.invalidateSelf();
  }

  Future<List<HistoryRecord>> search(String query) async {
    _searchQuery = query;
    final db = ref.read(appDatabaseProvider);
    if (_searchQuery.trim().isEmpty) {
      return db.historyDao.watchHistory().first;
    }
    return db.historyDao.searchHistory(_searchQuery);
  }

  Future<DeletedHistoryEntry?> deleteEntry(int id) async {
    final deletedEntries = await deleteEntries([id]);
    if (deletedEntries.isEmpty) {
      return null;
    }
    return deletedEntries.first;
  }

  Future<List<DeletedHistoryEntry>> deleteEntries(Iterable<int> ids) async {
    final db = ref.read(appDatabaseProvider);
    final deletedEntries = <DeletedHistoryEntry>[];
    final uniqueIds = ids.toSet();
    await db.transaction(() async {
      for (final id in uniqueIds) {
        final record = await db.historyDao.getHistoryRecordById(id);
        if (record == null) {
          continue;
        }
        final session = await db.sessionDao.getSession(record.sessionId);
        await db.historyDao.deleteHistoryRecord(id);
        if (session == null) {
          continue;
        }
        await db.sessionDao.deleteSession(record.sessionId);
        deletedEntries.add(
          DeletedHistoryEntry(record: record, session: session),
        );
      }
    });
    return deletedEntries;
  }

  Future<void> restoreEntry(DeletedHistoryEntry entry) async {
    await restoreEntries([entry]);
  }

  Future<void> restoreEntries(List<DeletedHistoryEntry> entries) async {
    if (entries.isEmpty) {
      return;
    }
    final db = ref.read(appDatabaseProvider);
    await db.transaction(() async {
      for (final entry in entries) {
        await db.sessionDao.restoreSession(entry.session);
        await db.historyDao.restoreHistoryRecord(entry.record);
      }
    });
  }
}
