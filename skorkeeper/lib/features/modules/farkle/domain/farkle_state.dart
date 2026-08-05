import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/modules/game_module_state.dart';

part 'farkle_state.freezed.dart';
part 'farkle_state.g.dart';

@freezed
abstract class FarkleState extends GameModuleState with _$FarkleState {
  const FarkleState._();

  const factory FarkleState({
    required String currentPlayerId,
    required int targetScore,
    required Map<String, int> playerTotals,
    required int currentTurnScore,
    required List<int> currentTurnDice,
    required int diceBanked,
    required Map<String, bool> hasOpened,
    required bool gameOver,
    String? winnerId,
    required List<String> playerOrder,
  }) = _FarkleState;

  factory FarkleState.fromJson(Map<String, dynamic> json) =>
      _$FarkleStateFromJson(json);
}
