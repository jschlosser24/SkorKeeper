import 'dart:io';

import '../../../core/database/daos/sport_export_dao.dart';

abstract class SportExportService {
  Future<File> exportGames(
    List<SportExportRecord> games, {
    required Directory tempDir,
  });
}
