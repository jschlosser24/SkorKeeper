// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scoring_layout_descriptor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScoringLayoutDescriptor {

 ScoringLayoutType get type; Map<String, dynamic> get config;
/// Create a copy of ScoringLayoutDescriptor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoringLayoutDescriptorCopyWith<ScoringLayoutDescriptor> get copyWith => _$ScoringLayoutDescriptorCopyWithImpl<ScoringLayoutDescriptor>(this as ScoringLayoutDescriptor, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoringLayoutDescriptor&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.config, config));
}


@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(config));

@override
String toString() {
  return 'ScoringLayoutDescriptor(type: $type, config: $config)';
}


}

/// @nodoc
abstract mixin class $ScoringLayoutDescriptorCopyWith<$Res>  {
  factory $ScoringLayoutDescriptorCopyWith(ScoringLayoutDescriptor value, $Res Function(ScoringLayoutDescriptor) _then) = _$ScoringLayoutDescriptorCopyWithImpl;
@useResult
$Res call({
 ScoringLayoutType type, Map<String, dynamic> config
});




}
/// @nodoc
class _$ScoringLayoutDescriptorCopyWithImpl<$Res>
    implements $ScoringLayoutDescriptorCopyWith<$Res> {
  _$ScoringLayoutDescriptorCopyWithImpl(this._self, this._then);

  final ScoringLayoutDescriptor _self;
  final $Res Function(ScoringLayoutDescriptor) _then;

/// Create a copy of ScoringLayoutDescriptor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? config = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ScoringLayoutType,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoringLayoutDescriptor].
extension ScoringLayoutDescriptorPatterns on ScoringLayoutDescriptor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoringLayoutDescriptor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoringLayoutDescriptor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoringLayoutDescriptor value)  $default,){
final _that = this;
switch (_that) {
case _ScoringLayoutDescriptor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoringLayoutDescriptor value)?  $default,){
final _that = this;
switch (_that) {
case _ScoringLayoutDescriptor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScoringLayoutType type,  Map<String, dynamic> config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoringLayoutDescriptor() when $default != null:
return $default(_that.type,_that.config);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScoringLayoutType type,  Map<String, dynamic> config)  $default,) {final _that = this;
switch (_that) {
case _ScoringLayoutDescriptor():
return $default(_that.type,_that.config);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScoringLayoutType type,  Map<String, dynamic> config)?  $default,) {final _that = this;
switch (_that) {
case _ScoringLayoutDescriptor() when $default != null:
return $default(_that.type,_that.config);case _:
  return null;

}
}

}

/// @nodoc


class _ScoringLayoutDescriptor implements ScoringLayoutDescriptor {
  const _ScoringLayoutDescriptor({required this.type, required final  Map<String, dynamic> config}): _config = config;
  

@override final  ScoringLayoutType type;
 final  Map<String, dynamic> _config;
@override Map<String, dynamic> get config {
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_config);
}


/// Create a copy of ScoringLayoutDescriptor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoringLayoutDescriptorCopyWith<_ScoringLayoutDescriptor> get copyWith => __$ScoringLayoutDescriptorCopyWithImpl<_ScoringLayoutDescriptor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoringLayoutDescriptor&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._config, _config));
}


@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_config));

@override
String toString() {
  return 'ScoringLayoutDescriptor(type: $type, config: $config)';
}


}

/// @nodoc
abstract mixin class _$ScoringLayoutDescriptorCopyWith<$Res> implements $ScoringLayoutDescriptorCopyWith<$Res> {
  factory _$ScoringLayoutDescriptorCopyWith(_ScoringLayoutDescriptor value, $Res Function(_ScoringLayoutDescriptor) _then) = __$ScoringLayoutDescriptorCopyWithImpl;
@override @useResult
$Res call({
 ScoringLayoutType type, Map<String, dynamic> config
});




}
/// @nodoc
class __$ScoringLayoutDescriptorCopyWithImpl<$Res>
    implements _$ScoringLayoutDescriptorCopyWith<$Res> {
  __$ScoringLayoutDescriptorCopyWithImpl(this._self, this._then);

  final _ScoringLayoutDescriptor _self;
  final $Res Function(_ScoringLayoutDescriptor) _then;

/// Create a copy of ScoringLayoutDescriptor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? config = null,}) {
  return _then(_ScoringLayoutDescriptor(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ScoringLayoutType,config: null == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
