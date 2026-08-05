import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/score_action.dart';
import 'darts_game_state.dart';
import 'darts_module_base.dart';

class Darts701Module extends DartsModuleBase {
  const Darts701Module({this.doubleIn = false, this.doubleOut = false})
    : super(
        variant: DartsVariant.v701,
        gameTypeId: 'darts701',
        displayName: 'Darts 701',
        description: 'Extended x01 darts for long matches.',
        startingScore: 701,
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
