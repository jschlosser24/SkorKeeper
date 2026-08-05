import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry.freezed.dart';

@freezed
abstract class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String playerId,
    required String displayName,
    required String colorHex,
    required int rank,
    required String scoreDisplay,
    required int sortKey,
    required bool isLeading,
  }) = _LeaderboardEntry;
}
