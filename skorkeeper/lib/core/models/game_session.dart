import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_type.dart';
import 'session_player.dart';

part 'game_session.freezed.dart';
part 'game_session.g.dart';

@freezed
abstract class GameSession with _$GameSession {
  const factory GameSession({
    required int id,
    required String gameType,
    String? sessionName,
    required SessionStatus status,
    required DateTime startedAt,
    DateTime? endedAt,
    required List<SessionPlayer> participants,
    required Map<String, dynamic> moduleState,
    String? winnerDisplayName,
  }) = _GameSession;

  factory GameSession.fromJson(Map<String, dynamic> json) =>
      _$GameSessionFromJson(json);
}
