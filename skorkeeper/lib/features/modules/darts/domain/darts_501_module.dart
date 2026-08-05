import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/score_action.dart';
import 'darts_game_state.dart';
import 'darts_module_base.dart';

class Darts501Module extends DartsModuleBase {
  const Darts501Module({this.doubleIn = false, this.doubleOut = false})
    : super(
        variant: DartsVariant.v501,
        gameTypeId: 'darts501',
        displayName: 'Darts 501',
        description:
            'Classic x01 darts with optional double-in and double-out.',
        startingScore: 501,
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
