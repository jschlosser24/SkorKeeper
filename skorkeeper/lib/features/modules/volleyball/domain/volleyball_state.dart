class VolleyballStateHelper {
  const VolleyballStateHelper._();

  static Map<String, dynamic> initial({String format = 'best_of_5', int pointsToWin = 25}) => {
        'currentSet': 1,
        'servingTeamId': 'home',
        'setScores': <Map<String, int>>[],
        'pointsToWin': pointsToWin,
        'targetSets': format == 'best_of_3'
            ? 2
            : format == 'one_set'
                ? 1
                : 3,
      };

  static Map<String, dynamic> initialTeamStats() => {
        'setsWon': 0,
        'totalPoints': 0,
        'setScores': <Map<String, int>>[],
      };
}
