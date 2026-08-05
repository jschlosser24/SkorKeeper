import 'game_module.dart';

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
}
