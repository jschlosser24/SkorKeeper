import '../../../core/modules/game_module_registry.dart';
import 'domain/baseball_module.dart';

void registerBaseballModule() {
  GameModuleRegistry.register(const BaseballModule());
}
