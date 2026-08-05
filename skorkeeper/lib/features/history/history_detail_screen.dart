import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart' as db;
import '../../core/models/session_player.dart';
import '../../core/modules/game_module.dart';
import '../../core/modules/game_module_registry.dart';
import '../../core/modules/leaderboard_entry.dart';
import '../../core/modules/scoring_layout_descriptor.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/history_provider.dart';
import '../../features/modules/bowling/domain/bowling_state.dart';
import '../../features/modules/bowling/presentation/bowling_sheet_widget.dart';
import '../../features/modules/cribbage/domain/cribbage_state.dart';
import '../../features/modules/cribbage/presentation/cribbage_board_widget.dart';
import '../../features/modules/custom/domain/custom_game_state.dart';
import '../../features/modules/darts/domain/darts_game_state.dart';
import '../../features/modules/farkle/domain/farkle_state.dart';
import '../../features/modules/golf/domain/golf_state.dart';
import '../../features/modules/yahtzee/domain/yahtzee_module.dart';
import '../../features/modules/yahtzee/domain/yahtzee_state.dart';
import '../../ui/widgets/leaderboard_row.dart';

class HistoryDetailScreen extends ConsumerWidget {
  const HistoryDetailScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);
    return FutureBuilder<_HistoryDetailData?>(
      future: _load(database),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const Scaffold(
            body: Center(child: Text('No saved history for this session.')),
          );
        }
        final record = data.record;
        final session = data.session;
        final module = data.module;
        final state = data.state;
        final standings = state == null
            ? const <LeaderboardEntry>[]
            : _resolveStandings(
                state is CustomGameState
                    ? _customStandings(
                        data.players,
                        data.scoreEntries,
                        state.scoreDirection,
                      )
                    : module.leaderboard(state),
                data.players,
              );
        final duration = record.durationSeconds == null
            ? null
            : Duration(seconds: record.durationSeconds!);
        final playedAt = DateTime.fromMillisecondsSinceEpoch(record.playedAt);
        return Scaffold(
          appBar: AppBar(
            title: Text(record.sessionName ?? _formatGameType(record.gameType)),
            actions: [
              IconButton(
                tooltip: 'Delete history entry',
                onPressed: () async {
                  final confirmed =
                      await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete history entry?'),
                          content: const Text(
                            'This removes the completed session and its saved history.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                  if (!confirmed) {
                    return;
                  }
                  await ref
                      .read(historyNotifierProvider.notifier)
                      .deleteEntry(record.id);
                  if (context.mounted) {
                    context.pop();
                  }
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    runSpacing: 8,
                    children: [
                      _MetaItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Played',
                        value: DateFormat('MMM d, yyyy').format(playedAt),
                      ),
                      _MetaItem(
                        icon: Icons.schedule_outlined,
                        label: 'Duration',
                        value: duration == null
                            ? '—'
                            : _formatDuration(duration),
                      ),
                      _MetaItem(
                        icon: Icons.groups_outlined,
                        label: 'Players',
                        value: data.players.length.toString(),
                      ),
                      _MetaItem(
                        icon: Icons.emoji_events_outlined,
                        label: 'Winner',
                        value: record.winnerDisplayName ?? '—',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Final standings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (standings.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(record.playerNames),
                  ),
                )
              else
                for (final entry in standings) LeaderboardRow(entry: entry),
              const SizedBox(height: 16),
              Text(
                'Score snapshot',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _ReadOnlyScoringView(
                module: module,
                players: data.players,
                state: state,
                rawStateJson: session.moduleStateJson,
                scoreEntries: data.scoreEntries,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<_HistoryDetailData?> _load(db.AppDatabase database) async {
    final session = await database.sessionDao.getSession(sessionId);
    final record = await database.historyDao.getHistoryRecord(sessionId);
    if (session == null || record == null) {
      return null;
    }
    final players = (jsonDecode(session.participantsJson) as List<dynamic>)
        .map((item) => SessionPlayer.fromJson(item as Map<String, dynamic>))
        .toList();
    final module = GameModuleRegistry.get(session.gameType);
    if (module == null) {
      return null;
    }
    final scoreEntries = await database.sessionDao.getScoreEntriesForSession(
      sessionId,
    );
    final state = module.stateFromJson(
      jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
    );
    return _HistoryDetailData(
      session: session,
      record: record,
      players: players,
      module: module,
      state: state,
      scoreEntries: scoreEntries,
    );
  }

  static List<LeaderboardEntry> _resolveStandings(
    List<LeaderboardEntry> entries,
    List<SessionPlayer> players,
  ) {
    final playerById = {for (final player in players) player.id: player};
    return entries.map((entry) {
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

  static List<LeaderboardEntry> _customStandings(
    List<SessionPlayer> players,
    List<db.ScoreEntry> scoreEntries,
    ScoreDirection direction,
  ) {
    if (players.isEmpty) {
      return const <LeaderboardEntry>[];
    }
    final totals = _buildTotals(players, _buildCellScores(scoreEntries));
    final sorted = [...players]
      ..sort((a, b) {
        final aScore = totals[a.id] ?? 0;
        final bScore = totals[b.id] ?? 0;
        final comparison = direction == ScoreDirection.highWins
            ? bScore.compareTo(aScore)
            : aScore.compareTo(bScore);
        if (comparison != 0) {
          return comparison;
        }
        return a.displayName.compareTo(b.displayName);
      });
    final bestScore = totals[sorted.first.id] ?? 0;
    var displayRank = 1;
    int? previousScore;
    final standings = <LeaderboardEntry>[];
    for (var index = 0; index < sorted.length; index++) {
      final player = sorted[index];
      final score = totals[player.id] ?? 0;
      if (previousScore != null && previousScore != score) {
        displayRank = index + 1;
      }
      standings.add(
        LeaderboardEntry(
          playerId: player.id,
          displayName: player.displayName,
          colorHex: player.colorHex,
          rank: displayRank,
          scoreDisplay: score.toString(),
          sortKey: score,
          isLeading: score == bestScore,
        ),
      );
      previousScore = score;
    }
    return standings;
  }

  static String _formatGameType(String gameType) {
    return gameType
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        )
        .split('_')
        .expand((part) => part.split(' '))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    }
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}

class _HistoryDetailData {
  const _HistoryDetailData({
    required this.session,
    required this.record,
    required this.players,
    required this.module,
    required this.state,
    required this.scoreEntries,
  });

  final db.GameSession session;
  final db.HistoryRecord record;
  final List<SessionPlayer> players;
  final GameModule module;
  final dynamic state;
  final List<db.ScoreEntry> scoreEntries;
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text('$label: ', style: Theme.of(context).textTheme.titleSmall),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _ReadOnlyScoringView extends StatelessWidget {
  const _ReadOnlyScoringView({
    required this.module,
    required this.players,
    required this.state,
    required this.rawStateJson,
    required this.scoreEntries,
  });

  final GameModule module;
  final List<SessionPlayer> players;
  final dynamic state;
  final String rawStateJson;
  final List<db.ScoreEntry> scoreEntries;

  @override
  Widget build(BuildContext context) {
    if (state == null) {
      return _FallbackSnapshotCard(rawStateJson: rawStateJson);
    }
    final layout = module.scoringLayout(state);
    if (layout.type == ScoringLayoutType.bowlingSheet &&
        state is BowlingState) {
      return BowlingSheetWidget(players: players, state: state as BowlingState);
    }
    if (state is GolfState) {
      return _GolfSnapshot(players: players, state: state as GolfState);
    }
    if (state is DartsGameState) {
      return _DartsSnapshot(players: players, state: state as DartsGameState);
    }
    if (state is YahtzeeState) {
      return _YahtzeeSnapshot(players: players, state: state as YahtzeeState);
    }
    if (state is FarkleState) {
      return _FarkleSnapshot(players: players, state: state as FarkleState);
    }
    if (state is CribbageState) {
      return _CribbageSnapshot(players: players, state: state as CribbageState);
    }
    if (state is CustomGameState) {
      return _CustomSnapshot(
        players: players,
        state: state as CustomGameState,
        scoreEntries: scoreEntries,
      );
    }
    return _FallbackSnapshotCard(rawStateJson: rawStateJson);
  }
}

class _GolfSnapshot extends StatelessWidget {
  const _GolfSnapshot({required this.players, required this.state});

  final List<SessionPlayer> players;
  final GolfState state;

  @override
  Widget build(BuildContext context) {
    final totals = {
      for (final player in players)
        player.id:
            state.scores[player.id]?.whereType<int>().fold<int>(
              0,
              (sum, value) => sum + value,
            ) ??
            0,
    };
    final leaderId = totals.entries
        .reduce((a, b) => a.value <= b.value ? a : b)
        .key;
    return Card(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              children: [
                _tableCell(context, 'Hole', header: true),
                if (!state.isMiniGolf) _tableCell(context, 'Par', header: true),
                for (final player in players)
                  _tableCell(
                    context,
                    player.displayName,
                    header: true,
                    highlight: player.id == leaderId,
                  ),
              ],
            ),
            for (var hole = 0; hole < state.holeCount; hole++)
              TableRow(
                children: [
                  _tableCell(context, '${hole + 1}'),
                  if (!state.isMiniGolf)
                    _tableCell(context, '${state.pars[hole]}'),
                  for (final player in players)
                    _tableCell(
                      context,
                      '${state.scores[player.id]?[hole] ?? '—'}',
                      highlight: player.id == leaderId,
                    ),
                ],
              ),
            TableRow(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              children: [
                _tableCell(context, 'Total', header: true),
                if (!state.isMiniGolf)
                  _tableCell(
                    context,
                    '${state.pars.fold<int>(0, (sum, value) => sum + value)}',
                    header: true,
                  ),
                for (final player in players)
                  _tableCell(
                    context,
                    '${totals[player.id] ?? 0}',
                    header: true,
                    highlight: player.id == leaderId,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DartsSnapshot extends StatelessWidget {
  const _DartsSnapshot({required this.players, required this.state});

  final List<SessionPlayer> players;
  final DartsGameState state;

  @override
  Widget build(BuildContext context) {
    final round = state.currentRound ?? 1;
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.gps_fixed_rounded),
            title: Text(_variantTitle(state.gameVariant)),
            subtitle: Text(_roundSummary(state, round)),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final player in players)
              SizedBox(
                width: 180,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.displayName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        for (final line in _playerLines(player.id))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(line),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _variantTitle(DartsVariant variant) {
    switch (variant) {
      case DartsVariant.v301:
        return '301';
      case DartsVariant.v501:
        return '501';
      case DartsVariant.v701:
        return '701';
      case DartsVariant.cricket:
        return 'Cricket';
      case DartsVariant.cutThroatCricket:
        return 'Cut-Throat Cricket';
      case DartsVariant.aroundTheClock:
        return 'Around the Clock';
      case DartsVariant.shanghai:
        return 'Shanghai';
      case DartsVariant.killer:
        return 'Killer';
      case DartsVariant.halveIt:
        return 'Halve It';
    }
  }

  String _roundSummary(DartsGameState state, int round) {
    switch (state.gameVariant) {
      case DartsVariant.aroundTheClock:
        return 'Each player advances by hitting the next target in order.';
      case DartsVariant.shanghai:
        return 'Round $round • Target $round';
      case DartsVariant.killer:
        return 'Lives remaining decide the winner.';
      default:
        return 'Current player: ${_playerName(state.currentPlayerId)}';
    }
  }

  List<String> _playerLines(String playerId) {
    final playerState = state.playerStates[playerId];
    final dartsThrown = playerState?.dartsThrown ?? 0;
    switch (state.gameVariant) {
      case DartsVariant.cricket:
      case DartsVariant.cutThroatCricket:
        return [
          'Points: ${state.cricketPoints?[playerId] ?? 0}',
          'Marks: ${_cricketMarks(playerId)}',
          'Darts: $dartsThrown',
        ];
      case DartsVariant.aroundTheClock:
        final progress = state.variantProgress?[playerId] ?? 1;
        return [
          'Next target: ${progress > 20 ? 'Bull' : progress}',
          'Completed: ${progress - 1}/21',
          'Darts: $dartsThrown',
        ];
      case DartsVariant.shanghai:
        return [
          'Score: ${state.variantScores?[playerId] ?? 0} pts',
          'Round target: ${state.currentRound ?? 1}',
          'Darts: $dartsThrown',
        ];
      case DartsVariant.killer:
        return [
          'Lives: ${state.killerLives?[playerId] ?? 0}',
          'Status: ${(state.killerStatus?[playerId] ?? false) ? 'Killer' : 'Alive'}',
          'Darts: $dartsThrown',
        ];
      case DartsVariant.halveIt:
        return [
          'Score: ${state.variantScores?[playerId] ?? 0}',
          'Round: ${state.currentRound ?? 1}',
          'Darts: $dartsThrown',
        ];
      default:
        return [
          'Remaining: ${playerState?.scoreRemaining ?? 0}',
          'Darts: $dartsThrown',
          'Turn throws: ${playerState?.scoresThisLeg.join(', ') ?? '—'}',
        ];
    }
  }

  String _cricketMarks(String playerId) {
    final marks = state.cricketMarks?[playerId];
    if (marks == null || marks.isEmpty) {
      return '—';
    }
    const targets = [15, 16, 17, 18, 19, 20, 25];
    return targets
        .map((target) => '$target:${marks[target.toString()] ?? 0}')
        .join('  ');
  }

  String _playerName(String playerId) {
    return players
        .firstWhere(
          (player) => player.id == playerId,
          orElse: () => players.first,
        )
        .displayName;
  }
}

class _YahtzeeSnapshot extends StatelessWidget {
  const _YahtzeeSnapshot({required this.players, required this.state});

  final List<SessionPlayer> players;
  final YahtzeeState state;

  static const _categories = <(String, int? Function(YahtzeeScorecard))>[
    ('Aces (1s)', _ones),
    ('Twos', _twos),
    ('Threes', _threes),
    ('Fours', _fours),
    ('Fives', _fives),
    ('Sixes', _sixes),
    ('3 of a Kind', _threeKind),
    ('4 of a Kind', _fourKind),
    ('Full House', _fullHouse),
    ('Small Straight', _smallStraight),
    ('Large Straight', _largeStraight),
    ('Yahtzee', _yahtzee),
    ('Chance', _chance),
  ];

  @override
  Widget build(BuildContext context) {
    final module = const YahtzeeModule();
    return Card(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Category')),
            for (final player in players)
              DataColumn(label: Text(player.displayName)),
          ],
          rows: [
            for (final category in _categories)
              DataRow(
                cells: [
                  DataCell(Text(category.$1)),
                  for (final player in players)
                    DataCell(
                      Text(
                        '${category.$2(state.scorecards[player.id]!) ?? '—'}',
                      ),
                    ),
                ],
              ),
            DataRow(
              cells: [
                const DataCell(Text('Total')),
                for (final player in players)
                  DataCell(
                    Text('${module.totalFor(state.scorecards[player.id]!)}'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static int? _ones(YahtzeeScorecard scorecard) => scorecard.ones;
  static int? _twos(YahtzeeScorecard scorecard) => scorecard.twos;
  static int? _threes(YahtzeeScorecard scorecard) => scorecard.threes;
  static int? _fours(YahtzeeScorecard scorecard) => scorecard.fours;
  static int? _fives(YahtzeeScorecard scorecard) => scorecard.fives;
  static int? _sixes(YahtzeeScorecard scorecard) => scorecard.sixes;
  static int? _threeKind(YahtzeeScorecard scorecard) => scorecard.threeOfAKind;
  static int? _fourKind(YahtzeeScorecard scorecard) => scorecard.fourOfAKind;
  static int? _fullHouse(YahtzeeScorecard scorecard) => scorecard.fullHouse;
  static int? _smallStraight(YahtzeeScorecard scorecard) =>
      scorecard.smallStraight;
  static int? _largeStraight(YahtzeeScorecard scorecard) =>
      scorecard.largeStraight;
  static int? _yahtzee(YahtzeeScorecard scorecard) => scorecard.yahtzee;
  static int? _chance(YahtzeeScorecard scorecard) => scorecard.chance;
}

class _FarkleSnapshot extends StatelessWidget {
  const _FarkleSnapshot({required this.players, required this.state});

  final List<SessionPlayer> players;
  final FarkleState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.casino_outlined),
            title: Text('Target score: ${state.targetScore}'),
            subtitle: Text(
              'Current player: ${_nameFor(state.currentPlayerId)}',
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (final player in players)
          Card(
            child: ListTile(
              title: Text(player.displayName),
              subtitle: Text(
                'Opened: ${(state.hasOpened[player.id] ?? false) ? 'Yes' : 'No'}',
              ),
              trailing: Text(
                '${state.playerTotals[player.id] ?? 0}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
      ],
    );
  }

  String _nameFor(String playerId) {
    return players
        .firstWhere(
          (player) => player.id == playerId,
          orElse: () => players.first,
        )
        .displayName;
  }
}

class _CribbageSnapshot extends StatelessWidget {
  const _CribbageSnapshot({required this.players, required this.state});

  final List<SessionPlayer> players;
  final CribbageState state;

  @override
  Widget build(BuildContext context) {
    final colors = {
      for (final player in players) player.id: _colorFromHex(player.colorHex),
    };
    return Column(
      children: [
        CribbageBoardWidget(positions: state.pegPositions, colors: colors),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            title: Text(
              'Dealer: ${players.firstWhere((player) => player.id == state.dealerId).displayName}',
            ),
            subtitle: Text('Hand ${state.handNumber}'),
          ),
        ),
        const SizedBox(height: 8),
        for (final player in players)
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _colorFromHex(player.colorHex),
              ),
              title: Text(player.displayName),
              subtitle: Text(
                'Front ${state.pegPositions[player.id]?.front ?? 0} • Rear ${state.pegPositions[player.id]?.rear ?? 0}',
              ),
            ),
          ),
      ],
    );
  }
}

class _FallbackSnapshotCard extends StatelessWidget {
  const _FallbackSnapshotCard({required this.rawStateJson});

  final String rawStateJson;

  @override
  Widget build(BuildContext context) {
    final decoded = jsonDecode(rawStateJson);
    final lines = <MapEntry<String, String>>[];
    _flatten(decoded, '', lines);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved game data',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final entry in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('${entry.key}: ${entry.value}'),
              ),
          ],
        ),
      ),
    );
  }

  void _flatten(
    dynamic value,
    String prefix,
    List<MapEntry<String, String>> lines,
  ) {
    if (value is Map<String, dynamic>) {
      for (final entry in value.entries) {
        _flatten(
          entry.value,
          prefix.isEmpty ? entry.key : '$prefix • ${entry.key}',
          lines,
        );
      }
      return;
    }
    if (value is List) {
      lines.add(MapEntry(prefix, value.join(', ')));
      return;
    }
    lines.add(MapEntry(prefix, '${value ?? '—'}'));
  }
}

class _CustomSnapshot extends StatelessWidget {
  const _CustomSnapshot({
    required this.players,
    required this.state,
    required this.scoreEntries,
  });

  final List<SessionPlayer> players;
  final CustomGameState state;
  final List<db.ScoreEntry> scoreEntries;

  @override
  Widget build(BuildContext context) {
    final cellScores = _buildCellScores(scoreEntries);
    final totals = _buildTotals(players, cellScores);
    final leaders = _customLeaders(players, totals, state.scoreDirection);
    final highestRecordedRound = cellScores.keys.isEmpty
        ? 0
        : cellScores.keys.reduce((a, b) => a > b ? a : b);
    final roundCount = [
      state.roundLabels.length,
      highestRecordedRound,
      1,
    ].reduce((a, b) => a > b ? a : b);
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: Icon(
              Icons.scoreboard_outlined,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            title: Text(state.gameName),
            subtitle: Text(
              state.scoreDirection == ScoreDirection.highWins
                  ? 'Highest total wins'
                  : 'Lowest total wins',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  children: [
                    _tableCell(context, 'Round', header: true),
                    for (final player in players)
                      _tableCell(
                        context,
                        player.displayName,
                        header: true,
                        highlight: leaders.contains(player.id),
                      ),
                  ],
                ),
                for (var round = 1; round <= roundCount; round++)
                  TableRow(
                    children: [
                      _tableCell(
                        context,
                        state.roundLabels.length >= round
                            ? state.roundLabels[round - 1]
                            : 'Round $round',
                      ),
                      for (final player in players)
                        _tableCell(
                          context,
                          '${cellScores[round]?[player.id] ?? '—'}',
                          highlight: leaders.contains(player.id),
                        ),
                    ],
                  ),
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  children: [
                    _tableCell(context, 'Total', header: true),
                    for (final player in players)
                      _tableCell(
                        context,
                        '${totals[player.id] ?? 0}',
                        header: true,
                        highlight: leaders.contains(player.id),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _tableCell(
  BuildContext context,
  String text, {
  bool header = false,
  bool highlight = false,
}) {
  final theme = Theme.of(context);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    color: highlight
        ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.55)
        : null,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: (header ? theme.textTheme.titleSmall : theme.textTheme.bodyMedium)
          ?.copyWith(
            fontWeight: header ? FontWeight.w600 : FontWeight.w400,
            color: highlight ? theme.colorScheme.onTertiaryContainer : null,
          ),
    ),
  );
}

Map<int, Map<String, int>> _buildCellScores(List<db.ScoreEntry> entries) {
  final scores = <int, Map<String, int>>{};
  final sorted = [...entries]
    ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
  for (final entry in sorted) {
    scores.putIfAbsent(
      entry.roundNumber,
      () => <String, int>{},
    )[entry.playerId] = entry.value;
  }
  return scores;
}

Map<String, int> _buildTotals(
  List<SessionPlayer> players,
  Map<int, Map<String, int>> cellScores,
) {
  final totals = <String, int>{for (final player in players) player.id: 0};
  for (final roundScores in cellScores.values) {
    roundScores.forEach((playerId, value) {
      totals[playerId] = (totals[playerId] ?? 0) + value;
    });
  }
  return totals;
}

Set<String> _customLeaders(
  List<SessionPlayer> players,
  Map<String, int> totals,
  ScoreDirection direction,
) {
  if (players.isEmpty) {
    return const <String>{};
  }
  final values = players.map((player) => totals[player.id] ?? 0).toList();
  final best = direction == ScoreDirection.highWins
      ? values.reduce((a, b) => a > b ? a : b)
      : values.reduce((a, b) => a < b ? a : b);
  return players
      .where((player) => (totals[player.id] ?? 0) == best)
      .map((player) => player.id)
      .toSet();
}

Color _colorFromHex(String value) {
  final normalized = value.replaceAll('#', '');
  return Color(int.parse('FF$normalized', radix: 16));
}
