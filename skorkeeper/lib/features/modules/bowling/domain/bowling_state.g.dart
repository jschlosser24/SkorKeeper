// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bowling_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BowlingFrame _$BowlingFrameFromJson(Map<String, dynamic> json) =>
    _BowlingFrame(
      frame: (json['frame'] as num).toInt(),
      rolls: (json['rolls'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      frameType: $enumDecode(_$FrameTypeEnumMap, json['frameType']),
      cumulativeScore: (json['cumulativeScore'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BowlingFrameToJson(_BowlingFrame instance) =>
    <String, dynamic>{
      'frame': instance.frame,
      'rolls': instance.rolls,
      'frameType': _$FrameTypeEnumMap[instance.frameType]!,
      'cumulativeScore': instance.cumulativeScore,
    };

const _$FrameTypeEnumMap = {
  FrameType.open: 'open',
  FrameType.spare: 'spare',
  FrameType.strike: 'strike',
};

_BowlingState _$BowlingStateFromJson(Map<String, dynamic> json) =>
    _BowlingState(
      currentPlayerIndex: (json['currentPlayerIndex'] as num).toInt(),
      currentFrame: (json['currentFrame'] as num).toInt(),
      frames: (json['frames'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => BowlingFrame.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      playerOrder: (json['playerOrder'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$BowlingStateToJson(_BowlingState instance) =>
    <String, dynamic>{
      'currentPlayerIndex': instance.currentPlayerIndex,
      'currentFrame': instance.currentFrame,
      'frames': instance.frames,
      'playerOrder': instance.playerOrder,
    };
