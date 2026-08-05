sealed class ScoreAction {
  const ScoreAction();
}

class CustomRoundScoreEntered extends ScoreAction {
  const CustomRoundScoreEntered({
    required this.playerId,
    required this.value,
    required this.roundNumber,
  });

  final String playerId;
  final int value;
  final int roundNumber;
}

class DartThrown extends ScoreAction {
  const DartThrown({required this.score, required this.multiplier});

  final int score;
  final int multiplier;
}

class YahtzeeScoreSelected extends ScoreAction {
  const YahtzeeScoreSelected({
    required this.playerId,
    required this.category,
    this.manualScore,
    this.yahtzeeBonus = false,
  });

  final String playerId;
  final dynamic category;
  /// When set, bypasses dice-based computation and uses this score directly.
  final int? manualScore;
  /// True when the player rolled a Yahtzee bonus (already has 50 in Yahtzee box).
  final bool yahtzeeBonus;
}

class GolfHoleScoreEntered extends ScoreAction {
  const GolfHoleScoreEntered({
    required this.playerId,
    required this.hole,
    required this.strokes,
  });

  final String playerId;
  final int hole;
  final int strokes;
}

class CribbagePointsScored extends ScoreAction {
  const CribbagePointsScored({required this.playerId, required this.points});

  final String playerId;
  final int points;
}

class BowlingRollEntered extends ScoreAction {
  const BowlingRollEntered({required this.pins});

  final int pins;
}

class FarkleBankScore extends ScoreAction {
  const FarkleBankScore({required this.turnScore});

  final int turnScore;
}

class FarkleFarkled extends ScoreAction {
  const FarkleFarkled();
}

class UnoRoundScoreEntered extends ScoreAction {
  const UnoRoundScoreEntered({required this.playerId, required this.points});

  final String playerId;
  final int points;
}

class DominoesRoundScoreEntered extends ScoreAction {
  const DominoesRoundScoreEntered({required this.playerId, required this.pips});

  final String playerId;
  final int pips;
}
