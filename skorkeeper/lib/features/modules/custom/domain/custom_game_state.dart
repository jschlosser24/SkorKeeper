import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/modules/game_module_state.dart';

part 'custom_game_state.freezed.dart';
part 'custom_game_state.g.dart';

enum ScoreDirection { highWins, lowWins }

@freezed
abstract class CustomGameState extends GameModuleState with _$CustomGameState {
  const CustomGameState._();

  const factory CustomGameState({
    required String gameName,
    required List<String> roundLabels,
    required ScoreDirection scoreDirection,
  }) = _CustomGameState;

  factory CustomGameState.fromJson(Map<String, dynamic> json) =>
      _$CustomGameStateFromJson(json);
}
