// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameSession _$GameSessionFromJson(Map<String, dynamic> json) => _GameSession(
  id: (json['id'] as num).toInt(),
  gameType: json['gameType'] as String,
  sessionName: json['sessionName'] as String?,
  status: $enumDecode(_$SessionStatusEnumMap, json['status']),
  startedAt: DateTime.parse(json['startedAt'] as String),
  endedAt: json['endedAt'] == null
      ? null
      : DateTime.parse(json['endedAt'] as String),
  participants: (json['participants'] as List<dynamic>)
      .map((e) => SessionPlayer.fromJson(e as Map<String, dynamic>))
      .toList(),
  moduleState: json['moduleState'] as Map<String, dynamic>,
  winnerDisplayName: json['winnerDisplayName'] as String?,
);

Map<String, dynamic> _$GameSessionToJson(_GameSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameType': instance.gameType,
      'sessionName': instance.sessionName,
      'status': _$SessionStatusEnumMap[instance.status]!,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'participants': instance.participants,
      'moduleState': instance.moduleState,
      'winnerDisplayName': instance.winnerDisplayName,
    };

const _$SessionStatusEnumMap = {
  SessionStatus.active: 'active',
  SessionStatus.completed: 'completed',
};
