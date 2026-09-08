// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sport_export.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SportExport {

/// UUID generated when the export is initiated.
 String get exportId;/// Target file format for this export.
 ExportFormat get format;/// IDs of the [GameSession] rows included in this export.
 List<int> get gameSessionIds;/// When the export was initiated.
 DateTime get createdAt;/// Absolute path to the generated temp file.
/// Null until generation is complete.
 String? get filePath;/// Current lifecycle status of the export.
 ExportStatus get status;/// Human-readable error message if [status] == [ExportStatus.failed].
 String? get errorMessage;
/// Create a copy of SportExport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SportExportCopyWith<SportExport> get copyWith => _$SportExportCopyWithImpl<SportExport>(this as SportExport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SportExport&&(identical(other.exportId, exportId) || other.exportId == exportId)&&(identical(other.format, format) || other.format == format)&&const DeepCollectionEquality().equals(other.gameSessionIds, gameSessionIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,exportId,format,const DeepCollectionEquality().hash(gameSessionIds),createdAt,filePath,status,errorMessage);

@override
String toString() {
  return 'SportExport(exportId: $exportId, format: $format, gameSessionIds: $gameSessionIds, createdAt: $createdAt, filePath: $filePath, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SportExportCopyWith<$Res>  {
  factory $SportExportCopyWith(SportExport value, $Res Function(SportExport) _then) = _$SportExportCopyWithImpl;
@useResult
$Res call({
 String exportId, ExportFormat format, List<int> gameSessionIds, DateTime createdAt, String? filePath, ExportStatus status, String? errorMessage
});




}
/// @nodoc
class _$SportExportCopyWithImpl<$Res>
    implements $SportExportCopyWith<$Res> {
  _$SportExportCopyWithImpl(this._self, this._then);

  final SportExport _self;
  final $Res Function(SportExport) _then;

/// Create a copy of SportExport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exportId = null,Object? format = null,Object? gameSessionIds = null,Object? createdAt = null,Object? filePath = freezed,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
exportId: null == exportId ? _self.exportId : exportId // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as ExportFormat,gameSessionIds: null == gameSessionIds ? _self.gameSessionIds : gameSessionIds // ignore: cast_nullable_to_non_nullable
as List<int>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExportStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SportExport].
extension SportExportPatterns on SportExport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SportExport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SportExport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SportExport value)  $default,){
final _that = this;
switch (_that) {
case _SportExport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SportExport value)?  $default,){
final _that = this;
switch (_that) {
case _SportExport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exportId,  ExportFormat format,  List<int> gameSessionIds,  DateTime createdAt,  String? filePath,  ExportStatus status,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SportExport() when $default != null:
return $default(_that.exportId,_that.format,_that.gameSessionIds,_that.createdAt,_that.filePath,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exportId,  ExportFormat format,  List<int> gameSessionIds,  DateTime createdAt,  String? filePath,  ExportStatus status,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SportExport():
return $default(_that.exportId,_that.format,_that.gameSessionIds,_that.createdAt,_that.filePath,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exportId,  ExportFormat format,  List<int> gameSessionIds,  DateTime createdAt,  String? filePath,  ExportStatus status,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SportExport() when $default != null:
return $default(_that.exportId,_that.format,_that.gameSessionIds,_that.createdAt,_that.filePath,_that.status,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SportExport implements SportExport {
  const _SportExport({required this.exportId, required this.format, required final  List<int> gameSessionIds, required this.createdAt, this.filePath, this.status = ExportStatus.pending, this.errorMessage}): _gameSessionIds = gameSessionIds;
  

/// UUID generated when the export is initiated.
@override final  String exportId;
/// Target file format for this export.
@override final  ExportFormat format;
/// IDs of the [GameSession] rows included in this export.
 final  List<int> _gameSessionIds;
/// IDs of the [GameSession] rows included in this export.
@override List<int> get gameSessionIds {
  if (_gameSessionIds is EqualUnmodifiableListView) return _gameSessionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gameSessionIds);
}

/// When the export was initiated.
@override final  DateTime createdAt;
/// Absolute path to the generated temp file.
/// Null until generation is complete.
@override final  String? filePath;
/// Current lifecycle status of the export.
@override@JsonKey() final  ExportStatus status;
/// Human-readable error message if [status] == [ExportStatus.failed].
@override final  String? errorMessage;

/// Create a copy of SportExport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SportExportCopyWith<_SportExport> get copyWith => __$SportExportCopyWithImpl<_SportExport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SportExport&&(identical(other.exportId, exportId) || other.exportId == exportId)&&(identical(other.format, format) || other.format == format)&&const DeepCollectionEquality().equals(other._gameSessionIds, _gameSessionIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,exportId,format,const DeepCollectionEquality().hash(_gameSessionIds),createdAt,filePath,status,errorMessage);

@override
String toString() {
  return 'SportExport(exportId: $exportId, format: $format, gameSessionIds: $gameSessionIds, createdAt: $createdAt, filePath: $filePath, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SportExportCopyWith<$Res> implements $SportExportCopyWith<$Res> {
  factory _$SportExportCopyWith(_SportExport value, $Res Function(_SportExport) _then) = __$SportExportCopyWithImpl;
@override @useResult
$Res call({
 String exportId, ExportFormat format, List<int> gameSessionIds, DateTime createdAt, String? filePath, ExportStatus status, String? errorMessage
});




}
/// @nodoc
class __$SportExportCopyWithImpl<$Res>
    implements _$SportExportCopyWith<$Res> {
  __$SportExportCopyWithImpl(this._self, this._then);

  final _SportExport _self;
  final $Res Function(_SportExport) _then;

/// Create a copy of SportExport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exportId = null,Object? format = null,Object? gameSessionIds = null,Object? createdAt = null,Object? filePath = freezed,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_SportExport(
exportId: null == exportId ? _self.exportId : exportId // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as ExportFormat,gameSessionIds: null == gameSessionIds ? _self._gameSessionIds : gameSessionIds // ignore: cast_nullable_to_non_nullable
as List<int>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExportStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
