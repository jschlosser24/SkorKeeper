// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'yahtzee_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YahtzeeScorecard {

 int? get ones; int? get twos; int? get threes; int? get fours; int? get fives; int? get sixes; int? get threeOfAKind; int? get fourOfAKind; int? get fullHouse; int? get smallStraight; int? get largeStraight; int? get yahtzee; int? get chance; int get yahtzeeBonusCount;
/// Create a copy of YahtzeeScorecard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YahtzeeScorecardCopyWith<YahtzeeScorecard> get copyWith => _$YahtzeeScorecardCopyWithImpl<YahtzeeScorecard>(this as YahtzeeScorecard, _$identity);

  /// Serializes this YahtzeeScorecard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YahtzeeScorecard&&(identical(other.ones, ones) || other.ones == ones)&&(identical(other.twos, twos) || other.twos == twos)&&(identical(other.threes, threes) || other.threes == threes)&&(identical(other.fours, fours) || other.fours == fours)&&(identical(other.fives, fives) || other.fives == fives)&&(identical(other.sixes, sixes) || other.sixes == sixes)&&(identical(other.threeOfAKind, threeOfAKind) || other.threeOfAKind == threeOfAKind)&&(identical(other.fourOfAKind, fourOfAKind) || other.fourOfAKind == fourOfAKind)&&(identical(other.fullHouse, fullHouse) || other.fullHouse == fullHouse)&&(identical(other.smallStraight, smallStraight) || other.smallStraight == smallStraight)&&(identical(other.largeStraight, largeStraight) || other.largeStraight == largeStraight)&&(identical(other.yahtzee, yahtzee) || other.yahtzee == yahtzee)&&(identical(other.chance, chance) || other.chance == chance)&&(identical(other.yahtzeeBonusCount, yahtzeeBonusCount) || other.yahtzeeBonusCount == yahtzeeBonusCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ones,twos,threes,fours,fives,sixes,threeOfAKind,fourOfAKind,fullHouse,smallStraight,largeStraight,yahtzee,chance,yahtzeeBonusCount);

@override
String toString() {
  return 'YahtzeeScorecard(ones: $ones, twos: $twos, threes: $threes, fours: $fours, fives: $fives, sixes: $sixes, threeOfAKind: $threeOfAKind, fourOfAKind: $fourOfAKind, fullHouse: $fullHouse, smallStraight: $smallStraight, largeStraight: $largeStraight, yahtzee: $yahtzee, chance: $chance, yahtzeeBonusCount: $yahtzeeBonusCount)';
}


}

/// @nodoc
abstract mixin class $YahtzeeScorecardCopyWith<$Res>  {
  factory $YahtzeeScorecardCopyWith(YahtzeeScorecard value, $Res Function(YahtzeeScorecard) _then) = _$YahtzeeScorecardCopyWithImpl;
@useResult
$Res call({
 int? ones, int? twos, int? threes, int? fours, int? fives, int? sixes, int? threeOfAKind, int? fourOfAKind, int? fullHouse, int? smallStraight, int? largeStraight, int? yahtzee, int? chance, int yahtzeeBonusCount
});




}
/// @nodoc
class _$YahtzeeScorecardCopyWithImpl<$Res>
    implements $YahtzeeScorecardCopyWith<$Res> {
  _$YahtzeeScorecardCopyWithImpl(this._self, this._then);

  final YahtzeeScorecard _self;
  final $Res Function(YahtzeeScorecard) _then;

/// Create a copy of YahtzeeScorecard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ones = freezed,Object? twos = freezed,Object? threes = freezed,Object? fours = freezed,Object? fives = freezed,Object? sixes = freezed,Object? threeOfAKind = freezed,Object? fourOfAKind = freezed,Object? fullHouse = freezed,Object? smallStraight = freezed,Object? largeStraight = freezed,Object? yahtzee = freezed,Object? chance = freezed,Object? yahtzeeBonusCount = null,}) {
  return _then(_self.copyWith(
ones: freezed == ones ? _self.ones : ones // ignore: cast_nullable_to_non_nullable
as int?,twos: freezed == twos ? _self.twos : twos // ignore: cast_nullable_to_non_nullable
as int?,threes: freezed == threes ? _self.threes : threes // ignore: cast_nullable_to_non_nullable
as int?,fours: freezed == fours ? _self.fours : fours // ignore: cast_nullable_to_non_nullable
as int?,fives: freezed == fives ? _self.fives : fives // ignore: cast_nullable_to_non_nullable
as int?,sixes: freezed == sixes ? _self.sixes : sixes // ignore: cast_nullable_to_non_nullable
as int?,threeOfAKind: freezed == threeOfAKind ? _self.threeOfAKind : threeOfAKind // ignore: cast_nullable_to_non_nullable
as int?,fourOfAKind: freezed == fourOfAKind ? _self.fourOfAKind : fourOfAKind // ignore: cast_nullable_to_non_nullable
as int?,fullHouse: freezed == fullHouse ? _self.fullHouse : fullHouse // ignore: cast_nullable_to_non_nullable
as int?,smallStraight: freezed == smallStraight ? _self.smallStraight : smallStraight // ignore: cast_nullable_to_non_nullable
as int?,largeStraight: freezed == largeStraight ? _self.largeStraight : largeStraight // ignore: cast_nullable_to_non_nullable
as int?,yahtzee: freezed == yahtzee ? _self.yahtzee : yahtzee // ignore: cast_nullable_to_non_nullable
as int?,chance: freezed == chance ? _self.chance : chance // ignore: cast_nullable_to_non_nullable
as int?,yahtzeeBonusCount: null == yahtzeeBonusCount ? _self.yahtzeeBonusCount : yahtzeeBonusCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [YahtzeeScorecard].
extension YahtzeeScorecardPatterns on YahtzeeScorecard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YahtzeeScorecard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YahtzeeScorecard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YahtzeeScorecard value)  $default,){
final _that = this;
switch (_that) {
case _YahtzeeScorecard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YahtzeeScorecard value)?  $default,){
final _that = this;
switch (_that) {
case _YahtzeeScorecard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? ones,  int? twos,  int? threes,  int? fours,  int? fives,  int? sixes,  int? threeOfAKind,  int? fourOfAKind,  int? fullHouse,  int? smallStraight,  int? largeStraight,  int? yahtzee,  int? chance,  int yahtzeeBonusCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YahtzeeScorecard() when $default != null:
return $default(_that.ones,_that.twos,_that.threes,_that.fours,_that.fives,_that.sixes,_that.threeOfAKind,_that.fourOfAKind,_that.fullHouse,_that.smallStraight,_that.largeStraight,_that.yahtzee,_that.chance,_that.yahtzeeBonusCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? ones,  int? twos,  int? threes,  int? fours,  int? fives,  int? sixes,  int? threeOfAKind,  int? fourOfAKind,  int? fullHouse,  int? smallStraight,  int? largeStraight,  int? yahtzee,  int? chance,  int yahtzeeBonusCount)  $default,) {final _that = this;
switch (_that) {
case _YahtzeeScorecard():
return $default(_that.ones,_that.twos,_that.threes,_that.fours,_that.fives,_that.sixes,_that.threeOfAKind,_that.fourOfAKind,_that.fullHouse,_that.smallStraight,_that.largeStraight,_that.yahtzee,_that.chance,_that.yahtzeeBonusCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? ones,  int? twos,  int? threes,  int? fours,  int? fives,  int? sixes,  int? threeOfAKind,  int? fourOfAKind,  int? fullHouse,  int? smallStraight,  int? largeStraight,  int? yahtzee,  int? chance,  int yahtzeeBonusCount)?  $default,) {final _that = this;
switch (_that) {
case _YahtzeeScorecard() when $default != null:
return $default(_that.ones,_that.twos,_that.threes,_that.fours,_that.fives,_that.sixes,_that.threeOfAKind,_that.fourOfAKind,_that.fullHouse,_that.smallStraight,_that.largeStraight,_that.yahtzee,_that.chance,_that.yahtzeeBonusCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YahtzeeScorecard extends YahtzeeScorecard {
  const _YahtzeeScorecard({this.ones, this.twos, this.threes, this.fours, this.fives, this.sixes, this.threeOfAKind, this.fourOfAKind, this.fullHouse, this.smallStraight, this.largeStraight, this.yahtzee, this.chance, this.yahtzeeBonusCount = 0}): super._();
  factory _YahtzeeScorecard.fromJson(Map<String, dynamic> json) => _$YahtzeeScorecardFromJson(json);

@override final  int? ones;
@override final  int? twos;
@override final  int? threes;
@override final  int? fours;
@override final  int? fives;
@override final  int? sixes;
@override final  int? threeOfAKind;
@override final  int? fourOfAKind;
@override final  int? fullHouse;
@override final  int? smallStraight;
@override final  int? largeStraight;
@override final  int? yahtzee;
@override final  int? chance;
@override@JsonKey() final  int yahtzeeBonusCount;

/// Create a copy of YahtzeeScorecard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YahtzeeScorecardCopyWith<_YahtzeeScorecard> get copyWith => __$YahtzeeScorecardCopyWithImpl<_YahtzeeScorecard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YahtzeeScorecardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YahtzeeScorecard&&(identical(other.ones, ones) || other.ones == ones)&&(identical(other.twos, twos) || other.twos == twos)&&(identical(other.threes, threes) || other.threes == threes)&&(identical(other.fours, fours) || other.fours == fours)&&(identical(other.fives, fives) || other.fives == fives)&&(identical(other.sixes, sixes) || other.sixes == sixes)&&(identical(other.threeOfAKind, threeOfAKind) || other.threeOfAKind == threeOfAKind)&&(identical(other.fourOfAKind, fourOfAKind) || other.fourOfAKind == fourOfAKind)&&(identical(other.fullHouse, fullHouse) || other.fullHouse == fullHouse)&&(identical(other.smallStraight, smallStraight) || other.smallStraight == smallStraight)&&(identical(other.largeStraight, largeStraight) || other.largeStraight == largeStraight)&&(identical(other.yahtzee, yahtzee) || other.yahtzee == yahtzee)&&(identical(other.chance, chance) || other.chance == chance)&&(identical(other.yahtzeeBonusCount, yahtzeeBonusCount) || other.yahtzeeBonusCount == yahtzeeBonusCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ones,twos,threes,fours,fives,sixes,threeOfAKind,fourOfAKind,fullHouse,smallStraight,largeStraight,yahtzee,chance,yahtzeeBonusCount);

@override
String toString() {
  return 'YahtzeeScorecard(ones: $ones, twos: $twos, threes: $threes, fours: $fours, fives: $fives, sixes: $sixes, threeOfAKind: $threeOfAKind, fourOfAKind: $fourOfAKind, fullHouse: $fullHouse, smallStraight: $smallStraight, largeStraight: $largeStraight, yahtzee: $yahtzee, chance: $chance, yahtzeeBonusCount: $yahtzeeBonusCount)';
}


}

/// @nodoc
abstract mixin class _$YahtzeeScorecardCopyWith<$Res> implements $YahtzeeScorecardCopyWith<$Res> {
  factory _$YahtzeeScorecardCopyWith(_YahtzeeScorecard value, $Res Function(_YahtzeeScorecard) _then) = __$YahtzeeScorecardCopyWithImpl;
@override @useResult
$Res call({
 int? ones, int? twos, int? threes, int? fours, int? fives, int? sixes, int? threeOfAKind, int? fourOfAKind, int? fullHouse, int? smallStraight, int? largeStraight, int? yahtzee, int? chance, int yahtzeeBonusCount
});




}
/// @nodoc
class __$YahtzeeScorecardCopyWithImpl<$Res>
    implements _$YahtzeeScorecardCopyWith<$Res> {
  __$YahtzeeScorecardCopyWithImpl(this._self, this._then);

  final _YahtzeeScorecard _self;
  final $Res Function(_YahtzeeScorecard) _then;

/// Create a copy of YahtzeeScorecard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ones = freezed,Object? twos = freezed,Object? threes = freezed,Object? fours = freezed,Object? fives = freezed,Object? sixes = freezed,Object? threeOfAKind = freezed,Object? fourOfAKind = freezed,Object? fullHouse = freezed,Object? smallStraight = freezed,Object? largeStraight = freezed,Object? yahtzee = freezed,Object? chance = freezed,Object? yahtzeeBonusCount = null,}) {
  return _then(_YahtzeeScorecard(
ones: freezed == ones ? _self.ones : ones // ignore: cast_nullable_to_non_nullable
as int?,twos: freezed == twos ? _self.twos : twos // ignore: cast_nullable_to_non_nullable
as int?,threes: freezed == threes ? _self.threes : threes // ignore: cast_nullable_to_non_nullable
as int?,fours: freezed == fours ? _self.fours : fours // ignore: cast_nullable_to_non_nullable
as int?,fives: freezed == fives ? _self.fives : fives // ignore: cast_nullable_to_non_nullable
as int?,sixes: freezed == sixes ? _self.sixes : sixes // ignore: cast_nullable_to_non_nullable
as int?,threeOfAKind: freezed == threeOfAKind ? _self.threeOfAKind : threeOfAKind // ignore: cast_nullable_to_non_nullable
as int?,fourOfAKind: freezed == fourOfAKind ? _self.fourOfAKind : fourOfAKind // ignore: cast_nullable_to_non_nullable
as int?,fullHouse: freezed == fullHouse ? _self.fullHouse : fullHouse // ignore: cast_nullable_to_non_nullable
as int?,smallStraight: freezed == smallStraight ? _self.smallStraight : smallStraight // ignore: cast_nullable_to_non_nullable
as int?,largeStraight: freezed == largeStraight ? _self.largeStraight : largeStraight // ignore: cast_nullable_to_non_nullable
as int?,yahtzee: freezed == yahtzee ? _self.yahtzee : yahtzee // ignore: cast_nullable_to_non_nullable
as int?,chance: freezed == chance ? _self.chance : chance // ignore: cast_nullable_to_non_nullable
as int?,yahtzeeBonusCount: null == yahtzeeBonusCount ? _self.yahtzeeBonusCount : yahtzeeBonusCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$YahtzeeState {

 int get currentPlayerIndex; int get currentRollNumber; List<int> get diceValues; List<bool> get diceHeld; Map<String, YahtzeeScorecard> get scorecards; List<String> get playerOrder; bool get gameOver; bool get useRealDice; String? get winnerId;
/// Create a copy of YahtzeeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YahtzeeStateCopyWith<YahtzeeState> get copyWith => _$YahtzeeStateCopyWithImpl<YahtzeeState>(this as YahtzeeState, _$identity);

  /// Serializes this YahtzeeState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YahtzeeState&&(identical(other.currentPlayerIndex, currentPlayerIndex) || other.currentPlayerIndex == currentPlayerIndex)&&(identical(other.currentRollNumber, currentRollNumber) || other.currentRollNumber == currentRollNumber)&&const DeepCollectionEquality().equals(other.diceValues, diceValues)&&const DeepCollectionEquality().equals(other.diceHeld, diceHeld)&&const DeepCollectionEquality().equals(other.scorecards, scorecards)&&const DeepCollectionEquality().equals(other.playerOrder, playerOrder)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.useRealDice, useRealDice) || other.useRealDice == useRealDice)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPlayerIndex,currentRollNumber,const DeepCollectionEquality().hash(diceValues),const DeepCollectionEquality().hash(diceHeld),const DeepCollectionEquality().hash(scorecards),const DeepCollectionEquality().hash(playerOrder),gameOver,useRealDice,winnerId);

@override
String toString() {
  return 'YahtzeeState(currentPlayerIndex: $currentPlayerIndex, currentRollNumber: $currentRollNumber, diceValues: $diceValues, diceHeld: $diceHeld, scorecards: $scorecards, playerOrder: $playerOrder, gameOver: $gameOver, useRealDice: $useRealDice, winnerId: $winnerId)';
}


}

/// @nodoc
abstract mixin class $YahtzeeStateCopyWith<$Res>  {
  factory $YahtzeeStateCopyWith(YahtzeeState value, $Res Function(YahtzeeState) _then) = _$YahtzeeStateCopyWithImpl;
@useResult
$Res call({
 int currentPlayerIndex, int currentRollNumber, List<int> diceValues, List<bool> diceHeld, Map<String, YahtzeeScorecard> scorecards, List<String> playerOrder, bool gameOver, bool useRealDice, String? winnerId
});




}
/// @nodoc
class _$YahtzeeStateCopyWithImpl<$Res>
    implements $YahtzeeStateCopyWith<$Res> {
  _$YahtzeeStateCopyWithImpl(this._self, this._then);

  final YahtzeeState _self;
  final $Res Function(YahtzeeState) _then;

/// Create a copy of YahtzeeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPlayerIndex = null,Object? currentRollNumber = null,Object? diceValues = null,Object? diceHeld = null,Object? scorecards = null,Object? playerOrder = null,Object? gameOver = null,Object? useRealDice = null,Object? winnerId = freezed,}) {
  return _then(_self.copyWith(
currentPlayerIndex: null == currentPlayerIndex ? _self.currentPlayerIndex : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
as int,currentRollNumber: null == currentRollNumber ? _self.currentRollNumber : currentRollNumber // ignore: cast_nullable_to_non_nullable
as int,diceValues: null == diceValues ? _self.diceValues : diceValues // ignore: cast_nullable_to_non_nullable
as List<int>,diceHeld: null == diceHeld ? _self.diceHeld : diceHeld // ignore: cast_nullable_to_non_nullable
as List<bool>,scorecards: null == scorecards ? _self.scorecards : scorecards // ignore: cast_nullable_to_non_nullable
as Map<String, YahtzeeScorecard>,playerOrder: null == playerOrder ? _self.playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,useRealDice: null == useRealDice ? _self.useRealDice : useRealDice // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [YahtzeeState].
extension YahtzeeStatePatterns on YahtzeeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YahtzeeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YahtzeeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YahtzeeState value)  $default,){
final _that = this;
switch (_that) {
case _YahtzeeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YahtzeeState value)?  $default,){
final _that = this;
switch (_that) {
case _YahtzeeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentPlayerIndex,  int currentRollNumber,  List<int> diceValues,  List<bool> diceHeld,  Map<String, YahtzeeScorecard> scorecards,  List<String> playerOrder,  bool gameOver,  bool useRealDice,  String? winnerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YahtzeeState() when $default != null:
return $default(_that.currentPlayerIndex,_that.currentRollNumber,_that.diceValues,_that.diceHeld,_that.scorecards,_that.playerOrder,_that.gameOver,_that.useRealDice,_that.winnerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentPlayerIndex,  int currentRollNumber,  List<int> diceValues,  List<bool> diceHeld,  Map<String, YahtzeeScorecard> scorecards,  List<String> playerOrder,  bool gameOver,  bool useRealDice,  String? winnerId)  $default,) {final _that = this;
switch (_that) {
case _YahtzeeState():
return $default(_that.currentPlayerIndex,_that.currentRollNumber,_that.diceValues,_that.diceHeld,_that.scorecards,_that.playerOrder,_that.gameOver,_that.useRealDice,_that.winnerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentPlayerIndex,  int currentRollNumber,  List<int> diceValues,  List<bool> diceHeld,  Map<String, YahtzeeScorecard> scorecards,  List<String> playerOrder,  bool gameOver,  bool useRealDice,  String? winnerId)?  $default,) {final _that = this;
switch (_that) {
case _YahtzeeState() when $default != null:
return $default(_that.currentPlayerIndex,_that.currentRollNumber,_that.diceValues,_that.diceHeld,_that.scorecards,_that.playerOrder,_that.gameOver,_that.useRealDice,_that.winnerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YahtzeeState extends YahtzeeState {
  const _YahtzeeState({required this.currentPlayerIndex, required this.currentRollNumber, required final  List<int> diceValues, required final  List<bool> diceHeld, required final  Map<String, YahtzeeScorecard> scorecards, required final  List<String> playerOrder, this.gameOver = false, this.useRealDice = false, this.winnerId}): _diceValues = diceValues,_diceHeld = diceHeld,_scorecards = scorecards,_playerOrder = playerOrder,super._();
  factory _YahtzeeState.fromJson(Map<String, dynamic> json) => _$YahtzeeStateFromJson(json);

@override final  int currentPlayerIndex;
@override final  int currentRollNumber;
 final  List<int> _diceValues;
@override List<int> get diceValues {
  if (_diceValues is EqualUnmodifiableListView) return _diceValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diceValues);
}

 final  List<bool> _diceHeld;
@override List<bool> get diceHeld {
  if (_diceHeld is EqualUnmodifiableListView) return _diceHeld;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diceHeld);
}

 final  Map<String, YahtzeeScorecard> _scorecards;
@override Map<String, YahtzeeScorecard> get scorecards {
  if (_scorecards is EqualUnmodifiableMapView) return _scorecards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_scorecards);
}

 final  List<String> _playerOrder;
@override List<String> get playerOrder {
  if (_playerOrder is EqualUnmodifiableListView) return _playerOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerOrder);
}

@override@JsonKey() final  bool gameOver;
@override@JsonKey() final  bool useRealDice;
@override final  String? winnerId;

/// Create a copy of YahtzeeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YahtzeeStateCopyWith<_YahtzeeState> get copyWith => __$YahtzeeStateCopyWithImpl<_YahtzeeState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YahtzeeStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YahtzeeState&&(identical(other.currentPlayerIndex, currentPlayerIndex) || other.currentPlayerIndex == currentPlayerIndex)&&(identical(other.currentRollNumber, currentRollNumber) || other.currentRollNumber == currentRollNumber)&&const DeepCollectionEquality().equals(other._diceValues, _diceValues)&&const DeepCollectionEquality().equals(other._diceHeld, _diceHeld)&&const DeepCollectionEquality().equals(other._scorecards, _scorecards)&&const DeepCollectionEquality().equals(other._playerOrder, _playerOrder)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.useRealDice, useRealDice) || other.useRealDice == useRealDice)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPlayerIndex,currentRollNumber,const DeepCollectionEquality().hash(_diceValues),const DeepCollectionEquality().hash(_diceHeld),const DeepCollectionEquality().hash(_scorecards),const DeepCollectionEquality().hash(_playerOrder),gameOver,useRealDice,winnerId);

@override
String toString() {
  return 'YahtzeeState(currentPlayerIndex: $currentPlayerIndex, currentRollNumber: $currentRollNumber, diceValues: $diceValues, diceHeld: $diceHeld, scorecards: $scorecards, playerOrder: $playerOrder, gameOver: $gameOver, useRealDice: $useRealDice, winnerId: $winnerId)';
}


}

/// @nodoc
abstract mixin class _$YahtzeeStateCopyWith<$Res> implements $YahtzeeStateCopyWith<$Res> {
  factory _$YahtzeeStateCopyWith(_YahtzeeState value, $Res Function(_YahtzeeState) _then) = __$YahtzeeStateCopyWithImpl;
@override @useResult
$Res call({
 int currentPlayerIndex, int currentRollNumber, List<int> diceValues, List<bool> diceHeld, Map<String, YahtzeeScorecard> scorecards, List<String> playerOrder, bool gameOver, bool useRealDice, String? winnerId
});




}
/// @nodoc
class __$YahtzeeStateCopyWithImpl<$Res>
    implements _$YahtzeeStateCopyWith<$Res> {
  __$YahtzeeStateCopyWithImpl(this._self, this._then);

  final _YahtzeeState _self;
  final $Res Function(_YahtzeeState) _then;

/// Create a copy of YahtzeeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPlayerIndex = null,Object? currentRollNumber = null,Object? diceValues = null,Object? diceHeld = null,Object? scorecards = null,Object? playerOrder = null,Object? gameOver = null,Object? useRealDice = null,Object? winnerId = freezed,}) {
  return _then(_YahtzeeState(
currentPlayerIndex: null == currentPlayerIndex ? _self.currentPlayerIndex : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
as int,currentRollNumber: null == currentRollNumber ? _self.currentRollNumber : currentRollNumber // ignore: cast_nullable_to_non_nullable
as int,diceValues: null == diceValues ? _self._diceValues : diceValues // ignore: cast_nullable_to_non_nullable
as List<int>,diceHeld: null == diceHeld ? _self._diceHeld : diceHeld // ignore: cast_nullable_to_non_nullable
as List<bool>,scorecards: null == scorecards ? _self._scorecards : scorecards // ignore: cast_nullable_to_non_nullable
as Map<String, YahtzeeScorecard>,playerOrder: null == playerOrder ? _self._playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,useRealDice: null == useRealDice ? _self.useRealDice : useRealDice // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
