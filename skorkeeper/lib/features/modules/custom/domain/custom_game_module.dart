import '../../../../core/models/session_player.dart';
import '../../../../core/modules/game_module.dart';
import '../../../../core/modules/game_module_state.dart';
import '../../../../core/modules/leaderboard_entry.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/modules/score_validation_result.dart';
import '../../../../core/modules/scoring_layout_descriptor.dart';
import '../../../../core/modules/win_result.dart';
import 'custom_game_state.dart';

class CustomGameModule implements GameModule {
  const CustomGameModule();

  @override
  String get gameTypeId => 'custom';

  @override
  String get displayName => 'Custom Scoring';

  @override
  String get description =>
      'Track scores for any game with custom round-by-round entry.';

  @override
  String get iconAsset =>
      '<svg viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="6" width="52" height="52" rx="16" fill="#236192"/><path d="M20 32h24M32 20v24" stroke="white" stroke-width="6" stroke-linecap="round"/></svg>';

  @override
  int get minPlayers => 1;

  @override
  int get maxPlayers => 10;

  @override
  Map<String, dynamic> initialState(List<SessionPlayer> players) {
    return const CustomGameState(
      gameName: 'Custom Game',
      roundLabels: <String>[],
      scoreDirection: ScoreDirection.highWins,
    ).toJson();
  }

  @override
  GameModuleState? stateFromJson(Map<String, dynamic> json) {
    try {
      return CustomGameState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  GameModuleState applyAction(GameModuleState state, ScoreAction action) {
    return state as CustomGameState;
  }

  @override
  List<LeaderboardEntry> leaderboard(GameModuleState state) {
    return const <LeaderboardEntry>[];
  }

  @override
  WinResult? checkWinCondition(GameModuleState state) => null;

  @override
  ScoringLayoutDescriptor scoringLayout(GameModuleState state) {
    return const ScoringLayoutDescriptor(
      type: ScoringLayoutType.numericKeypad,
      config: <String, dynamic>{'allowNegative': true},
    );
  }

  @override
  ScoreValidationResult validateScore(
    GameModuleState state,
    String playerId,
    dynamic proposedValue,
  ) {
    final value = proposedValue is int
        ? proposedValue
        : int.tryParse(proposedValue.toString());
    if (value == null) {
      return const ScoreValidationResult.invalid(
        reason: 'Enter a whole number.',
        shortCode: 'INVALID_SCORE',
      );
    }
    return const ScoreValidationResult.valid();
  }
}
