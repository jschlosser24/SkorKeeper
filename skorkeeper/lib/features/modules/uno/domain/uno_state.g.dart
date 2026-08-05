// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uno_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnoState _$UnoStateFromJson(Map<String, dynamic> json) => _UnoState(
  currentRound: (json['currentRound'] as num).toInt(),
  targetScore: (json['targetScore'] as num).toInt(),
  playerTotals: Map<String, int>.from(json['playerTotals'] as Map),
  eliminatedPlayerIds: (json['eliminatedPlayerIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  gameOver: json['gameOver'] as bool,
  winnerId: json['winnerId'] as String?,
  playerOrder: (json['playerOrder'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UnoStateToJson(_UnoState instance) => <String, dynamic>{
  'currentRound': instance.currentRound,
  'targetScore': instance.targetScore,
  'playerTotals': instance.playerTotals,
  'eliminatedPlayerIds': instance.eliminatedPlayerIds,
  'gameOver': instance.gameOver,
  'winnerId': instance.winnerId,
  'playerOrder': instance.playerOrder,
};
