// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'golf_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GolfState {

 int get holeCount; List<int> get pars; Map<String, List<int?>> get scores; bool get isMiniGolf; int get currentHole;
/// Create a copy of GolfState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GolfStateCopyWith<GolfState> get copyWith => _$GolfStateCopyWithImpl<GolfState>(this as GolfState, _$identity);

  /// Serializes this GolfState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GolfState&&(identical(other.holeCount, holeCount) || other.holeCount == holeCount)&&const DeepCollectionEquality().equals(other.pars, pars)&&const DeepCollectionEquality().equals(other.scores, scores)&&(identical(other.isMiniGolf, isMiniGolf) || other.isMiniGolf == isMiniGolf)&&(identical(other.currentHole, currentHole) || other.currentHole == currentHole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,holeCount,const DeepCollectionEquality().hash(pars),const DeepCollectionEquality().hash(scores),isMiniGolf,currentHole);

@override
String toString() {
  return 'GolfState(holeCount: $holeCount, pars: $pars, scores: $scores, isMiniGolf: $isMiniGolf, currentHole: $currentHole)';
}


}

/// @nodoc
abstract mixin class $GolfStateCopyWith<$Res>  {
  factory $GolfStateCopyWith(GolfState value, $Res Function(GolfState) _then) = _$GolfStateCopyWithImpl;
@useResult
$Res call({
 int holeCount, List<int> pars, Map<String, List<int?>> scores, bool isMiniGolf, int currentHole
});




}
/// @nodoc
class _$GolfStateCopyWithImpl<$Res>
    implements $GolfStateCopyWith<$Res> {
  _$GolfStateCopyWithImpl(this._self, this._then);

  final GolfState _self;
  final $Res Function(GolfState) _then;

/// Create a copy of GolfState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? holeCount = null,Object? pars = null,Object? scores = null,Object? isMiniGolf = null,Object? currentHole = null,}) {
  return _then(_self.copyWith(
holeCount: null == holeCount ? _self.holeCount : holeCount // ignore: cast_nullable_to_non_nullable
as int,pars: null == pars ? _self.pars : pars // ignore: cast_nullable_to_non_nullable
as List<int>,scores: null == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, List<int?>>,isMiniGolf: null == isMiniGolf ? _self.isMiniGolf : isMiniGolf // ignore: cast_nullable_to_non_nullable
as bool,currentHole: null == currentHole ? _self.currentHole : currentHole // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GolfState].
extension GolfStatePatterns on GolfState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GolfState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GolfState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GolfState value)  $default,){
final _that = this;
switch (_that) {
case _GolfState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GolfState value)?  $default,){
final _that = this;
switch (_that) {
case _GolfState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int holeCount,  List<int> pars,  Map<String, List<int?>> scores,  bool isMiniGolf,  int currentHole)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GolfState() when $default != null:
return $default(_that.holeCount,_that.pars,_that.scores,_that.isMiniGolf,_that.currentHole);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int holeCount,  List<int> pars,  Map<String, List<int?>> scores,  bool isMiniGolf,  int currentHole)  $default,) {final _that = this;
switch (_that) {
case _GolfState():
return $default(_that.holeCount,_that.pars,_that.scores,_that.isMiniGolf,_that.currentHole);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int holeCount,  List<int> pars,  Map<String, List<int?>> scores,  bool isMiniGolf,  int currentHole)?  $default,) {final _that = this;
switch (_that) {
case _GolfState() when $default != null:
return $default(_that.holeCount,_that.pars,_that.scores,_that.isMiniGolf,_that.currentHole);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GolfState extends GolfState {
  const _GolfState({required this.holeCount, required final  List<int> pars, required final  Map<String, List<int?>> scores, required this.isMiniGolf, required this.currentHole}): _pars = pars,_scores = scores,super._();
  factory _GolfState.fromJson(Map<String, dynamic> json) => _$GolfStateFromJson(json);

@override final  int holeCount;
 final  List<int> _pars;
@override List<int> get pars {
  if (_pars is EqualUnmodifiableListView) return _pars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pars);
}

 final  Map<String, List<int?>> _scores;
@override Map<String, List<int?>> get scores {
  if (_scores is EqualUnmodifiableMapView) return _scores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_scores);
}

@override final  bool isMiniGolf;
@override final  int currentHole;

/// Create a copy of GolfState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GolfStateCopyWith<_GolfState> get copyWith => __$GolfStateCopyWithImpl<_GolfState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GolfStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GolfState&&(identical(other.holeCount, holeCount) || other.holeCount == holeCount)&&const DeepCollectionEquality().equals(other._pars, _pars)&&const DeepCollectionEquality().equals(other._scores, _scores)&&(identical(other.isMiniGolf, isMiniGolf) || other.isMiniGolf == isMiniGolf)&&(identical(other.currentHole, currentHole) || other.currentHole == currentHole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,holeCount,const DeepCollectionEquality().hash(_pars),const DeepCollectionEquality().hash(_scores),isMiniGolf,currentHole);

@override
String toString() {
  return 'GolfState(holeCount: $holeCount, pars: $pars, scores: $scores, isMiniGolf: $isMiniGolf, currentHole: $currentHole)';
}


}

/// @nodoc
abstract mixin class _$GolfStateCopyWith<$Res> implements $GolfStateCopyWith<$Res> {
  factory _$GolfStateCopyWith(_GolfState value, $Res Function(_GolfState) _then) = __$GolfStateCopyWithImpl;
@override @useResult
$Res call({
 int holeCount, List<int> pars, Map<String, List<int?>> scores, bool isMiniGolf, int currentHole
});




}
/// @nodoc
class __$GolfStateCopyWithImpl<$Res>
    implements _$GolfStateCopyWith<$Res> {
  __$GolfStateCopyWithImpl(this._self, this._then);

  final _GolfState _self;
  final $Res Function(_GolfState) _then;

/// Create a copy of GolfState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? holeCount = null,Object? pars = null,Object? scores = null,Object? isMiniGolf = null,Object? currentHole = null,}) {
  return _then(_GolfState(
holeCount: null == holeCount ? _self.holeCount : holeCount // ignore: cast_nullable_to_non_nullable
as int,pars: null == pars ? _self._pars : pars // ignore: cast_nullable_to_non_nullable
as List<int>,scores: null == scores ? _self._scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, List<int?>>,isMiniGolf: null == isMiniGolf ? _self.isMiniGolf : isMiniGolf // ignore: cast_nullable_to_non_nullable
as bool,currentHole: null == currentHole ? _self.currentHole : currentHole // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
