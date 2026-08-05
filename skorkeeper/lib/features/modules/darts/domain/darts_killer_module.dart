import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/win_result.dart';
import 'darts_game_state.dart';
import 'darts_module_base.dart';

class DartsKillerModule extends DartsModuleBase {
  const DartsKillerModule()
    : super(
        variant: DartsVariant.killer,
        gameTypeId: 'dartsKiller',
        displayName: 'Killer',
        description:
            'Claim your number, become killer, then knock out opponents.',
        minPlayers: 2,
      );

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    final base = DartsGameState.fromJson(super.initialState(players));
    return base
        .copyWith(
          killerTargets: {
            for (var i = 0; i < players.length; i++)
              players[i].id: (i % 20) + 1,
          },
          killerLives: {for (final player in players) player.id: 3},
          killerStatus: {for (final player in players) player.id: false},
          variantProgress: {for (final player in players) player.id: 0},
          variantScores: {for (final player in players) player.id: 3},
        )
        .toJson();
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    if (action is! DartThrown) {
      return state;
    }
    final current = state as DartsGameState;
    final lives = {...?current.killerLives};
    final status = {...?current.killerStatus};
    final progress = {...?current.variantProgress};
    final targets = {...?current.killerTargets};
    final ownTarget = targets[current.currentPlayerId];
    if (ownTarget != null &&
        action.score == ownTarget &&
        !(status[current.currentPlayerId] ?? false)) {
      final nextProgress =
          (progress[current.currentPlayerId] ?? 0) + action.multiplier;
      progress[current.currentPlayerId] = nextProgress;
      if (nextProgress >= 3) {
        status[current.currentPlayerId] = true;
      }
    } else if (status[current.currentPlayerId] ?? false) {
      for (final entry in targets.entries) {
        if (entry.key == current.currentPlayerId) {
          continue;
        }
        if (entry.value == action.score && (lives[entry.key] ?? 0) > 0) {
          lives[entry.key] = ((lives[entry.key] ?? 0) - action.multiplier)
              .clamp(0, 3);
        }
      }
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
      killerLives: lives,
      killerStatus: status,
      variantProgress: progress,
      variantScores: lives,
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
    final alive = lives.entries.where((entry) => entry.value > 0).toList();
    if (alive.length == 1) {
      updated = updated.copyWith(gameOver: true, winnerId: alive.first.key);
    } else if (updated.currentThrowInTurn > 3) {
      updated = advanceTurn(updated);
    }
    return updated;
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as DartsGameState;
    final entries = current.playerStates.keys.map((playerId) {
      final lives = current.killerLives?[playerId] ?? 0;
      final killer = current.killerStatus?[playerId] ?? false;
      return LeaderboardEntry(
        playerId: playerId,
        displayName: playerId,
        colorHex: '#236192',
        rank: 0,
        scoreDisplay: '${killer ? 'Killer' : 'Lives'}: $lives',
        sortKey: lives * 10 + (killer ? 1 : 0),
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
      winDescription: 'Last player with lives remaining',
      finalStandings: leaderboard(current),
    );
  }
}
