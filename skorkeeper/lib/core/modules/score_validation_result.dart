import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_validation_result.freezed.dart';

@freezed
abstract class ScoreValidationResult with _$ScoreValidationResult {
  const factory ScoreValidationResult.valid() = ValidScore;
  const factory ScoreValidationResult.invalid({
    required String reason,
    required String shortCode,
  }) = InvalidScore;
}

class InvalidScoreActionException implements Exception {
  const InvalidScoreActionException(this.message, {required this.ruleCode});

  final String message;
  final String ruleCode;

  @override
  String toString() =>
      'InvalidScoreActionException(' + ruleCode + '): ' + message;
}
