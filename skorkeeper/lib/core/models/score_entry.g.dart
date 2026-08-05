// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScoreEntry _$ScoreEntryFromJson(Map<String, dynamic> json) => _ScoreEntry(
  id: (json['id'] as num).toInt(),
  sessionId: (json['sessionId'] as num).toInt(),
  playerId: json['playerId'] as String,
  roundNumber: (json['roundNumber'] as num).toInt(),
  value: (json['value'] as num).toInt(),
  notes: json['notes'] as String?,
  recordedAt: DateTime.parse(json['recordedAt'] as String),
);

Map<String, dynamic> _$ScoreEntryToJson(_ScoreEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'playerId': instance.playerId,
      'roundNumber': instance.roundNumber,
      'value': instance.value,
      'notes': instance.notes,
      'recordedAt': instance.recordedAt.toIso8601String(),
    };
