class TennisStateHelper {
  const TennisStateHelper._();

  static Map<String, dynamic> initial({String format = 'best_of_3'}) => {
        'currentSet': 1,
        'homeGamesThisSet': 0,
        'awayGamesThisSet': 0,
        'homePoints': 0,
        'awayPoints': 0,
        'homeTiebreakPoints': 0,
        'awayTiebreakPoints': 0,
        'isTiebreak': false,
        'servingTeamId': 'home',
        'setScores': <Map<String, int>>[],
        'targetSets': format == 'best_of_7'
            ? 4
            : format == 'best_of_5'
            ? 3
            : format == 'one_set'
                ? 1
                : 2,
      };

  static Map<String, dynamic> initialTeamStats() => {
        'setsWon': 0,
        'totalGamesWon': 0,
        'setScores': <Map<String, int>>[],
      };
}
