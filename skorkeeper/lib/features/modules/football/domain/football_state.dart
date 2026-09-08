class FootballStateHelper {
  const FootballStateHelper._();

  /// Default quarter duration: 15 minutes.
  static const int defaultPeriodDurationSeconds = 15 * 60;

  static Map<String, dynamic> initial({
    String format = 'full',
    int periodDurationSeconds = defaultPeriodDurationSeconds,
  }) => {
    'currentPeriod': 1,
    'periodCount': 4,
    'periodDurationSeconds': periodDurationSeconds,
    'remainingSeconds': periodDurationSeconds,
    'currentDown': 1,
    'yardsToGo': format == 'two_minute_drill' ? 5 : 10,
    'possessingTeamId': 'home',
  };

  static Map<String, dynamic> initialTeamStats() => {
    'totalYards': 0,
    'touchdowns': 0,
    'fieldGoals': 0,
    'safeties': 0,
    'firstDowns': 0,
    'quarterScores': <int>[],
  };
}
