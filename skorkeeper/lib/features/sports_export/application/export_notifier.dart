import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/modules/sport_enums.dart';
import '../../../core/providers/database_provider.dart';
import '../domain/csv_export_service.dart';
import '../domain/json_export_service.dart';
import '../domain/pdf_export_service.dart';
import '../domain/sport_export.dart';
import '../domain/sport_export_service.dart';

part 'export_notifier.g.dart';

@riverpod
class ExportNotifier extends _$ExportNotifier {
  @override
  Future<SportExport?> build() async => null;

  Future<void> exportGames(List<int> ids, ExportFormat format) async {
    if (ids.isEmpty) {
      state = AsyncError('No games selected.', StackTrace.current);
      return;
    }
    final export = SportExport(
      exportId: '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      format: format,
      gameSessionIds: ids,
      createdAt: DateTime.now(),
      status: ExportStatus.generating,
    );
    state = AsyncData(export);
    try {
      final tempDir = await getTemporaryDirectory();
      final records = await ref.read(appDatabaseProvider).sportExportDao.getGamesForExport(ids);
      final service = _serviceFor(format);
      final file = await service.exportGames(records, tempDir: Directory(tempDir.path));
      await Share.shareXFiles([XFile(file.path)], text: 'SkorKeeper export');
      for (final id in ids) {
        await ref.read(appDatabaseProvider).sportHistoryDao.updateExportStatus(id, format.name);
      }
      state = AsyncData(
        export.copyWith(status: ExportStatus.complete, filePath: file.path),
      );
    } catch (error, stackTrace) {
      state = AsyncError(_friendlyError(error), stackTrace);
    }
  }

  SportExportService _serviceFor(ExportFormat format) {
    switch (format) {
      case ExportFormat.csv:
        return CsvExportService();
      case ExportFormat.json:
        return JsonExportService();
      case ExportFormat.pdf:
        return PdfExportService();
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('PathAccessException')) {
      return 'Unable to create export file. Please check device storage and try again.';
    }
    return 'Export failed. Please try again.';
  }
}
