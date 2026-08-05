// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'win_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WinResult {

 String get winnerId; String get winnerDisplayName; String get winDescription; List<LeaderboardEntry> get finalStandings;
/// Create a copy of WinResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WinResultCopyWith<WinResult> get copyWith => _$WinResultCopyWithImpl<WinResult>(this as WinResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WinResult&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.winnerDisplayName, winnerDisplayName) || other.winnerDisplayName == winnerDisplayName)&&(identical(other.winDescription, winDescription) || other.winDescription == winDescription)&&const DeepCollectionEquality().equals(other.finalStandings, finalStandings));
}


@override
int get hashCode => Object.hash(runtimeType,winnerId,winnerDisplayName,winDescription,const DeepCollectionEquality().hash(finalStandings));

@override
String toString() {
  return 'WinResult(winnerId: $winnerId, winnerDisplayName: $winnerDisplayName, winDescription: $winDescription, finalStandings: $finalStandings)';
}


}

/// @nodoc
abstract mixin class $WinResultCopyWith<$Res>  {
  factory $WinResultCopyWith(WinResult value, $Res Function(WinResult) _then) = _$WinResultCopyWithImpl;
@useResult
$Res call({
 String winnerId, String winnerDisplayName, String winDescription, List<LeaderboardEntry> finalStandings
});




}
/// @nodoc
class _$WinResultCopyWithImpl<$Res>
    implements $WinResultCopyWith<$Res> {
  _$WinResultCopyWithImpl(this._self, this._then);

  final WinResult _self;
  final $Res Function(WinResult) _then;

/// Create a copy of WinResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? winnerId = null,Object? winnerDisplayName = null,Object? winDescription = null,Object? finalStandings = null,}) {
  return _then(_self.copyWith(
winnerId: null == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String,winnerDisplayName: null == winnerDisplayName ? _self.winnerDisplayName : winnerDisplayName // ignore: cast_nullable_to_non_nullable
as String,winDescription: null == winDescription ? _self.winDescription : winDescription // ignore: cast_nullable_to_non_nullable
as String,finalStandings: null == finalStandings ? _self.finalStandings : finalStandings // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [WinResult].
extension WinResultPatterns on WinResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WinResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WinResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WinResult value)  $default,){
final _that = this;
switch (_that) {
case _WinResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WinResult value)?  $default,){
final _that = this;
switch (_that) {
case _WinResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String winnerId,  String winnerDisplayName,  String winDescription,  List<LeaderboardEntry> finalStandings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WinResult() when $default != null:
return $default(_that.winnerId,_that.winnerDisplayName,_that.winDescription,_that.finalStandings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String winnerId,  String winnerDisplayName,  String winDescription,  List<LeaderboardEntry> finalStandings)  $default,) {final _that = this;
switch (_that) {
case _WinResult():
return $default(_that.winnerId,_that.winnerDisplayName,_that.winDescription,_that.finalStandings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String winnerId,  String winnerDisplayName,  String winDescription,  List<LeaderboardEntry> finalStandings)?  $default,) {final _that = this;
switch (_that) {
case _WinResult() when $default != null:
return $default(_that.winnerId,_that.winnerDisplayName,_that.winDescription,_that.finalStandings);case _:
  return null;

}
}

}

/// @nodoc


class _WinResult implements WinResult {
  const _WinResult({required this.winnerId, required this.winnerDisplayName, required this.winDescription, required final  List<LeaderboardEntry> finalStandings}): _finalStandings = finalStandings;
  

@override final  String winnerId;
@override final  String winnerDisplayName;
@override final  String winDescription;
 final  List<LeaderboardEntry> _finalStandings;
@override List<LeaderboardEntry> get finalStandings {
  if (_finalStandings is EqualUnmodifiableListView) return _finalStandings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_finalStandings);
}


/// Create a copy of WinResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WinResultCopyWith<_WinResult> get copyWith => __$WinResultCopyWithImpl<_WinResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WinResult&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.winnerDisplayName, winnerDisplayName) || other.winnerDisplayName == winnerDisplayName)&&(identical(other.winDescription, winDescription) || other.winDescription == winDescription)&&const DeepCollectionEquality().equals(other._finalStandings, _finalStandings));
}


@override
int get hashCode => Object.hash(runtimeType,winnerId,winnerDisplayName,winDescription,const DeepCollectionEquality().hash(_finalStandings));

@override
String toString() {
  return 'WinResult(winnerId: $winnerId, winnerDisplayName: $winnerDisplayName, winDescription: $winDescription, finalStandings: $finalStandings)';
}


}

/// @nodoc
abstract mixin class _$WinResultCopyWith<$Res> implements $WinResultCopyWith<$Res> {
  factory _$WinResultCopyWith(_WinResult value, $Res Function(_WinResult) _then) = __$WinResultCopyWithImpl;
@override @useResult
$Res call({
 String winnerId, String winnerDisplayName, String winDescription, List<LeaderboardEntry> finalStandings
});




}
/// @nodoc
class __$WinResultCopyWithImpl<$Res>
    implements _$WinResultCopyWith<$Res> {
  __$WinResultCopyWithImpl(this._self, this._then);

  final _WinResult _self;
  final $Res Function(_WinResult) _then;

/// Create a copy of WinResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? winnerId = null,Object? winnerDisplayName = null,Object? winDescription = null,Object? finalStandings = null,}) {
  return _then(_WinResult(
winnerId: null == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String,winnerDisplayName: null == winnerDisplayName ? _self.winnerDisplayName : winnerDisplayName // ignore: cast_nullable_to_non_nullable
as String,winDescription: null == winDescription ? _self.winDescription : winDescription // ignore: cast_nullable_to_non_nullable
as String,finalStandings: null == finalStandings ? _self._finalStandings : finalStandings // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,
  ));
}


}

// dart format on
