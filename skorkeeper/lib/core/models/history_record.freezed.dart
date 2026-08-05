// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryRecord {

 int get id; int get sessionId; String get gameType; String? get sessionName; String get playerNames; String? get winnerDisplayName; String get finalScoresJson; DateTime get playedAt; int? get durationSeconds;
/// Create a copy of HistoryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryRecordCopyWith<HistoryRecord> get copyWith => _$HistoryRecordCopyWithImpl<HistoryRecord>(this as HistoryRecord, _$identity);

  /// Serializes this HistoryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.sessionName, sessionName) || other.sessionName == sessionName)&&(identical(other.playerNames, playerNames) || other.playerNames == playerNames)&&(identical(other.winnerDisplayName, winnerDisplayName) || other.winnerDisplayName == winnerDisplayName)&&(identical(other.finalScoresJson, finalScoresJson) || other.finalScoresJson == finalScoresJson)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,gameType,sessionName,playerNames,winnerDisplayName,finalScoresJson,playedAt,durationSeconds);

@override
String toString() {
  return 'HistoryRecord(id: $id, sessionId: $sessionId, gameType: $gameType, sessionName: $sessionName, playerNames: $playerNames, winnerDisplayName: $winnerDisplayName, finalScoresJson: $finalScoresJson, playedAt: $playedAt, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class $HistoryRecordCopyWith<$Res>  {
  factory $HistoryRecordCopyWith(HistoryRecord value, $Res Function(HistoryRecord) _then) = _$HistoryRecordCopyWithImpl;
@useResult
$Res call({
 int id, int sessionId, String gameType, String? sessionName, String playerNames, String? winnerDisplayName, String finalScoresJson, DateTime playedAt, int? durationSeconds
});




}
/// @nodoc
class _$HistoryRecordCopyWithImpl<$Res>
    implements $HistoryRecordCopyWith<$Res> {
  _$HistoryRecordCopyWithImpl(this._self, this._then);

  final HistoryRecord _self;
  final $Res Function(HistoryRecord) _then;

/// Create a copy of HistoryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? gameType = null,Object? sessionName = freezed,Object? playerNames = null,Object? winnerDisplayName = freezed,Object? finalScoresJson = null,Object? playedAt = null,Object? durationSeconds = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int,gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,sessionName: freezed == sessionName ? _self.sessionName : sessionName // ignore: cast_nullable_to_non_nullable
as String?,playerNames: null == playerNames ? _self.playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as String,winnerDisplayName: freezed == winnerDisplayName ? _self.winnerDisplayName : winnerDisplayName // ignore: cast_nullable_to_non_nullable
as String?,finalScoresJson: null == finalScoresJson ? _self.finalScoresJson : finalScoresJson // ignore: cast_nullable_to_non_nullable
as String,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryRecord].
extension HistoryRecordPatterns on HistoryRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryRecord value)  $default,){
final _that = this;
switch (_that) {
case _HistoryRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int sessionId,  String gameType,  String? sessionName,  String playerNames,  String? winnerDisplayName,  String finalScoresJson,  DateTime playedAt,  int? durationSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryRecord() when $default != null:
return $default(_that.id,_that.sessionId,_that.gameType,_that.sessionName,_that.playerNames,_that.winnerDisplayName,_that.finalScoresJson,_that.playedAt,_that.durationSeconds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int sessionId,  String gameType,  String? sessionName,  String playerNames,  String? winnerDisplayName,  String finalScoresJson,  DateTime playedAt,  int? durationSeconds)  $default,) {final _that = this;
switch (_that) {
case _HistoryRecord():
return $default(_that.id,_that.sessionId,_that.gameType,_that.sessionName,_that.playerNames,_that.winnerDisplayName,_that.finalScoresJson,_that.playedAt,_that.durationSeconds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int sessionId,  String gameType,  String? sessionName,  String playerNames,  String? winnerDisplayName,  String finalScoresJson,  DateTime playedAt,  int? durationSeconds)?  $default,) {final _that = this;
switch (_that) {
case _HistoryRecord() when $default != null:
return $default(_that.id,_that.sessionId,_that.gameType,_that.sessionName,_that.playerNames,_that.winnerDisplayName,_that.finalScoresJson,_that.playedAt,_that.durationSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryRecord implements HistoryRecord {
  const _HistoryRecord({required this.id, required this.sessionId, required this.gameType, this.sessionName, required this.playerNames, this.winnerDisplayName, required this.finalScoresJson, required this.playedAt, this.durationSeconds});
  factory _HistoryRecord.fromJson(Map<String, dynamic> json) => _$HistoryRecordFromJson(json);

@override final  int id;
@override final  int sessionId;
@override final  String gameType;
@override final  String? sessionName;
@override final  String playerNames;
@override final  String? winnerDisplayName;
@override final  String finalScoresJson;
@override final  DateTime playedAt;
@override final  int? durationSeconds;

/// Create a copy of HistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryRecordCopyWith<_HistoryRecord> get copyWith => __$HistoryRecordCopyWithImpl<_HistoryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.sessionName, sessionName) || other.sessionName == sessionName)&&(identical(other.playerNames, playerNames) || other.playerNames == playerNames)&&(identical(other.winnerDisplayName, winnerDisplayName) || other.winnerDisplayName == winnerDisplayName)&&(identical(other.finalScoresJson, finalScoresJson) || other.finalScoresJson == finalScoresJson)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,gameType,sessionName,playerNames,winnerDisplayName,finalScoresJson,playedAt,durationSeconds);

@override
String toString() {
  return 'HistoryRecord(id: $id, sessionId: $sessionId, gameType: $gameType, sessionName: $sessionName, playerNames: $playerNames, winnerDisplayName: $winnerDisplayName, finalScoresJson: $finalScoresJson, playedAt: $playedAt, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class _$HistoryRecordCopyWith<$Res> implements $HistoryRecordCopyWith<$Res> {
  factory _$HistoryRecordCopyWith(_HistoryRecord value, $Res Function(_HistoryRecord) _then) = __$HistoryRecordCopyWithImpl;
@override @useResult
$Res call({
 int id, int sessionId, String gameType, String? sessionName, String playerNames, String? winnerDisplayName, String finalScoresJson, DateTime playedAt, int? durationSeconds
});




}
/// @nodoc
class __$HistoryRecordCopyWithImpl<$Res>
    implements _$HistoryRecordCopyWith<$Res> {
  __$HistoryRecordCopyWithImpl(this._self, this._then);

  final _HistoryRecord _self;
  final $Res Function(_HistoryRecord) _then;

/// Create a copy of HistoryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? gameType = null,Object? sessionName = freezed,Object? playerNames = null,Object? winnerDisplayName = freezed,Object? finalScoresJson = null,Object? playedAt = null,Object? durationSeconds = freezed,}) {
  return _then(_HistoryRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int,gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,sessionName: freezed == sessionName ? _self.sessionName : sessionName // ignore: cast_nullable_to_non_nullable
as String?,playerNames: null == playerNames ? _self.playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as String,winnerDisplayName: freezed == winnerDisplayName ? _self.winnerDisplayName : winnerDisplayName // ignore: cast_nullable_to_non_nullable
as String?,finalScoresJson: null == finalScoresJson ? _self.finalScoresJson : finalScoresJson // ignore: cast_nullable_to_non_nullable
as String,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
