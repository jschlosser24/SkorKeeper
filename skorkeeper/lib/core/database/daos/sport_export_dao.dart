import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/game_sessions.dart';
import '../tables/sport_game_notes.dart';
import '../tables/sport_history_meta.dart';

part 'sport_export_dao.g.dart';

/// Result type for export queries — joins game session, meta, and notes.
class SportExportRecord {
  const SportExportRecord({
    required this.session,
    required this.meta,
    this.notes,
  });

  final GameSession session;
  final SportHistoryMetaData meta;
  final SportGameNote? notes;
}

/// DAO for building export data sets from sport game history.
@DriftAccessor(tables: [GameSessions, SportHistoryMeta, SportGameNotes])
class SportExportDao extends DatabaseAccessor<AppDatabase>
    with _$SportExportDaoMixin {
  SportExportDao(super.db);

  /// Fetches full export records (session + meta + notes) for a list of
  /// session IDs. Used by export services to assemble PDF/CSV/JSON files.
  Future<List<SportExportRecord>> getGamesForExport(
    List<int> sessionIds,
  ) async {
    if (sessionIds.isEmpty) return [];

    final metaRows = await (select(sportHistoryMeta)
          ..where((t) => t.sessionId.isIn(sessionIds)))
        .get();

    final sessionRows = await (select(gameSessions)
          ..where((t) => t.id.isIn(sessionIds)))
        .get();

    final notesRows = await (select(sportGameNotes)
          ..where((t) => t.sessionId.isIn(sessionIds)))
        .get();

    final sessionMap = {for (final s in sessionRows) s.id: s};
    final notesMap = {for (final n in notesRows) n.sessionId: n};

    final results = <SportExportRecord>[];
    for (final meta in metaRows) {
      final session = sessionMap[meta.sessionId];
      if (session == null) continue;
      results.add(
        SportExportRecord(
          session: session,
          meta: meta,
          notes: notesMap[meta.sessionId],
        ),
      );
    }

    // Preserve the caller's ordering.
    results.sort(
      (a, b) => sessionIds.indexOf(a.session.id) -
          sessionIds.indexOf(b.session.id),
    );
    return results;
  }

  /// Returns sport game sessions within a date range (unix ms).
  Future<List<SportExportRecord>> getGamesByDateRange({
    required int fromMs,
    required int toMs,
  }) async {
    final sessionRows = await (select(gameSessions)
          ..where(
            (t) =>
                t.startedAt.isBiggerOrEqualValue(fromMs) &
                t.startedAt.isSmallerOrEqualValue(toMs),
          ))
        .get();

    final ids = sessionRows.map((s) => s.id).toList();
    return getGamesForExport(ids);
  }

  /// Returns all sport game sessions for a specific sport type.
  Future<List<SportExportRecord>> getGamesBySportType(
    String sportType,
  ) async {
    final metaRows = await (select(sportHistoryMeta)
          ..where((t) => t.sportType.equals(sportType)))
        .get();

    final ids = metaRows.map((m) => m.sessionId).toList();
    return getGamesForExport(ids);
  }
}
