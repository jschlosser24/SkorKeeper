import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_player.freezed.dart';
part 'session_player.g.dart';

const kDefaultPlayerColors = [
  '#236192',
  '#78BE20',
  '#981D97',
  '#9ea2a2',
  '#F06292',
  '#FF6B35',
  '#FFD700',
  '#00C0A0',
  '#E84855',
  '#8338EC',
];

@freezed
abstract class SessionPlayer with _$SessionPlayer {
  const factory SessionPlayer({
    required String id,
    required String displayName,
    required String colorHex,
    required int seatOrder,
  }) = _SessionPlayer;

  factory SessionPlayer.fromJson(Map<String, dynamic> json) =>
      _$SessionPlayerFromJson(json);
}
