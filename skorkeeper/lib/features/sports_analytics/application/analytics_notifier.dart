import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/database_provider.dart';
import '../domain/analytics_calculator.dart';

part 'analytics_notifier.g.dart';

@riverpod
class AnalyticsNotifier extends _$AnalyticsNotifier {
  final AnalyticsCalculator _calculator = const AnalyticsCalculator();

  @override
  Future<SeasonSummary> build() async {
    final records = await ref.read(appDatabaseProvider).sportHistoryDao.getSportGames();
    return _calculator.computeSummary(records);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final records = await ref.read(appDatabaseProvider).sportHistoryDao.getSportGames();
      return _calculator.computeSummary(records);
    });
  }
}
