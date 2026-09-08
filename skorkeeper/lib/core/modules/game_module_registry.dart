import 'game_module.dart';
import '../monetization/sports_entitlement.dart';
import 'sport_enums.dart';

class GameModuleRegistry {
  GameModuleRegistry._();

  static final Map<String, GameModule> _modules = <String, GameModule>{};

  static void register(GameModule module) {
    assert(
      !_modules.containsKey(module.gameTypeId),
      'Duplicate game module: ' + module.gameTypeId,
    );
    _modules[module.gameTypeId] = module;
  }

  static GameModule? get(String gameTypeId) => _modules[gameTypeId];

  static List<GameModule> get all => List.unmodifiable(_modules.values);

  static void clear() => _modules.clear();

  /// All registered sport modules (gameTypeId starts with 'sport_').
  static List<GameModule> get sportModules =>
      _modules.values
          .where((m) => m.gameTypeId.startsWith('sport_'))
          .toList();

  /// Sport modules accessible with the given [entitlement].
  ///
  /// Returns all sport modules the user is permitted to launch based on their
  /// current [SportsEntitlement].
  static List<GameModule> sportModulesFor(SportsEntitlement entitlement) {
    return sportModules.where((m) {
      final sport = SportType.values.firstWhere(
        (s) => s.gameTypeId == m.gameTypeId,
        orElse: () => SportType.baseball,
      );
      return entitlement.canAccess(sport);
    }).toList();
  }
}
