import '../../core/modules/game_module_registry.dart';
import 'baseball/domain/baseball_module.dart';
import 'basketball/domain/basketball_module.dart';
import 'football/domain/football_module.dart';
import 'hockey/domain/hockey_module.dart';
import 'lacrosse/domain/lacrosse_module.dart';
import 'soccer/domain/soccer_module.dart';
import 'tennis/domain/tennis_module.dart';
import 'volleyball/domain/volleyball_module.dart';

void registerSportsModules() {
  final modules = [
    const BaseballModule(),
    const BasketballModule(),
    const FootballModule(),
    const SoccerModule(),
    const TennisModule(),
    const VolleyballModule(),
    const HockeyModule(),
    const LacrosseModule(),
  ];
  for (final module in modules) {
    if (GameModuleRegistry.get(module.gameTypeId) == null) {
      GameModuleRegistry.register(module);
    }
  }
}
