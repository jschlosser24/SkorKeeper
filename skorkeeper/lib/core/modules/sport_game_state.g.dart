// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sport_game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SportPlayer _$SportPlayerFromJson(Map<String, dynamic> json) => _SportPlayer(
  id: json['id'] as String,
  name: json['name'] as String,
  number: json['number'] as String?,
  stats: json['stats'] as Map<String, dynamic>? ?? const <String, dynamic>{},
);

Map<String, dynamic> _$SportPlayerToJson(_SportPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'number': instance.number,
      'stats': instance.stats,
    };

_SportTeam _$SportTeamFromJson(Map<String, dynamic> json) => _SportTeam(
  id: json['id'] as String,
  name: json['name'] as String,
  score: (json['score'] as num?)?.toInt() ?? 0,
  roster: (json['roster'] as List<dynamic>?)
      ?.map((e) => SportPlayer.fromJson(e as Map<String, dynamic>))
      .toList(),
  stats: json['stats'] as Map<String, dynamic>? ?? const <String, dynamic>{},
);

Map<String, dynamic> _$SportTeamToJson(_SportTeam instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'score': instance.score,
      'roster': instance.roster,
      'stats': instance.stats,
    };

_SportEvent _$SportEventFromJson(Map<String, dynamic> json) => _SportEvent(
  id: json['id'] as String,
  gameTimeSeconds: (json['gameTimeSeconds'] as num).toInt(),
  wallClockMs: (json['wallClockMs'] as num).toInt(),
  eventType: json['eventType'] as String,
  teamId: json['teamId'] as String,
  playerId: json['playerId'] as String?,
  pointsDelta: (json['pointsDelta'] as num?)?.toInt() ?? 0,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$SportEventToJson(_SportEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameTimeSeconds': instance.gameTimeSeconds,
      'wallClockMs': instance.wallClockMs,
      'eventType': instance.eventType,
      'teamId': instance.teamId,
      'playerId': instance.playerId,
      'pointsDelta': instance.pointsDelta,
      'metadata': instance.metadata,
    };

_SportGameState _$SportGameStateFromJson(Map<String, dynamic> json) =>
    _SportGameState(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      sportType: $enumDecode(_$SportTypeEnumMap, json['sportType']),
      trackingMode: $enumDecode(_$TrackingModeEnumMap, json['trackingMode']),
      homeTeam: SportTeam.fromJson(json['homeTeam'] as Map<String, dynamic>),
      awayTeam: SportTeam.fromJson(json['awayTeam'] as Map<String, dynamic>),
      gameFormat: json['gameFormat'] as String? ?? 'full',
      gamePhase:
          $enumDecodeNullable(_$GamePhaseEnumMap, json['gamePhase']) ??
          GamePhase.notStarted,
      elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt() ?? 0,
      timerRunning: json['timerRunning'] as bool? ?? false,
      events:
          (json['events'] as List<dynamic>?)
              ?.map((e) => SportEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SportEvent>[],
      notes: json['notes'] as String?,
      sportSpecific:
          json['sportSpecific'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );

Map<String, dynamic> _$SportGameStateToJson(_SportGameState instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'sportType': _$SportTypeEnumMap[instance.sportType]!,
      'trackingMode': _$TrackingModeEnumMap[instance.trackingMode]!,
      'homeTeam': instance.homeTeam,
      'awayTeam': instance.awayTeam,
      'gameFormat': instance.gameFormat,
      'gamePhase': _$GamePhaseEnumMap[instance.gamePhase]!,
      'elapsedSeconds': instance.elapsedSeconds,
      'timerRunning': instance.timerRunning,
      'events': instance.events,
      'notes': instance.notes,
      'sportSpecific': instance.sportSpecific,
    };

const _$SportTypeEnumMap = {
  SportType.baseball: 'baseball',
  SportType.basketball: 'basketball',
  SportType.football: 'football',
  SportType.soccer: 'soccer',
  SportType.tennis: 'tennis',
  SportType.volleyball: 'volleyball',
  SportType.hockey: 'hockey',
  SportType.lacrosse: 'lacrosse',
};

const _$TrackingModeEnumMap = {
  TrackingMode.basic: 'basic',
  TrackingMode.inDepth: 'inDepth',
};

const _$GamePhaseEnumMap = {
  GamePhase.notStarted: 'notStarted',
  GamePhase.active: 'active',
  GamePhase.paused: 'paused',
  GamePhase.periodBreak: 'periodBreak',
  GamePhase.halftimeBreak: 'halftimeBreak',
  GamePhase.tiebreakActive: 'tiebreakActive',
  GamePhase.completed: 'completed',
};
