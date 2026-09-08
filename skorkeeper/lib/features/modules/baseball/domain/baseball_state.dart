import '../../shared/sport_module_utils.dart';

class BaseballStateHelper {
  const BaseballStateHelper._();

  /// Plate appearance results that count as a base hit.
  static const List<String> hitResults = ['single', 'double', 'triple', 'home_run'];

  /// Plate appearance results that record an out and advance the outs counter.
  static const List<String> outResults = ['out', 'strikeout'];

  static Map<String, dynamic> initial({String format = 'innings_9'}) => {
        'currentInning': 1,
        'currentHalf': 'top',
        'outs': 0,
        'balls': 0,
        'strikes': 0,
        'homeBatterIndex': 0,
        'awayBatterIndex': 0,
        'maxInnings': parseInnings(format),
      };

  /// Parses a game-format string into an innings count (1–9).
  ///
  /// Accepts the new `innings_N` format (N between 1 and 9), the legacy
  /// `nine_inning` / `seven_inning` values, and `scrimmage` (open-ended — the
  /// game only ends when the user taps "End Game").
  static int parseInnings(String format) {
    if (format == 'scrimmage') {
      return 99;
    }
    if (format == 'nine_inning') {
      return 9;
    }
    if (format == 'seven_inning') {
      return 7;
    }
    final match = RegExp(r'^innings_(\d+)$').firstMatch(format);
    if (match != null) {
      final value = int.tryParse(match.group(1)!) ?? 9;
      return value.clamp(1, 9);
    }
    return 9;
  }

  static Map<String, dynamic> initialTeamStats() => {
        'hits': 0,
        'errors': 0,
        'strikeouts': 0,
        'walks': 0,
        'earnedRuns': 0,
        'atBats': 0,
        'rbi': 0,
        'inningScores': <int>[],
        'inningHits': <int>[],
        'inningErrors': <int>[],
      };

  /// The team id ('home' or 'away') currently at bat for [currentHalf].
  ///
  /// The visiting (away) team bats in the top half; the home team bats in
  /// the bottom half — matching a standard baseball scorebook.
  static String battingTeamId(String currentHalf) =>
      currentHalf == 'bottom' ? 'home' : 'away';

  /// The team id currently in the field for [currentHalf].
  static String fieldingTeamId(String currentHalf) =>
      currentHalf == 'bottom' ? 'away' : 'home';

  static double battingAverage(Map<String, dynamic> stats) {
    final hits = SportModuleUtils.asInt(stats['hits']);
    final atBats = SportModuleUtils.asInt(stats['atBats']);
    if (atBats == 0) {
      return 0;
    }
    return hits / atBats;
  }

  static double era(Map<String, dynamic> stats, int inningsPitched) {
    if (inningsPitched <= 0) {
      return 0;
    }
    final earnedRuns = SportModuleUtils.asInt(stats['earnedRuns']);
    return earnedRuns / inningsPitched * 9;
  }
}
