class SoccerStateHelper {
  const SoccerStateHelper._();

  static Map<String, dynamic> initial() => {
        'currentHalf': 1,
        'possessingTeamId': 'home',
        'homePossessionSeconds': 0,
        'awayPossessionSeconds': 0,
        'halfPossessionSnapshots': <Map<String, dynamic>>[],
      };

  static Map<String, dynamic> initialTeamStats() => {
        'goals': 0,
        'halfScores': <int>[],
        'possessionSeconds': 0,
      };
}
