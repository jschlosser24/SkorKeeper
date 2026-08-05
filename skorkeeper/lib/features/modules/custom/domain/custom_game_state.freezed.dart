// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomGameState {

 String get gameName; List<String> get roundLabels; ScoreDirection get scoreDirection;
/// Create a copy of CustomGameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomGameStateCopyWith<CustomGameState> get copyWith => _$CustomGameStateCopyWithImpl<CustomGameState>(this as CustomGameState, _$identity);

  /// Serializes this CustomGameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomGameState&&(identical(other.gameName, gameName) || other.gameName == gameName)&&const DeepCollectionEquality().equals(other.roundLabels, roundLabels)&&(identical(other.scoreDirection, scoreDirection) || other.scoreDirection == scoreDirection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameName,const DeepCollectionEquality().hash(roundLabels),scoreDirection);

@override
String toString() {
  return 'CustomGameState(gameName: $gameName, roundLabels: $roundLabels, scoreDirection: $scoreDirection)';
}


}

/// @nodoc
abstract mixin class $CustomGameStateCopyWith<$Res>  {
  factory $CustomGameStateCopyWith(CustomGameState value, $Res Function(CustomGameState) _then) = _$CustomGameStateCopyWithImpl;
@useResult
$Res call({
 String gameName, List<String> roundLabels, ScoreDirection scoreDirection
});




}
/// @nodoc
class _$CustomGameStateCopyWithImpl<$Res>
    implements $CustomGameStateCopyWith<$Res> {
  _$CustomGameStateCopyWithImpl(this._self, this._then);

  final CustomGameState _self;
  final $Res Function(CustomGameState) _then;

/// Create a copy of CustomGameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameName = null,Object? roundLabels = null,Object? scoreDirection = null,}) {
  return _then(_self.copyWith(
gameName: null == gameName ? _self.gameName : gameName // ignore: cast_nullable_to_non_nullable
as String,roundLabels: null == roundLabels ? _self.roundLabels : roundLabels // ignore: cast_nullable_to_non_nullable
as List<String>,scoreDirection: null == scoreDirection ? _self.scoreDirection : scoreDirection // ignore: cast_nullable_to_non_nullable
as ScoreDirection,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomGameState].
extension CustomGameStatePatterns on CustomGameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomGameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomGameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomGameState value)  $default,){
final _that = this;
switch (_that) {
case _CustomGameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomGameState value)?  $default,){
final _that = this;
switch (_that) {
case _CustomGameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gameName,  List<String> roundLabels,  ScoreDirection scoreDirection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomGameState() when $default != null:
return $default(_that.gameName,_that.roundLabels,_that.scoreDirection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gameName,  List<String> roundLabels,  ScoreDirection scoreDirection)  $default,) {final _that = this;
switch (_that) {
case _CustomGameState():
return $default(_that.gameName,_that.roundLabels,_that.scoreDirection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gameName,  List<String> roundLabels,  ScoreDirection scoreDirection)?  $default,) {final _that = this;
switch (_that) {
case _CustomGameState() when $default != null:
return $default(_that.gameName,_that.roundLabels,_that.scoreDirection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomGameState extends CustomGameState {
  const _CustomGameState({required this.gameName, required final  List<String> roundLabels, required this.scoreDirection}): _roundLabels = roundLabels,super._();
  factory _CustomGameState.fromJson(Map<String, dynamic> json) => _$CustomGameStateFromJson(json);

@override final  String gameName;
 final  List<String> _roundLabels;
@override List<String> get roundLabels {
  if (_roundLabels is EqualUnmodifiableListView) return _roundLabels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roundLabels);
}

@override final  ScoreDirection scoreDirection;

/// Create a copy of CustomGameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomGameStateCopyWith<_CustomGameState> get copyWith => __$CustomGameStateCopyWithImpl<_CustomGameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomGameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomGameState&&(identical(other.gameName, gameName) || other.gameName == gameName)&&const DeepCollectionEquality().equals(other._roundLabels, _roundLabels)&&(identical(other.scoreDirection, scoreDirection) || other.scoreDirection == scoreDirection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameName,const DeepCollectionEquality().hash(_roundLabels),scoreDirection);

@override
String toString() {
  return 'CustomGameState(gameName: $gameName, roundLabels: $roundLabels, scoreDirection: $scoreDirection)';
}


}

/// @nodoc
abstract mixin class _$CustomGameStateCopyWith<$Res> implements $CustomGameStateCopyWith<$Res> {
  factory _$CustomGameStateCopyWith(_CustomGameState value, $Res Function(_CustomGameState) _then) = __$CustomGameStateCopyWithImpl;
@override @useResult
$Res call({
 String gameName, List<String> roundLabels, ScoreDirection scoreDirection
});




}
/// @nodoc
class __$CustomGameStateCopyWithImpl<$Res>
    implements _$CustomGameStateCopyWith<$Res> {
  __$CustomGameStateCopyWithImpl(this._self, this._then);

  final _CustomGameState _self;
  final $Res Function(_CustomGameState) _then;

/// Create a copy of CustomGameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameName = null,Object? roundLabels = null,Object? scoreDirection = null,}) {
  return _then(_CustomGameState(
gameName: null == gameName ? _self.gameName : gameName // ignore: cast_nullable_to_non_nullable
as String,roundLabels: null == roundLabels ? _self._roundLabels : roundLabels // ignore: cast_nullable_to_non_nullable
as List<String>,scoreDirection: null == scoreDirection ? _self.scoreDirection : scoreDirection // ignore: cast_nullable_to_non_nullable
as ScoreDirection,
  ));
}


}

// dart format on
