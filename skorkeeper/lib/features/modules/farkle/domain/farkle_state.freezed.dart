// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farkle_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FarkleState {

 String get currentPlayerId; int get targetScore; Map<String, int> get playerTotals; int get currentTurnScore; List<int> get currentTurnDice; int get diceBanked; Map<String, bool> get hasOpened; bool get gameOver; String? get winnerId; List<String> get playerOrder;
/// Create a copy of FarkleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarkleStateCopyWith<FarkleState> get copyWith => _$FarkleStateCopyWithImpl<FarkleState>(this as FarkleState, _$identity);

  /// Serializes this FarkleState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarkleState&&(identical(other.currentPlayerId, currentPlayerId) || other.currentPlayerId == currentPlayerId)&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&const DeepCollectionEquality().equals(other.playerTotals, playerTotals)&&(identical(other.currentTurnScore, currentTurnScore) || other.currentTurnScore == currentTurnScore)&&const DeepCollectionEquality().equals(other.currentTurnDice, currentTurnDice)&&(identical(other.diceBanked, diceBanked) || other.diceBanked == diceBanked)&&const DeepCollectionEquality().equals(other.hasOpened, hasOpened)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&const DeepCollectionEquality().equals(other.playerOrder, playerOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPlayerId,targetScore,const DeepCollectionEquality().hash(playerTotals),currentTurnScore,const DeepCollectionEquality().hash(currentTurnDice),diceBanked,const DeepCollectionEquality().hash(hasOpened),gameOver,winnerId,const DeepCollectionEquality().hash(playerOrder));

@override
String toString() {
  return 'FarkleState(currentPlayerId: $currentPlayerId, targetScore: $targetScore, playerTotals: $playerTotals, currentTurnScore: $currentTurnScore, currentTurnDice: $currentTurnDice, diceBanked: $diceBanked, hasOpened: $hasOpened, gameOver: $gameOver, winnerId: $winnerId, playerOrder: $playerOrder)';
}


}

/// @nodoc
abstract mixin class $FarkleStateCopyWith<$Res>  {
  factory $FarkleStateCopyWith(FarkleState value, $Res Function(FarkleState) _then) = _$FarkleStateCopyWithImpl;
@useResult
$Res call({
 String currentPlayerId, int targetScore, Map<String, int> playerTotals, int currentTurnScore, List<int> currentTurnDice, int diceBanked, Map<String, bool> hasOpened, bool gameOver, String? winnerId, List<String> playerOrder
});




}
/// @nodoc
class _$FarkleStateCopyWithImpl<$Res>
    implements $FarkleStateCopyWith<$Res> {
  _$FarkleStateCopyWithImpl(this._self, this._then);

  final FarkleState _self;
  final $Res Function(FarkleState) _then;

/// Create a copy of FarkleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPlayerId = null,Object? targetScore = null,Object? playerTotals = null,Object? currentTurnScore = null,Object? currentTurnDice = null,Object? diceBanked = null,Object? hasOpened = null,Object? gameOver = null,Object? winnerId = freezed,Object? playerOrder = null,}) {
  return _then(_self.copyWith(
currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,targetScore: null == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int,playerTotals: null == playerTotals ? _self.playerTotals : playerTotals // ignore: cast_nullable_to_non_nullable
as Map<String, int>,currentTurnScore: null == currentTurnScore ? _self.currentTurnScore : currentTurnScore // ignore: cast_nullable_to_non_nullable
as int,currentTurnDice: null == currentTurnDice ? _self.currentTurnDice : currentTurnDice // ignore: cast_nullable_to_non_nullable
as List<int>,diceBanked: null == diceBanked ? _self.diceBanked : diceBanked // ignore: cast_nullable_to_non_nullable
as int,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,playerOrder: null == playerOrder ? _self.playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FarkleState].
extension FarkleStatePatterns on FarkleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarkleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarkleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarkleState value)  $default,){
final _that = this;
switch (_that) {
case _FarkleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarkleState value)?  $default,){
final _that = this;
switch (_that) {
case _FarkleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currentPlayerId,  int targetScore,  Map<String, int> playerTotals,  int currentTurnScore,  List<int> currentTurnDice,  int diceBanked,  Map<String, bool> hasOpened,  bool gameOver,  String? winnerId,  List<String> playerOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarkleState() when $default != null:
return $default(_that.currentPlayerId,_that.targetScore,_that.playerTotals,_that.currentTurnScore,_that.currentTurnDice,_that.diceBanked,_that.hasOpened,_that.gameOver,_that.winnerId,_that.playerOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currentPlayerId,  int targetScore,  Map<String, int> playerTotals,  int currentTurnScore,  List<int> currentTurnDice,  int diceBanked,  Map<String, bool> hasOpened,  bool gameOver,  String? winnerId,  List<String> playerOrder)  $default,) {final _that = this;
switch (_that) {
case _FarkleState():
return $default(_that.currentPlayerId,_that.targetScore,_that.playerTotals,_that.currentTurnScore,_that.currentTurnDice,_that.diceBanked,_that.hasOpened,_that.gameOver,_that.winnerId,_that.playerOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currentPlayerId,  int targetScore,  Map<String, int> playerTotals,  int currentTurnScore,  List<int> currentTurnDice,  int diceBanked,  Map<String, bool> hasOpened,  bool gameOver,  String? winnerId,  List<String> playerOrder)?  $default,) {final _that = this;
switch (_that) {
case _FarkleState() when $default != null:
return $default(_that.currentPlayerId,_that.targetScore,_that.playerTotals,_that.currentTurnScore,_that.currentTurnDice,_that.diceBanked,_that.hasOpened,_that.gameOver,_that.winnerId,_that.playerOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarkleState extends FarkleState {
  const _FarkleState({required this.currentPlayerId, required this.targetScore, required final  Map<String, int> playerTotals, required this.currentTurnScore, required final  List<int> currentTurnDice, required this.diceBanked, required final  Map<String, bool> hasOpened, required this.gameOver, this.winnerId, required final  List<String> playerOrder}): _playerTotals = playerTotals,_currentTurnDice = currentTurnDice,_hasOpened = hasOpened,_playerOrder = playerOrder,super._();
  factory _FarkleState.fromJson(Map<String, dynamic> json) => _$FarkleStateFromJson(json);

@override final  String currentPlayerId;
@override final  int targetScore;
 final  Map<String, int> _playerTotals;
@override Map<String, int> get playerTotals {
  if (_playerTotals is EqualUnmodifiableMapView) return _playerTotals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_playerTotals);
}

@override final  int currentTurnScore;
 final  List<int> _currentTurnDice;
@override List<int> get currentTurnDice {
  if (_currentTurnDice is EqualUnmodifiableListView) return _currentTurnDice;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_currentTurnDice);
}

@override final  int diceBanked;
 final  Map<String, bool> _hasOpened;
@override Map<String, bool> get hasOpened {
  if (_hasOpened is EqualUnmodifiableMapView) return _hasOpened;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_hasOpened);
}

@override final  bool gameOver;
@override final  String? winnerId;
 final  List<String> _playerOrder;
@override List<String> get playerOrder {
  if (_playerOrder is EqualUnmodifiableListView) return _playerOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerOrder);
}


/// Create a copy of FarkleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarkleStateCopyWith<_FarkleState> get copyWith => __$FarkleStateCopyWithImpl<_FarkleState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarkleStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarkleState&&(identical(other.currentPlayerId, currentPlayerId) || other.currentPlayerId == currentPlayerId)&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&const DeepCollectionEquality().equals(other._playerTotals, _playerTotals)&&(identical(other.currentTurnScore, currentTurnScore) || other.currentTurnScore == currentTurnScore)&&const DeepCollectionEquality().equals(other._currentTurnDice, _currentTurnDice)&&(identical(other.diceBanked, diceBanked) || other.diceBanked == diceBanked)&&const DeepCollectionEquality().equals(other._hasOpened, _hasOpened)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&const DeepCollectionEquality().equals(other._playerOrder, _playerOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPlayerId,targetScore,const DeepCollectionEquality().hash(_playerTotals),currentTurnScore,const DeepCollectionEquality().hash(_currentTurnDice),diceBanked,const DeepCollectionEquality().hash(_hasOpened),gameOver,winnerId,const DeepCollectionEquality().hash(_playerOrder));

@override
String toString() {
  return 'FarkleState(currentPlayerId: $currentPlayerId, targetScore: $targetScore, playerTotals: $playerTotals, currentTurnScore: $currentTurnScore, currentTurnDice: $currentTurnDice, diceBanked: $diceBanked, hasOpened: $hasOpened, gameOver: $gameOver, winnerId: $winnerId, playerOrder: $playerOrder)';
}


}

/// @nodoc
abstract mixin class _$FarkleStateCopyWith<$Res> implements $FarkleStateCopyWith<$Res> {
  factory _$FarkleStateCopyWith(_FarkleState value, $Res Function(_FarkleState) _then) = __$FarkleStateCopyWithImpl;
@override @useResult
$Res call({
 String currentPlayerId, int targetScore, Map<String, int> playerTotals, int currentTurnScore, List<int> currentTurnDice, int diceBanked, Map<String, bool> hasOpened, bool gameOver, String? winnerId, List<String> playerOrder
});




}
/// @nodoc
class __$FarkleStateCopyWithImpl<$Res>
    implements _$FarkleStateCopyWith<$Res> {
  __$FarkleStateCopyWithImpl(this._self, this._then);

  final _FarkleState _self;
  final $Res Function(_FarkleState) _then;

/// Create a copy of FarkleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPlayerId = null,Object? targetScore = null,Object? playerTotals = null,Object? currentTurnScore = null,Object? currentTurnDice = null,Object? diceBanked = null,Object? hasOpened = null,Object? gameOver = null,Object? winnerId = freezed,Object? playerOrder = null,}) {
  return _then(_FarkleState(
currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,targetScore: null == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int,playerTotals: null == playerTotals ? _self._playerTotals : playerTotals // ignore: cast_nullable_to_non_nullable
as Map<String, int>,currentTurnScore: null == currentTurnScore ? _self.currentTurnScore : currentTurnScore // ignore: cast_nullable_to_non_nullable
as int,currentTurnDice: null == currentTurnDice ? _self._currentTurnDice : currentTurnDice // ignore: cast_nullable_to_non_nullable
as List<int>,diceBanked: null == diceBanked ? _self.diceBanked : diceBanked // ignore: cast_nullable_to_non_nullable
as int,hasOpened: null == hasOpened ? _self._hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,playerOrder: null == playerOrder ? _self._playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
