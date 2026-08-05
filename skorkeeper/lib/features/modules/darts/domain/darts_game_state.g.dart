// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'darts_game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DartsPlayerState _$DartsPlayerStateFromJson(Map<String, dynamic> json) =>
    _DartsPlayerState(
      scoreRemaining: (json['scoreRemaining'] as num).toInt(),
      dartsThrown: (json['dartsThrown'] as num).toInt(),
      scoresThisLeg: (json['scoresThisLeg'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      hasOpened: json['hasOpened'] as bool,
    );

Map<String, dynamic> _$DartsPlayerStateToJson(_DartsPlayerState instance) =>
    <String, dynamic>{
      'scoreRemaining': instance.scoreRemaining,
      'dartsThrown': instance.dartsThrown,
      'scoresThisLeg': instance.scoresThisLeg,
      'hasOpened': instance.hasOpened,
    };

_DartsGameState _$DartsGameStateFromJson(Map<String, dynamic> json) =>
    _DartsGameState(
      gameVariant: $enumDecode(_$DartsVariantEnumMap, json['gameVariant']),
      doubleIn: json['doubleIn'] as bool,
      doubleOut: json['doubleOut'] as bool,
      playerStates: (json['playerStates'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, DartsPlayerState.fromJson(e as Map<String, dynamic>)),
      ),
      currentPlayerId: json['currentPlayerId'] as String,
      currentThrowInTurn: (json['currentThrowInTurn'] as num).toInt(),
      throwsThisTurn: (json['throwsThisTurn'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      legsWon: Map<String, int>.from(json['legsWon'] as Map),
      setsWon: Map<String, int>.from(json['setsWon'] as Map),
      cricketMarks: (json['cricketMarks'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Map<String, int>.from(e as Map)),
      ),
      cricketPoints: (json['cricketPoints'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      gameOver: json['gameOver'] as bool,
      winnerId: json['winnerId'] as String?,
      variantScores: (json['variantScores'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      variantProgress: (json['variantProgress'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      killerTargets: (json['killerTargets'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      killerLives: (json['killerLives'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      killerStatus: (json['killerStatus'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
      currentRound: (json['currentRound'] as num?)?.toInt(),
      currentTarget: (json['currentTarget'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DartsGameStateToJson(_DartsGameState instance) =>
    <String, dynamic>{
      'gameVariant': _$DartsVariantEnumMap[instance.gameVariant]!,
      'doubleIn': instance.doubleIn,
      'doubleOut': instance.doubleOut,
      'playerStates': instance.playerStates,
      'currentPlayerId': instance.currentPlayerId,
      'currentThrowInTurn': instance.currentThrowInTurn,
      'throwsThisTurn': instance.throwsThisTurn,
      'legsWon': instance.legsWon,
      'setsWon': instance.setsWon,
      'cricketMarks': instance.cricketMarks,
      'cricketPoints': instance.cricketPoints,
      'gameOver': instance.gameOver,
      'winnerId': instance.winnerId,
      'variantScores': instance.variantScores,
      'variantProgress': instance.variantProgress,
      'killerTargets': instance.killerTargets,
      'killerLives': instance.killerLives,
      'killerStatus': instance.killerStatus,
      'currentRound': instance.currentRound,
      'currentTarget': instance.currentTarget,
    };

const _$DartsVariantEnumMap = {
  DartsVariant.v301: 'v301',
  DartsVariant.v501: 'v501',
  DartsVariant.v701: 'v701',
  DartsVariant.cricket: 'cricket',
  DartsVariant.cutThroatCricket: 'cutThroatCricket',
  DartsVariant.aroundTheClock: 'aroundTheClock',
  DartsVariant.shanghai: 'shanghai',
  DartsVariant.killer: 'killer',
  DartsVariant.halveIt: 'halveIt',
};
