import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/score_action.dart';
import 'darts_game_state.dart';
import 'darts_module_base.dart';

class Darts301Module extends DartsModuleBase {
  const Darts301Module({this.doubleIn = false, this.doubleOut = false})
    : super(
        variant: DartsVariant.v301,
        gameTypeId: 'darts301',
        displayName: 'Darts 301',
        description: 'Short-format x01 darts.',
        startingScore: 301,
        defaultDoubleIn: doubleIn,
        defaultDoubleOut: doubleOut,
      );

  final bool doubleIn;
  final bool doubleOut;

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    if (action is DartThrown) {
      return applyX01Throw(state as DartsGameState, action);
    }
    return state;
  }
}
