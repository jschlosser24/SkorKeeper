import 'dart:convert';
import 'dart:io';

import '../../../core/database/daos/sport_export_dao.dart';
import '../../../core/modules/sport_game_state.dart';
import 'sport_export_service.dart';

class JsonExportService implements SportExportService {
  @override
  Future<File> exportGames(
    List<SportExportRecord> games, {
    required Directory tempDir,
  }) async {
    final timestamp = DateTime.now();
    final file = File(
      '${tempDir.path}\\SkorKeeper_Export_${timestamp.toIso8601String().replaceAll(RegExp(r'[:\-]'), '').replaceAll('.', '_')}.json',
    );
    final payload = {
      'exportVersion': '1.0',
      'exportedAt': timestamp.toIso8601String(),
      'exportedBy': 'SkorKeeper',
      'games': [
        for (final game in games)
          SportGameState.fromJson(
            jsonDecode(game.session.moduleStateJson) as Map<String, dynamic>,
          ).toJson(),
      ],
    };
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(payload));
    return file;
  }
}
