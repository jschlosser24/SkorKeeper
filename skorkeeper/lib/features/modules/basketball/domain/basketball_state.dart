class BasketballStateHelper {
  const BasketballStateHelper._();

  /// Default quarter/period duration: 12 minutes.
  static const int defaultPeriodDurationSeconds = 12 * 60;

  static Map<String, dynamic> initial({
    String format = 'full',
    int periodDurationSeconds = defaultPeriodDurationSeconds,
  }) => {
        'currentPeriod': 1,
        'periodCount': format == 'halves' ? 2 : 4,
        'periodDurationSeconds': periodDurationSeconds,
        'remainingSeconds': periodDurationSeconds,
        'possessionTeamId': 'home',
      };

  static Map<String, dynamic> initialTeamStats({int timeoutsPerTeam = 5}) => {
        'fieldGoalsMade': 0,
        'fieldGoalsAttempted': 0,
        'threesMade': 0,
        'threesAttempted': 0,
        'ftMade': 0,
        'ftAttempted': 0,
        'quarterScores': <int>[],
        'fouls': 0,
        'timeoutsRemaining': timeoutsPerTeam,
      };
}
