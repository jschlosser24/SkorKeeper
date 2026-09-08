// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sports_entitlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SportsEntitlement {

/// True when the user owns the Sports Plan ($6.99 one-time IAP).
 bool get hasSportsPlan;/// True when the user owns Sports Pro ($19.99 one-time IAP).
 bool get hasSportsPro;
/// Create a copy of SportsEntitlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SportsEntitlementCopyWith<SportsEntitlement> get copyWith => _$SportsEntitlementCopyWithImpl<SportsEntitlement>(this as SportsEntitlement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SportsEntitlement&&(identical(other.hasSportsPlan, hasSportsPlan) || other.hasSportsPlan == hasSportsPlan)&&(identical(other.hasSportsPro, hasSportsPro) || other.hasSportsPro == hasSportsPro));
}


@override
int get hashCode => Object.hash(runtimeType,hasSportsPlan,hasSportsPro);

@override
String toString() {
  return 'SportsEntitlement(hasSportsPlan: $hasSportsPlan, hasSportsPro: $hasSportsPro)';
}


}

/// @nodoc
abstract mixin class $SportsEntitlementCopyWith<$Res>  {
  factory $SportsEntitlementCopyWith(SportsEntitlement value, $Res Function(SportsEntitlement) _then) = _$SportsEntitlementCopyWithImpl;
@useResult
$Res call({
 bool hasSportsPlan, bool hasSportsPro
});




}
/// @nodoc
class _$SportsEntitlementCopyWithImpl<$Res>
    implements $SportsEntitlementCopyWith<$Res> {
  _$SportsEntitlementCopyWithImpl(this._self, this._then);

  final SportsEntitlement _self;
  final $Res Function(SportsEntitlement) _then;

/// Create a copy of SportsEntitlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasSportsPlan = null,Object? hasSportsPro = null,}) {
  return _then(_self.copyWith(
hasSportsPlan: null == hasSportsPlan ? _self.hasSportsPlan : hasSportsPlan // ignore: cast_nullable_to_non_nullable
as bool,hasSportsPro: null == hasSportsPro ? _self.hasSportsPro : hasSportsPro // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SportsEntitlement].
extension SportsEntitlementPatterns on SportsEntitlement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SportsEntitlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SportsEntitlement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SportsEntitlement value)  $default,){
final _that = this;
switch (_that) {
case _SportsEntitlement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SportsEntitlement value)?  $default,){
final _that = this;
switch (_that) {
case _SportsEntitlement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasSportsPlan,  bool hasSportsPro)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SportsEntitlement() when $default != null:
return $default(_that.hasSportsPlan,_that.hasSportsPro);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasSportsPlan,  bool hasSportsPro)  $default,) {final _that = this;
switch (_that) {
case _SportsEntitlement():
return $default(_that.hasSportsPlan,_that.hasSportsPro);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasSportsPlan,  bool hasSportsPro)?  $default,) {final _that = this;
switch (_that) {
case _SportsEntitlement() when $default != null:
return $default(_that.hasSportsPlan,_that.hasSportsPro);case _:
  return null;

}
}

}

/// @nodoc


class _SportsEntitlement extends SportsEntitlement {
  const _SportsEntitlement({this.hasSportsPlan = false, this.hasSportsPro = false}): super._();
  

/// True when the user owns the Sports Plan ($6.99 one-time IAP).
@override@JsonKey() final  bool hasSportsPlan;
/// True when the user owns Sports Pro ($19.99 one-time IAP).
@override@JsonKey() final  bool hasSportsPro;

/// Create a copy of SportsEntitlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SportsEntitlementCopyWith<_SportsEntitlement> get copyWith => __$SportsEntitlementCopyWithImpl<_SportsEntitlement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SportsEntitlement&&(identical(other.hasSportsPlan, hasSportsPlan) || other.hasSportsPlan == hasSportsPlan)&&(identical(other.hasSportsPro, hasSportsPro) || other.hasSportsPro == hasSportsPro));
}


@override
int get hashCode => Object.hash(runtimeType,hasSportsPlan,hasSportsPro);

@override
String toString() {
  return 'SportsEntitlement(hasSportsPlan: $hasSportsPlan, hasSportsPro: $hasSportsPro)';
}


}

/// @nodoc
abstract mixin class _$SportsEntitlementCopyWith<$Res> implements $SportsEntitlementCopyWith<$Res> {
  factory _$SportsEntitlementCopyWith(_SportsEntitlement value, $Res Function(_SportsEntitlement) _then) = __$SportsEntitlementCopyWithImpl;
@override @useResult
$Res call({
 bool hasSportsPlan, bool hasSportsPro
});




}
/// @nodoc
class __$SportsEntitlementCopyWithImpl<$Res>
    implements _$SportsEntitlementCopyWith<$Res> {
  __$SportsEntitlementCopyWithImpl(this._self, this._then);

  final _SportsEntitlement _self;
  final $Res Function(_SportsEntitlement) _then;

/// Create a copy of SportsEntitlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasSportsPlan = null,Object? hasSportsPro = null,}) {
  return _then(_SportsEntitlement(
hasSportsPlan: null == hasSportsPlan ? _self.hasSportsPlan : hasSportsPlan // ignore: cast_nullable_to_non_nullable
as bool,hasSportsPro: null == hasSportsPro ? _self.hasSportsPro : hasSportsPro // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
