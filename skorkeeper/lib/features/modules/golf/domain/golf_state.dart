import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/modules/game_module_state.dart';

part 'golf_state.freezed.dart';
part 'golf_state.g.dart';

@freezed
abstract class GolfState extends GameModuleState with _$GolfState {
  const GolfState._();

  const factory GolfState({
    required int holeCount,
    required List<int> pars,
    required Map<String, List<int?>> scores,
    required bool isMiniGolf,
    required int currentHole,
  }) = _GolfState;

  factory GolfState.fromJson(Map<String, dynamic> json) =>
      _$GolfStateFromJson(json);
}

String relativeToParLabel(int strokes, int par) {
  final diff = strokes - par;
  if (diff <= -3) {
    return 'Albatross';
  }
  if (diff == -2) {
    return 'Eagle';
  }
  if (diff == -1) {
    return 'Birdie';
  }
  if (diff == 0) {
    return 'Par';
  }
  if (diff == 1) {
    return 'Bogey';
  }
  if (diff == 2) {
    return 'Double Bogey';
  }
  if (diff == 3) {
    return 'Triple Bogey';
  }
  return '+$diff';
}
