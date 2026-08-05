// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dominoes_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DominoesState _$DominoesStateFromJson(Map<String, dynamic> json) =>
    _DominoesState(
      currentRound: (json['currentRound'] as num).toInt(),
      playerTotals: Map<String, int>.from(json['playerTotals'] as Map),
      gameOver: json['gameOver'] as bool,
      winnerId: json['winnerId'] as String?,
      playerOrder: (json['playerOrder'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DominoesStateToJson(_DominoesState instance) =>
    <String, dynamic>{
      'currentRound': instance.currentRound,
      'playerTotals': instance.playerTotals,
      'gameOver': instance.gameOver,
      'winnerId': instance.winnerId,
      'playerOrder': instance.playerOrder,
    };
