import 'dart:convert';
import 'dart:io';

import '../../../core/database/daos/sport_export_dao.dart';
import '../../../core/modules/sport_enums.dart';
import '../../../core/modules/sport_game_state.dart';
import '../../modules/shared/sport_module_utils.dart';
import 'sport_export_service.dart';

class CsvExportService implements SportExportService {
  @override
  Future<File> exportGames(
    List<SportExportRecord> games, {
    required Directory tempDir,
  }) async {
    final timestamp = DateTime.now();
    final path =
        '${tempDir.path}\\SkorKeeper_Export_${timestamp.toIso8601String().replaceAll(RegExp(r'[:\-]'), '').replaceAll('.', '_')}.csv';
    final file = File(path);
    final rows = <List<String>>[
      const [
        'Export Date',
        'Sport',
        'Game Date',
        'Home Team',
        'Away Team',
        'Final Score Home',
        'Final Score Away',
        'Duration (s)',
        'Format',
        'Tracking Mode',
        'Notes',
        'Player Stats JSON',
      ],
    ];
    for (final game in games) {
      final state = SportGameState.fromJson(
        jsonDecode(game.session.moduleStateJson) as Map<String, dynamic>,
      );
      rows.add([
        timestamp.toIso8601String(),
        SportModuleUtils.sportLabel(game.meta.sportType),
        DateTime.fromMillisecondsSinceEpoch(game.session.startedAt).toIso8601String(),
        state.homeTeam.name,
        state.awayTeam.name,
        '${state.homeTeam.score}',
        '${state.awayTeam.score}',
        '${state.elapsedSeconds}',
        state.gameFormat,
        game.meta.trackingMode,
        game.notes?.content ?? state.notes ?? '',
        state.trackingMode == TrackingMode.inDepth
            ? jsonEncode({
                'home': state.homeTeam.roster?.map((player) => player.toJson()).toList(),
                'away': state.awayTeam.roster?.map((player) => player.toJson()).toList(),
              })
            : '',
      ]);
    }
    final content = rows.map(_csvLine).join('\r\n');
    await file.writeAsString('\uFEFF$content');
    return file;
  }

  String _csvLine(List<String> cells) {
    return cells.map((cell) => '"${cell.replaceAll('"', '""')}"').join(',');
  }
}
