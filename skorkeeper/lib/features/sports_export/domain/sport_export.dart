import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/modules/sport_enums.dart';

part 'sport_export.freezed.dart';

/// Transient model representing an in-progress or completed export operation.
///
/// Not persisted as a database row. The export file is written to the device
/// temp directory, shared via [share_plus], then discarded.
///
/// After sharing, [SportHistoryMeta.exportedAt] is updated via
/// [SportHistoryDao.updateExportStatus].
@freezed
abstract class SportExport with _$SportExport {
  const factory SportExport({
    /// UUID generated when the export is initiated.
    required String exportId,

    /// Target file format for this export.
    required ExportFormat format,

    /// IDs of the [GameSession] rows included in this export.
    required List<int> gameSessionIds,

    /// When the export was initiated.
    required DateTime createdAt,

    /// Absolute path to the generated temp file.
    /// Null until generation is complete.
    String? filePath,

    /// Current lifecycle status of the export.
    @Default(ExportStatus.pending) ExportStatus status,

    /// Human-readable error message if [status] == [ExportStatus.failed].
    String? errorMessage,
  }) = _SportExport;
}
