import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../../../../core/modules/scoring_layout_descriptor.dart';
import '../../../../core/modules/win_result.dart';
import 'yahtzee_state.dart';

class YahtzeeModule implements GameModule {
  const YahtzeeModule();

  @override
  String get gameTypeId => 'yahtzee';

  @override
  String get displayName => 'Yahtzee';

  @override
  String get description => 'Official Yahtzee scorecard with built-in dice.';

  @override
  String get iconAsset =>
      '<svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><rect x="10" y="10" width="44" height="44" rx="10" fill="#FF6B35"/><circle cx="24" cy="24" r="4" fill="white"/><circle cx="40" cy="40" r="4" fill="white"/><circle cx="24" cy="40" r="4" fill="white"/><circle cx="40" cy="24" r="4" fill="white"/></svg>';

  @override
  int get minPlayers => 1;

  @override
  int get maxPlayers => 6;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return YahtzeeState(
      currentPlayerIndex: 0,
      currentRollNumber: 0,
      diceValues: const [1, 1, 1, 1, 1],
      diceHeld: const [false, false, false, false, false],
      scorecards: {
        for (final player in players) player.id: const YahtzeeScorecard(),
      },
      playerOrder: players.map((player) => player.id).toList(),
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    try {
      return YahtzeeState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    final current = state as YahtzeeState;
    if (action is! YahtzeeScoreSelected) {
      return current;
    }
    final category = action.category as YahtzeeCategory;
    final scorecards = {...current.scorecards};
    final scorecard = scorecards[action.playerId] ?? const YahtzeeScorecard();

    // Detect Yahtzee Joker: all 5 dice show same face AND Yahtzee box already scored 50.
    // In real-dice mode dice values are unreliable; rely solely on the action flag instead.
    final isYahtzeeRoll =
        !current.useRealDice && current.diceValues.toSet().length == 1;
    final alreadyScoredYahtzee = scorecard.yahtzee == 50;
    final isJoker = current.useRealDice
        ? action.yahtzeeBonus
        : (isYahtzeeRoll && alreadyScoredYahtzee);

    final score = action.manualScore ??
        computeCategoryScore(
          current.diceValues,
          category,
          scorecard,
          isJoker: isJoker,
        );

    var updatedScorecard = _setCategory(scorecard, category, score);
    if (isJoker) {
      updatedScorecard = updatedScorecard.copyWith(
        yahtzeeBonusCount: updatedScorecard.yahtzeeBonusCount + 1,
      );
    }
    scorecards[action.playerId] = updatedScorecard;

    final nextPlayerIndex =
        (current.currentPlayerIndex + 1) % current.playerOrder.length;
    final nextState = current.copyWith(
      scorecards: scorecards,
      currentPlayerIndex: nextPlayerIndex,
      currentRollNumber: 0,
      diceHeld: List<bool>.filled(5, false),
      diceValues: const [1, 1, 1, 1, 1],
    );
    final win = checkWinCondition(nextState);
    if (win != null) {
      return nextState.copyWith(gameOver: true, winnerId: win.winnerId);
    }
    return nextState;
  }

  int computeCategoryScore(
    List<int> dice,
    YahtzeeCategory category,
    YahtzeeScorecard scorecard, {
    bool isJoker = false,
  }) {
    final counts = <int, int>{};
    for (final die in dice) {
      counts[die] = (counts[die] ?? 0) + 1;
    }
    final total = dice.fold<int>(0, (sum, value) => sum + value);
    switch (category) {
      case YahtzeeCategory.ones:
        return dice.where((die) => die == 1).length * 1;
      case YahtzeeCategory.twos:
        return dice.where((die) => die == 2).length * 2;
      case YahtzeeCategory.threes:
        return dice.where((die) => die == 3).length * 3;
      case YahtzeeCategory.fours:
        return dice.where((die) => die == 4).length * 4;
      case YahtzeeCategory.fives:
        return dice.where((die) => die == 5).length * 5;
      case YahtzeeCategory.sixes:
        return dice.where((die) => die == 6).length * 6;
      case YahtzeeCategory.threeOfAKind:
        // Joker: Yahtzee counts as 3-of-a-kind; score is sum of all dice.
        return (isJoker || counts.values.any((count) => count >= 3))
            ? total
            : 0;
      case YahtzeeCategory.fourOfAKind:
        // Joker: Yahtzee counts as 4-of-a-kind; score is sum of all dice.
        return (isJoker || counts.values.any((count) => count >= 4))
            ? total
            : 0;
      case YahtzeeCategory.fullHouse:
        // Joker: Yahtzee counts as a Full House (25 pts).
        return (isJoker ||
                (counts.values.contains(3) && counts.values.contains(2)))
            ? 25
            : 0;
      case YahtzeeCategory.smallStraight:
        final unique = counts.keys.toSet();
        const runs = [
          {1, 2, 3, 4},
          {2, 3, 4, 5},
          {3, 4, 5, 6},
        ];
        // Joker: Yahtzee counts as a Small Straight (30 pts).
        return (isJoker || runs.any((run) => unique.containsAll(run))) ? 30 : 0;
      case YahtzeeCategory.largeStraight:
        final sorted = counts.keys.toList()..sort();
        // Joker: Yahtzee counts as a Large Straight (40 pts).
        return (isJoker ||
                sorted.join(',') == '1,2,3,4,5' ||
                sorted.join(',') == '2,3,4,5,6')
            ? 40
            : 0;
      case YahtzeeCategory.yahtzee:
        final isYahtzee = counts.values.any((count) => count == 5);
        if (scorecard.yahtzee != null && scorecard.yahtzee == 50 && isYahtzee) {
          return 50;
        }
        return isYahtzee ? 50 : 0;
      case YahtzeeCategory.chance:
        return total;
    }
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as YahtzeeState;
    final entries = current.scorecards.entries.map((entry) {
      final total = totalFor(entry.value);
      return LeaderboardEntry(
        playerId: entry.key,
        displayName: entry.key,
        colorHex: '#FF6B35',
        rank: 0,
        scoreDisplay: total.toString(),
        sortKey: total,
        isLeading: false,
      );
    }).toList()..sort((a, b) => b.sortKey.compareTo(a.sortKey));
    for (var i = 0; i < entries.length; i++) {
      entries[i] = entries[i].copyWith(rank: i + 1, isLeading: i == 0);
    }
    return entries;
  }

  int totalFor(YahtzeeScorecard scorecard) {
    final upper = [
      scorecard.ones,
      scorecard.twos,
      scorecard.threes,
      scorecard.fours,
      scorecard.fives,
      scorecard.sixes,
    ].whereType<int>().fold<int>(0, (sum, value) => sum + value);
    final lower = [
      scorecard.threeOfAKind,
      scorecard.fourOfAKind,
      scorecard.fullHouse,
      scorecard.smallStraight,
      scorecard.largeStraight,
      scorecard.yahtzee,
      scorecard.chance,
    ].whereType<int>().fold<int>(0, (sum, value) => sum + value);
    final bonus = upper >= 63 ? 35 : 0;
    final yahtzeeBonus = scorecard.yahtzeeBonusCount * 100;
    return upper + lower + bonus + yahtzeeBonus;
  }

  @override
  WinResult? checkWinCondition(GameModuleState state) {
    final current = state as YahtzeeState;
    final complete = current.scorecards.values.every(_allCategoriesScored);
    if (!complete) {
      return null;
    }
    final standings = leaderboard(current);
    return WinResult(
      winnerId: standings.first.playerId,
      winnerDisplayName: standings.first.displayName,
      winDescription: 'Highest Yahtzee total wins',
      finalStandings: standings,
    );
  }

  @override
  ScoringLayoutDescriptor scoringLayout(GameModuleState state) {
    return const ScoringLayoutDescriptor(
      type: ScoringLayoutType.yahtzeeScorecard,
      config: <String, dynamic>{},
    );
  }

  @override
  ScoreValidationResult validateScore(
    GameModuleState state,
    String playerId,
    dynamic proposedValue,
  ) {
    if (proposedValue is! YahtzeeScoreSelected) {
      return const ScoreValidationResult.invalid(
        reason: 'Choose a category.',
        shortCode: 'INVALID_CATEGORY',
      );
    }
    final current = state as YahtzeeState;
    final scorecard = current.scorecards[playerId];
    final category = proposedValue.category as YahtzeeCategory;
    if (_getCategory(scorecard ?? const YahtzeeScorecard(), category) != null) {
      return const ScoreValidationResult.invalid(
        reason: 'That category is already locked.',
        shortCode: 'CATEGORY_LOCKED',
      );
    }
    return const ScoreValidationResult.valid();
  }

  YahtzeeScorecard _setCategory(
    YahtzeeScorecard scorecard,
    YahtzeeCategory category,
    int value,
  ) {
    switch (category) {
      case YahtzeeCategory.ones:
        return scorecard.copyWith(ones: value);
      case YahtzeeCategory.twos:
        return scorecard.copyWith(twos: value);
      case YahtzeeCategory.threes:
        return scorecard.copyWith(threes: value);
      case YahtzeeCategory.fours:
        return scorecard.copyWith(fours: value);
      case YahtzeeCategory.fives:
        return scorecard.copyWith(fives: value);
      case YahtzeeCategory.sixes:
        return scorecard.copyWith(sixes: value);
      case YahtzeeCategory.threeOfAKind:
        return scorecard.copyWith(threeOfAKind: value);
      case YahtzeeCategory.fourOfAKind:
        return scorecard.copyWith(fourOfAKind: value);
      case YahtzeeCategory.fullHouse:
        return scorecard.copyWith(fullHouse: value);
      case YahtzeeCategory.smallStraight:
        return scorecard.copyWith(smallStraight: value);
      case YahtzeeCategory.largeStraight:
        return scorecard.copyWith(largeStraight: value);
      case YahtzeeCategory.yahtzee:
        return scorecard.copyWith(yahtzee: value);
      case YahtzeeCategory.chance:
        return scorecard.copyWith(chance: value);
    }
  }

  int? _getCategory(YahtzeeScorecard scorecard, YahtzeeCategory category) {
    switch (category) {
      case YahtzeeCategory.ones:
        return scorecard.ones;
      case YahtzeeCategory.twos:
        return scorecard.twos;
      case YahtzeeCategory.threes:
        return scorecard.threes;
      case YahtzeeCategory.fours:
        return scorecard.fours;
      case YahtzeeCategory.fives:
        return scorecard.fives;
      case YahtzeeCategory.sixes:
        return scorecard.sixes;
      case YahtzeeCategory.threeOfAKind:
        return scorecard.threeOfAKind;
      case YahtzeeCategory.fourOfAKind:
        return scorecard.fourOfAKind;
      case YahtzeeCategory.fullHouse:
        return scorecard.fullHouse;
      case YahtzeeCategory.smallStraight:
        return scorecard.smallStraight;
      case YahtzeeCategory.largeStraight:
        return scorecard.largeStraight;
      case YahtzeeCategory.yahtzee:
        return scorecard.yahtzee;
      case YahtzeeCategory.chance:
        return scorecard.chance;
    }
  }

  bool _allCategoriesScored(YahtzeeScorecard scorecard) {
    return [
      scorecard.ones,
      scorecard.twos,
      scorecard.threes,
      scorecard.fours,
      scorecard.fives,
      scorecard.sixes,
      scorecard.threeOfAKind,
      scorecard.fourOfAKind,
      scorecard.fullHouse,
      scorecard.smallStraight,
      scorecard.largeStraight,
      scorecard.yahtzee,
      scorecard.chance,
    ].every((value) => value != null);
  }
}
