// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'uno_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnoState {

 int get currentRound; int get targetScore; Map<String, int> get playerTotals; List<String> get eliminatedPlayerIds; bool get gameOver; String? get winnerId; List<String> get playerOrder;
/// Create a copy of UnoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnoStateCopyWith<UnoState> get copyWith => _$UnoStateCopyWithImpl<UnoState>(this as UnoState, _$identity);

  /// Serializes this UnoState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnoState&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&const DeepCollectionEquality().equals(other.playerTotals, playerTotals)&&const DeepCollectionEquality().equals(other.eliminatedPlayerIds, eliminatedPlayerIds)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&const DeepCollectionEquality().equals(other.playerOrder, playerOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentRound,targetScore,const DeepCollectionEquality().hash(playerTotals),const DeepCollectionEquality().hash(eliminatedPlayerIds),gameOver,winnerId,const DeepCollectionEquality().hash(playerOrder));

@override
String toString() {
  return 'UnoState(currentRound: $currentRound, targetScore: $targetScore, playerTotals: $playerTotals, eliminatedPlayerIds: $eliminatedPlayerIds, gameOver: $gameOver, winnerId: $winnerId, playerOrder: $playerOrder)';
}


}

/// @nodoc
abstract mixin class $UnoStateCopyWith<$Res>  {
  factory $UnoStateCopyWith(UnoState value, $Res Function(UnoState) _then) = _$UnoStateCopyWithImpl;
@useResult
$Res call({
 int currentRound, int targetScore, Map<String, int> playerTotals, List<String> eliminatedPlayerIds, bool gameOver, String? winnerId, List<String> playerOrder
});




}
/// @nodoc
class _$UnoStateCopyWithImpl<$Res>
    implements $UnoStateCopyWith<$Res> {
  _$UnoStateCopyWithImpl(this._self, this._then);

  final UnoState _self;
  final $Res Function(UnoState) _then;

/// Create a copy of UnoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentRound = null,Object? targetScore = null,Object? playerTotals = null,Object? eliminatedPlayerIds = null,Object? gameOver = null,Object? winnerId = freezed,Object? playerOrder = null,}) {
  return _then(_self.copyWith(
currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int,targetScore: null == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int,playerTotals: null == playerTotals ? _self.playerTotals : playerTotals // ignore: cast_nullable_to_non_nullable
as Map<String, int>,eliminatedPlayerIds: null == eliminatedPlayerIds ? _self.eliminatedPlayerIds : eliminatedPlayerIds // ignore: cast_nullable_to_non_nullable
as List<String>,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,playerOrder: null == playerOrder ? _self.playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UnoState].
extension UnoStatePatterns on UnoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnoState value)  $default,){
final _that = this;
switch (_that) {
case _UnoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnoState value)?  $default,){
final _that = this;
switch (_that) {
case _UnoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentRound,  int targetScore,  Map<String, int> playerTotals,  List<String> eliminatedPlayerIds,  bool gameOver,  String? winnerId,  List<String> playerOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnoState() when $default != null:
return $default(_that.currentRound,_that.targetScore,_that.playerTotals,_that.eliminatedPlayerIds,_that.gameOver,_that.winnerId,_that.playerOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentRound,  int targetScore,  Map<String, int> playerTotals,  List<String> eliminatedPlayerIds,  bool gameOver,  String? winnerId,  List<String> playerOrder)  $default,) {final _that = this;
switch (_that) {
case _UnoState():
return $default(_that.currentRound,_that.targetScore,_that.playerTotals,_that.eliminatedPlayerIds,_that.gameOver,_that.winnerId,_that.playerOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentRound,  int targetScore,  Map<String, int> playerTotals,  List<String> eliminatedPlayerIds,  bool gameOver,  String? winnerId,  List<String> playerOrder)?  $default,) {final _that = this;
switch (_that) {
case _UnoState() when $default != null:
return $default(_that.currentRound,_that.targetScore,_that.playerTotals,_that.eliminatedPlayerIds,_that.gameOver,_that.winnerId,_that.playerOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnoState extends UnoState {
  const _UnoState({required this.currentRound, required this.targetScore, required final  Map<String, int> playerTotals, required final  List<String> eliminatedPlayerIds, required this.gameOver, this.winnerId, required final  List<String> playerOrder}): _playerTotals = playerTotals,_eliminatedPlayerIds = eliminatedPlayerIds,_playerOrder = playerOrder,super._();
  factory _UnoState.fromJson(Map<String, dynamic> json) => _$UnoStateFromJson(json);

@override final  int currentRound;
@override final  int targetScore;
 final  Map<String, int> _playerTotals;
@override Map<String, int> get playerTotals {
  if (_playerTotals is EqualUnmodifiableMapView) return _playerTotals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_playerTotals);
}

 final  List<String> _eliminatedPlayerIds;
@override List<String> get eliminatedPlayerIds {
  if (_eliminatedPlayerIds is EqualUnmodifiableListView) return _eliminatedPlayerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eliminatedPlayerIds);
}

@override final  bool gameOver;
@override final  String? winnerId;
 final  List<String> _playerOrder;
@override List<String> get playerOrder {
  if (_playerOrder is EqualUnmodifiableListView) return _playerOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerOrder);
}


/// Create a copy of UnoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnoStateCopyWith<_UnoState> get copyWith => __$UnoStateCopyWithImpl<_UnoState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnoStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnoState&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&const DeepCollectionEquality().equals(other._playerTotals, _playerTotals)&&const DeepCollectionEquality().equals(other._eliminatedPlayerIds, _eliminatedPlayerIds)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&const DeepCollectionEquality().equals(other._playerOrder, _playerOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentRound,targetScore,const DeepCollectionEquality().hash(_playerTotals),const DeepCollectionEquality().hash(_eliminatedPlayerIds),gameOver,winnerId,const DeepCollectionEquality().hash(_playerOrder));

@override
String toString() {
  return 'UnoState(currentRound: $currentRound, targetScore: $targetScore, playerTotals: $playerTotals, eliminatedPlayerIds: $eliminatedPlayerIds, gameOver: $gameOver, winnerId: $winnerId, playerOrder: $playerOrder)';
}


}

/// @nodoc
abstract mixin class _$UnoStateCopyWith<$Res> implements $UnoStateCopyWith<$Res> {
  factory _$UnoStateCopyWith(_UnoState value, $Res Function(_UnoState) _then) = __$UnoStateCopyWithImpl;
@override @useResult
$Res call({
 int currentRound, int targetScore, Map<String, int> playerTotals, List<String> eliminatedPlayerIds, bool gameOver, String? winnerId, List<String> playerOrder
});




}
/// @nodoc
class __$UnoStateCopyWithImpl<$Res>
    implements _$UnoStateCopyWith<$Res> {
  __$UnoStateCopyWithImpl(this._self, this._then);

  final _UnoState _self;
  final $Res Function(_UnoState) _then;

/// Create a copy of UnoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentRound = null,Object? targetScore = null,Object? playerTotals = null,Object? eliminatedPlayerIds = null,Object? gameOver = null,Object? winnerId = freezed,Object? playerOrder = null,}) {
  return _then(_UnoState(
currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int,targetScore: null == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int,playerTotals: null == playerTotals ? _self._playerTotals : playerTotals // ignore: cast_nullable_to_non_nullable
as Map<String, int>,eliminatedPlayerIds: null == eliminatedPlayerIds ? _self._eliminatedPlayerIds : eliminatedPlayerIds // ignore: cast_nullable_to_non_nullable
as List<String>,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,playerOrder: null == playerOrder ? _self._playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
