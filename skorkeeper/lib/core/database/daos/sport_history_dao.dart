import 'dart:convert';

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/game_sessions.dart';
import '../tables/history_records.dart';
import '../tables/sport_game_notes.dart';
import '../tables/sport_history_meta.dart';
import '../../modules/sport_game_state.dart';

part 'sport_history_dao.g.dart';

/// Exception thrown when a Sports Plan user attempts to save a game that
/// would exceed the 100-game history limit.
class GameHistoryLimitReachedException implements Exception {
  const GameHistoryLimitReachedException();

  @override
  String toString() =>
      'GameHistoryLimitReachedException: Sports Plan history limit (100 games) reached.';
}

/// DAO for sport game history, notes, and history-limit enforcement.
class SportHistoryRecord {
  const SportHistoryRecord({
    required this.session,
    required this.meta,
    required this.state,
    this.history,
    this.notes,
  });

  final GameSession session;
  final SportHistoryMetaData meta;
  final SportGameState state;
  final HistoryRecord? history;
  final SportGameNote? notes;
}

@DriftAccessor(tables: [GameSessions, HistoryRecords, SportHistoryMeta, SportGameNotes])
class SportHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$SportHistoryDaoMixin {
  SportHistoryDao(super.db);

  // ─── Queries ──────────────────────────────────────────────────────────────

  /// Returns all sport game session IDs ordered by most-recently started.
  Future<List<SportHistoryRecord>> getSportGames() async {
    final metaRows = await (select(sportHistoryMeta)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.sessionId,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
    return _hydrate(metaRows);
  }

  /// Returns sport game sessions filtered by [tierRequired].
  Future<List<SportHistoryRecord>> getSportGamesByTier(String tierRequired) async {
    final metaRows = await (select(sportHistoryMeta)
          ..where((t) => t.tierRequired.equals(tierRequired))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.sessionId,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
    return _hydrate(metaRows);
  }

  /// Returns the total number of sport game sessions for a given tier.
  ///
  /// Used to enforce the 100-game limit for Sports Plan users.
  Future<int> getSportGameCount({required String tierRequired}) async {
    final count = sportHistoryMeta.id.count();
    final query = selectOnly(sportHistoryMeta)
      ..addColumns([count])
      ..where(sportHistoryMeta.tierRequired.equals(tierRequired));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  // ─── Mutations ────────────────────────────────────────────────────────────

  /// Saves a completed sport game to history.
  ///
  /// Throws [GameHistoryLimitReachedException] when [tierRequired] is
  /// `'sports_plan'` and the 100-game limit has been reached.
  Future<void> saveSportGame({
    required int sessionId,
    required String sportType,
    required String trackingMode,
    required String tierRequired,
  }) async {
    if (tierRequired == 'sports_plan') {
      final count =
          await getSportGameCount(tierRequired: tierRequired);
      if (count >= 100) {
        throw const GameHistoryLimitReachedException();
      }
    }

    await into(sportHistoryMeta).insertOnConflictUpdate(
      SportHistoryMetaCompanion.insert(
        sessionId: sessionId,
        sportType: sportType,
        trackingMode: trackingMode,
        tierRequired: tierRequired,
      ),
    );
  }

  /// Deletes the sport meta row and associated notes for a session.
  Future<void> deleteSportGame(int sessionId) async {
    await (delete(historyRecords)
          ..where((t) => t.sessionId.equals(sessionId)))
        .go();
    await (delete(sportHistoryMeta)
          ..where((t) => t.sessionId.equals(sessionId)))
        .go();
    await (delete(sportGameNotes)
          ..where((t) => t.sessionId.equals(sessionId)))
        .go();
    await (delete(gameSessions)..where((t) => t.id.equals(sessionId))).go();
  }

  /// Updates the export status after a successful export operation.
  Future<void> updateExportStatus(int sessionId, String formats) {
    return (update(sportHistoryMeta)
          ..where((t) => t.sessionId.equals(sessionId)))
        .write(
          SportHistoryMetaCompanion(
            exportedAt: Value(DateTime.now().millisecondsSinceEpoch),
            exportFormats: Value(formats),
          ),
        );
  }

  // ─── Notes ────────────────────────────────────────────────────────────────

  /// Upserts game notes for a session.
  Future<void> upsertNotes(int sessionId, String content) {
    return into(sportGameNotes).insertOnConflictUpdate(
      SportGameNotesCompanion.insert(
        sessionId: sessionId,
        content: Value(content),
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// Returns the notes row for a session, or null if none exists.
  Future<SportGameNote?> getNotes(int sessionId) {
    return (select(sportGameNotes)
          ..where((t) => t.sessionId.equals(sessionId)))
        .getSingleOrNull();
  }

  Future<List<SportHistoryRecord>> _hydrate(
    List<SportHistoryMetaData> metaRows,
  ) async {
    if (metaRows.isEmpty) {
      return [];
    }
    final ids = metaRows.map((row) => row.sessionId).toList();
    final sessions = await (select(gameSessions)..where((t) => t.id.isIn(ids))).get();
    final history = await (select(historyRecords)..where((t) => t.sessionId.isIn(ids))).get();
    final notesRows = await (select(sportGameNotes)
          ..where((t) => t.sessionId.isIn(ids)))
        .get();
    final sessionMap = {for (final row in sessions) row.id: row};
    final historyMap = {for (final row in history) row.sessionId: row};
    final notesMap = {for (final row in notesRows) row.sessionId: row};
    return [
      for (final meta in metaRows)
        if (sessionMap.containsKey(meta.sessionId))
          SportHistoryRecord(
            session: sessionMap[meta.sessionId]!,
            meta: meta,
            state: SportGameState.fromJson(
              jsonDecode(sessionMap[meta.sessionId]!.moduleStateJson)
                  as Map<String, dynamic>,
            ),
            history: historyMap[meta.sessionId],
            notes: notesMap[meta.sessionId],
          ),
    ];
  }
}
