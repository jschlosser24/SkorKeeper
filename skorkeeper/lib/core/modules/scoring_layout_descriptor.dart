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

  /// Sports layout with team scores, optional period/inning counter, and a
  /// sport-specific action button grid. Unlocked by the Sports Plan tier.
  sportsBasic,

  /// Sports layout that adds player-level stat attribution, in-depth event
  /// tracking, and advanced metrics. Requires the Sports Pro tier.
  sportsInDepth,
}

@freezed
abstract class ScoringLayoutDescriptor with _$ScoringLayoutDescriptor {
  const factory ScoringLayoutDescriptor({
    required ScoringLayoutType type,
    required Map<String, dynamic> config,
  }) = _ScoringLayoutDescriptor;
}
