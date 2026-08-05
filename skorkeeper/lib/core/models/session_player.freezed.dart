// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionPlayer {

 String get id; String get displayName; String get colorHex; int get seatOrder;
/// Create a copy of SessionPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionPlayerCopyWith<SessionPlayer> get copyWith => _$SessionPlayerCopyWithImpl<SessionPlayer>(this as SessionPlayer, _$identity);

  /// Serializes this SessionPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.seatOrder, seatOrder) || other.seatOrder == seatOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,colorHex,seatOrder);

@override
String toString() {
  return 'SessionPlayer(id: $id, displayName: $displayName, colorHex: $colorHex, seatOrder: $seatOrder)';
}


}

/// @nodoc
abstract mixin class $SessionPlayerCopyWith<$Res>  {
  factory $SessionPlayerCopyWith(SessionPlayer value, $Res Function(SessionPlayer) _then) = _$SessionPlayerCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String colorHex, int seatOrder
});




}
/// @nodoc
class _$SessionPlayerCopyWithImpl<$Res>
    implements $SessionPlayerCopyWith<$Res> {
  _$SessionPlayerCopyWithImpl(this._self, this._then);

  final SessionPlayer _self;
  final $Res Function(SessionPlayer) _then;

/// Create a copy of SessionPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? colorHex = null,Object? seatOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,seatOrder: null == seatOrder ? _self.seatOrder : seatOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionPlayer].
extension SessionPlayerPatterns on SessionPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionPlayer value)  $default,){
final _that = this;
switch (_that) {
case _SessionPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _SessionPlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String colorHex,  int seatOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionPlayer() when $default != null:
return $default(_that.id,_that.displayName,_that.colorHex,_that.seatOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String colorHex,  int seatOrder)  $default,) {final _that = this;
switch (_that) {
case _SessionPlayer():
return $default(_that.id,_that.displayName,_that.colorHex,_that.seatOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String colorHex,  int seatOrder)?  $default,) {final _that = this;
switch (_that) {
case _SessionPlayer() when $default != null:
return $default(_that.id,_that.displayName,_that.colorHex,_that.seatOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionPlayer implements SessionPlayer {
  const _SessionPlayer({required this.id, required this.displayName, required this.colorHex, required this.seatOrder});
  factory _SessionPlayer.fromJson(Map<String, dynamic> json) => _$SessionPlayerFromJson(json);

@override final  String id;
@override final  String displayName;
@override final  String colorHex;
@override final  int seatOrder;

/// Create a copy of SessionPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionPlayerCopyWith<_SessionPlayer> get copyWith => __$SessionPlayerCopyWithImpl<_SessionPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.seatOrder, seatOrder) || other.seatOrder == seatOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,colorHex,seatOrder);

@override
String toString() {
  return 'SessionPlayer(id: $id, displayName: $displayName, colorHex: $colorHex, seatOrder: $seatOrder)';
}


}

/// @nodoc
abstract mixin class _$SessionPlayerCopyWith<$Res> implements $SessionPlayerCopyWith<$Res> {
  factory _$SessionPlayerCopyWith(_SessionPlayer value, $Res Function(_SessionPlayer) _then) = __$SessionPlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String colorHex, int seatOrder
});




}
/// @nodoc
class __$SessionPlayerCopyWithImpl<$Res>
    implements _$SessionPlayerCopyWith<$Res> {
  __$SessionPlayerCopyWithImpl(this._self, this._then);

  final _SessionPlayer _self;
  final $Res Function(_SessionPlayer) _then;

/// Create a copy of SessionPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? colorHex = null,Object? seatOrder = null,}) {
  return _then(_SessionPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,seatOrder: null == seatOrder ? _self.seatOrder : seatOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
