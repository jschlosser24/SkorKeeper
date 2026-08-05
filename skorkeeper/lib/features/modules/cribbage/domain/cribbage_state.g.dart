// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cribbage_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CribbagePegPosition _$CribbagePegPositionFromJson(Map<String, dynamic> json) =>
    _CribbagePegPosition(
      front: (json['front'] as num).toInt(),
      rear: (json['rear'] as num).toInt(),
    );

Map<String, dynamic> _$CribbagePegPositionToJson(
  _CribbagePegPosition instance,
) => <String, dynamic>{'front': instance.front, 'rear': instance.rear};

_CribbageState _$CribbageStateFromJson(Map<String, dynamic> json) =>
    _CribbageState(
      variant: json['variant'] as String,
      dealerId: json['dealerId'] as String,
      pegPositions: (json['pegPositions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          CribbagePegPosition.fromJson(e as Map<String, dynamic>),
        ),
      ),
      gameOver: json['gameOver'] as bool,
      winnerId: json['winnerId'] as String?,
      handNumber: (json['handNumber'] as num).toInt(),
    );

Map<String, dynamic> _$CribbageStateToJson(_CribbageState instance) =>
    <String, dynamic>{
      'variant': instance.variant,
      'dealerId': instance.dealerId,
      'pegPositions': instance.pegPositions,
      'gameOver': instance.gameOver,
      'winnerId': instance.winnerId,
      'handNumber': instance.handNumber,
    };
