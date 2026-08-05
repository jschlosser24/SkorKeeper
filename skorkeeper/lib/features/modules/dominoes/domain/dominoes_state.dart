import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/modules/game_module_state.dart';

part 'dominoes_state.freezed.dart';
part 'dominoes_state.g.dart';

@freezed
abstract class DominoesState extends GameModuleState with _$DominoesState {
  const DominoesState._();

  const factory DominoesState({
    required int currentRound,
    required Map<String, int> playerTotals,
    required bool gameOver,
    String? winnerId,
    required List<String> playerOrder,
  }) = _DominoesState;

  factory DominoesState.fromJson(Map<String, dynamic> json) =>
      _$DominoesStateFromJson(json);
}
