import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/win_result.dart';
import 'darts_game_state.dart';
import 'darts_module_base.dart';

class DartsAroundTheClockModule extends DartsModuleBase {
  const DartsAroundTheClockModule()
    : super(
        variant: DartsVariant.aroundTheClock,
        gameTypeId: 'dartsAroundTheClock',
        displayName: 'Around the Clock',
        description: 'Hit 1-20 in order, then bull to finish.',
      );

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    final base = DartsGameState.fromJson(super.initialState(players));
    return base
        .copyWith(variantProgress: {for (final player in players) player.id: 1})
        .toJson();
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    if (action is! DartThrown) {
      return state;
    }
    final current = state as DartsGameState;
    final progress = {...?current.variantProgress};
    final target = progress[current.currentPlayerId] ?? 1;
    final hit = target <= 20
        ? action.score == target
        : target == 21 && action.score == 25;
    if (hit) {
      progress[current.currentPlayerId] = target + 1;
    }
    final updatedPlayer = current.playerStates[current.currentPlayerId]!
        .copyWith(
          dartsThrown:
              current.playerStates[current.currentPlayerId]!.dartsThrown + 1,
          scoresThisLeg: [
            ...current.playerStates[current.currentPlayerId]!.scoresThisLeg,
            action.score * action.multiplier,
          ],
        );
    var updated = current.copyWith(
      variantProgress: progress,
      currentThrowInTurn: current.currentThrowInTurn + 1,
      throwsThisTurn: [
        ...current.throwsThisTurn,
        action.score * action.multiplier,
      ],
      playerStates: {
        ...current.playerStates,
        current.currentPlayerId: updatedPlayer,
      },
    );
    if ((progress[current.currentPlayerId] ?? 1) > 21) {
      updated = updated.copyWith(
        gameOver: true,
        winnerId: current.currentPlayerId,
      );
    }
    if (!updated.gameOver && updated.currentThrowInTurn > 3) {
      updated = advanceTurn(updated);
    }
    return updated;
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as DartsGameState;
    final entries = current.playerStates.keys.map((playerId) {
      final progress = (current.variantProgress?[playerId] ?? 1) - 1;
      return LeaderboardEntry(
        playerId: playerId,
        displayName: playerId,
        colorHex: '#236192',
        rank: 0,
        scoreDisplay: 'Hit $progress',
        sortKey: progress,
        isLeading: false,
      );
    }).toList()..sort((a, b) => b.sortKey.compareTo(a.sortKey));
    for (var i = 0; i < entries.length; i++) {
      entries[i] = entries[i].copyWith(rank: i + 1, isLeading: i == 0);
    }
    return entries;
  }

  @override
  WinResult? checkWinCondition(GameModuleState state) {
    final current = state as DartsGameState;
    if (!current.gameOver || current.winnerId == null) {
      return null;
    }
    return WinResult(
      winnerId: current.winnerId!,
      winnerDisplayName: current.winnerId!,
      winDescription: 'Completed the clock',
      finalStandings: leaderboard(current),
    );
  }
}
