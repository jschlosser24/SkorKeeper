// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farkle_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FarkleState _$FarkleStateFromJson(Map<String, dynamic> json) => _FarkleState(
  currentPlayerId: json['currentPlayerId'] as String,
  targetScore: (json['targetScore'] as num).toInt(),
  playerTotals: Map<String, int>.from(json['playerTotals'] as Map),
  currentTurnScore: (json['currentTurnScore'] as num).toInt(),
  currentTurnDice: (json['currentTurnDice'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  diceBanked: (json['diceBanked'] as num).toInt(),
  hasOpened: Map<String, bool>.from(json['hasOpened'] as Map),
  gameOver: json['gameOver'] as bool,
  winnerId: json['winnerId'] as String?,
  playerOrder: (json['playerOrder'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$FarkleStateToJson(_FarkleState instance) =>
    <String, dynamic>{
      'currentPlayerId': instance.currentPlayerId,
      'targetScore': instance.targetScore,
      'playerTotals': instance.playerTotals,
      'currentTurnScore': instance.currentTurnScore,
      'currentTurnDice': instance.currentTurnDice,
      'diceBanked': instance.diceBanked,
      'hasOpened': instance.hasOpened,
      'gameOver': instance.gameOver,
      'winnerId': instance.winnerId,
      'playerOrder': instance.playerOrder,
    };
