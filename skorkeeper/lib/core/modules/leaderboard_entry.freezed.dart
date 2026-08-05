// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeaderboardEntry {

 String get playerId; String get displayName; String get colorHex; int get rank; String get scoreDisplay; int get sortKey; bool get isLeading;
/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith => _$LeaderboardEntryCopyWithImpl<LeaderboardEntry>(this as LeaderboardEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardEntry&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.scoreDisplay, scoreDisplay) || other.scoreDisplay == scoreDisplay)&&(identical(other.sortKey, sortKey) || other.sortKey == sortKey)&&(identical(other.isLeading, isLeading) || other.isLeading == isLeading));
}


@override
int get hashCode => Object.hash(runtimeType,playerId,displayName,colorHex,rank,scoreDisplay,sortKey,isLeading);

@override
String toString() {
  return 'LeaderboardEntry(playerId: $playerId, displayName: $displayName, colorHex: $colorHex, rank: $rank, scoreDisplay: $scoreDisplay, sortKey: $sortKey, isLeading: $isLeading)';
}


}

/// @nodoc
abstract mixin class $LeaderboardEntryCopyWith<$Res>  {
  factory $LeaderboardEntryCopyWith(LeaderboardEntry value, $Res Function(LeaderboardEntry) _then) = _$LeaderboardEntryCopyWithImpl;
@useResult
$Res call({
 String playerId, String displayName, String colorHex, int rank, String scoreDisplay, int sortKey, bool isLeading
});




}
/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final LeaderboardEntry _self;
  final $Res Function(LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? displayName = null,Object? colorHex = null,Object? rank = null,Object? scoreDisplay = null,Object? sortKey = null,Object? isLeading = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,scoreDisplay: null == scoreDisplay ? _self.scoreDisplay : scoreDisplay // ignore: cast_nullable_to_non_nullable
as String,sortKey: null == sortKey ? _self.sortKey : sortKey // ignore: cast_nullable_to_non_nullable
as int,isLeading: null == isLeading ? _self.isLeading : isLeading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardEntry].
extension LeaderboardEntryPatterns on LeaderboardEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardEntry value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardEntry value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String displayName,  String colorHex,  int rank,  String scoreDisplay,  int sortKey,  bool isLeading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
return $default(_that.playerId,_that.displayName,_that.colorHex,_that.rank,_that.scoreDisplay,_that.sortKey,_that.isLeading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String displayName,  String colorHex,  int rank,  String scoreDisplay,  int sortKey,  bool isLeading)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntry():
return $default(_that.playerId,_that.displayName,_that.colorHex,_that.rank,_that.scoreDisplay,_that.sortKey,_that.isLeading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String displayName,  String colorHex,  int rank,  String scoreDisplay,  int sortKey,  bool isLeading)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
return $default(_that.playerId,_that.displayName,_that.colorHex,_that.rank,_that.scoreDisplay,_that.sortKey,_that.isLeading);case _:
  return null;

}
}

}

/// @nodoc


class _LeaderboardEntry implements LeaderboardEntry {
  const _LeaderboardEntry({required this.playerId, required this.displayName, required this.colorHex, required this.rank, required this.scoreDisplay, required this.sortKey, required this.isLeading});
  

@override final  String playerId;
@override final  String displayName;
@override final  String colorHex;
@override final  int rank;
@override final  String scoreDisplay;
@override final  int sortKey;
@override final  bool isLeading;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardEntryCopyWith<_LeaderboardEntry> get copyWith => __$LeaderboardEntryCopyWithImpl<_LeaderboardEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardEntry&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.scoreDisplay, scoreDisplay) || other.scoreDisplay == scoreDisplay)&&(identical(other.sortKey, sortKey) || other.sortKey == sortKey)&&(identical(other.isLeading, isLeading) || other.isLeading == isLeading));
}


@override
int get hashCode => Object.hash(runtimeType,playerId,displayName,colorHex,rank,scoreDisplay,sortKey,isLeading);

@override
String toString() {
  return 'LeaderboardEntry(playerId: $playerId, displayName: $displayName, colorHex: $colorHex, rank: $rank, scoreDisplay: $scoreDisplay, sortKey: $sortKey, isLeading: $isLeading)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardEntryCopyWith<$Res> implements $LeaderboardEntryCopyWith<$Res> {
  factory _$LeaderboardEntryCopyWith(_LeaderboardEntry value, $Res Function(_LeaderboardEntry) _then) = __$LeaderboardEntryCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String displayName, String colorHex, int rank, String scoreDisplay, int sortKey, bool isLeading
});




}
/// @nodoc
class __$LeaderboardEntryCopyWithImpl<$Res>
    implements _$LeaderboardEntryCopyWith<$Res> {
  __$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final _LeaderboardEntry _self;
  final $Res Function(_LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? displayName = null,Object? colorHex = null,Object? rank = null,Object? scoreDisplay = null,Object? sortKey = null,Object? isLeading = null,}) {
  return _then(_LeaderboardEntry(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,scoreDisplay: null == scoreDisplay ? _self.scoreDisplay : scoreDisplay // ignore: cast_nullable_to_non_nullable
as String,sortKey: null == sortKey ? _self.sortKey : sortKey // ignore: cast_nullable_to_non_nullable
as int,isLeading: null == isLeading ? _self.isLeading : isLeading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
