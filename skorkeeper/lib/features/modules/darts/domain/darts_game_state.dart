import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/modules/game_module_state.dart';

part 'darts_game_state.freezed.dart';
part 'darts_game_state.g.dart';

enum DartsVariant {
  v301,
  v501,
  v701,
  cricket,
  cutThroatCricket,
  aroundTheClock,
  shanghai,
  killer,
  halveIt,
}

@freezed
abstract class DartsPlayerState with _$DartsPlayerState {
  const factory DartsPlayerState({
    required int scoreRemaining,
    required int dartsThrown,
    required List<int> scoresThisLeg,
    required bool hasOpened,
  }) = _DartsPlayerState;

  factory DartsPlayerState.fromJson(Map<String, dynamic> json) =>
      _$DartsPlayerStateFromJson(json);
}

@freezed
@JsonSerializable(explicitToJson: true)
abstract class DartsGameState extends GameModuleState with _$DartsGameState {
  const DartsGameState._();

  const factory DartsGameState({
    required DartsVariant gameVariant,
    required bool doubleIn,
    required bool doubleOut,
    required Map<String, DartsPlayerState> playerStates,
    required String currentPlayerId,
    required int currentThrowInTurn,
    required List<int> throwsThisTurn,
    required Map<String, int> legsWon,
    required Map<String, int> setsWon,
    Map<String, Map<String, int>>? cricketMarks,
    Map<String, int>? cricketPoints,
    required bool gameOver,
    String? winnerId,
    Map<String, int>? variantScores,
    Map<String, int>? variantProgress,
    Map<String, int>? killerTargets,
    Map<String, int>? killerLives,
    Map<String, bool>? killerStatus,
    int? currentRound,
    int? currentTarget,
  }) = _DartsGameState;

  factory DartsGameState.fromJson(Map<String, dynamic> json) =>
      _$DartsGameStateFromJson(json);
}
