class HockeyStateHelper {
  const HockeyStateHelper._();

  static const int defaultPeriodDurationSeconds = 20 * 60;

  static Map<String, dynamic> initial({
    int periodDurationSeconds = defaultPeriodDurationSeconds,
  }) => {
        'currentPeriod': 1,
        'periodDurationSeconds': periodDurationSeconds,
        'remainingSeconds': periodDurationSeconds,
        'isOvertime': false,
        'isShootout': false,
        'activePenalties': <Map<String, dynamic>>[],
      };

  static Map<String, dynamic> initialTeamStats() => {
        'goals': 0,
        'assists': 0,
        'penaltyMinutes': 0,
        'periodScores': <int>[],
        'shotsOnGoal': 0,
      };
}
