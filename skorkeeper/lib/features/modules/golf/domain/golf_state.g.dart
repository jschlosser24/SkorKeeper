// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'golf_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GolfState _$GolfStateFromJson(Map<String, dynamic> json) => _GolfState(
  holeCount: (json['holeCount'] as num).toInt(),
  pars: (json['pars'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
  scores: (json['scores'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>).map((e) => (e as num?)?.toInt()).toList(),
    ),
  ),
  isMiniGolf: json['isMiniGolf'] as bool,
  currentHole: (json['currentHole'] as num).toInt(),
);

Map<String, dynamic> _$GolfStateToJson(_GolfState instance) =>
    <String, dynamic>{
      'holeCount': instance.holeCount,
      'pars': instance.pars,
      'scores': instance.scores,
      'isMiniGolf': instance.isMiniGolf,
      'currentHole': instance.currentHole,
    };
