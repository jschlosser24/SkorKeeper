import 'package:flutter/material.dart';

import '../../../core/models/session_player.dart';
import '../../../core/modules/leaderboard_entry.dart';
import '../../../core/modules/score_validation_result.dart';
import '../../../core/modules/sport_enums.dart';
import '../../../core/modules/sport_game_state.dart';
import '../../../core/modules/win_result.dart';

class SportModuleUtils {
  const SportModuleUtils._();

  static SportGameState initialState({
    required SportType sportType,
    required String gameFormat,
    required TrackingMode trackingMode,
    required Map<String, dynamic> sportSpecific,
    required Map<String, dynamic> homeStats,
    required Map<String, dynamic> awayStats,
    required List<SessionPlayer> players,
  }) {
    final homeName = players.isNotEmpty ? players.first.displayName : 'Home';
    final awayName =
        players.length > 1 ? players[1].displayName : 'Away';
    return SportGameState(
      sportType: sportType,
      trackingMode: trackingMode,
      gameFormat: gameFormat,
      gamePhase: GamePhase.active,
      homeTeam: SportTeam(id: 'home', name: homeName, stats: homeStats),
      awayTeam: SportTeam(id: 'away', name: awayName, stats: awayStats),
      sportSpecific: sportSpecific,
    );
  }

  static SportTeam teamFor(SportGameState state, String teamId) {
    return teamId == 'away' ? state.awayTeam : state.homeTeam;
  }

  static SportGameState replaceTeam(
    SportGameState state,
    String teamId,
    SportTeam team,
  ) {
    return teamId == 'away'
        ? state.copyWith(awayTeam: team)
        : state.copyWith(homeTeam: team);
  }

  static SportGameState updateTeam(
    SportGameState state,
    String teamId,
    SportTeam Function(SportTeam team) transform,
  ) {
    final team = teamFor(state, teamId);
    return replaceTeam(state, teamId, transform(team));
  }

  static SportTeam incrementStat(
    SportTeam team,
    String key, {
    int by = 1,
  }) {
    final stats = Map<String, dynamic>.from(team.stats);
    stats[key] = asInt(stats[key]) + by;
    return team.copyWith(stats: stats);
  }

  static SportTeam setStat(
    SportTeam team,
    String key,
    dynamic value,
  ) {
    final stats = Map<String, dynamic>.from(team.stats);
    stats[key] = value;
    return team.copyWith(stats: stats);
  }

  static SportTeam incrementSegmentScore(
    SportTeam team,
    String key,
    int segmentIndex,
    int delta,
  ) {
    final stats = Map<String, dynamic>.from(team.stats);
    final scores = intList(stats[key]);
    while (scores.length <= segmentIndex) {
      scores.add(0);
    }
    scores[segmentIndex] = scores[segmentIndex] + delta;
    stats[key] = scores;
    return team.copyWith(stats: stats);
  }

  static SportTeam setScoresList(
    SportTeam team,
    String key,
    List<dynamic> value,
  ) {
    final stats = Map<String, dynamic>.from(team.stats);
    stats[key] = value;
    return team.copyWith(stats: stats);
  }

  static SportTeam incrementPlayerStat(
    SportTeam team,
    String playerId,
    String statKey, {
    int by = 1,
  }) {
    final roster = team.roster;
    if (roster == null) {
      return team;
    }
    final updated = roster
        .map((player) {
          if (player.id != playerId) {
            return player;
          }
          final stats = Map<String, dynamic>.from(player.stats);
          stats[statKey] = asInt(stats[statKey]) + by;
          return player.copyWith(stats: stats);
        })
        .toList();
    return team.copyWith(roster: updated);
  }

  static SportGameState appendEvent(
    SportGameState state, {
    required String eventType,
    required String teamId,
    int pointsDelta = 0,
    String? playerId,
    Map<String, dynamic>? metadata,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return state.copyWith(
      events: [
        ...state.events,
        SportEvent(
          id: '${state.sportType.name}_$now',
          gameTimeSeconds: state.elapsedSeconds,
          wallClockMs: now,
          eventType: eventType,
          teamId: teamId,
          playerId: playerId,
          pointsDelta: pointsDelta,
          metadata: metadata,
        ),
      ],
    );
  }

  /// Applies a manual score correction to both teams. Used by the shared
  /// [SportScoreEdited] action across non-baseball sport modules.
  static SportGameState applyScoreEdit(
    SportGameState state,
    int homeScore,
    int awayScore,
  ) {
    return state.copyWith(
      homeTeam: state.homeTeam.copyWith(score: homeScore),
      awayTeam: state.awayTeam.copyWith(score: awayScore),
    );
  }

  /// Applies a manual period/quarter/half/set override, stored under
  /// [periodKey] in `sportSpecific`. Used by the shared [SportPeriodEdited]
  /// action across non-baseball sport modules.
  static SportGameState applyPeriodEdit(
    SportGameState state,
    String periodKey,
    int period,
  ) {
    final sportSpecific = mapCopy(state.sportSpecific);
    sportSpecific[periodKey] = period;
    return state.copyWith(sportSpecific: sportSpecific);
  }

  static ScoreValidationResult alwaysValid() =>
      const ScoreValidationResult.valid();

  static WinResult? resolveWinResult(SportGameState state) {
    if (state.gamePhase != GamePhase.completed) {
      return null;
    }
    final home = state.homeTeam;
    final away = state.awayTeam;
    final winner = home.score == away.score
        ? SportTeam(id: 'tie', name: 'Tie', score: home.score)
        : (home.score > away.score ? home : away);
    final standings = leaderboard(state);
    final description = home.score == away.score
        ? 'Game ended in a tie'
        : '${winner.name} won ${home.score}-${away.score}';
    return WinResult(
      winnerId: winner.id,
      winnerDisplayName: winner.name,
      winDescription: description,
      finalStandings: standings,
    );
  }

  static List<LeaderboardEntry> leaderboard(SportGameState state) {
    final home = state.homeTeam;
    final away = state.awayTeam;
    final teams = [home, away]..sort((a, b) => b.score.compareTo(a.score));
    return [
      for (var i = 0; i < teams.length; i++)
        LeaderboardEntry(
          playerId: teams[i].id,
          displayName: teams[i].name,
          colorHex: i == 0 ? '#236192' : '#981D97',
          rank: i + 1,
          scoreDisplay: teams[i].score.toString(),
          sortKey: teams[i].score,
          isLeading: i == 0,
        ),
    ];
  }

  static int asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double asDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String asString(dynamic value, {String fallback = ''}) {
    final string = value?.toString();
    if (string == null || string.isEmpty) {
      return fallback;
    }
    return string;
  }

  static List<int> intList(dynamic value) {
    if (value is List<int>) {
      return List<int>.from(value);
    }
    if (value is List<dynamic>) {
      return value.map(asInt).toList();
    }
    return <int>[];
  }

  static List<Map<String, dynamic>> mapList(dynamic value) {
    if (value is List<dynamic>) {
      return value
          .whereType<Map<String, dynamic>>()
          .map((entry) => Map<String, dynamic>.from(entry))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  static Map<String, dynamic> mapCopy(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static String ordinal(int number) {
    final mod100 = number % 100;
    if (mod100 >= 11 && mod100 <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  static String formatClock(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String sportLabel(String gameTypeId) {
    final value = gameTypeId.replaceFirst('sport_', '');
    if (value.isEmpty) {
      return 'Sport';
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  static IconData iconForSport(SportType sportType) {
    switch (sportType) {
      case SportType.baseball:
        return Icons.sports_baseball;
      case SportType.basketball:
        return Icons.sports_basketball;
      case SportType.football:
        return Icons.sports_football;
      case SportType.soccer:
        return Icons.sports_soccer;
      case SportType.tennis:
        return Icons.sports_tennis;
      case SportType.volleyball:
        return Icons.sports_volleyball;
      case SportType.hockey:
        return Icons.sports_hockey;
      case SportType.lacrosse:
        return Icons.sports;
    }
  }
}
