// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dominoes_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DominoesState {

 int get currentRound; Map<String, int> get playerTotals; bool get gameOver; String? get winnerId; List<String> get playerOrder;
/// Create a copy of DominoesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DominoesStateCopyWith<DominoesState> get copyWith => _$DominoesStateCopyWithImpl<DominoesState>(this as DominoesState, _$identity);

  /// Serializes this DominoesState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DominoesState&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&const DeepCollectionEquality().equals(other.playerTotals, playerTotals)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&const DeepCollectionEquality().equals(other.playerOrder, playerOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentRound,const DeepCollectionEquality().hash(playerTotals),gameOver,winnerId,const DeepCollectionEquality().hash(playerOrder));

@override
String toString() {
  return 'DominoesState(currentRound: $currentRound, playerTotals: $playerTotals, gameOver: $gameOver, winnerId: $winnerId, playerOrder: $playerOrder)';
}


}

/// @nodoc
abstract mixin class $DominoesStateCopyWith<$Res>  {
  factory $DominoesStateCopyWith(DominoesState value, $Res Function(DominoesState) _then) = _$DominoesStateCopyWithImpl;
@useResult
$Res call({
 int currentRound, Map<String, int> playerTotals, bool gameOver, String? winnerId, List<String> playerOrder
});




}
/// @nodoc
class _$DominoesStateCopyWithImpl<$Res>
    implements $DominoesStateCopyWith<$Res> {
  _$DominoesStateCopyWithImpl(this._self, this._then);

  final DominoesState _self;
  final $Res Function(DominoesState) _then;

/// Create a copy of DominoesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentRound = null,Object? playerTotals = null,Object? gameOver = null,Object? winnerId = freezed,Object? playerOrder = null,}) {
  return _then(_self.copyWith(
currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int,playerTotals: null == playerTotals ? _self.playerTotals : playerTotals // ignore: cast_nullable_to_non_nullable
as Map<String, int>,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,playerOrder: null == playerOrder ? _self.playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DominoesState].
extension DominoesStatePatterns on DominoesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DominoesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DominoesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DominoesState value)  $default,){
final _that = this;
switch (_that) {
case _DominoesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DominoesState value)?  $default,){
final _that = this;
switch (_that) {
case _DominoesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentRound,  Map<String, int> playerTotals,  bool gameOver,  String? winnerId,  List<String> playerOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DominoesState() when $default != null:
return $default(_that.currentRound,_that.playerTotals,_that.gameOver,_that.winnerId,_that.playerOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentRound,  Map<String, int> playerTotals,  bool gameOver,  String? winnerId,  List<String> playerOrder)  $default,) {final _that = this;
switch (_that) {
case _DominoesState():
return $default(_that.currentRound,_that.playerTotals,_that.gameOver,_that.winnerId,_that.playerOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentRound,  Map<String, int> playerTotals,  bool gameOver,  String? winnerId,  List<String> playerOrder)?  $default,) {final _that = this;
switch (_that) {
case _DominoesState() when $default != null:
return $default(_that.currentRound,_that.playerTotals,_that.gameOver,_that.winnerId,_that.playerOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DominoesState extends DominoesState {
  const _DominoesState({required this.currentRound, required final  Map<String, int> playerTotals, required this.gameOver, this.winnerId, required final  List<String> playerOrder}): _playerTotals = playerTotals,_playerOrder = playerOrder,super._();
  factory _DominoesState.fromJson(Map<String, dynamic> json) => _$DominoesStateFromJson(json);

@override final  int currentRound;
 final  Map<String, int> _playerTotals;
@override Map<String, int> get playerTotals {
  if (_playerTotals is EqualUnmodifiableMapView) return _playerTotals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_playerTotals);
}

@override final  bool gameOver;
@override final  String? winnerId;
 final  List<String> _playerOrder;
@override List<String> get playerOrder {
  if (_playerOrder is EqualUnmodifiableListView) return _playerOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerOrder);
}


/// Create a copy of DominoesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DominoesStateCopyWith<_DominoesState> get copyWith => __$DominoesStateCopyWithImpl<_DominoesState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DominoesStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DominoesState&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&const DeepCollectionEquality().equals(other._playerTotals, _playerTotals)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&const DeepCollectionEquality().equals(other._playerOrder, _playerOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentRound,const DeepCollectionEquality().hash(_playerTotals),gameOver,winnerId,const DeepCollectionEquality().hash(_playerOrder));

@override
String toString() {
  return 'DominoesState(currentRound: $currentRound, playerTotals: $playerTotals, gameOver: $gameOver, winnerId: $winnerId, playerOrder: $playerOrder)';
}


}

/// @nodoc
abstract mixin class _$DominoesStateCopyWith<$Res> implements $DominoesStateCopyWith<$Res> {
  factory _$DominoesStateCopyWith(_DominoesState value, $Res Function(_DominoesState) _then) = __$DominoesStateCopyWithImpl;
@override @useResult
$Res call({
 int currentRound, Map<String, int> playerTotals, bool gameOver, String? winnerId, List<String> playerOrder
});




}
/// @nodoc
class __$DominoesStateCopyWithImpl<$Res>
    implements _$DominoesStateCopyWith<$Res> {
  __$DominoesStateCopyWithImpl(this._self, this._then);

  final _DominoesState _self;
  final $Res Function(_DominoesState) _then;

/// Create a copy of DominoesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentRound = null,Object? playerTotals = null,Object? gameOver = null,Object? winnerId = freezed,Object? playerOrder = null,}) {
  return _then(_DominoesState(
currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int,playerTotals: null == playerTotals ? _self._playerTotals : playerTotals // ignore: cast_nullable_to_non_nullable
as Map<String, int>,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,playerOrder: null == playerOrder ? _self._playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
