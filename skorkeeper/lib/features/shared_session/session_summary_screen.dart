import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../core/database/app_database.dart' as db;
import '../../core/models/session_player.dart';
import '../../core/modules/leaderboard_entry.dart';
import '../../core/modules/game_module_registry.dart';
import '../../core/providers/database_provider.dart';
import '../../ui/widgets/leaderboard_row.dart';

class SessionSummaryScreen extends ConsumerWidget {
  const SessionSummaryScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);
    return StreamBuilder<db.GameSession?>(
      stream: (database.select(
        database.gameSessions,
      )..where((tbl) => tbl.id.equals(sessionId))).watchSingleOrNull(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final session = snapshot.data;
        if (session == null) {
          return const Scaffold(
            body: Center(child: Text('Summary unavailable.')),
          );
        }
        final module = GameModuleRegistry.get(session.gameType);
        final state = module?.stateFromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        final players = (jsonDecode(session.participantsJson) as List<dynamic>)
            .map((item) => SessionPlayer.fromJson(item as Map<String, dynamic>))
            .toList();
        final standings = state == null || module == null
            ? const []
            : _resolveStandings(module.leaderboard(state), players);
        final duration = session.endedAt == null
            ? null
            : Duration(milliseconds: session.endedAt! - session.startedAt);
        return Scaffold(
          appBar: AppBar(title: const Text('Game Summary')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 180,
                child: Lottie.asset(
                  'assets/animations/win_celebration.json',
                  repeat: false,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.celebration, size: 120),
                ),
              ),
              Text(
                session.winnerDisplayName ?? 'Winner pending',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (duration != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Duration: ' + _formatDuration(duration),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              for (final entry in standings) LeaderboardRow(entry: entry),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/home'),
                child: const Text('Done'),
              ),
              const SizedBox(height: 12),
              Text(
                'Ended ' +
                    DateFormat.yMMMd().add_jm().format(
                      DateTime.fromMillisecondsSinceEpoch(
                        session.endedAt ?? session.startedAt,
                      ),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return minutes.toString().padLeft(2, '0') +
        ':' +
        seconds.toString().padLeft(2, '0');
  }

  List<LeaderboardEntry> _resolveStandings(
    List<LeaderboardEntry> standings,
    List<SessionPlayer> players,
  ) {
    final playerById = {for (final player in players) player.id: player};
    return standings.map((entry) {
      final player = playerById[entry.playerId];
      if (player == null) {
        return entry;
      }
      return entry.copyWith(
        displayName: player.displayName,
        colorHex: player.colorHex,
      );
    }).toList();
  }
}
