import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_record.freezed.dart';
part 'history_record.g.dart';

@freezed
abstract class HistoryRecord with _$HistoryRecord {
  const factory HistoryRecord({
    required int id,
    required int sessionId,
    required String gameType,
    String? sessionName,
    required String playerNames,
    String? winnerDisplayName,
    required String finalScoresJson,
    required DateTime playedAt,
    int? durationSeconds,
  }) = _HistoryRecord;

  factory HistoryRecord.fromJson(Map<String, dynamic> json) =>
      _$HistoryRecordFromJson(json);
}
