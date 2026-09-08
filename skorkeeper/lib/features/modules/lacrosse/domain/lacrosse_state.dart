class LacrosseStateHelper {
  const LacrosseStateHelper._();

  static const int defaultPeriodDurationSeconds = 15 * 60;

  static Map<String, dynamic> initial({
    int periodDurationSeconds = defaultPeriodDurationSeconds,
  }) => {
        'currentQuarter': 1,
        'periodDurationSeconds': periodDurationSeconds,
        'remainingSeconds': periodDurationSeconds,
      };

  static Map<String, dynamic> initialTeamStats() => {
        'goals': 0,
        'assists': 0,
        'groundBalls': 0,
        'clearsSuccessful': 0,
        'clearsFailed': 0,
        'quarterScores': <int>[],
      };
}
