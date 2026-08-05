import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/modules/game_module_state.dart';

part 'cribbage_state.freezed.dart';
part 'cribbage_state.g.dart';

@freezed
abstract class CribbagePegPosition with _$CribbagePegPosition {
  const factory CribbagePegPosition({required int front, required int rear}) =
      _CribbagePegPosition;

  factory CribbagePegPosition.fromJson(Map<String, dynamic> json) =>
      _$CribbagePegPositionFromJson(json);
}

@freezed
abstract class CribbageState extends GameModuleState with _$CribbageState {
  const CribbageState._();

  const factory CribbageState({
    required String variant,
    required String dealerId,
    required Map<String, CribbagePegPosition> pegPositions,
    required bool gameOver,
    String? winnerId,
    required int handNumber,
  }) = _CribbageState;

  factory CribbageState.fromJson(Map<String, dynamic> json) =>
      _$CribbageStateFromJson(json);
}
