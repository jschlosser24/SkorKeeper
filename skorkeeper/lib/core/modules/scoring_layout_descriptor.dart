import 'package:freezed_annotation/freezed_annotation.dart';

part 'scoring_layout_descriptor.freezed.dart';

enum ScoringLayoutType {
  numericKeypad,
  dartsKeypad,
  yahtzeeScorecard,
  golfScorecard,
  cribbageBoard,
  bowlingSheet,
  livesCounter,
}

@freezed
abstract class ScoringLayoutDescriptor with _$ScoringLayoutDescriptor {
  const factory ScoringLayoutDescriptor({
    required ScoringLayoutType type,
    required Map<String, dynamic> config,
  }) = _ScoringLayoutDescriptor;
}
