// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameSession {

 int get id; String get gameType; String? get sessionName; SessionStatus get status; DateTime get startedAt; DateTime? get endedAt; List<SessionPlayer> get participants; Map<String, dynamic> get moduleState; String? get winnerDisplayName;
/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameSessionCopyWith<GameSession> get copyWith => _$GameSessionCopyWithImpl<GameSession>(this as GameSession, _$identity);

  /// Serializes this GameSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameSession&&(identical(other.id, id) || other.id == id)&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.sessionName, sessionName) || other.sessionName == sessionName)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&const DeepCollectionEquality().equals(other.participants, participants)&&const DeepCollectionEquality().equals(other.moduleState, moduleState)&&(identical(other.winnerDisplayName, winnerDisplayName) || other.winnerDisplayName == winnerDisplayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameType,sessionName,status,startedAt,endedAt,const DeepCollectionEquality().hash(participants),const DeepCollectionEquality().hash(moduleState),winnerDisplayName);

@override
String toString() {
  return 'GameSession(id: $id, gameType: $gameType, sessionName: $sessionName, status: $status, startedAt: $startedAt, endedAt: $endedAt, participants: $participants, moduleState: $moduleState, winnerDisplayName: $winnerDisplayName)';
}


}

/// @nodoc
abstract mixin class $GameSessionCopyWith<$Res>  {
  factory $GameSessionCopyWith(GameSession value, $Res Function(GameSession) _then) = _$GameSessionCopyWithImpl;
@useResult
$Res call({
 int id, String gameType, String? sessionName, SessionStatus status, DateTime startedAt, DateTime? endedAt, List<SessionPlayer> participants, Map<String, dynamic> moduleState, String? winnerDisplayName
});




}
/// @nodoc
class _$GameSessionCopyWithImpl<$Res>
    implements $GameSessionCopyWith<$Res> {
  _$GameSessionCopyWithImpl(this._self, this._then);

  final GameSession _self;
  final $Res Function(GameSession) _then;

/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gameType = null,Object? sessionName = freezed,Object? status = null,Object? startedAt = null,Object? endedAt = freezed,Object? participants = null,Object? moduleState = null,Object? winnerDisplayName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,sessionName: freezed == sessionName ? _self.sessionName : sessionName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<SessionPlayer>,moduleState: null == moduleState ? _self.moduleState : moduleState // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,winnerDisplayName: freezed == winnerDisplayName ? _self.winnerDisplayName : winnerDisplayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameSession].
extension GameSessionPatterns on GameSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameSession value)  $default,){
final _that = this;
switch (_that) {
case _GameSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameSession value)?  $default,){
final _that = this;
switch (_that) {
case _GameSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String gameType,  String? sessionName,  SessionStatus status,  DateTime startedAt,  DateTime? endedAt,  List<SessionPlayer> participants,  Map<String, dynamic> moduleState,  String? winnerDisplayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameSession() when $default != null:
return $default(_that.id,_that.gameType,_that.sessionName,_that.status,_that.startedAt,_that.endedAt,_that.participants,_that.moduleState,_that.winnerDisplayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String gameType,  String? sessionName,  SessionStatus status,  DateTime startedAt,  DateTime? endedAt,  List<SessionPlayer> participants,  Map<String, dynamic> moduleState,  String? winnerDisplayName)  $default,) {final _that = this;
switch (_that) {
case _GameSession():
return $default(_that.id,_that.gameType,_that.sessionName,_that.status,_that.startedAt,_that.endedAt,_that.participants,_that.moduleState,_that.winnerDisplayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String gameType,  String? sessionName,  SessionStatus status,  DateTime startedAt,  DateTime? endedAt,  List<SessionPlayer> participants,  Map<String, dynamic> moduleState,  String? winnerDisplayName)?  $default,) {final _that = this;
switch (_that) {
case _GameSession() when $default != null:
return $default(_that.id,_that.gameType,_that.sessionName,_that.status,_that.startedAt,_that.endedAt,_that.participants,_that.moduleState,_that.winnerDisplayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameSession implements GameSession {
  const _GameSession({required this.id, required this.gameType, this.sessionName, required this.status, required this.startedAt, this.endedAt, required final  List<SessionPlayer> participants, required final  Map<String, dynamic> moduleState, this.winnerDisplayName}): _participants = participants,_moduleState = moduleState;
  factory _GameSession.fromJson(Map<String, dynamic> json) => _$GameSessionFromJson(json);

@override final  int id;
@override final  String gameType;
@override final  String? sessionName;
@override final  SessionStatus status;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
 final  List<SessionPlayer> _participants;
@override List<SessionPlayer> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

 final  Map<String, dynamic> _moduleState;
@override Map<String, dynamic> get moduleState {
  if (_moduleState is EqualUnmodifiableMapView) return _moduleState;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_moduleState);
}

@override final  String? winnerDisplayName;

/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameSessionCopyWith<_GameSession> get copyWith => __$GameSessionCopyWithImpl<_GameSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameSession&&(identical(other.id, id) || other.id == id)&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.sessionName, sessionName) || other.sessionName == sessionName)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&const DeepCollectionEquality().equals(other._participants, _participants)&&const DeepCollectionEquality().equals(other._moduleState, _moduleState)&&(identical(other.winnerDisplayName, winnerDisplayName) || other.winnerDisplayName == winnerDisplayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameType,sessionName,status,startedAt,endedAt,const DeepCollectionEquality().hash(_participants),const DeepCollectionEquality().hash(_moduleState),winnerDisplayName);

@override
String toString() {
  return 'GameSession(id: $id, gameType: $gameType, sessionName: $sessionName, status: $status, startedAt: $startedAt, endedAt: $endedAt, participants: $participants, moduleState: $moduleState, winnerDisplayName: $winnerDisplayName)';
}


}

/// @nodoc
abstract mixin class _$GameSessionCopyWith<$Res> implements $GameSessionCopyWith<$Res> {
  factory _$GameSessionCopyWith(_GameSession value, $Res Function(_GameSession) _then) = __$GameSessionCopyWithImpl;
@override @useResult
$Res call({
 int id, String gameType, String? sessionName, SessionStatus status, DateTime startedAt, DateTime? endedAt, List<SessionPlayer> participants, Map<String, dynamic> moduleState, String? winnerDisplayName
});




}
/// @nodoc
class __$GameSessionCopyWithImpl<$Res>
    implements _$GameSessionCopyWith<$Res> {
  __$GameSessionCopyWithImpl(this._self, this._then);

  final _GameSession _self;
  final $Res Function(_GameSession) _then;

/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gameType = null,Object? sessionName = freezed,Object? status = null,Object? startedAt = null,Object? endedAt = freezed,Object? participants = null,Object? moduleState = null,Object? winnerDisplayName = freezed,}) {
  return _then(_GameSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,sessionName: freezed == sessionName ? _self.sessionName : sessionName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<SessionPlayer>,moduleState: null == moduleState ? _self._moduleState : moduleState // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,winnerDisplayName: freezed == winnerDisplayName ? _self.winnerDisplayName : winnerDisplayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
