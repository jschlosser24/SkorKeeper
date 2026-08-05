import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/modules/game_module_state.dart';

part 'bowling_state.freezed.dart';
part 'bowling_state.g.dart';

enum FrameType { open, spare, strike }

@freezed
abstract class BowlingFrame with _$BowlingFrame {
  const factory BowlingFrame({
    required int frame,
    required List<int> rolls,
    required FrameType frameType,
    int? cumulativeScore,
  }) = _BowlingFrame;

  factory BowlingFrame.fromJson(Map<String, dynamic> json) =>
      _$BowlingFrameFromJson(json);
}

@freezed
abstract class BowlingState extends GameModuleState with _$BowlingState {
  const BowlingState._();

  const factory BowlingState({
    required int currentPlayerIndex,
    required int currentFrame,
    required Map<String, List<BowlingFrame>> frames,
    required List<String> playerOrder,
  }) = _BowlingState;

  factory BowlingState.fromJson(Map<String, dynamic> json) =>
      _$BowlingStateFromJson(json);
}
