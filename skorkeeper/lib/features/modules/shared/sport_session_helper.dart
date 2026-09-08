import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/models/session_player.dart';
import '../../../core/modules/sport_game_state.dart';
import '../../../core/providers/database_provider.dart';

List<SessionPlayer> createTeamSessionPlayers(String homeName, String awayName) {
  return [
    SessionPlayer(
      id: 'home',
      displayName: homeName,
      colorHex: '#236192',
      seatOrder: 0,
    ),
    SessionPlayer(
      id: 'away',
      displayName: awayName,
      colorHex: '#981D97',
      seatOrder: 1,
    ),
  ];
}

List<SportPlayer> buildRoster(String prefix, String raw) {
  final entries = raw
      .replaceAll(RegExp(r'[\n;]'), ',')
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  final roster = <SportPlayer>[];
  for (var i = 0; i < entries.length; i++) {
    final entry = entries[i];
    var name = entry;
    String? number;
    String? position;

    final positionMatch = RegExp(r'\(([^)]+)\)\s*$').firstMatch(name);
    if (positionMatch != null) {
      position = positionMatch.group(1)?.trim();
      name = name.substring(0, positionMatch.start).trim();
    }

    final numberMatch = RegExp(r'(?:(?:^|\s)#?)(\d{1,3})(?=\s|$)').firstMatch(name);
    if (numberMatch != null) {
      number = numberMatch.group(1);
      name = name.replaceFirst(numberMatch.group(0)!, '').trim();
    }

    if (name.isEmpty) {
      name = 'Player ${i + 1}';
    }

    final stats = <String, dynamic>{};
    if (position != null && position.isNotEmpty) {
      stats['position'] = position;
    }

    roster.add(
      SportPlayer(
        id: '${prefix}_${i + 1}',
        name: name,
        number: number ?? '${i + 1}',
        stats: stats,
      ),
    );
  }

  return roster;
}

Future<int> createSportSession(
  WidgetRef ref, {
  required String gameType,
  required String sessionName,
  required List<SessionPlayer> participants,
  required SportGameState state,
}) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return ref.read(appDatabaseProvider).sessionDao.insertSession(
        GameSessionsCompanion.insert(
          gameType: gameType,
          sessionName: drift.Value(sessionName),
          startedAt: now,
          participantsJson: jsonEncode(
            participants.map((player) => player.toJson()).toList(),
          ),
          moduleStateJson: jsonEncode(state.toJson()),
        ),
      );
}
