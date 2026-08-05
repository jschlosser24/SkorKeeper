// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yahtzee_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YahtzeeScorecard _$YahtzeeScorecardFromJson(Map<String, dynamic> json) =>
    _YahtzeeScorecard(
      ones: (json['ones'] as num?)?.toInt(),
      twos: (json['twos'] as num?)?.toInt(),
      threes: (json['threes'] as num?)?.toInt(),
      fours: (json['fours'] as num?)?.toInt(),
      fives: (json['fives'] as num?)?.toInt(),
      sixes: (json['sixes'] as num?)?.toInt(),
      threeOfAKind: (json['threeOfAKind'] as num?)?.toInt(),
      fourOfAKind: (json['fourOfAKind'] as num?)?.toInt(),
      fullHouse: (json['fullHouse'] as num?)?.toInt(),
      smallStraight: (json['smallStraight'] as num?)?.toInt(),
      largeStraight: (json['largeStraight'] as num?)?.toInt(),
      yahtzee: (json['yahtzee'] as num?)?.toInt(),
      chance: (json['chance'] as num?)?.toInt(),
      yahtzeeBonusCount: (json['yahtzeeBonusCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$YahtzeeScorecardToJson(_YahtzeeScorecard instance) =>
    <String, dynamic>{
      'ones': instance.ones,
      'twos': instance.twos,
      'threes': instance.threes,
      'fours': instance.fours,
      'fives': instance.fives,
      'sixes': instance.sixes,
      'threeOfAKind': instance.threeOfAKind,
      'fourOfAKind': instance.fourOfAKind,
      'fullHouse': instance.fullHouse,
      'smallStraight': instance.smallStraight,
      'largeStraight': instance.largeStraight,
      'yahtzee': instance.yahtzee,
      'chance': instance.chance,
      'yahtzeeBonusCount': instance.yahtzeeBonusCount,
    };

_YahtzeeState _$YahtzeeStateFromJson(Map<String, dynamic> json) =>
    _YahtzeeState(
      currentPlayerIndex: (json['currentPlayerIndex'] as num).toInt(),
      currentRollNumber: (json['currentRollNumber'] as num).toInt(),
      diceValues: (json['diceValues'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      diceHeld: (json['diceHeld'] as List<dynamic>)
          .map((e) => e as bool)
          .toList(),
      scorecards: (json['scorecards'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, YahtzeeScorecard.fromJson(e as Map<String, dynamic>)),
      ),
      playerOrder: (json['playerOrder'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      gameOver: json['gameOver'] as bool? ?? false,
      useRealDice: json['useRealDice'] as bool? ?? false,
      winnerId: json['winnerId'] as String?,
    );

Map<String, dynamic> _$YahtzeeStateToJson(_YahtzeeState instance) =>
    <String, dynamic>{
      'currentPlayerIndex': instance.currentPlayerIndex,
      'currentRollNumber': instance.currentRollNumber,
      'diceValues': instance.diceValues,
      'diceHeld': instance.diceHeld,
      'scorecards': instance.scorecards,
      'playerOrder': instance.playerOrder,
      'gameOver': instance.gameOver,
      'useRealDice': instance.useRealDice,
      'winnerId': instance.winnerId,
    };
