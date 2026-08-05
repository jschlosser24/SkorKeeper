// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'darts_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DartsPlayerState {

 int get scoreRemaining; int get dartsThrown; List<int> get scoresThisLeg; bool get hasOpened;
/// Create a copy of DartsPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DartsPlayerStateCopyWith<DartsPlayerState> get copyWith => _$DartsPlayerStateCopyWithImpl<DartsPlayerState>(this as DartsPlayerState, _$identity);

  /// Serializes this DartsPlayerState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DartsPlayerState&&(identical(other.scoreRemaining, scoreRemaining) || other.scoreRemaining == scoreRemaining)&&(identical(other.dartsThrown, dartsThrown) || other.dartsThrown == dartsThrown)&&const DeepCollectionEquality().equals(other.scoresThisLeg, scoresThisLeg)&&(identical(other.hasOpened, hasOpened) || other.hasOpened == hasOpened));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scoreRemaining,dartsThrown,const DeepCollectionEquality().hash(scoresThisLeg),hasOpened);

@override
String toString() {
  return 'DartsPlayerState(scoreRemaining: $scoreRemaining, dartsThrown: $dartsThrown, scoresThisLeg: $scoresThisLeg, hasOpened: $hasOpened)';
}


}

/// @nodoc
abstract mixin class $DartsPlayerStateCopyWith<$Res>  {
  factory $DartsPlayerStateCopyWith(DartsPlayerState value, $Res Function(DartsPlayerState) _then) = _$DartsPlayerStateCopyWithImpl;
@useResult
$Res call({
 int scoreRemaining, int dartsThrown, List<int> scoresThisLeg, bool hasOpened
});




}
/// @nodoc
class _$DartsPlayerStateCopyWithImpl<$Res>
    implements $DartsPlayerStateCopyWith<$Res> {
  _$DartsPlayerStateCopyWithImpl(this._self, this._then);

  final DartsPlayerState _self;
  final $Res Function(DartsPlayerState) _then;

/// Create a copy of DartsPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scoreRemaining = null,Object? dartsThrown = null,Object? scoresThisLeg = null,Object? hasOpened = null,}) {
  return _then(_self.copyWith(
scoreRemaining: null == scoreRemaining ? _self.scoreRemaining : scoreRemaining // ignore: cast_nullable_to_non_nullable
as int,dartsThrown: null == dartsThrown ? _self.dartsThrown : dartsThrown // ignore: cast_nullable_to_non_nullable
as int,scoresThisLeg: null == scoresThisLeg ? _self.scoresThisLeg : scoresThisLeg // ignore: cast_nullable_to_non_nullable
as List<int>,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DartsPlayerState].
extension DartsPlayerStatePatterns on DartsPlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DartsPlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DartsPlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DartsPlayerState value)  $default,){
final _that = this;
switch (_that) {
case _DartsPlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DartsPlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _DartsPlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scoreRemaining,  int dartsThrown,  List<int> scoresThisLeg,  bool hasOpened)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DartsPlayerState() when $default != null:
return $default(_that.scoreRemaining,_that.dartsThrown,_that.scoresThisLeg,_that.hasOpened);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scoreRemaining,  int dartsThrown,  List<int> scoresThisLeg,  bool hasOpened)  $default,) {final _that = this;
switch (_that) {
case _DartsPlayerState():
return $default(_that.scoreRemaining,_that.dartsThrown,_that.scoresThisLeg,_that.hasOpened);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scoreRemaining,  int dartsThrown,  List<int> scoresThisLeg,  bool hasOpened)?  $default,) {final _that = this;
switch (_that) {
case _DartsPlayerState() when $default != null:
return $default(_that.scoreRemaining,_that.dartsThrown,_that.scoresThisLeg,_that.hasOpened);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DartsPlayerState implements DartsPlayerState {
  const _DartsPlayerState({required this.scoreRemaining, required this.dartsThrown, required final  List<int> scoresThisLeg, required this.hasOpened}): _scoresThisLeg = scoresThisLeg;
  factory _DartsPlayerState.fromJson(Map<String, dynamic> json) => _$DartsPlayerStateFromJson(json);

@override final  int scoreRemaining;
@override final  int dartsThrown;
 final  List<int> _scoresThisLeg;
@override List<int> get scoresThisLeg {
  if (_scoresThisLeg is EqualUnmodifiableListView) return _scoresThisLeg;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scoresThisLeg);
}

@override final  bool hasOpened;

/// Create a copy of DartsPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DartsPlayerStateCopyWith<_DartsPlayerState> get copyWith => __$DartsPlayerStateCopyWithImpl<_DartsPlayerState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DartsPlayerStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DartsPlayerState&&(identical(other.scoreRemaining, scoreRemaining) || other.scoreRemaining == scoreRemaining)&&(identical(other.dartsThrown, dartsThrown) || other.dartsThrown == dartsThrown)&&const DeepCollectionEquality().equals(other._scoresThisLeg, _scoresThisLeg)&&(identical(other.hasOpened, hasOpened) || other.hasOpened == hasOpened));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scoreRemaining,dartsThrown,const DeepCollectionEquality().hash(_scoresThisLeg),hasOpened);

@override
String toString() {
  return 'DartsPlayerState(scoreRemaining: $scoreRemaining, dartsThrown: $dartsThrown, scoresThisLeg: $scoresThisLeg, hasOpened: $hasOpened)';
}


}

/// @nodoc
abstract mixin class _$DartsPlayerStateCopyWith<$Res> implements $DartsPlayerStateCopyWith<$Res> {
  factory _$DartsPlayerStateCopyWith(_DartsPlayerState value, $Res Function(_DartsPlayerState) _then) = __$DartsPlayerStateCopyWithImpl;
@override @useResult
$Res call({
 int scoreRemaining, int dartsThrown, List<int> scoresThisLeg, bool hasOpened
});




}
/// @nodoc
class __$DartsPlayerStateCopyWithImpl<$Res>
    implements _$DartsPlayerStateCopyWith<$Res> {
  __$DartsPlayerStateCopyWithImpl(this._self, this._then);

  final _DartsPlayerState _self;
  final $Res Function(_DartsPlayerState) _then;

/// Create a copy of DartsPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scoreRemaining = null,Object? dartsThrown = null,Object? scoresThisLeg = null,Object? hasOpened = null,}) {
  return _then(_DartsPlayerState(
scoreRemaining: null == scoreRemaining ? _self.scoreRemaining : scoreRemaining // ignore: cast_nullable_to_non_nullable
as int,dartsThrown: null == dartsThrown ? _self.dartsThrown : dartsThrown // ignore: cast_nullable_to_non_nullable
as int,scoresThisLeg: null == scoresThisLeg ? _self._scoresThisLeg : scoresThisLeg // ignore: cast_nullable_to_non_nullable
as List<int>,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DartsGameState {

 DartsVariant get gameVariant; bool get doubleIn; bool get doubleOut; Map<String, DartsPlayerState> get playerStates; String get currentPlayerId; int get currentThrowInTurn; List<int> get throwsThisTurn; Map<String, int> get legsWon; Map<String, int> get setsWon; Map<String, Map<String, int>>? get cricketMarks; Map<String, int>? get cricketPoints; bool get gameOver; String? get winnerId; Map<String, int>? get variantScores; Map<String, int>? get variantProgress; Map<String, int>? get killerTargets; Map<String, int>? get killerLives; Map<String, bool>? get killerStatus; int? get currentRound; int? get currentTarget;
/// Create a copy of DartsGameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DartsGameStateCopyWith<DartsGameState> get copyWith => _$DartsGameStateCopyWithImpl<DartsGameState>(this as DartsGameState, _$identity);

  /// Serializes this DartsGameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DartsGameState&&(identical(other.gameVariant, gameVariant) || other.gameVariant == gameVariant)&&(identical(other.doubleIn, doubleIn) || other.doubleIn == doubleIn)&&(identical(other.doubleOut, doubleOut) || other.doubleOut == doubleOut)&&const DeepCollectionEquality().equals(other.playerStates, playerStates)&&(identical(other.currentPlayerId, currentPlayerId) || other.currentPlayerId == currentPlayerId)&&(identical(other.currentThrowInTurn, currentThrowInTurn) || other.currentThrowInTurn == currentThrowInTurn)&&const DeepCollectionEquality().equals(other.throwsThisTurn, throwsThisTurn)&&const DeepCollectionEquality().equals(other.legsWon, legsWon)&&const DeepCollectionEquality().equals(other.setsWon, setsWon)&&const DeepCollectionEquality().equals(other.cricketMarks, cricketMarks)&&const DeepCollectionEquality().equals(other.cricketPoints, cricketPoints)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&const DeepCollectionEquality().equals(other.variantScores, variantScores)&&const DeepCollectionEquality().equals(other.variantProgress, variantProgress)&&const DeepCollectionEquality().equals(other.killerTargets, killerTargets)&&const DeepCollectionEquality().equals(other.killerLives, killerLives)&&const DeepCollectionEquality().equals(other.killerStatus, killerStatus)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.currentTarget, currentTarget) || other.currentTarget == currentTarget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gameVariant,doubleIn,doubleOut,const DeepCollectionEquality().hash(playerStates),currentPlayerId,currentThrowInTurn,const DeepCollectionEquality().hash(throwsThisTurn),const DeepCollectionEquality().hash(legsWon),const DeepCollectionEquality().hash(setsWon),const DeepCollectionEquality().hash(cricketMarks),const DeepCollectionEquality().hash(cricketPoints),gameOver,winnerId,const DeepCollectionEquality().hash(variantScores),const DeepCollectionEquality().hash(variantProgress),const DeepCollectionEquality().hash(killerTargets),const DeepCollectionEquality().hash(killerLives),const DeepCollectionEquality().hash(killerStatus),currentRound,currentTarget]);

@override
String toString() {
  return 'DartsGameState(gameVariant: $gameVariant, doubleIn: $doubleIn, doubleOut: $doubleOut, playerStates: $playerStates, currentPlayerId: $currentPlayerId, currentThrowInTurn: $currentThrowInTurn, throwsThisTurn: $throwsThisTurn, legsWon: $legsWon, setsWon: $setsWon, cricketMarks: $cricketMarks, cricketPoints: $cricketPoints, gameOver: $gameOver, winnerId: $winnerId, variantScores: $variantScores, variantProgress: $variantProgress, killerTargets: $killerTargets, killerLives: $killerLives, killerStatus: $killerStatus, currentRound: $currentRound, currentTarget: $currentTarget)';
}


}

/// @nodoc
abstract mixin class $DartsGameStateCopyWith<$Res>  {
  factory $DartsGameStateCopyWith(DartsGameState value, $Res Function(DartsGameState) _then) = _$DartsGameStateCopyWithImpl;
@useResult
$Res call({
 DartsVariant gameVariant, bool doubleIn, bool doubleOut, Map<String, DartsPlayerState> playerStates, String currentPlayerId, int currentThrowInTurn, List<int> throwsThisTurn, Map<String, int> legsWon, Map<String, int> setsWon, Map<String, Map<String, int>>? cricketMarks, Map<String, int>? cricketPoints, bool gameOver, String? winnerId, Map<String, int>? variantScores, Map<String, int>? variantProgress, Map<String, int>? killerTargets, Map<String, int>? killerLives, Map<String, bool>? killerStatus, int? currentRound, int? currentTarget
});




}
/// @nodoc
class _$DartsGameStateCopyWithImpl<$Res>
    implements $DartsGameStateCopyWith<$Res> {
  _$DartsGameStateCopyWithImpl(this._self, this._then);

  final DartsGameState _self;
  final $Res Function(DartsGameState) _then;

/// Create a copy of DartsGameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameVariant = null,Object? doubleIn = null,Object? doubleOut = null,Object? playerStates = null,Object? currentPlayerId = null,Object? currentThrowInTurn = null,Object? throwsThisTurn = null,Object? legsWon = null,Object? setsWon = null,Object? cricketMarks = freezed,Object? cricketPoints = freezed,Object? gameOver = null,Object? winnerId = freezed,Object? variantScores = freezed,Object? variantProgress = freezed,Object? killerTargets = freezed,Object? killerLives = freezed,Object? killerStatus = freezed,Object? currentRound = freezed,Object? currentTarget = freezed,}) {
  return _then(_self.copyWith(
gameVariant: null == gameVariant ? _self.gameVariant : gameVariant // ignore: cast_nullable_to_non_nullable
as DartsVariant,doubleIn: null == doubleIn ? _self.doubleIn : doubleIn // ignore: cast_nullable_to_non_nullable
as bool,doubleOut: null == doubleOut ? _self.doubleOut : doubleOut // ignore: cast_nullable_to_non_nullable
as bool,playerStates: null == playerStates ? _self.playerStates : playerStates // ignore: cast_nullable_to_non_nullable
as Map<String, DartsPlayerState>,currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,currentThrowInTurn: null == currentThrowInTurn ? _self.currentThrowInTurn : currentThrowInTurn // ignore: cast_nullable_to_non_nullable
as int,throwsThisTurn: null == throwsThisTurn ? _self.throwsThisTurn : throwsThisTurn // ignore: cast_nullable_to_non_nullable
as List<int>,legsWon: null == legsWon ? _self.legsWon : legsWon // ignore: cast_nullable_to_non_nullable
as Map<String, int>,setsWon: null == setsWon ? _self.setsWon : setsWon // ignore: cast_nullable_to_non_nullable
as Map<String, int>,cricketMarks: freezed == cricketMarks ? _self.cricketMarks : cricketMarks // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, int>>?,cricketPoints: freezed == cricketPoints ? _self.cricketPoints : cricketPoints // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,variantScores: freezed == variantScores ? _self.variantScores : variantScores // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,variantProgress: freezed == variantProgress ? _self.variantProgress : variantProgress // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,killerTargets: freezed == killerTargets ? _self.killerTargets : killerTargets // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,killerLives: freezed == killerLives ? _self.killerLives : killerLives // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,killerStatus: freezed == killerStatus ? _self.killerStatus : killerStatus // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,currentRound: freezed == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int?,currentTarget: freezed == currentTarget ? _self.currentTarget : currentTarget // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DartsGameState].
extension DartsGameStatePatterns on DartsGameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DartsGameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DartsGameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DartsGameState value)  $default,){
final _that = this;
switch (_that) {
case _DartsGameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DartsGameState value)?  $default,){
final _that = this;
switch (_that) {
case _DartsGameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DartsVariant gameVariant,  bool doubleIn,  bool doubleOut,  Map<String, DartsPlayerState> playerStates,  String currentPlayerId,  int currentThrowInTurn,  List<int> throwsThisTurn,  Map<String, int> legsWon,  Map<String, int> setsWon,  Map<String, Map<String, int>>? cricketMarks,  Map<String, int>? cricketPoints,  bool gameOver,  String? winnerId,  Map<String, int>? variantScores,  Map<String, int>? variantProgress,  Map<String, int>? killerTargets,  Map<String, int>? killerLives,  Map<String, bool>? killerStatus,  int? currentRound,  int? currentTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DartsGameState() when $default != null:
return $default(_that.gameVariant,_that.doubleIn,_that.doubleOut,_that.playerStates,_that.currentPlayerId,_that.currentThrowInTurn,_that.throwsThisTurn,_that.legsWon,_that.setsWon,_that.cricketMarks,_that.cricketPoints,_that.gameOver,_that.winnerId,_that.variantScores,_that.variantProgress,_that.killerTargets,_that.killerLives,_that.killerStatus,_that.currentRound,_that.currentTarget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DartsVariant gameVariant,  bool doubleIn,  bool doubleOut,  Map<String, DartsPlayerState> playerStates,  String currentPlayerId,  int currentThrowInTurn,  List<int> throwsThisTurn,  Map<String, int> legsWon,  Map<String, int> setsWon,  Map<String, Map<String, int>>? cricketMarks,  Map<String, int>? cricketPoints,  bool gameOver,  String? winnerId,  Map<String, int>? variantScores,  Map<String, int>? variantProgress,  Map<String, int>? killerTargets,  Map<String, int>? killerLives,  Map<String, bool>? killerStatus,  int? currentRound,  int? currentTarget)  $default,) {final _that = this;
switch (_that) {
case _DartsGameState():
return $default(_that.gameVariant,_that.doubleIn,_that.doubleOut,_that.playerStates,_that.currentPlayerId,_that.currentThrowInTurn,_that.throwsThisTurn,_that.legsWon,_that.setsWon,_that.cricketMarks,_that.cricketPoints,_that.gameOver,_that.winnerId,_that.variantScores,_that.variantProgress,_that.killerTargets,_that.killerLives,_that.killerStatus,_that.currentRound,_that.currentTarget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DartsVariant gameVariant,  bool doubleIn,  bool doubleOut,  Map<String, DartsPlayerState> playerStates,  String currentPlayerId,  int currentThrowInTurn,  List<int> throwsThisTurn,  Map<String, int> legsWon,  Map<String, int> setsWon,  Map<String, Map<String, int>>? cricketMarks,  Map<String, int>? cricketPoints,  bool gameOver,  String? winnerId,  Map<String, int>? variantScores,  Map<String, int>? variantProgress,  Map<String, int>? killerTargets,  Map<String, int>? killerLives,  Map<String, bool>? killerStatus,  int? currentRound,  int? currentTarget)?  $default,) {final _that = this;
switch (_that) {
case _DartsGameState() when $default != null:
return $default(_that.gameVariant,_that.doubleIn,_that.doubleOut,_that.playerStates,_that.currentPlayerId,_that.currentThrowInTurn,_that.throwsThisTurn,_that.legsWon,_that.setsWon,_that.cricketMarks,_that.cricketPoints,_that.gameOver,_that.winnerId,_that.variantScores,_that.variantProgress,_that.killerTargets,_that.killerLives,_that.killerStatus,_that.currentRound,_that.currentTarget);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DartsGameState extends DartsGameState {
  const _DartsGameState({required this.gameVariant, required this.doubleIn, required this.doubleOut, required final  Map<String, DartsPlayerState> playerStates, required this.currentPlayerId, required this.currentThrowInTurn, required final  List<int> throwsThisTurn, required final  Map<String, int> legsWon, required final  Map<String, int> setsWon, final  Map<String, Map<String, int>>? cricketMarks, final  Map<String, int>? cricketPoints, required this.gameOver, this.winnerId, final  Map<String, int>? variantScores, final  Map<String, int>? variantProgress, final  Map<String, int>? killerTargets, final  Map<String, int>? killerLives, final  Map<String, bool>? killerStatus, this.currentRound, this.currentTarget}): _playerStates = playerStates,_throwsThisTurn = throwsThisTurn,_legsWon = legsWon,_setsWon = setsWon,_cricketMarks = cricketMarks,_cricketPoints = cricketPoints,_variantScores = variantScores,_variantProgress = variantProgress,_killerTargets = killerTargets,_killerLives = killerLives,_killerStatus = killerStatus,super._();
  factory _DartsGameState.fromJson(Map<String, dynamic> json) => _$DartsGameStateFromJson(json);

@override final  DartsVariant gameVariant;
@override final  bool doubleIn;
@override final  bool doubleOut;
 final  Map<String, DartsPlayerState> _playerStates;
@override Map<String, DartsPlayerState> get playerStates {
  if (_playerStates is EqualUnmodifiableMapView) return _playerStates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_playerStates);
}

@override final  String currentPlayerId;
@override final  int currentThrowInTurn;
 final  List<int> _throwsThisTurn;
@override List<int> get throwsThisTurn {
  if (_throwsThisTurn is EqualUnmodifiableListView) return _throwsThisTurn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_throwsThisTurn);
}

 final  Map<String, int> _legsWon;
@override Map<String, int> get legsWon {
  if (_legsWon is EqualUnmodifiableMapView) return _legsWon;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_legsWon);
}

 final  Map<String, int> _setsWon;
@override Map<String, int> get setsWon {
  if (_setsWon is EqualUnmodifiableMapView) return _setsWon;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_setsWon);
}

 final  Map<String, Map<String, int>>? _cricketMarks;
@override Map<String, Map<String, int>>? get cricketMarks {
  final value = _cricketMarks;
  if (value == null) return null;
  if (_cricketMarks is EqualUnmodifiableMapView) return _cricketMarks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, int>? _cricketPoints;
@override Map<String, int>? get cricketPoints {
  final value = _cricketPoints;
  if (value == null) return null;
  if (_cricketPoints is EqualUnmodifiableMapView) return _cricketPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  bool gameOver;
@override final  String? winnerId;
 final  Map<String, int>? _variantScores;
@override Map<String, int>? get variantScores {
  final value = _variantScores;
  if (value == null) return null;
  if (_variantScores is EqualUnmodifiableMapView) return _variantScores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, int>? _variantProgress;
@override Map<String, int>? get variantProgress {
  final value = _variantProgress;
  if (value == null) return null;
  if (_variantProgress is EqualUnmodifiableMapView) return _variantProgress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, int>? _killerTargets;
@override Map<String, int>? get killerTargets {
  final value = _killerTargets;
  if (value == null) return null;
  if (_killerTargets is EqualUnmodifiableMapView) return _killerTargets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, int>? _killerLives;
@override Map<String, int>? get killerLives {
  final value = _killerLives;
  if (value == null) return null;
  if (_killerLives is EqualUnmodifiableMapView) return _killerLives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, bool>? _killerStatus;
@override Map<String, bool>? get killerStatus {
  final value = _killerStatus;
  if (value == null) return null;
  if (_killerStatus is EqualUnmodifiableMapView) return _killerStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  int? currentRound;
@override final  int? currentTarget;

/// Create a copy of DartsGameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DartsGameStateCopyWith<_DartsGameState> get copyWith => __$DartsGameStateCopyWithImpl<_DartsGameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DartsGameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DartsGameState&&(identical(other.gameVariant, gameVariant) || other.gameVariant == gameVariant)&&(identical(other.doubleIn, doubleIn) || other.doubleIn == doubleIn)&&(identical(other.doubleOut, doubleOut) || other.doubleOut == doubleOut)&&const DeepCollectionEquality().equals(other._playerStates, _playerStates)&&(identical(other.currentPlayerId, currentPlayerId) || other.currentPlayerId == currentPlayerId)&&(identical(other.currentThrowInTurn, currentThrowInTurn) || other.currentThrowInTurn == currentThrowInTurn)&&const DeepCollectionEquality().equals(other._throwsThisTurn, _throwsThisTurn)&&const DeepCollectionEquality().equals(other._legsWon, _legsWon)&&const DeepCollectionEquality().equals(other._setsWon, _setsWon)&&const DeepCollectionEquality().equals(other._cricketMarks, _cricketMarks)&&const DeepCollectionEquality().equals(other._cricketPoints, _cricketPoints)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&const DeepCollectionEquality().equals(other._variantScores, _variantScores)&&const DeepCollectionEquality().equals(other._variantProgress, _variantProgress)&&const DeepCollectionEquality().equals(other._killerTargets, _killerTargets)&&const DeepCollectionEquality().equals(other._killerLives, _killerLives)&&const DeepCollectionEquality().equals(other._killerStatus, _killerStatus)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.currentTarget, currentTarget) || other.currentTarget == currentTarget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gameVariant,doubleIn,doubleOut,const DeepCollectionEquality().hash(_playerStates),currentPlayerId,currentThrowInTurn,const DeepCollectionEquality().hash(_throwsThisTurn),const DeepCollectionEquality().hash(_legsWon),const DeepCollectionEquality().hash(_setsWon),const DeepCollectionEquality().hash(_cricketMarks),const DeepCollectionEquality().hash(_cricketPoints),gameOver,winnerId,const DeepCollectionEquality().hash(_variantScores),const DeepCollectionEquality().hash(_variantProgress),const DeepCollectionEquality().hash(_killerTargets),const DeepCollectionEquality().hash(_killerLives),const DeepCollectionEquality().hash(_killerStatus),currentRound,currentTarget]);

@override
String toString() {
  return 'DartsGameState(gameVariant: $gameVariant, doubleIn: $doubleIn, doubleOut: $doubleOut, playerStates: $playerStates, currentPlayerId: $currentPlayerId, currentThrowInTurn: $currentThrowInTurn, throwsThisTurn: $throwsThisTurn, legsWon: $legsWon, setsWon: $setsWon, cricketMarks: $cricketMarks, cricketPoints: $cricketPoints, gameOver: $gameOver, winnerId: $winnerId, variantScores: $variantScores, variantProgress: $variantProgress, killerTargets: $killerTargets, killerLives: $killerLives, killerStatus: $killerStatus, currentRound: $currentRound, currentTarget: $currentTarget)';
}


}

/// @nodoc
abstract mixin class _$DartsGameStateCopyWith<$Res> implements $DartsGameStateCopyWith<$Res> {
  factory _$DartsGameStateCopyWith(_DartsGameState value, $Res Function(_DartsGameState) _then) = __$DartsGameStateCopyWithImpl;
@override @useResult
$Res call({
 DartsVariant gameVariant, bool doubleIn, bool doubleOut, Map<String, DartsPlayerState> playerStates, String currentPlayerId, int currentThrowInTurn, List<int> throwsThisTurn, Map<String, int> legsWon, Map<String, int> setsWon, Map<String, Map<String, int>>? cricketMarks, Map<String, int>? cricketPoints, bool gameOver, String? winnerId, Map<String, int>? variantScores, Map<String, int>? variantProgress, Map<String, int>? killerTargets, Map<String, int>? killerLives, Map<String, bool>? killerStatus, int? currentRound, int? currentTarget
});




}
/// @nodoc
class __$DartsGameStateCopyWithImpl<$Res>
    implements _$DartsGameStateCopyWith<$Res> {
  __$DartsGameStateCopyWithImpl(this._self, this._then);

  final _DartsGameState _self;
  final $Res Function(_DartsGameState) _then;

/// Create a copy of DartsGameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameVariant = null,Object? doubleIn = null,Object? doubleOut = null,Object? playerStates = null,Object? currentPlayerId = null,Object? currentThrowInTurn = null,Object? throwsThisTurn = null,Object? legsWon = null,Object? setsWon = null,Object? cricketMarks = freezed,Object? cricketPoints = freezed,Object? gameOver = null,Object? winnerId = freezed,Object? variantScores = freezed,Object? variantProgress = freezed,Object? killerTargets = freezed,Object? killerLives = freezed,Object? killerStatus = freezed,Object? currentRound = freezed,Object? currentTarget = freezed,}) {
  return _then(_DartsGameState(
gameVariant: null == gameVariant ? _self.gameVariant : gameVariant // ignore: cast_nullable_to_non_nullable
as DartsVariant,doubleIn: null == doubleIn ? _self.doubleIn : doubleIn // ignore: cast_nullable_to_non_nullable
as bool,doubleOut: null == doubleOut ? _self.doubleOut : doubleOut // ignore: cast_nullable_to_non_nullable
as bool,playerStates: null == playerStates ? _self._playerStates : playerStates // ignore: cast_nullable_to_non_nullable
as Map<String, DartsPlayerState>,currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,currentThrowInTurn: null == currentThrowInTurn ? _self.currentThrowInTurn : currentThrowInTurn // ignore: cast_nullable_to_non_nullable
as int,throwsThisTurn: null == throwsThisTurn ? _self._throwsThisTurn : throwsThisTurn // ignore: cast_nullable_to_non_nullable
as List<int>,legsWon: null == legsWon ? _self._legsWon : legsWon // ignore: cast_nullable_to_non_nullable
as Map<String, int>,setsWon: null == setsWon ? _self._setsWon : setsWon // ignore: cast_nullable_to_non_nullable
as Map<String, int>,cricketMarks: freezed == cricketMarks ? _self._cricketMarks : cricketMarks // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, int>>?,cricketPoints: freezed == cricketPoints ? _self._cricketPoints : cricketPoints // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,variantScores: freezed == variantScores ? _self._variantScores : variantScores // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,variantProgress: freezed == variantProgress ? _self._variantProgress : variantProgress // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,killerTargets: freezed == killerTargets ? _self._killerTargets : killerTargets // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,killerLives: freezed == killerLives ? _self._killerLives : killerLives // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,killerStatus: freezed == killerStatus ? _self._killerStatus : killerStatus // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,currentRound: freezed == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int?,currentTarget: freezed == currentTarget ? _self.currentTarget : currentTarget // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
