// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScoreEntry {

 int get id; int get sessionId; String get playerId; int get roundNumber; int get value; String? get notes; DateTime get recordedAt;
/// Create a copy of ScoreEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreEntryCopyWith<ScoreEntry> get copyWith => _$ScoreEntryCopyWithImpl<ScoreEntry>(this as ScoreEntry, _$identity);

  /// Serializes this ScoreEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&(identical(other.value, value) || other.value == value)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,playerId,roundNumber,value,notes,recordedAt);

@override
String toString() {
  return 'ScoreEntry(id: $id, sessionId: $sessionId, playerId: $playerId, roundNumber: $roundNumber, value: $value, notes: $notes, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $ScoreEntryCopyWith<$Res>  {
  factory $ScoreEntryCopyWith(ScoreEntry value, $Res Function(ScoreEntry) _then) = _$ScoreEntryCopyWithImpl;
@useResult
$Res call({
 int id, int sessionId, String playerId, int roundNumber, int value, String? notes, DateTime recordedAt
});




}
/// @nodoc
class _$ScoreEntryCopyWithImpl<$Res>
    implements $ScoreEntryCopyWith<$Res> {
  _$ScoreEntryCopyWithImpl(this._self, this._then);

  final ScoreEntry _self;
  final $Res Function(ScoreEntry) _then;

/// Create a copy of ScoreEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? playerId = null,Object? roundNumber = null,Object? value = null,Object? notes = freezed,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreEntry].
extension ScoreEntryPatterns on ScoreEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreEntry value)  $default,){
final _that = this;
switch (_that) {
case _ScoreEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int sessionId,  String playerId,  int roundNumber,  int value,  String? notes,  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreEntry() when $default != null:
return $default(_that.id,_that.sessionId,_that.playerId,_that.roundNumber,_that.value,_that.notes,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int sessionId,  String playerId,  int roundNumber,  int value,  String? notes,  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _ScoreEntry():
return $default(_that.id,_that.sessionId,_that.playerId,_that.roundNumber,_that.value,_that.notes,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int sessionId,  String playerId,  int roundNumber,  int value,  String? notes,  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _ScoreEntry() when $default != null:
return $default(_that.id,_that.sessionId,_that.playerId,_that.roundNumber,_that.value,_that.notes,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScoreEntry implements ScoreEntry {
  const _ScoreEntry({required this.id, required this.sessionId, required this.playerId, required this.roundNumber, required this.value, this.notes, required this.recordedAt});
  factory _ScoreEntry.fromJson(Map<String, dynamic> json) => _$ScoreEntryFromJson(json);

@override final  int id;
@override final  int sessionId;
@override final  String playerId;
@override final  int roundNumber;
@override final  int value;
@override final  String? notes;
@override final  DateTime recordedAt;

/// Create a copy of ScoreEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreEntryCopyWith<_ScoreEntry> get copyWith => __$ScoreEntryCopyWithImpl<_ScoreEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScoreEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&(identical(other.value, value) || other.value == value)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,playerId,roundNumber,value,notes,recordedAt);

@override
String toString() {
  return 'ScoreEntry(id: $id, sessionId: $sessionId, playerId: $playerId, roundNumber: $roundNumber, value: $value, notes: $notes, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$ScoreEntryCopyWith<$Res> implements $ScoreEntryCopyWith<$Res> {
  factory _$ScoreEntryCopyWith(_ScoreEntry value, $Res Function(_ScoreEntry) _then) = __$ScoreEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, int sessionId, String playerId, int roundNumber, int value, String? notes, DateTime recordedAt
});




}
/// @nodoc
class __$ScoreEntryCopyWithImpl<$Res>
    implements _$ScoreEntryCopyWith<$Res> {
  __$ScoreEntryCopyWithImpl(this._self, this._then);

  final _ScoreEntry _self;
  final $Res Function(_ScoreEntry) _then;

/// Create a copy of ScoreEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? playerId = null,Object? roundNumber = null,Object? value = null,Object? notes = freezed,Object? recordedAt = null,}) {
  return _then(_ScoreEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as int,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
