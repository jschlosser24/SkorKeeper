import 'package:freezed_annotation/freezed_annotation.dart';

import 'leaderboard_entry.dart';

part 'win_result.freezed.dart';

@freezed
abstract class WinResult with _$WinResult {
  const factory WinResult({
    required String winnerId,
    required String winnerDisplayName,
    required String winDescription,
    required List<LeaderboardEntry> finalStandings,
  }) = _WinResult;
}
