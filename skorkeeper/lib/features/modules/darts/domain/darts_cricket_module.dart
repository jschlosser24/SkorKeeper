import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/win_result.dart';
import 'darts_game_state.dart';
import 'darts_module_base.dart';

class DartsCricketModule extends DartsModuleBase {
  const DartsCricketModule()
    : super(
        variant: DartsVariant.cricket,
        gameTypeId: 'dartsCricket',
        displayName: 'Darts Cricket',
        description: 'Close 15-20 and bull while outscoring opponents.',
        minPlayers: 2,
      );

  static const targets = <int>[15, 16, 17, 18, 19, 20, 25];

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    final base = DartsGameState.fromJson(super.initialState(players));
    return base
        .copyWith(
          cricketMarks: {
            for (final player in players)
              player.id: {for (final target in targets) target.toString(): 0},
          },
          cricketPoints: {for (final player in players) player.id: 0},
          variantScores: {for (final player in players) player.id: 0},
        )
        .toJson();
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    if (action is! DartThrown) {
      return state;
    }
    final current = state as DartsGameState;
    final marks = {...?current.cricketMarks};
    final points = {...?current.cricketPoints};
    if (!targets.contains(action.score)) {
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
      final allOpponentsOpen = current.playerStates.keys
          .where((id) => id != current.currentPlayerId)
          .where((id) => (marks[id]?[targetKey] ?? 0) < 3);
      if (allOpponentsOpen.isNotEmpty) {
        points[current.currentPlayerId] =
            (points[current.currentPlayerId] ?? 0) + (overflow * action.score);
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
    final win = checkWinCondition(updated);
    if (win != null) {
      return updated.copyWith(gameOver: true, winnerId: win.winnerId);
    }
    if (updated.currentThrowInTurn > 3) {
      updated = advanceTurn(updated);
    }
    return updated;
  }

  @override
  WinResult? checkWinCondition(GameModuleState state) {
    final current = state as DartsGameState;
    for (final playerId in current.playerStates.keys) {
      final marks = current.cricketMarks?[playerId];
      if (marks == null) {
        continue;
      }
      final allClosed = targets.every(
        (target) => (marks[target.toString()] ?? 0) >= 3,
      );
      final playerPoints = current.cricketPoints?[playerId] ?? 0;
      final bestPoints =
          current.cricketPoints?.values.fold<int>(
            0,
            (best, value) => value > best ? value : best,
          ) ??
          0;
      if (allClosed && playerPoints >= bestPoints) {
        return WinResult(
          winnerId: playerId,
          winnerDisplayName: playerId,
          winDescription: 'Closed all numbers',
          finalStandings: leaderboard(current),
        );
      }
    }
    return null;
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as DartsGameState;
    final entries = current.playerStates.keys.map((playerId) {
      final points = current.cricketPoints?[playerId] ?? 0;
      final marks =
          current.cricketMarks?[playerId]?.values.fold<int>(
            0,
            (sum, value) => sum + value,
          ) ??
          0;
      return LeaderboardEntry(
        playerId: playerId,
        displayName: playerId,
        colorHex: '#236192',
        rank: 0,
        scoreDisplay: '$points pts',
        sortKey: points * 100 + marks,
        isLeading: false,
      );
    }).toList()..sort((a, b) => b.sortKey.compareTo(a.sortKey));
    for (var i = 0; i < entries.length; i++) {
      entries[i] = entries[i].copyWith(rank: i + 1, isLeading: i == 0);
    }
    return entries;
  }
}
