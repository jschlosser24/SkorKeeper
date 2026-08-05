import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/score_action.dart';
import 'darts_cricket_module.dart';
import 'darts_game_state.dart';

class DartsCutThroatModule extends DartsCricketModule {
  const DartsCutThroatModule();

  @override
  String get gameTypeId => 'dartsCutThroat';

  @override
  String get displayName => 'Cut Throat Cricket';

  @override
  String get description => 'Closed numbers score against every open opponent.';

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    final base = DartsGameState.fromJson(super.initialState(players));
    return base.copyWith(gameVariant: DartsVariant.cutThroatCricket).toJson();
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    if (action is! DartThrown) {
      return state;
    }
    final current = state as DartsGameState;
    final marks = {...?current.cricketMarks};
    final points = {...?current.cricketPoints};
    if (!DartsCricketModule.targets.contains(action.score)) {
      return current.currentThrowInTurn >= 3
          ? advanceTurn(current)
          : current.copyWith(
              currentThrowInTurn: current.currentThrowInTurn + 1,
              throwsThisTurn: [...current.throwsThisTurn, 0],
            );
    }
    final targetKey = action.score.toString();
    final playerMarks = {...?marks[current.currentPlayerId]};
    final currentMarks = playerMarks[targetKey] ?? 0;
    final nextMarks = (currentMarks + action.multiplier).clamp(0, 3);
    final overflow = currentMarks + action.multiplier - 3;
    playerMarks[targetKey] = nextMarks;
    marks[current.currentPlayerId] = playerMarks;
    if (overflow > 0) {
      final openOpponents = current.playerStates.keys
          .where((id) => id != current.currentPlayerId)
          .where((id) => (marks[id]?[targetKey] ?? 0) < 3);
      for (final opponentId in openOpponents) {
        points[opponentId] =
            (points[opponentId] ?? 0) + (overflow * action.score);
      }
    }
    var updated = current.copyWith(
      cricketMarks: marks,
      cricketPoints: points,
      variantScores: points,
      currentThrowInTurn: current.currentThrowInTurn + 1,
      throwsThisTurn: [
        ...current.throwsThisTurn,
        action.score * action.multiplier,
      ],
      playerStates: {
        ...current.playerStates,
        current.currentPlayerId: current.playerStates[current.currentPlayerId]!
            .copyWith(
              dartsThrown:
                  current.playerStates[current.currentPlayerId]!.dartsThrown +
                  1,
              scoresThisLeg: [
                ...current.playerStates[current.currentPlayerId]!.scoresThisLeg,
                action.score * action.multiplier,
              ],
            ),
      },
    );
    if (updated.currentThrowInTurn > 3) {
      updated = advanceTurn(updated);
    }
    return updated;
  }
}
