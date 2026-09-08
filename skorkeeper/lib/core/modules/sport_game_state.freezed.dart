// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sport_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SportPlayer {

/// UUID generated at setup.
 String get id; String get name;/// Optional jersey number string (1–3 digits).
 String? get number;/// Per-player sport-specific stats keyed by stat name.
///
/// Basketball: {points, rebounds, assists, steals, blocks, fouls}
/// Football:   {passingYards, rushingYards, receivingYards, touchdowns}
/// Soccer:     {goals, assists}
/// Tennis:     {aces, doubleFaults, winners}
/// Volleyball: {kills, blocks, aces}
/// Hockey:     {goals, assists, penaltyMinutes}
/// Lacrosse:   {goals, groundBalls, clears}
 Map<String, dynamic> get stats;
/// Create a copy of SportPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SportPlayerCopyWith<SportPlayer> get copyWith => _$SportPlayerCopyWithImpl<SportPlayer>(this as SportPlayer, _$identity);

  /// Serializes this SportPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SportPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.number, number) || other.number == number)&&const DeepCollectionEquality().equals(other.stats, stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,number,const DeepCollectionEquality().hash(stats));

@override
String toString() {
  return 'SportPlayer(id: $id, name: $name, number: $number, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $SportPlayerCopyWith<$Res>  {
  factory $SportPlayerCopyWith(SportPlayer value, $Res Function(SportPlayer) _then) = _$SportPlayerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? number, Map<String, dynamic> stats
});




}
/// @nodoc
class _$SportPlayerCopyWithImpl<$Res>
    implements $SportPlayerCopyWith<$Res> {
  _$SportPlayerCopyWithImpl(this._self, this._then);

  final SportPlayer _self;
  final $Res Function(SportPlayer) _then;

/// Create a copy of SportPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? number = freezed,Object? stats = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [SportPlayer].
extension SportPlayerPatterns on SportPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SportPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SportPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SportPlayer value)  $default,){
final _that = this;
switch (_that) {
case _SportPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SportPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _SportPlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? number,  Map<String, dynamic> stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SportPlayer() when $default != null:
return $default(_that.id,_that.name,_that.number,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? number,  Map<String, dynamic> stats)  $default,) {final _that = this;
switch (_that) {
case _SportPlayer():
return $default(_that.id,_that.name,_that.number,_that.stats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? number,  Map<String, dynamic> stats)?  $default,) {final _that = this;
switch (_that) {
case _SportPlayer() when $default != null:
return $default(_that.id,_that.name,_that.number,_that.stats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SportPlayer implements SportPlayer {
  const _SportPlayer({required this.id, required this.name, this.number, final  Map<String, dynamic> stats = const <String, dynamic>{}}): _stats = stats;
  factory _SportPlayer.fromJson(Map<String, dynamic> json) => _$SportPlayerFromJson(json);

/// UUID generated at setup.
@override final  String id;
@override final  String name;
/// Optional jersey number string (1–3 digits).
@override final  String? number;
/// Per-player sport-specific stats keyed by stat name.
///
/// Basketball: {points, rebounds, assists, steals, blocks, fouls}
/// Football:   {passingYards, rushingYards, receivingYards, touchdowns}
/// Soccer:     {goals, assists}
/// Tennis:     {aces, doubleFaults, winners}
/// Volleyball: {kills, blocks, aces}
/// Hockey:     {goals, assists, penaltyMinutes}
/// Lacrosse:   {goals, groundBalls, clears}
 final  Map<String, dynamic> _stats;
/// Per-player sport-specific stats keyed by stat name.
///
/// Basketball: {points, rebounds, assists, steals, blocks, fouls}
/// Football:   {passingYards, rushingYards, receivingYards, touchdowns}
/// Soccer:     {goals, assists}
/// Tennis:     {aces, doubleFaults, winners}
/// Volleyball: {kills, blocks, aces}
/// Hockey:     {goals, assists, penaltyMinutes}
/// Lacrosse:   {goals, groundBalls, clears}
@override@JsonKey() Map<String, dynamic> get stats {
  if (_stats is EqualUnmodifiableMapView) return _stats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stats);
}


/// Create a copy of SportPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SportPlayerCopyWith<_SportPlayer> get copyWith => __$SportPlayerCopyWithImpl<_SportPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SportPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SportPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.number, number) || other.number == number)&&const DeepCollectionEquality().equals(other._stats, _stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,number,const DeepCollectionEquality().hash(_stats));

@override
String toString() {
  return 'SportPlayer(id: $id, name: $name, number: $number, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$SportPlayerCopyWith<$Res> implements $SportPlayerCopyWith<$Res> {
  factory _$SportPlayerCopyWith(_SportPlayer value, $Res Function(_SportPlayer) _then) = __$SportPlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? number, Map<String, dynamic> stats
});




}
/// @nodoc
class __$SportPlayerCopyWithImpl<$Res>
    implements _$SportPlayerCopyWith<$Res> {
  __$SportPlayerCopyWithImpl(this._self, this._then);

  final _SportPlayer _self;
  final $Res Function(_SportPlayer) _then;

/// Create a copy of SportPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? number = freezed,Object? stats = null,}) {
  return _then(_SportPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self._stats : stats // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$SportTeam {

/// 'home' or 'away'
 String get id;/// User-entered team name (1–40 characters).
 String get name;/// Current accumulated game score.
 int get score;/// Player roster — null in basic mode; populated in in-depth mode.
 List<SportPlayer>? get roster;/// Aggregated sport-specific team stats.
///
/// Baseball:   {hits, errors, strikeouts, walks, earnedRuns, atBats,
///              inningScores: []}
/// Basketball: {fieldGoalsMade, fieldGoalsAttempted, threesMade,
///              threesAttempted, ftMade, ftAttempted, quarterScores: []}
/// Football:   {totalYards, touchdowns, firstDowns, fieldGoals, safeties,
///              quarterScores: []}
/// Soccer:     {goals, halfScores: [], possessionSeconds}
/// Tennis:     {setsWon, totalGamesWon, setScores: []}
/// Volleyball: {setsWon, totalPoints, setScores: []}
/// Hockey:     {goals, assists, penaltyMinutes, periodScores: [],
///              shotsOnGoal}
/// Lacrosse:   {goals, assists, groundBalls, clearsSuccessful,
///              clearsFailed, quarterScores: []}
 Map<String, dynamic> get stats;
/// Create a copy of SportTeam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SportTeamCopyWith<SportTeam> get copyWith => _$SportTeamCopyWithImpl<SportTeam>(this as SportTeam, _$identity);

  /// Serializes this SportTeam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SportTeam&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other.roster, roster)&&const DeepCollectionEquality().equals(other.stats, stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,score,const DeepCollectionEquality().hash(roster),const DeepCollectionEquality().hash(stats));

@override
String toString() {
  return 'SportTeam(id: $id, name: $name, score: $score, roster: $roster, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $SportTeamCopyWith<$Res>  {
  factory $SportTeamCopyWith(SportTeam value, $Res Function(SportTeam) _then) = _$SportTeamCopyWithImpl;
@useResult
$Res call({
 String id, String name, int score, List<SportPlayer>? roster, Map<String, dynamic> stats
});




}
/// @nodoc
class _$SportTeamCopyWithImpl<$Res>
    implements $SportTeamCopyWith<$Res> {
  _$SportTeamCopyWithImpl(this._self, this._then);

  final SportTeam _self;
  final $Res Function(SportTeam) _then;

/// Create a copy of SportTeam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? score = null,Object? roster = freezed,Object? stats = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,roster: freezed == roster ? _self.roster : roster // ignore: cast_nullable_to_non_nullable
as List<SportPlayer>?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [SportTeam].
extension SportTeamPatterns on SportTeam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SportTeam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SportTeam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SportTeam value)  $default,){
final _that = this;
switch (_that) {
case _SportTeam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SportTeam value)?  $default,){
final _that = this;
switch (_that) {
case _SportTeam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int score,  List<SportPlayer>? roster,  Map<String, dynamic> stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SportTeam() when $default != null:
return $default(_that.id,_that.name,_that.score,_that.roster,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int score,  List<SportPlayer>? roster,  Map<String, dynamic> stats)  $default,) {final _that = this;
switch (_that) {
case _SportTeam():
return $default(_that.id,_that.name,_that.score,_that.roster,_that.stats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int score,  List<SportPlayer>? roster,  Map<String, dynamic> stats)?  $default,) {final _that = this;
switch (_that) {
case _SportTeam() when $default != null:
return $default(_that.id,_that.name,_that.score,_that.roster,_that.stats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SportTeam implements SportTeam {
  const _SportTeam({required this.id, required this.name, this.score = 0, final  List<SportPlayer>? roster, final  Map<String, dynamic> stats = const <String, dynamic>{}}): _roster = roster,_stats = stats;
  factory _SportTeam.fromJson(Map<String, dynamic> json) => _$SportTeamFromJson(json);

/// 'home' or 'away'
@override final  String id;
/// User-entered team name (1–40 characters).
@override final  String name;
/// Current accumulated game score.
@override@JsonKey() final  int score;
/// Player roster — null in basic mode; populated in in-depth mode.
 final  List<SportPlayer>? _roster;
/// Player roster — null in basic mode; populated in in-depth mode.
@override List<SportPlayer>? get roster {
  final value = _roster;
  if (value == null) return null;
  if (_roster is EqualUnmodifiableListView) return _roster;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Aggregated sport-specific team stats.
///
/// Baseball:   {hits, errors, strikeouts, walks, earnedRuns, atBats,
///              inningScores: []}
/// Basketball: {fieldGoalsMade, fieldGoalsAttempted, threesMade,
///              threesAttempted, ftMade, ftAttempted, quarterScores: []}
/// Football:   {totalYards, touchdowns, firstDowns, fieldGoals, safeties,
///              quarterScores: []}
/// Soccer:     {goals, halfScores: [], possessionSeconds}
/// Tennis:     {setsWon, totalGamesWon, setScores: []}
/// Volleyball: {setsWon, totalPoints, setScores: []}
/// Hockey:     {goals, assists, penaltyMinutes, periodScores: [],
///              shotsOnGoal}
/// Lacrosse:   {goals, assists, groundBalls, clearsSuccessful,
///              clearsFailed, quarterScores: []}
 final  Map<String, dynamic> _stats;
/// Aggregated sport-specific team stats.
///
/// Baseball:   {hits, errors, strikeouts, walks, earnedRuns, atBats,
///              inningScores: []}
/// Basketball: {fieldGoalsMade, fieldGoalsAttempted, threesMade,
///              threesAttempted, ftMade, ftAttempted, quarterScores: []}
/// Football:   {totalYards, touchdowns, firstDowns, fieldGoals, safeties,
///              quarterScores: []}
/// Soccer:     {goals, halfScores: [], possessionSeconds}
/// Tennis:     {setsWon, totalGamesWon, setScores: []}
/// Volleyball: {setsWon, totalPoints, setScores: []}
/// Hockey:     {goals, assists, penaltyMinutes, periodScores: [],
///              shotsOnGoal}
/// Lacrosse:   {goals, assists, groundBalls, clearsSuccessful,
///              clearsFailed, quarterScores: []}
@override@JsonKey() Map<String, dynamic> get stats {
  if (_stats is EqualUnmodifiableMapView) return _stats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stats);
}


/// Create a copy of SportTeam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SportTeamCopyWith<_SportTeam> get copyWith => __$SportTeamCopyWithImpl<_SportTeam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SportTeamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SportTeam&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other._roster, _roster)&&const DeepCollectionEquality().equals(other._stats, _stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,score,const DeepCollectionEquality().hash(_roster),const DeepCollectionEquality().hash(_stats));

@override
String toString() {
  return 'SportTeam(id: $id, name: $name, score: $score, roster: $roster, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$SportTeamCopyWith<$Res> implements $SportTeamCopyWith<$Res> {
  factory _$SportTeamCopyWith(_SportTeam value, $Res Function(_SportTeam) _then) = __$SportTeamCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int score, List<SportPlayer>? roster, Map<String, dynamic> stats
});




}
/// @nodoc
class __$SportTeamCopyWithImpl<$Res>
    implements _$SportTeamCopyWith<$Res> {
  __$SportTeamCopyWithImpl(this._self, this._then);

  final _SportTeam _self;
  final $Res Function(_SportTeam) _then;

/// Create a copy of SportTeam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? score = null,Object? roster = freezed,Object? stats = null,}) {
  return _then(_SportTeam(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,roster: freezed == roster ? _self._roster : roster // ignore: cast_nullable_to_non_nullable
as List<SportPlayer>?,stats: null == stats ? _self._stats : stats // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$SportEvent {

/// Unique identifier — '{sportType}_{wallClockMs}' or UUID.
 String get id;/// Elapsed game time in seconds when this event was recorded.
 int get gameTimeSeconds;/// Device wall-clock time (ms since epoch) for timeline ordering.
 int get wallClockMs;/// Sport-specific event type string.
///
/// Baseball:   run | out | hit | strikeout | ball | strike | error | walk
/// Basketball: 2pt | 3pt | ft_made | ft_missed | rebound | foul | turnover
/// Football:   touchdown | extra_point | two_point_conv | field_goal |
///             safety | down_advance
/// Soccer:     goal | possession_toggle | half_start | half_end
/// Tennis:     point_won | game_won | set_won | tiebreak_point
/// Volleyball: point_won | set_won | serving_change
/// Hockey:     goal | primary_assist | secondary_assist | penalty_start |
///             penalty_end | period_end
/// Lacrosse:   goal | ground_ball | clear_success | clear_fail
 String get eventType;/// 'home' or 'away'
 String get teamId;/// Null in basic mode.
 String? get playerId;/// Score change caused by this event (0 for non-scoring events).
 int get pointsDelta;/// Event-specific supplemental data.
///
/// goal (Soccer/Hockey): {assistPlayerId?, assistPlayerName?, period}
/// penalty_start (Hockey): {type, durationMinutes, playerId}
/// primary/secondary_assist (Hockey): {goalEventId}
/// possession_toggle (Soccer): {newPossessingTeam: 'home'|'away'}
 Map<String, dynamic>? get metadata;
/// Create a copy of SportEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SportEventCopyWith<SportEvent> get copyWith => _$SportEventCopyWithImpl<SportEvent>(this as SportEvent, _$identity);

  /// Serializes this SportEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SportEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.gameTimeSeconds, gameTimeSeconds) || other.gameTimeSeconds == gameTimeSeconds)&&(identical(other.wallClockMs, wallClockMs) || other.wallClockMs == wallClockMs)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.pointsDelta, pointsDelta) || other.pointsDelta == pointsDelta)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameTimeSeconds,wallClockMs,eventType,teamId,playerId,pointsDelta,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'SportEvent(id: $id, gameTimeSeconds: $gameTimeSeconds, wallClockMs: $wallClockMs, eventType: $eventType, teamId: $teamId, playerId: $playerId, pointsDelta: $pointsDelta, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $SportEventCopyWith<$Res>  {
  factory $SportEventCopyWith(SportEvent value, $Res Function(SportEvent) _then) = _$SportEventCopyWithImpl;
@useResult
$Res call({
 String id, int gameTimeSeconds, int wallClockMs, String eventType, String teamId, String? playerId, int pointsDelta, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$SportEventCopyWithImpl<$Res>
    implements $SportEventCopyWith<$Res> {
  _$SportEventCopyWithImpl(this._self, this._then);

  final SportEvent _self;
  final $Res Function(SportEvent) _then;

/// Create a copy of SportEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gameTimeSeconds = null,Object? wallClockMs = null,Object? eventType = null,Object? teamId = null,Object? playerId = freezed,Object? pointsDelta = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameTimeSeconds: null == gameTimeSeconds ? _self.gameTimeSeconds : gameTimeSeconds // ignore: cast_nullable_to_non_nullable
as int,wallClockMs: null == wallClockMs ? _self.wallClockMs : wallClockMs // ignore: cast_nullable_to_non_nullable
as int,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,playerId: freezed == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String?,pointsDelta: null == pointsDelta ? _self.pointsDelta : pointsDelta // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SportEvent].
extension SportEventPatterns on SportEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SportEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SportEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SportEvent value)  $default,){
final _that = this;
switch (_that) {
case _SportEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SportEvent value)?  $default,){
final _that = this;
switch (_that) {
case _SportEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int gameTimeSeconds,  int wallClockMs,  String eventType,  String teamId,  String? playerId,  int pointsDelta,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SportEvent() when $default != null:
return $default(_that.id,_that.gameTimeSeconds,_that.wallClockMs,_that.eventType,_that.teamId,_that.playerId,_that.pointsDelta,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int gameTimeSeconds,  int wallClockMs,  String eventType,  String teamId,  String? playerId,  int pointsDelta,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _SportEvent():
return $default(_that.id,_that.gameTimeSeconds,_that.wallClockMs,_that.eventType,_that.teamId,_that.playerId,_that.pointsDelta,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int gameTimeSeconds,  int wallClockMs,  String eventType,  String teamId,  String? playerId,  int pointsDelta,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _SportEvent() when $default != null:
return $default(_that.id,_that.gameTimeSeconds,_that.wallClockMs,_that.eventType,_that.teamId,_that.playerId,_that.pointsDelta,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SportEvent implements SportEvent {
  const _SportEvent({required this.id, required this.gameTimeSeconds, required this.wallClockMs, required this.eventType, required this.teamId, this.playerId, this.pointsDelta = 0, final  Map<String, dynamic>? metadata}): _metadata = metadata;
  factory _SportEvent.fromJson(Map<String, dynamic> json) => _$SportEventFromJson(json);

/// Unique identifier — '{sportType}_{wallClockMs}' or UUID.
@override final  String id;
/// Elapsed game time in seconds when this event was recorded.
@override final  int gameTimeSeconds;
/// Device wall-clock time (ms since epoch) for timeline ordering.
@override final  int wallClockMs;
/// Sport-specific event type string.
///
/// Baseball:   run | out | hit | strikeout | ball | strike | error | walk
/// Basketball: 2pt | 3pt | ft_made | ft_missed | rebound | foul | turnover
/// Football:   touchdown | extra_point | two_point_conv | field_goal |
///             safety | down_advance
/// Soccer:     goal | possession_toggle | half_start | half_end
/// Tennis:     point_won | game_won | set_won | tiebreak_point
/// Volleyball: point_won | set_won | serving_change
/// Hockey:     goal | primary_assist | secondary_assist | penalty_start |
///             penalty_end | period_end
/// Lacrosse:   goal | ground_ball | clear_success | clear_fail
@override final  String eventType;
/// 'home' or 'away'
@override final  String teamId;
/// Null in basic mode.
@override final  String? playerId;
/// Score change caused by this event (0 for non-scoring events).
@override@JsonKey() final  int pointsDelta;
/// Event-specific supplemental data.
///
/// goal (Soccer/Hockey): {assistPlayerId?, assistPlayerName?, period}
/// penalty_start (Hockey): {type, durationMinutes, playerId}
/// primary/secondary_assist (Hockey): {goalEventId}
/// possession_toggle (Soccer): {newPossessingTeam: 'home'|'away'}
 final  Map<String, dynamic>? _metadata;
/// Event-specific supplemental data.
///
/// goal (Soccer/Hockey): {assistPlayerId?, assistPlayerName?, period}
/// penalty_start (Hockey): {type, durationMinutes, playerId}
/// primary/secondary_assist (Hockey): {goalEventId}
/// possession_toggle (Soccer): {newPossessingTeam: 'home'|'away'}
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SportEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SportEventCopyWith<_SportEvent> get copyWith => __$SportEventCopyWithImpl<_SportEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SportEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SportEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.gameTimeSeconds, gameTimeSeconds) || other.gameTimeSeconds == gameTimeSeconds)&&(identical(other.wallClockMs, wallClockMs) || other.wallClockMs == wallClockMs)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.pointsDelta, pointsDelta) || other.pointsDelta == pointsDelta)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameTimeSeconds,wallClockMs,eventType,teamId,playerId,pointsDelta,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'SportEvent(id: $id, gameTimeSeconds: $gameTimeSeconds, wallClockMs: $wallClockMs, eventType: $eventType, teamId: $teamId, playerId: $playerId, pointsDelta: $pointsDelta, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$SportEventCopyWith<$Res> implements $SportEventCopyWith<$Res> {
  factory _$SportEventCopyWith(_SportEvent value, $Res Function(_SportEvent) _then) = __$SportEventCopyWithImpl;
@override @useResult
$Res call({
 String id, int gameTimeSeconds, int wallClockMs, String eventType, String teamId, String? playerId, int pointsDelta, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$SportEventCopyWithImpl<$Res>
    implements _$SportEventCopyWith<$Res> {
  __$SportEventCopyWithImpl(this._self, this._then);

  final _SportEvent _self;
  final $Res Function(_SportEvent) _then;

/// Create a copy of SportEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gameTimeSeconds = null,Object? wallClockMs = null,Object? eventType = null,Object? teamId = null,Object? playerId = freezed,Object? pointsDelta = null,Object? metadata = freezed,}) {
  return _then(_SportEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameTimeSeconds: null == gameTimeSeconds ? _self.gameTimeSeconds : gameTimeSeconds // ignore: cast_nullable_to_non_nullable
as int,wallClockMs: null == wallClockMs ? _self.wallClockMs : wallClockMs // ignore: cast_nullable_to_non_nullable
as int,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,playerId: freezed == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String?,pointsDelta: null == pointsDelta ? _self.pointsDelta : pointsDelta // ignore: cast_nullable_to_non_nullable
as int,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$SportGameState {

/// Schema version sentinel — always `1` for this release.
 int get schemaVersion; SportType get sportType; TrackingMode get trackingMode; SportTeam get homeTeam; SportTeam get awayTeam;/// Sport-specific format string.
///
/// Baseball:   'nine_inning' | 'seven_inning' | 'scrimmage'
/// Basketball: 'full' | 'halves' | 'scrimmage'
/// Football:   'full' | 'two_minute_drill' | 'scrimmage'
/// Soccer:     'full' | 'short' | 'scrimmage'
/// Tennis:     'best_of_3' | 'best_of_5' | 'one_set' | 'pro_set'
/// Volleyball: 'best_of_5' | 'best_of_3' | 'one_set'
/// Hockey:     'full' | 'recreational' | 'scrimmage'
/// Lacrosse:   'full' | 'short' | 'scrimmage'
 String get gameFormat; GamePhase get gamePhase;/// Total elapsed game time in seconds.
 int get elapsedSeconds; bool get timerRunning;/// Append-only event log.
 List<SportEvent> get events;/// Free-form game notes (mirrors [SportGameNotes.content] for quick access).
 String? get notes;/// Sport-specific state fields embedded inline.
///
/// Baseball:   {currentInning, currentHalf, outs, maxInnings}
/// Basketball: {currentPeriod, periodCount}
/// Football:   {currentPeriod, currentDown, yardsToGo, possessingTeamId}
/// Soccer:     {currentHalf, possessingTeamId, homePossessionSeconds,
///              awayPossessionSeconds}
/// Tennis:     {currentSet, homeGamesThisSet, awayGamesThisSet,
///              homePoints, awayPoints, isTiebreak, servingTeamId,
///              setScores}
/// Volleyball: {currentSet, servingTeamId, setScores}
/// Hockey:     {currentPeriod, isOvertime, isShootout, activePenalties}
/// Lacrosse:   {currentQuarter}
 Map<String, dynamic> get sportSpecific;
/// Create a copy of SportGameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SportGameStateCopyWith<SportGameState> get copyWith => _$SportGameStateCopyWithImpl<SportGameState>(this as SportGameState, _$identity);

  /// Serializes this SportGameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SportGameState&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.sportType, sportType) || other.sportType == sportType)&&(identical(other.trackingMode, trackingMode) || other.trackingMode == trackingMode)&&(identical(other.homeTeam, homeTeam) || other.homeTeam == homeTeam)&&(identical(other.awayTeam, awayTeam) || other.awayTeam == awayTeam)&&(identical(other.gameFormat, gameFormat) || other.gameFormat == gameFormat)&&(identical(other.gamePhase, gamePhase) || other.gamePhase == gamePhase)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.timerRunning, timerRunning) || other.timerRunning == timerRunning)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.sportSpecific, sportSpecific));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,sportType,trackingMode,homeTeam,awayTeam,gameFormat,gamePhase,elapsedSeconds,timerRunning,const DeepCollectionEquality().hash(events),notes,const DeepCollectionEquality().hash(sportSpecific));

@override
String toString() {
  return 'SportGameState(schemaVersion: $schemaVersion, sportType: $sportType, trackingMode: $trackingMode, homeTeam: $homeTeam, awayTeam: $awayTeam, gameFormat: $gameFormat, gamePhase: $gamePhase, elapsedSeconds: $elapsedSeconds, timerRunning: $timerRunning, events: $events, notes: $notes, sportSpecific: $sportSpecific)';
}


}

/// @nodoc
abstract mixin class $SportGameStateCopyWith<$Res>  {
  factory $SportGameStateCopyWith(SportGameState value, $Res Function(SportGameState) _then) = _$SportGameStateCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, SportType sportType, TrackingMode trackingMode, SportTeam homeTeam, SportTeam awayTeam, String gameFormat, GamePhase gamePhase, int elapsedSeconds, bool timerRunning, List<SportEvent> events, String? notes, Map<String, dynamic> sportSpecific
});


$SportTeamCopyWith<$Res> get homeTeam;$SportTeamCopyWith<$Res> get awayTeam;

}
/// @nodoc
class _$SportGameStateCopyWithImpl<$Res>
    implements $SportGameStateCopyWith<$Res> {
  _$SportGameStateCopyWithImpl(this._self, this._then);

  final SportGameState _self;
  final $Res Function(SportGameState) _then;

/// Create a copy of SportGameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? sportType = null,Object? trackingMode = null,Object? homeTeam = null,Object? awayTeam = null,Object? gameFormat = null,Object? gamePhase = null,Object? elapsedSeconds = null,Object? timerRunning = null,Object? events = null,Object? notes = freezed,Object? sportSpecific = null,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,sportType: null == sportType ? _self.sportType : sportType // ignore: cast_nullable_to_non_nullable
as SportType,trackingMode: null == trackingMode ? _self.trackingMode : trackingMode // ignore: cast_nullable_to_non_nullable
as TrackingMode,homeTeam: null == homeTeam ? _self.homeTeam : homeTeam // ignore: cast_nullable_to_non_nullable
as SportTeam,awayTeam: null == awayTeam ? _self.awayTeam : awayTeam // ignore: cast_nullable_to_non_nullable
as SportTeam,gameFormat: null == gameFormat ? _self.gameFormat : gameFormat // ignore: cast_nullable_to_non_nullable
as String,gamePhase: null == gamePhase ? _self.gamePhase : gamePhase // ignore: cast_nullable_to_non_nullable
as GamePhase,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,timerRunning: null == timerRunning ? _self.timerRunning : timerRunning // ignore: cast_nullable_to_non_nullable
as bool,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<SportEvent>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,sportSpecific: null == sportSpecific ? _self.sportSpecific : sportSpecific // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}
/// Create a copy of SportGameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SportTeamCopyWith<$Res> get homeTeam {
  
  return $SportTeamCopyWith<$Res>(_self.homeTeam, (value) {
    return _then(_self.copyWith(homeTeam: value));
  });
}/// Create a copy of SportGameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SportTeamCopyWith<$Res> get awayTeam {
  
  return $SportTeamCopyWith<$Res>(_self.awayTeam, (value) {
    return _then(_self.copyWith(awayTeam: value));
  });
}
}


/// Adds pattern-matching-related methods to [SportGameState].
extension SportGameStatePatterns on SportGameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SportGameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SportGameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SportGameState value)  $default,){
final _that = this;
switch (_that) {
case _SportGameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SportGameState value)?  $default,){
final _that = this;
switch (_that) {
case _SportGameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  SportType sportType,  TrackingMode trackingMode,  SportTeam homeTeam,  SportTeam awayTeam,  String gameFormat,  GamePhase gamePhase,  int elapsedSeconds,  bool timerRunning,  List<SportEvent> events,  String? notes,  Map<String, dynamic> sportSpecific)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SportGameState() when $default != null:
return $default(_that.schemaVersion,_that.sportType,_that.trackingMode,_that.homeTeam,_that.awayTeam,_that.gameFormat,_that.gamePhase,_that.elapsedSeconds,_that.timerRunning,_that.events,_that.notes,_that.sportSpecific);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  SportType sportType,  TrackingMode trackingMode,  SportTeam homeTeam,  SportTeam awayTeam,  String gameFormat,  GamePhase gamePhase,  int elapsedSeconds,  bool timerRunning,  List<SportEvent> events,  String? notes,  Map<String, dynamic> sportSpecific)  $default,) {final _that = this;
switch (_that) {
case _SportGameState():
return $default(_that.schemaVersion,_that.sportType,_that.trackingMode,_that.homeTeam,_that.awayTeam,_that.gameFormat,_that.gamePhase,_that.elapsedSeconds,_that.timerRunning,_that.events,_that.notes,_that.sportSpecific);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  SportType sportType,  TrackingMode trackingMode,  SportTeam homeTeam,  SportTeam awayTeam,  String gameFormat,  GamePhase gamePhase,  int elapsedSeconds,  bool timerRunning,  List<SportEvent> events,  String? notes,  Map<String, dynamic> sportSpecific)?  $default,) {final _that = this;
switch (_that) {
case _SportGameState() when $default != null:
return $default(_that.schemaVersion,_that.sportType,_that.trackingMode,_that.homeTeam,_that.awayTeam,_that.gameFormat,_that.gamePhase,_that.elapsedSeconds,_that.timerRunning,_that.events,_that.notes,_that.sportSpecific);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SportGameState implements SportGameState {
  const _SportGameState({this.schemaVersion = 1, required this.sportType, required this.trackingMode, required this.homeTeam, required this.awayTeam, this.gameFormat = 'full', this.gamePhase = GamePhase.notStarted, this.elapsedSeconds = 0, this.timerRunning = false, final  List<SportEvent> events = const <SportEvent>[], this.notes, final  Map<String, dynamic> sportSpecific = const <String, dynamic>{}}): _events = events,_sportSpecific = sportSpecific;
  factory _SportGameState.fromJson(Map<String, dynamic> json) => _$SportGameStateFromJson(json);

/// Schema version sentinel — always `1` for this release.
@override@JsonKey() final  int schemaVersion;
@override final  SportType sportType;
@override final  TrackingMode trackingMode;
@override final  SportTeam homeTeam;
@override final  SportTeam awayTeam;
/// Sport-specific format string.
///
/// Baseball:   'nine_inning' | 'seven_inning' | 'scrimmage'
/// Basketball: 'full' | 'halves' | 'scrimmage'
/// Football:   'full' | 'two_minute_drill' | 'scrimmage'
/// Soccer:     'full' | 'short' | 'scrimmage'
/// Tennis:     'best_of_3' | 'best_of_5' | 'one_set' | 'pro_set'
/// Volleyball: 'best_of_5' | 'best_of_3' | 'one_set'
/// Hockey:     'full' | 'recreational' | 'scrimmage'
/// Lacrosse:   'full' | 'short' | 'scrimmage'
@override@JsonKey() final  String gameFormat;
@override@JsonKey() final  GamePhase gamePhase;
/// Total elapsed game time in seconds.
@override@JsonKey() final  int elapsedSeconds;
@override@JsonKey() final  bool timerRunning;
/// Append-only event log.
 final  List<SportEvent> _events;
/// Append-only event log.
@override@JsonKey() List<SportEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

/// Free-form game notes (mirrors [SportGameNotes.content] for quick access).
@override final  String? notes;
/// Sport-specific state fields embedded inline.
///
/// Baseball:   {currentInning, currentHalf, outs, maxInnings}
/// Basketball: {currentPeriod, periodCount}
/// Football:   {currentPeriod, currentDown, yardsToGo, possessingTeamId}
/// Soccer:     {currentHalf, possessingTeamId, homePossessionSeconds,
///              awayPossessionSeconds}
/// Tennis:     {currentSet, homeGamesThisSet, awayGamesThisSet,
///              homePoints, awayPoints, isTiebreak, servingTeamId,
///              setScores}
/// Volleyball: {currentSet, servingTeamId, setScores}
/// Hockey:     {currentPeriod, isOvertime, isShootout, activePenalties}
/// Lacrosse:   {currentQuarter}
 final  Map<String, dynamic> _sportSpecific;
/// Sport-specific state fields embedded inline.
///
/// Baseball:   {currentInning, currentHalf, outs, maxInnings}
/// Basketball: {currentPeriod, periodCount}
/// Football:   {currentPeriod, currentDown, yardsToGo, possessingTeamId}
/// Soccer:     {currentHalf, possessingTeamId, homePossessionSeconds,
///              awayPossessionSeconds}
/// Tennis:     {currentSet, homeGamesThisSet, awayGamesThisSet,
///              homePoints, awayPoints, isTiebreak, servingTeamId,
///              setScores}
/// Volleyball: {currentSet, servingTeamId, setScores}
/// Hockey:     {currentPeriod, isOvertime, isShootout, activePenalties}
/// Lacrosse:   {currentQuarter}
@override@JsonKey() Map<String, dynamic> get sportSpecific {
  if (_sportSpecific is EqualUnmodifiableMapView) return _sportSpecific;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_sportSpecific);
}


/// Create a copy of SportGameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SportGameStateCopyWith<_SportGameState> get copyWith => __$SportGameStateCopyWithImpl<_SportGameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SportGameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SportGameState&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.sportType, sportType) || other.sportType == sportType)&&(identical(other.trackingMode, trackingMode) || other.trackingMode == trackingMode)&&(identical(other.homeTeam, homeTeam) || other.homeTeam == homeTeam)&&(identical(other.awayTeam, awayTeam) || other.awayTeam == awayTeam)&&(identical(other.gameFormat, gameFormat) || other.gameFormat == gameFormat)&&(identical(other.gamePhase, gamePhase) || other.gamePhase == gamePhase)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.timerRunning, timerRunning) || other.timerRunning == timerRunning)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._sportSpecific, _sportSpecific));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,sportType,trackingMode,homeTeam,awayTeam,gameFormat,gamePhase,elapsedSeconds,timerRunning,const DeepCollectionEquality().hash(_events),notes,const DeepCollectionEquality().hash(_sportSpecific));

@override
String toString() {
  return 'SportGameState(schemaVersion: $schemaVersion, sportType: $sportType, trackingMode: $trackingMode, homeTeam: $homeTeam, awayTeam: $awayTeam, gameFormat: $gameFormat, gamePhase: $gamePhase, elapsedSeconds: $elapsedSeconds, timerRunning: $timerRunning, events: $events, notes: $notes, sportSpecific: $sportSpecific)';
}


}

/// @nodoc
abstract mixin class _$SportGameStateCopyWith<$Res> implements $SportGameStateCopyWith<$Res> {
  factory _$SportGameStateCopyWith(_SportGameState value, $Res Function(_SportGameState) _then) = __$SportGameStateCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, SportType sportType, TrackingMode trackingMode, SportTeam homeTeam, SportTeam awayTeam, String gameFormat, GamePhase gamePhase, int elapsedSeconds, bool timerRunning, List<SportEvent> events, String? notes, Map<String, dynamic> sportSpecific
});


@override $SportTeamCopyWith<$Res> get homeTeam;@override $SportTeamCopyWith<$Res> get awayTeam;

}
/// @nodoc
class __$SportGameStateCopyWithImpl<$Res>
    implements _$SportGameStateCopyWith<$Res> {
  __$SportGameStateCopyWithImpl(this._self, this._then);

  final _SportGameState _self;
  final $Res Function(_SportGameState) _then;

/// Create a copy of SportGameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? sportType = null,Object? trackingMode = null,Object? homeTeam = null,Object? awayTeam = null,Object? gameFormat = null,Object? gamePhase = null,Object? elapsedSeconds = null,Object? timerRunning = null,Object? events = null,Object? notes = freezed,Object? sportSpecific = null,}) {
  return _then(_SportGameState(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,sportType: null == sportType ? _self.sportType : sportType // ignore: cast_nullable_to_non_nullable
as SportType,trackingMode: null == trackingMode ? _self.trackingMode : trackingMode // ignore: cast_nullable_to_non_nullable
as TrackingMode,homeTeam: null == homeTeam ? _self.homeTeam : homeTeam // ignore: cast_nullable_to_non_nullable
as SportTeam,awayTeam: null == awayTeam ? _self.awayTeam : awayTeam // ignore: cast_nullable_to_non_nullable
as SportTeam,gameFormat: null == gameFormat ? _self.gameFormat : gameFormat // ignore: cast_nullable_to_non_nullable
as String,gamePhase: null == gamePhase ? _self.gamePhase : gamePhase // ignore: cast_nullable_to_non_nullable
as GamePhase,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,timerRunning: null == timerRunning ? _self.timerRunning : timerRunning // ignore: cast_nullable_to_non_nullable
as bool,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<SportEvent>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,sportSpecific: null == sportSpecific ? _self._sportSpecific : sportSpecific // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of SportGameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SportTeamCopyWith<$Res> get homeTeam {
  
  return $SportTeamCopyWith<$Res>(_self.homeTeam, (value) {
    return _then(_self.copyWith(homeTeam: value));
  });
}/// Create a copy of SportGameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SportTeamCopyWith<$Res> get awayTeam {
  
  return $SportTeamCopyWith<$Res>(_self.awayTeam, (value) {
    return _then(_self.copyWith(awayTeam: value));
  });
}
}

// dart format on
