// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomGameState _$CustomGameStateFromJson(Map<String, dynamic> json) =>
    _CustomGameState(
      gameName: json['gameName'] as String,
      roundLabels: (json['roundLabels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scoreDirection: $enumDecode(
        _$ScoreDirectionEnumMap,
        json['scoreDirection'],
      ),
    );

Map<String, dynamic> _$CustomGameStateToJson(_CustomGameState instance) =>
    <String, dynamic>{
      'gameName': instance.gameName,
      'roundLabels': instance.roundLabels,
      'scoreDirection': _$ScoreDirectionEnumMap[instance.scoreDirection]!,
    };

const _$ScoreDirectionEnumMap = {
  ScoreDirection.highWins: 'highWins',
  ScoreDirection.lowWins: 'lowWins',
};
