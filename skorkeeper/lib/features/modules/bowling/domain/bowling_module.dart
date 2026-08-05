import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../../../../core/modules/scoring_layout_descriptor.dart';
import '../../../../core/modules/win_result.dart';
import 'bowling_state.dart';

class BowlingModule implements GameModule {
  const BowlingModule();

  @override
  String get gameTypeId => 'bowling';

  @override
  String get displayName => 'Bowling';

  @override
  String get description => 'Track every frame with strike and spare scoring.';

  @override
  String get iconAsset =>
      '<svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="52" height="52" rx="16" fill="#8338EC"/><circle cx="24" cy="38" r="10" fill="white"/><circle cx="22" cy="35" r="1.8" fill="#8338EC"/><circle cx="27" cy="34" r="1.8" fill="#8338EC"/><circle cx="25" cy="39" r="1.8" fill="#8338EC"/><rect x="40" y="20" width="6" height="22" rx="3" fill="#FFD700"/></svg>';

  @override
  int get minPlayers => 1;

  @override
  int get maxPlayers => 6;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return BowlingState(
      currentPlayerIndex: 0,
      currentFrame: 1,
      frames: {for (final player in players) player.id: const <BowlingFrame>[]},
      playerOrder: players.map((player) => player.id).toList(),
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    try {
      return BowlingState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    final current = state as BowlingState;
    if (action is! BowlingRollEntered) {
      return current;
    }
    final playerId = current.playerOrder[current.currentPlayerIndex];
    final allFrames = {
      for (final entry in current.frames.entries) entry.key: [...entry.value],
    };
    final playerFrames = [...(allFrames[playerId] ?? const <BowlingFrame>[])];
    final frameNumber = _activeFrameNumber(playerFrames);
    if (frameNumber > 10) {
      return current;
    }
    if (playerFrames.isEmpty || _isFrameComplete(playerFrames.last)) {
      playerFrames.add(
        BowlingFrame(
          frame: frameNumber,
          rolls: [action.pins],
          frameType: action.pins == 10 ? FrameType.strike : FrameType.open,
        ),
      );
    } else {
      final existing = playerFrames.removeLast();
      final updatedRolls = [...existing.rolls, action.pins];
      playerFrames.add(
        existing.copyWith(
          rolls: updatedRolls,
          frameType: _frameTypeFor(updatedRolls, existing.frame),
        ),
      );
    }
    allFrames[playerId] = playerFrames;
    final recalculated = _recalculate(allFrames);
    final completedFrame = _isFrameComplete(recalculated[playerId]!.last);
    final nextPlayerIndex = completedFrame
        ? (current.currentPlayerIndex + 1) % current.playerOrder.length
        : current.currentPlayerIndex;
    return current.copyWith(
      frames: recalculated,
      currentPlayerIndex: nextPlayerIndex,
      currentFrame: _deriveCurrentFrame(
        recalculated,
        current.playerOrder,
        nextPlayerIndex,
      ),
    );
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    final current = state as BowlingState;
    final entries = current.playerOrder.map((playerId) {
      final frames = current.frames[playerId] ?? const <BowlingFrame>[];
      final total = _displayTotal(frames);
      return LeaderboardEntry(
        playerId: playerId,
        displayName: playerId,
        colorHex: '#8338EC',
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

  @override
  WinResult? checkWinCondition(GameModuleState state) {
    final current = state as BowlingState;
    final complete = current.playerOrder.every((playerId) {
      final frames = current.frames[playerId] ?? const <BowlingFrame>[];
      return frames.length == 10 && _isFrameComplete(frames.last);
    });
    if (!complete) {
      return null;
    }
    final standings = leaderboard(current);
    return WinResult(
      winnerId: standings.first.playerId,
      winnerDisplayName: standings.first.displayName,
      winDescription: 'Highest pinfall wins',
      finalStandings: standings,
    );
  }

  @override
  ScoringLayoutDescriptor scoringLayout(GameModuleState state) {
    return const ScoringLayoutDescriptor(
      type: ScoringLayoutType.bowlingSheet,
      config: <String, dynamic>{},
    );
  }

  @override
  ScoreValidationResult validateScore(
    GameModuleState state,
    String playerId,
    dynamic proposedValue,
  ) {
    final pins = proposedValue is int
        ? proposedValue
        : int.tryParse(proposedValue.toString());
    if (pins == null || pins < 0 || pins > 10) {
      return const ScoreValidationResult.invalid(
        reason: 'Pins must be between 0 and 10.',
        shortCode: 'INVALID_PINS',
      );
    }
    final current = state as BowlingState;
    final activePlayerId = current.playerOrder[current.currentPlayerIndex];
    final frames = [
      ...(current.frames[activePlayerId] ?? const <BowlingFrame>[]),
    ];
    final max = _maxAllowedPins(frames);
    if (pins > max) {
      return ScoreValidationResult.invalid(
        reason: 'Only $max pins are available on this roll.',
        shortCode: 'TOO_MANY_PINS',
      );
    }
    return const ScoreValidationResult.valid();
  }

  bool canUseStrikeShortcut(BowlingState state) {
    return maxPinsForCurrentRoll(state) == 10;
  }

  int? spareShortcutPins(BowlingState state) {
    final currentPlayerId = state.playerOrder[state.currentPlayerIndex];
    final frames = [
      ...(state.frames[currentPlayerId] ?? const <BowlingFrame>[]),
    ];
    if (frames.isEmpty || _isFrameComplete(frames.last)) {
      return null;
    }
    final frame = frames.last;
    if (frame.rolls.isEmpty) {
      return null;
    }
    final remainingPins = _maxAllowedPins(frames);
    return remainingPins > 0 && remainingPins < 10 ? remainingPins : null;
  }

  int maxPinsForCurrentRoll(BowlingState state) {
    final currentPlayerId = state.playerOrder[state.currentPlayerIndex];
    final frames = [
      ...(state.frames[currentPlayerId] ?? const <BowlingFrame>[]),
    ];
    return _maxAllowedPins(frames);
  }

  int _displayTotal(List<BowlingFrame> frames) {
    final lastResolved = frames
        .where((frame) => frame.cumulativeScore != null)
        .lastOrNull;
    if (lastResolved != null) {
      return lastResolved.cumulativeScore!;
    }
    return frames
        .expand((frame) => frame.rolls)
        .fold<int>(0, (sum, roll) => sum + roll);
  }

  int _activeFrameNumber(List<BowlingFrame> frames) {
    if (frames.isEmpty) {
      return 1;
    }
    final last = frames.last;
    return _isFrameComplete(last) ? last.frame + 1 : last.frame;
  }

  int _deriveCurrentFrame(
    Map<String, List<BowlingFrame>> frames,
    List<String> playerOrder,
    int playerIndex,
  ) {
    final playerFrames =
        frames[playerOrder[playerIndex]] ?? const <BowlingFrame>[];
    final frame = _activeFrameNumber(playerFrames);
    return frame > 10 ? 10 : frame;
  }

  Map<String, List<BowlingFrame>> _recalculate(
    Map<String, List<BowlingFrame>> framesByPlayer,
  ) {
    return {
      for (final entry in framesByPlayer.entries)
        entry.key: _recalculateFramesForPlayer(entry.value),
    };
  }

  List<BowlingFrame> _recalculateFramesForPlayer(List<BowlingFrame> frames) {
    final rolls = frames.expand((frame) => frame.rolls).toList();
    var running = 0;
    final recalculated = <BowlingFrame>[];
    var rollIndex = 0;
    for (final frame in frames) {
      final frameScore = _scoreForFrame(frames, frame.frame, rollIndex, rolls);
      if (frameScore != null) {
        running += frameScore;
      }
      recalculated.add(
        frame.copyWith(cumulativeScore: frameScore == null ? null : running),
      );
      rollIndex += frame.rolls.length;
    }
    return recalculated;
  }

  int? _scoreForFrame(
    List<BowlingFrame> frames,
    int frameNumber,
    int rollIndex,
    List<int> rolls,
  ) {
    final frame = frames.firstWhere((item) => item.frame == frameNumber);
    if (frameNumber == 10) {
      return _isFrameComplete(frame)
          ? frame.rolls.fold<int>(0, (a, b) => a + b)
          : null;
    }
    if (frame.frameType == FrameType.strike) {
      return rollIndex + 2 < rolls.length
          ? 10 + rolls[rollIndex + 1] + rolls[rollIndex + 2]
          : null;
    }
    if (frame.frameType == FrameType.spare) {
      return rollIndex + 2 < rolls.length ? 10 + rolls[rollIndex + 2] : null;
    }
    return frame.rolls.length == 2 ? frame.rolls[0] + frame.rolls[1] : null;
  }

  FrameType _frameTypeFor(List<int> rolls, int frameNumber) {
    if (rolls.isEmpty) {
      return FrameType.open;
    }
    if (rolls.first == 10) {
      return FrameType.strike;
    }
    if (frameNumber < 10 && rolls.length >= 2 && rolls[0] + rolls[1] == 10) {
      return FrameType.spare;
    }
    if (frameNumber == 10 &&
        rolls.length >= 2 &&
        rolls[0] != 10 &&
        rolls[0] + rolls[1] == 10) {
      return FrameType.spare;
    }
    return FrameType.open;
  }

  bool _isFrameComplete(BowlingFrame frame) {
    if (frame.frame < 10) {
      return frame.frameType == FrameType.strike || frame.rolls.length >= 2;
    }
    if (frame.rolls.isEmpty) {
      return false;
    }
    if (frame.rolls.first == 10) {
      return frame.rolls.length >= 3;
    }
    if (frame.rolls.length < 2) {
      return false;
    }
    if (frame.rolls[0] + frame.rolls[1] == 10) {
      return frame.rolls.length >= 3;
    }
    return frame.rolls.length >= 2;
  }

  int _maxAllowedPins(List<BowlingFrame> frames) {
    if (frames.isEmpty || _isFrameComplete(frames.last)) {
      return 10;
    }
    final frame = frames.last;
    if (frame.frame < 10) {
      return 10 - frame.rolls.first;
    }
    if (frame.rolls.length == 1) {
      return frame.rolls.first == 10 ? 10 : 10 - frame.rolls.first;
    }
    if (frame.rolls.length == 2) {
      if (frame.rolls.first == 10 && frame.rolls[1] < 10) {
        return 10 - frame.rolls[1];
      }
      if (frame.rolls.first != 10 && frame.rolls[0] + frame.rolls[1] == 10) {
        return 10;
      }
    }
    return 10;
  }
}

extension<T> on Iterable<T> {
  T? get lastOrNull => isEmpty ? null : last;
}
