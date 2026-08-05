import '../models/session_player.dart';
import 'game_module_state.dart';
import 'leaderboard_entry.dart';
import 'score_action.dart';
import 'score_validation_result.dart';
import 'scoring_layout_descriptor.dart';
import 'win_result.dart';

abstract interface class GameModule {
  String get gameTypeId;
  String get displayName;
  String get description;
  String get iconAsset;
  int get minPlayers;
  int get maxPlayers;

  Map<String, dynamic> initialState(List<SessionPlayer> players);
  GameModuleState? stateFromJson(Map<String, dynamic> json);
  GameModuleState applyAction(GameModuleState state, ScoreAction action);
  List<LeaderboardEntry> leaderboard(GameModuleState state);
  WinResult? checkWinCondition(GameModuleState state);
  ScoringLayoutDescriptor scoringLayout(GameModuleState state);
  ScoreValidationResult validateScore(
    GameModuleState state,
    String playerId,
    dynamic proposedValue,
  );
}
