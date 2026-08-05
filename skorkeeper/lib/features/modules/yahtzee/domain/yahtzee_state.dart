import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/modules/game_module_state.dart';

part 'yahtzee_state.freezed.dart';
part 'yahtzee_state.g.dart';

enum YahtzeeCategory {
  ones,
  twos,
  threes,
  fours,
  fives,
  sixes,
  threeOfAKind,
  fourOfAKind,
  fullHouse,
  smallStraight,
  largeStraight,
  yahtzee,
  chance,
}

@freezed
abstract class YahtzeeScorecard with _$YahtzeeScorecard {
  const YahtzeeScorecard._();

  const factory YahtzeeScorecard({
    int? ones,
    int? twos,
    int? threes,
    int? fours,
    int? fives,
    int? sixes,
    int? threeOfAKind,
    int? fourOfAKind,
    int? fullHouse,
    int? smallStraight,
    int? largeStraight,
    int? yahtzee,
    int? chance,
    @Default(0) int yahtzeeBonusCount,
  }) = _YahtzeeScorecard;

  factory YahtzeeScorecard.fromJson(Map<String, dynamic> json) =>
      _$YahtzeeScorecardFromJson(json);
}

@freezed
abstract class YahtzeeState extends GameModuleState with _$YahtzeeState {
  const YahtzeeState._();

  const factory YahtzeeState({
    required int currentPlayerIndex,
    required int currentRollNumber,
    required List<int> diceValues,
    required List<bool> diceHeld,
    required Map<String, YahtzeeScorecard> scorecards,
    required List<String> playerOrder,
    @Default(false) bool gameOver,
    @Default(false) bool useRealDice,
    String? winnerId,
  }) = _YahtzeeState;

  factory YahtzeeState.fromJson(Map<String, dynamic> json) =>
      _$YahtzeeStateFromJson(json);
}
