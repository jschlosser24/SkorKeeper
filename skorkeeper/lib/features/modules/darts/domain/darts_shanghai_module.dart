import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/win_result.dart';
import 'darts_game_state.dart';
import 'darts_module_base.dart';

class DartsShanghaiModule extends DartsModuleBase {
  const DartsShanghaiModule()
    : super(
        variant: DartsVariant.shanghai,
        gameTypeId: 'dartsShanghai',
        displayName: 'Shanghai',
        description: 'Seven rounds, highest score wins, Shanghai is instant.',
      );

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    final base = DartsGameState.fromJson(super.initialState(players));
    return base
        .copyWith(
          variantScores: {for (final player in players) player.id: 0},
          currentRound: 1,
          currentTarget: 1,
        )
        .toJson();
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    if (action is! DartThrown) {
      return state;
    }
    final current = state as DartsGameState;
    final scores = {...?current.variantScores};
    final roundTarget = current.currentRound ?? 1;
    if (action.score == roundTarget) {
      scores[current.currentPlayerId] =
          (scores[current.currentPlayerId] ?? 0) +
          (action.score * action.multiplier);
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
      variantScores: scores,
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
    final roundHits = updated.throwsThisTurn.toSet();
    if (roundHits.contains(roundTarget) &&
        roundHits.contains(roundTarget * 2) &&
        roundHits.contains(roundTarget * 3)) {
      return updated.copyWith(
        gameOver: true,
        winnerId: current.currentPlayerId,
      );
    }
    if (updated.currentThrowInTurn > 3) {
      final next = advanceTurn(updated);
      if ((next.currentRound ?? 1) > 7) {
        final winner =
            (scores.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value)))
                .first
                .key;
        return next.copyWith(gameOver: true, winnerId: winner);
      }
      return next;
    }
    return updated;
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as DartsGameState;
    final entries = current.playerStates.keys.map((playerId) {
      final score = current.variantScores?[playerId] ?? 0;
      return LeaderboardEntry(
        playerId: playerId,
        displayName: playerId,
        colorHex: '#236192',
        rank: 0,
        scoreDisplay: '$score pts',
        sortKey: score,
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
      winDescription: 'Won Shanghai',
      finalStandings: leaderboard(current),
    );
  }
}
