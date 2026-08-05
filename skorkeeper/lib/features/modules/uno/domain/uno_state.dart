import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/modules/game_module_state.dart';

part 'uno_state.freezed.dart';
part 'uno_state.g.dart';

@freezed
abstract class UnoState extends GameModuleState with _$UnoState {
  const UnoState._();

  const factory UnoState({
    required int currentRound,
    required int targetScore,
    required Map<String, int> playerTotals,
    required List<String> eliminatedPlayerIds,
    required bool gameOver,
    String? winnerId,
    required List<String> playerOrder,
  }) = _UnoState;

  factory UnoState.fromJson(Map<String, dynamic> json) =>
      _$UnoStateFromJson(json);
}
