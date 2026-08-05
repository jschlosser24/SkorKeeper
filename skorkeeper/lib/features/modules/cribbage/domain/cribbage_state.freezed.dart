// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cribbage_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CribbagePegPosition {

 int get front; int get rear;
/// Create a copy of CribbagePegPosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CribbagePegPositionCopyWith<CribbagePegPosition> get copyWith => _$CribbagePegPositionCopyWithImpl<CribbagePegPosition>(this as CribbagePegPosition, _$identity);

  /// Serializes this CribbagePegPosition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CribbagePegPosition&&(identical(other.front, front) || other.front == front)&&(identical(other.rear, rear) || other.rear == rear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,front,rear);

@override
String toString() {
  return 'CribbagePegPosition(front: $front, rear: $rear)';
}


}

/// @nodoc
abstract mixin class $CribbagePegPositionCopyWith<$Res>  {
  factory $CribbagePegPositionCopyWith(CribbagePegPosition value, $Res Function(CribbagePegPosition) _then) = _$CribbagePegPositionCopyWithImpl;
@useResult
$Res call({
 int front, int rear
});




}
/// @nodoc
class _$CribbagePegPositionCopyWithImpl<$Res>
    implements $CribbagePegPositionCopyWith<$Res> {
  _$CribbagePegPositionCopyWithImpl(this._self, this._then);

  final CribbagePegPosition _self;
  final $Res Function(CribbagePegPosition) _then;

/// Create a copy of CribbagePegPosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? front = null,Object? rear = null,}) {
  return _then(_self.copyWith(
front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as int,rear: null == rear ? _self.rear : rear // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CribbagePegPosition].
extension CribbagePegPositionPatterns on CribbagePegPosition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CribbagePegPosition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CribbagePegPosition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CribbagePegPosition value)  $default,){
final _that = this;
switch (_that) {
case _CribbagePegPosition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CribbagePegPosition value)?  $default,){
final _that = this;
switch (_that) {
case _CribbagePegPosition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int front,  int rear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CribbagePegPosition() when $default != null:
return $default(_that.front,_that.rear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int front,  int rear)  $default,) {final _that = this;
switch (_that) {
case _CribbagePegPosition():
return $default(_that.front,_that.rear);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int front,  int rear)?  $default,) {final _that = this;
switch (_that) {
case _CribbagePegPosition() when $default != null:
return $default(_that.front,_that.rear);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CribbagePegPosition implements CribbagePegPosition {
  const _CribbagePegPosition({required this.front, required this.rear});
  factory _CribbagePegPosition.fromJson(Map<String, dynamic> json) => _$CribbagePegPositionFromJson(json);

@override final  int front;
@override final  int rear;

/// Create a copy of CribbagePegPosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CribbagePegPositionCopyWith<_CribbagePegPosition> get copyWith => __$CribbagePegPositionCopyWithImpl<_CribbagePegPosition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CribbagePegPositionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CribbagePegPosition&&(identical(other.front, front) || other.front == front)&&(identical(other.rear, rear) || other.rear == rear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,front,rear);

@override
String toString() {
  return 'CribbagePegPosition(front: $front, rear: $rear)';
}


}

/// @nodoc
abstract mixin class _$CribbagePegPositionCopyWith<$Res> implements $CribbagePegPositionCopyWith<$Res> {
  factory _$CribbagePegPositionCopyWith(_CribbagePegPosition value, $Res Function(_CribbagePegPosition) _then) = __$CribbagePegPositionCopyWithImpl;
@override @useResult
$Res call({
 int front, int rear
});




}
/// @nodoc
class __$CribbagePegPositionCopyWithImpl<$Res>
    implements _$CribbagePegPositionCopyWith<$Res> {
  __$CribbagePegPositionCopyWithImpl(this._self, this._then);

  final _CribbagePegPosition _self;
  final $Res Function(_CribbagePegPosition) _then;

/// Create a copy of CribbagePegPosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? front = null,Object? rear = null,}) {
  return _then(_CribbagePegPosition(
front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as int,rear: null == rear ? _self.rear : rear // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CribbageState {

 String get variant; String get dealerId; Map<String, CribbagePegPosition> get pegPositions; bool get gameOver; String? get winnerId; int get handNumber;
/// Create a copy of CribbageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CribbageStateCopyWith<CribbageState> get copyWith => _$CribbageStateCopyWithImpl<CribbageState>(this as CribbageState, _$identity);

  /// Serializes this CribbageState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CribbageState&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.dealerId, dealerId) || other.dealerId == dealerId)&&const DeepCollectionEquality().equals(other.pegPositions, pegPositions)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.handNumber, handNumber) || other.handNumber == handNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,variant,dealerId,const DeepCollectionEquality().hash(pegPositions),gameOver,winnerId,handNumber);

@override
String toString() {
  return 'CribbageState(variant: $variant, dealerId: $dealerId, pegPositions: $pegPositions, gameOver: $gameOver, winnerId: $winnerId, handNumber: $handNumber)';
}


}

/// @nodoc
abstract mixin class $CribbageStateCopyWith<$Res>  {
  factory $CribbageStateCopyWith(CribbageState value, $Res Function(CribbageState) _then) = _$CribbageStateCopyWithImpl;
@useResult
$Res call({
 String variant, String dealerId, Map<String, CribbagePegPosition> pegPositions, bool gameOver, String? winnerId, int handNumber
});




}
/// @nodoc
class _$CribbageStateCopyWithImpl<$Res>
    implements $CribbageStateCopyWith<$Res> {
  _$CribbageStateCopyWithImpl(this._self, this._then);

  final CribbageState _self;
  final $Res Function(CribbageState) _then;

/// Create a copy of CribbageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? variant = null,Object? dealerId = null,Object? pegPositions = null,Object? gameOver = null,Object? winnerId = freezed,Object? handNumber = null,}) {
  return _then(_self.copyWith(
variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String,dealerId: null == dealerId ? _self.dealerId : dealerId // ignore: cast_nullable_to_non_nullable
as String,pegPositions: null == pegPositions ? _self.pegPositions : pegPositions // ignore: cast_nullable_to_non_nullable
as Map<String, CribbagePegPosition>,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,handNumber: null == handNumber ? _self.handNumber : handNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CribbageState].
extension CribbageStatePatterns on CribbageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CribbageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CribbageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CribbageState value)  $default,){
final _that = this;
switch (_that) {
case _CribbageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CribbageState value)?  $default,){
final _that = this;
switch (_that) {
case _CribbageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String variant,  String dealerId,  Map<String, CribbagePegPosition> pegPositions,  bool gameOver,  String? winnerId,  int handNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CribbageState() when $default != null:
return $default(_that.variant,_that.dealerId,_that.pegPositions,_that.gameOver,_that.winnerId,_that.handNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String variant,  String dealerId,  Map<String, CribbagePegPosition> pegPositions,  bool gameOver,  String? winnerId,  int handNumber)  $default,) {final _that = this;
switch (_that) {
case _CribbageState():
return $default(_that.variant,_that.dealerId,_that.pegPositions,_that.gameOver,_that.winnerId,_that.handNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String variant,  String dealerId,  Map<String, CribbagePegPosition> pegPositions,  bool gameOver,  String? winnerId,  int handNumber)?  $default,) {final _that = this;
switch (_that) {
case _CribbageState() when $default != null:
return $default(_that.variant,_that.dealerId,_that.pegPositions,_that.gameOver,_that.winnerId,_that.handNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CribbageState extends CribbageState {
  const _CribbageState({required this.variant, required this.dealerId, required final  Map<String, CribbagePegPosition> pegPositions, required this.gameOver, this.winnerId, required this.handNumber}): _pegPositions = pegPositions,super._();
  factory _CribbageState.fromJson(Map<String, dynamic> json) => _$CribbageStateFromJson(json);

@override final  String variant;
@override final  String dealerId;
 final  Map<String, CribbagePegPosition> _pegPositions;
@override Map<String, CribbagePegPosition> get pegPositions {
  if (_pegPositions is EqualUnmodifiableMapView) return _pegPositions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pegPositions);
}

@override final  bool gameOver;
@override final  String? winnerId;
@override final  int handNumber;

/// Create a copy of CribbageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CribbageStateCopyWith<_CribbageState> get copyWith => __$CribbageStateCopyWithImpl<_CribbageState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CribbageStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CribbageState&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.dealerId, dealerId) || other.dealerId == dealerId)&&const DeepCollectionEquality().equals(other._pegPositions, _pegPositions)&&(identical(other.gameOver, gameOver) || other.gameOver == gameOver)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.handNumber, handNumber) || other.handNumber == handNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,variant,dealerId,const DeepCollectionEquality().hash(_pegPositions),gameOver,winnerId,handNumber);

@override
String toString() {
  return 'CribbageState(variant: $variant, dealerId: $dealerId, pegPositions: $pegPositions, gameOver: $gameOver, winnerId: $winnerId, handNumber: $handNumber)';
}


}

/// @nodoc
abstract mixin class _$CribbageStateCopyWith<$Res> implements $CribbageStateCopyWith<$Res> {
  factory _$CribbageStateCopyWith(_CribbageState value, $Res Function(_CribbageState) _then) = __$CribbageStateCopyWithImpl;
@override @useResult
$Res call({
 String variant, String dealerId, Map<String, CribbagePegPosition> pegPositions, bool gameOver, String? winnerId, int handNumber
});




}
/// @nodoc
class __$CribbageStateCopyWithImpl<$Res>
    implements _$CribbageStateCopyWith<$Res> {
  __$CribbageStateCopyWithImpl(this._self, this._then);

  final _CribbageState _self;
  final $Res Function(_CribbageState) _then;

/// Create a copy of CribbageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? variant = null,Object? dealerId = null,Object? pegPositions = null,Object? gameOver = null,Object? winnerId = freezed,Object? handNumber = null,}) {
  return _then(_CribbageState(
variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String,dealerId: null == dealerId ? _self.dealerId : dealerId // ignore: cast_nullable_to_non_nullable
as String,pegPositions: null == pegPositions ? _self._pegPositions : pegPositions // ignore: cast_nullable_to_non_nullable
as Map<String, CribbagePegPosition>,gameOver: null == gameOver ? _self.gameOver : gameOver // ignore: cast_nullable_to_non_nullable
as bool,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,handNumber: null == handNumber ? _self.handNumber : handNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
