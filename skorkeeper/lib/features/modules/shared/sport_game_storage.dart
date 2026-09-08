import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/modules/sport_enums.dart';
import '../../../core/modules/sport_game_state.dart';
import '../../../core/providers/active_sessions_provider.dart';
import '../../../core/providers/database_provider.dart';
import '../../../features/sports_hub/application/sports_entitlement_notifier.dart';

Future<SportGameState> loadSportState(Ref ref, int sessionId) async {
  final session = await ref.read(appDatabaseProvider).sessionDao.getSession(sessionId);
  if (session == null) {
    throw StateError('Session $sessionId not found');
  }
  return SportGameState.fromJson(
    jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
  );
}

Future<void> persistSportState(
  Ref ref,
  int sessionId,
  SportGameState state,
) async {
  await ref
      .read(appDatabaseProvider)
      .sessionDao
      .updateModuleState(sessionId, jsonEncode(state.toJson()));
}

Future<void> saveSportNotes(
  Ref ref,
  int sessionId,
  SportGameState state,
) async {
  if ((state.notes ?? '').trim().isEmpty) {
    return;
  }
  await ref
      .read(appDatabaseProvider)
      .sportHistoryDao
      .upsertNotes(sessionId, state.notes!.trim());
}

Future<void> finalizeSportGame(
  Ref ref,
  int sessionId,
  SportGameState state,
) async {
  final db = ref.read(appDatabaseProvider);
  final entitlement = ref.read(sportsEntitlementNotifierProvider).valueOrNull;
  final tierRequired = (entitlement?.hasSportsPro ?? false) ||
          state.sportType.requiresPro ||
          state.trackingMode == TrackingMode.inDepth
      ? 'sports_pro'
      : 'sports_plan';
  await db.sportHistoryDao.saveSportGame(
    sessionId: sessionId,
    sportType: state.sportType.gameTypeId,
    trackingMode: state.trackingMode == TrackingMode.inDepth ? 'in_depth' : 'basic',
    tierRequired: tierRequired,
  );
  await saveSportNotes(ref, sessionId, state);
  await ref.read(activeSessionsNotifierProvider.notifier).endSession(
        sessionId,
        winnerLabelForState(state),
        jsonEncode(state.toJson()),
      );
}

String winnerLabelForState(SportGameState state) {
  if (state.homeTeam.score == state.awayTeam.score) {
    return 'Tie';
  }
  return state.homeTeam.score > state.awayTeam.score
      ? state.homeTeam.name
      : state.awayTeam.name;
}
