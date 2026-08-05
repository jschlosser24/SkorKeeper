// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_validation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScoreValidationResult {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreValidationResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScoreValidationResult()';
}


}

/// @nodoc
class $ScoreValidationResultCopyWith<$Res>  {
$ScoreValidationResultCopyWith(ScoreValidationResult _, $Res Function(ScoreValidationResult) __);
}


/// Adds pattern-matching-related methods to [ScoreValidationResult].
extension ScoreValidationResultPatterns on ScoreValidationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ValidScore value)?  valid,TResult Function( InvalidScore value)?  invalid,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ValidScore() when valid != null:
return valid(_that);case InvalidScore() when invalid != null:
return invalid(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ValidScore value)  valid,required TResult Function( InvalidScore value)  invalid,}){
final _that = this;
switch (_that) {
case ValidScore():
return valid(_that);case InvalidScore():
return invalid(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ValidScore value)?  valid,TResult? Function( InvalidScore value)?  invalid,}){
final _that = this;
switch (_that) {
case ValidScore() when valid != null:
return valid(_that);case InvalidScore() when invalid != null:
return invalid(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  valid,TResult Function( String reason,  String shortCode)?  invalid,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ValidScore() when valid != null:
return valid();case InvalidScore() when invalid != null:
return invalid(_that.reason,_that.shortCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  valid,required TResult Function( String reason,  String shortCode)  invalid,}) {final _that = this;
switch (_that) {
case ValidScore():
return valid();case InvalidScore():
return invalid(_that.reason,_that.shortCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  valid,TResult? Function( String reason,  String shortCode)?  invalid,}) {final _that = this;
switch (_that) {
case ValidScore() when valid != null:
return valid();case InvalidScore() when invalid != null:
return invalid(_that.reason,_that.shortCode);case _:
  return null;

}
}

}

/// @nodoc


class ValidScore implements ScoreValidationResult {
  const ValidScore();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidScore);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScoreValidationResult.valid()';
}


}




/// @nodoc


class InvalidScore implements ScoreValidationResult {
  const InvalidScore({required this.reason, required this.shortCode});
  

 final  String reason;
 final  String shortCode;

/// Create a copy of ScoreValidationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvalidScoreCopyWith<InvalidScore> get copyWith => _$InvalidScoreCopyWithImpl<InvalidScore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidScore&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.shortCode, shortCode) || other.shortCode == shortCode));
}


@override
int get hashCode => Object.hash(runtimeType,reason,shortCode);

@override
String toString() {
  return 'ScoreValidationResult.invalid(reason: $reason, shortCode: $shortCode)';
}


}

/// @nodoc
abstract mixin class $InvalidScoreCopyWith<$Res> implements $ScoreValidationResultCopyWith<$Res> {
  factory $InvalidScoreCopyWith(InvalidScore value, $Res Function(InvalidScore) _then) = _$InvalidScoreCopyWithImpl;
@useResult
$Res call({
 String reason, String shortCode
});




}
/// @nodoc
class _$InvalidScoreCopyWithImpl<$Res>
    implements $InvalidScoreCopyWith<$Res> {
  _$InvalidScoreCopyWithImpl(this._self, this._then);

  final InvalidScore _self;
  final $Res Function(InvalidScore) _then;

/// Create a copy of ScoreValidationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? shortCode = null,}) {
  return _then(InvalidScore(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,shortCode: null == shortCode ? _self.shortCode : shortCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
