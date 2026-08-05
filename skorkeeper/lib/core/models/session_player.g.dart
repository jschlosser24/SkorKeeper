// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionPlayer _$SessionPlayerFromJson(Map<String, dynamic> json) =>
    _SessionPlayer(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      colorHex: json['colorHex'] as String,
      seatOrder: (json['seatOrder'] as num).toInt(),
    );

Map<String, dynamic> _$SessionPlayerToJson(_SessionPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'colorHex': instance.colorHex,
      'seatOrder': instance.seatOrder,
    };
