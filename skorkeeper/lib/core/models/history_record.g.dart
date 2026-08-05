// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryRecord _$HistoryRecordFromJson(Map<String, dynamic> json) =>
    _HistoryRecord(
      id: (json['id'] as num).toInt(),
      sessionId: (json['sessionId'] as num).toInt(),
      gameType: json['gameType'] as String,
      sessionName: json['sessionName'] as String?,
      playerNames: json['playerNames'] as String,
      winnerDisplayName: json['winnerDisplayName'] as String?,
      finalScoresJson: json['finalScoresJson'] as String,
      playedAt: DateTime.parse(json['playedAt'] as String),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HistoryRecordToJson(_HistoryRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'gameType': instance.gameType,
      'sessionName': instance.sessionName,
      'playerNames': instance.playerNames,
      'winnerDisplayName': instance.winnerDisplayName,
      'finalScoresJson': instance.finalScoresJson,
      'playedAt': instance.playedAt.toIso8601String(),
      'durationSeconds': instance.durationSeconds,
    };
