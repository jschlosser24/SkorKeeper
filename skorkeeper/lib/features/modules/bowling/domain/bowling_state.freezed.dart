// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bowling_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BowlingFrame {

 int get frame; List<int> get rolls; FrameType get frameType; int? get cumulativeScore;
/// Create a copy of BowlingFrame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BowlingFrameCopyWith<BowlingFrame> get copyWith => _$BowlingFrameCopyWithImpl<BowlingFrame>(this as BowlingFrame, _$identity);

  /// Serializes this BowlingFrame to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BowlingFrame&&(identical(other.frame, frame) || other.frame == frame)&&const DeepCollectionEquality().equals(other.rolls, rolls)&&(identical(other.frameType, frameType) || other.frameType == frameType)&&(identical(other.cumulativeScore, cumulativeScore) || other.cumulativeScore == cumulativeScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,frame,const DeepCollectionEquality().hash(rolls),frameType,cumulativeScore);

@override
String toString() {
  return 'BowlingFrame(frame: $frame, rolls: $rolls, frameType: $frameType, cumulativeScore: $cumulativeScore)';
}


}

/// @nodoc
abstract mixin class $BowlingFrameCopyWith<$Res>  {
  factory $BowlingFrameCopyWith(BowlingFrame value, $Res Function(BowlingFrame) _then) = _$BowlingFrameCopyWithImpl;
@useResult
$Res call({
 int frame, List<int> rolls, FrameType frameType, int? cumulativeScore
});




}
/// @nodoc
class _$BowlingFrameCopyWithImpl<$Res>
    implements $BowlingFrameCopyWith<$Res> {
  _$BowlingFrameCopyWithImpl(this._self, this._then);

  final BowlingFrame _self;
  final $Res Function(BowlingFrame) _then;

/// Create a copy of BowlingFrame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? frame = null,Object? rolls = null,Object? frameType = null,Object? cumulativeScore = freezed,}) {
  return _then(_self.copyWith(
frame: null == frame ? _self.frame : frame // ignore: cast_nullable_to_non_nullable
as int,rolls: null == rolls ? _self.rolls : rolls // ignore: cast_nullable_to_non_nullable
as List<int>,frameType: null == frameType ? _self.frameType : frameType // ignore: cast_nullable_to_non_nullable
as FrameType,cumulativeScore: freezed == cumulativeScore ? _self.cumulativeScore : cumulativeScore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BowlingFrame].
extension BowlingFramePatterns on BowlingFrame {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BowlingFrame value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BowlingFrame() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BowlingFrame value)  $default,){
final _that = this;
switch (_that) {
case _BowlingFrame():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BowlingFrame value)?  $default,){
final _that = this;
switch (_that) {
case _BowlingFrame() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int frame,  List<int> rolls,  FrameType frameType,  int? cumulativeScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BowlingFrame() when $default != null:
return $default(_that.frame,_that.rolls,_that.frameType,_that.cumulativeScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int frame,  List<int> rolls,  FrameType frameType,  int? cumulativeScore)  $default,) {final _that = this;
switch (_that) {
case _BowlingFrame():
return $default(_that.frame,_that.rolls,_that.frameType,_that.cumulativeScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int frame,  List<int> rolls,  FrameType frameType,  int? cumulativeScore)?  $default,) {final _that = this;
switch (_that) {
case _BowlingFrame() when $default != null:
return $default(_that.frame,_that.rolls,_that.frameType,_that.cumulativeScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BowlingFrame implements BowlingFrame {
  const _BowlingFrame({required this.frame, required final  List<int> rolls, required this.frameType, this.cumulativeScore}): _rolls = rolls;
  factory _BowlingFrame.fromJson(Map<String, dynamic> json) => _$BowlingFrameFromJson(json);

@override final  int frame;
 final  List<int> _rolls;
@override List<int> get rolls {
  if (_rolls is EqualUnmodifiableListView) return _rolls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rolls);
}

@override final  FrameType frameType;
@override final  int? cumulativeScore;

/// Create a copy of BowlingFrame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BowlingFrameCopyWith<_BowlingFrame> get copyWith => __$BowlingFrameCopyWithImpl<_BowlingFrame>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BowlingFrameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BowlingFrame&&(identical(other.frame, frame) || other.frame == frame)&&const DeepCollectionEquality().equals(other._rolls, _rolls)&&(identical(other.frameType, frameType) || other.frameType == frameType)&&(identical(other.cumulativeScore, cumulativeScore) || other.cumulativeScore == cumulativeScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,frame,const DeepCollectionEquality().hash(_rolls),frameType,cumulativeScore);

@override
String toString() {
  return 'BowlingFrame(frame: $frame, rolls: $rolls, frameType: $frameType, cumulativeScore: $cumulativeScore)';
}


}

/// @nodoc
abstract mixin class _$BowlingFrameCopyWith<$Res> implements $BowlingFrameCopyWith<$Res> {
  factory _$BowlingFrameCopyWith(_BowlingFrame value, $Res Function(_BowlingFrame) _then) = __$BowlingFrameCopyWithImpl;
@override @useResult
$Res call({
 int frame, List<int> rolls, FrameType frameType, int? cumulativeScore
});




}
/// @nodoc
class __$BowlingFrameCopyWithImpl<$Res>
    implements _$BowlingFrameCopyWith<$Res> {
  __$BowlingFrameCopyWithImpl(this._self, this._then);

  final _BowlingFrame _self;
  final $Res Function(_BowlingFrame) _then;

/// Create a copy of BowlingFrame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? frame = null,Object? rolls = null,Object? frameType = null,Object? cumulativeScore = freezed,}) {
  return _then(_BowlingFrame(
frame: null == frame ? _self.frame : frame // ignore: cast_nullable_to_non_nullable
as int,rolls: null == rolls ? _self._rolls : rolls // ignore: cast_nullable_to_non_nullable
as List<int>,frameType: null == frameType ? _self.frameType : frameType // ignore: cast_nullable_to_non_nullable
as FrameType,cumulativeScore: freezed == cumulativeScore ? _self.cumulativeScore : cumulativeScore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$BowlingState {

 int get currentPlayerIndex; int get currentFrame; Map<String, List<BowlingFrame>> get frames; List<String> get playerOrder;
/// Create a copy of BowlingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BowlingStateCopyWith<BowlingState> get copyWith => _$BowlingStateCopyWithImpl<BowlingState>(this as BowlingState, _$identity);

  /// Serializes this BowlingState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BowlingState&&(identical(other.currentPlayerIndex, currentPlayerIndex) || other.currentPlayerIndex == currentPlayerIndex)&&(identical(other.currentFrame, currentFrame) || other.currentFrame == currentFrame)&&const DeepCollectionEquality().equals(other.frames, frames)&&const DeepCollectionEquality().equals(other.playerOrder, playerOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPlayerIndex,currentFrame,const DeepCollectionEquality().hash(frames),const DeepCollectionEquality().hash(playerOrder));

@override
String toString() {
  return 'BowlingState(currentPlayerIndex: $currentPlayerIndex, currentFrame: $currentFrame, frames: $frames, playerOrder: $playerOrder)';
}


}

/// @nodoc
abstract mixin class $BowlingStateCopyWith<$Res>  {
  factory $BowlingStateCopyWith(BowlingState value, $Res Function(BowlingState) _then) = _$BowlingStateCopyWithImpl;
@useResult
$Res call({
 int currentPlayerIndex, int currentFrame, Map<String, List<BowlingFrame>> frames, List<String> playerOrder
});




}
/// @nodoc
class _$BowlingStateCopyWithImpl<$Res>
    implements $BowlingStateCopyWith<$Res> {
  _$BowlingStateCopyWithImpl(this._self, this._then);

  final BowlingState _self;
  final $Res Function(BowlingState) _then;

/// Create a copy of BowlingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPlayerIndex = null,Object? currentFrame = null,Object? frames = null,Object? playerOrder = null,}) {
  return _then(_self.copyWith(
currentPlayerIndex: null == currentPlayerIndex ? _self.currentPlayerIndex : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
as int,currentFrame: null == currentFrame ? _self.currentFrame : currentFrame // ignore: cast_nullable_to_non_nullable
as int,frames: null == frames ? _self.frames : frames // ignore: cast_nullable_to_non_nullable
as Map<String, List<BowlingFrame>>,playerOrder: null == playerOrder ? _self.playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BowlingState].
extension BowlingStatePatterns on BowlingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BowlingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BowlingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BowlingState value)  $default,){
final _that = this;
switch (_that) {
case _BowlingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BowlingState value)?  $default,){
final _that = this;
switch (_that) {
case _BowlingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentPlayerIndex,  int currentFrame,  Map<String, List<BowlingFrame>> frames,  List<String> playerOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BowlingState() when $default != null:
return $default(_that.currentPlayerIndex,_that.currentFrame,_that.frames,_that.playerOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentPlayerIndex,  int currentFrame,  Map<String, List<BowlingFrame>> frames,  List<String> playerOrder)  $default,) {final _that = this;
switch (_that) {
case _BowlingState():
return $default(_that.currentPlayerIndex,_that.currentFrame,_that.frames,_that.playerOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentPlayerIndex,  int currentFrame,  Map<String, List<BowlingFrame>> frames,  List<String> playerOrder)?  $default,) {final _that = this;
switch (_that) {
case _BowlingState() when $default != null:
return $default(_that.currentPlayerIndex,_that.currentFrame,_that.frames,_that.playerOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BowlingState extends BowlingState {
  const _BowlingState({required this.currentPlayerIndex, required this.currentFrame, required final  Map<String, List<BowlingFrame>> frames, required final  List<String> playerOrder}): _frames = frames,_playerOrder = playerOrder,super._();
  factory _BowlingState.fromJson(Map<String, dynamic> json) => _$BowlingStateFromJson(json);

@override final  int currentPlayerIndex;
@override final  int currentFrame;
 final  Map<String, List<BowlingFrame>> _frames;
@override Map<String, List<BowlingFrame>> get frames {
  if (_frames is EqualUnmodifiableMapView) return _frames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_frames);
}

 final  List<String> _playerOrder;
@override List<String> get playerOrder {
  if (_playerOrder is EqualUnmodifiableListView) return _playerOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerOrder);
}


/// Create a copy of BowlingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BowlingStateCopyWith<_BowlingState> get copyWith => __$BowlingStateCopyWithImpl<_BowlingState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BowlingStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BowlingState&&(identical(other.currentPlayerIndex, currentPlayerIndex) || other.currentPlayerIndex == currentPlayerIndex)&&(identical(other.currentFrame, currentFrame) || other.currentFrame == currentFrame)&&const DeepCollectionEquality().equals(other._frames, _frames)&&const DeepCollectionEquality().equals(other._playerOrder, _playerOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPlayerIndex,currentFrame,const DeepCollectionEquality().hash(_frames),const DeepCollectionEquality().hash(_playerOrder));

@override
String toString() {
  return 'BowlingState(currentPlayerIndex: $currentPlayerIndex, currentFrame: $currentFrame, frames: $frames, playerOrder: $playerOrder)';
}


}

/// @nodoc
abstract mixin class _$BowlingStateCopyWith<$Res> implements $BowlingStateCopyWith<$Res> {
  factory _$BowlingStateCopyWith(_BowlingState value, $Res Function(_BowlingState) _then) = __$BowlingStateCopyWithImpl;
@override @useResult
$Res call({
 int currentPlayerIndex, int currentFrame, Map<String, List<BowlingFrame>> frames, List<String> playerOrder
});




}
/// @nodoc
class __$BowlingStateCopyWithImpl<$Res>
    implements _$BowlingStateCopyWith<$Res> {
  __$BowlingStateCopyWithImpl(this._self, this._then);

  final _BowlingState _self;
  final $Res Function(_BowlingState) _then;

/// Create a copy of BowlingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPlayerIndex = null,Object? currentFrame = null,Object? frames = null,Object? playerOrder = null,}) {
  return _then(_BowlingState(
currentPlayerIndex: null == currentPlayerIndex ? _self.currentPlayerIndex : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
as int,currentFrame: null == currentFrame ? _self.currentFrame : currentFrame // ignore: cast_nullable_to_non_nullable
as int,frames: null == frames ? _self._frames : frames // ignore: cast_nullable_to_non_nullable
as Map<String, List<BowlingFrame>>,playerOrder: null == playerOrder ? _self._playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
