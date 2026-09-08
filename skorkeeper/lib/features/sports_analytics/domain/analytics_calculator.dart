import '../../../core/database/daos/sport_history_dao.dart';
import '../../../core/modules/sport_enums.dart';
import '../../modules/baseball/domain/baseball_state.dart';
import '../../modules/shared/sport_module_utils.dart';

class SeasonSummary {
  const SeasonSummary({
    required this.gamesPerSport,
    required this.averageScores,
    required this.scoringTrend,
    required this.sportMetrics,
  });

  final Map<String, int> gamesPerSport;
  final Map<String, double> averageScores;
  final List<String> scoringTrend;
  final Map<String, String> sportMetrics;
}

class AnalyticsCalculator {
  const AnalyticsCalculator();

  SeasonSummary computeSummary(List<SportHistoryRecord> records) {
    final gamesPerSport = <String, int>{};
    final totalScore = <String, int>{};
    final scoringTrend = <String>[];
    final sportMetrics = <String, String>{};
    for (final record in records) {
      final sport = record.state.sportType.displayName;
      gamesPerSport[sport] = (gamesPerSport[sport] ?? 0) + 1;
      totalScore[sport] =
          (totalScore[sport] ?? 0) + record.state.homeTeam.score + record.state.awayTeam.score;
      scoringTrend.add(
        '$sport • ${record.state.awayTeam.name} ${record.state.awayTeam.score}-${record.state.homeTeam.score} ${record.state.homeTeam.name}',
      );
      if (record.state.sportType == SportType.baseball) {
        sportMetrics['Baseball BA / ERA'] =
            '${BaseballStateHelper.battingAverage(record.state.homeTeam.stats).toStringAsFixed(3)} / '
            '${BaseballStateHelper.era(record.state.homeTeam.stats, SportModuleUtils.asInt(record.state.sportSpecific['maxInnings'])).toStringAsFixed(2)}';
      } else if (record.state.sportType == SportType.basketball) {
        sportMetrics['Basketball FG%'] =
            '${((SportModuleUtils.asDouble(record.state.homeTeam.stats['fgPercentage'])) * 100).toStringAsFixed(1)}%';
      } else if (record.state.sportType == SportType.soccer) {
        final home = SportModuleUtils.asInt(record.state.homeTeam.stats['possessionSeconds']);
        final away = SportModuleUtils.asInt(record.state.awayTeam.stats['possessionSeconds']);
        final total = home + away;
        final pct = total == 0 ? 0 : home / total * 100;
        sportMetrics['Soccer Possession'] = '${pct.toStringAsFixed(1)}%';
      }
    }
    final averages = <String, double>{};
    for (final entry in gamesPerSport.entries) {
      averages[entry.key] = entry.value == 0
          ? 0
          : (totalScore[entry.key] ?? 0) / entry.value;
    }
    return SeasonSummary(
      gamesPerSport: gamesPerSport,
      averageScores: averages,
      scoringTrend: scoringTrend,
      sportMetrics: sportMetrics,
    );
  }
}
