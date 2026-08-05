import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_entry.freezed.dart';
part 'score_entry.g.dart';

@freezed
abstract class ScoreEntry with _$ScoreEntry {
  const factory ScoreEntry({
    required int id,
    required int sessionId,
    required String playerId,
    required int roundNumber,
    required int value,
    String? notes,
    required DateTime recordedAt,
  }) = _ScoreEntry;

  factory ScoreEntry.fromJson(Map<String, dynamic> json) =>
      _$ScoreEntryFromJson(json);
}
