import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/models/session_player.dart';
import '../../../../core/modules/score_action.dart';
import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../features/shared_session/rules_sheet.dart';
import '../../../../ui/widgets/leaderboard_row.dart';
import '../domain/farkle_module.dart';
import '../domain/farkle_state.dart';

class FarkleSessionScreen extends ConsumerStatefulWidget {
  const FarkleSessionScreen({required this.sessionId, super.key});

  final int sessionId;

  @override
  ConsumerState<FarkleSessionScreen> createState() =>
      _FarkleSessionScreenState();
}

class _FarkleSessionScreenState extends ConsumerState<FarkleSessionScreen> {
  final _random = Random();

  // Which dice are held (set aside for scoring) this turn – local state only
  List<bool> _heldDice = List.filled(6, false);
  List<int> _rollBatchByDie = List.filled(6, 0);
  int _currentRollBatch = 0;
  bool _hasFarkled = false;
  bool _hasRolled = false;

  void _resetTurnState() {
    setState(() {
      _heldDice = List.filled(6, false);
      _rollBatchByDie = List.filled(6, 0);
      _currentRollBatch = 0;
      _hasFarkled = false;
      _hasRolled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(appDatabaseProvider);
    return StreamBuilder<db.GameSession?>(
      stream: (database.select(
        database.gameSessions,
      )..where((tbl) => tbl.id.equals(widget.sessionId))).watchSingleOrNull(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final session = snapshot.data;
        if (session == null) {
          return const Scaffold(
            body: Center(child: Text('Session unavailable.')),
          );
        }
        final players = _parsePlayers(session.participantsJson);
        final state = FarkleState.fromJson(
          jsonDecode(session.moduleStateJson) as Map<String, dynamic>,
        );
        final module = FarkleModule(targetScore: state.targetScore);
        final currentPlayer = players.firstWhere(
          (player) => player.id == state.currentPlayerId,
          orElse: () => players.first,
        );
        final standings = module
            .leaderboard(state)
            .map(
              (entry) => entry.copyWith(
                displayName: players
                    .firstWhere(
                      (player) => player.id == entry.playerId,
                      orElse: () => currentPlayer,
                    )
                    .displayName,
                colorHex: players
                    .firstWhere(
                      (player) => player.id == entry.playerId,
                      orElse: () => currentPlayer,
                    )
                    .colorHex,
              ),
            )
            .toList();

        if (state.gameOver && state.winnerId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final winner = players.firstWhere(
              (player) => player.id == state.winnerId,
              orElse: () => currentPlayer,
            );
            await ref
                .read(activeSessionsNotifierProvider.notifier)
                .endSession(
                  session.id,
                  winner.displayName,
                  jsonEncode(state.toJson()),
                );
            if (context.mounted) {
              context.go('/home/session/${session.id}/summary');
            }
          });
        }

        // Count how many dice are still in play (not held)
        final heldCount = _heldDice.where((h) => h).length;
        final diceInPlay = 6 - heldCount;

        // Compute potential score from held dice
        final heldValues = [
          for (var i = 0; i < state.currentTurnDice.length; i++)
            if (_heldDice[i])
              _ScoringDie(
                value: state.currentTurnDice[i],
                rollBatch: _rollBatchByDie[i],
              ),
        ];
        final heldScore = _estimateScore(heldValues).score;
        final currentRollHeldValues = [
          for (var i = 0; i < state.currentTurnDice.length; i++)
            if (_heldDice[i] && _rollBatchByDie[i] == _currentRollBatch)
              _ScoringDie(
                value: state.currentTurnDice[i],
                rollBatch: _rollBatchByDie[i],
              ),
        ];
        final currentRollHeldScore = _estimateScore(
          currentRollHeldValues,
        ).score;
        final turnScore = state.currentTurnScore + currentRollHeldScore;
        final hasHeldNewScoringDie =
            !_hasRolled || currentRollHeldScore > 0 || _currentRollBatch == 0;
        final isHotDice = _hasRolled && diceInPlay == 0;
        final canRoll =
            !_hasFarkled &&
            (diceInPlay > 0 || isHotDice) &&
            hasHeldNewScoringDie;
        final canBank =
            (state.currentTurnScore > 0 || heldScore > 0) &&
            turnScore >= 500;
        final currentHints = _buildScoringHints([
          for (var i = 0; i < state.currentTurnDice.length; i++)
            _ScoringDie(
              value: state.currentTurnDice[i],
              rollBatch: _rollBatchByDie[i],
            ),
        ]);

        return Scaffold(
          appBar: AppBar(
            title: Text(session.sessionName ?? module.displayName),
            actions: [
              IconButton(
                tooltip: 'Help',
                onPressed: () => _showRules(context),
                icon: const Icon(Icons.help_outline),
              ),
              TextButton(
                onPressed: () async {
                  final winner = standings.isEmpty
                      ? currentPlayer.displayName
                      : standings.first.displayName;
                  await ref
                      .read(activeSessionsNotifierProvider.notifier)
                      .endSession(
                        session.id,
                        winner,
                        jsonEncode(state.toJson()),
                      );
                  if (context.mounted) {
                    context.go('/home/session/${session.id}/summary');
                  }
                },
                child: const Text('End Game'),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Current player info ──────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _hasFarkled
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      _hasFarkled
                          ? 'FARKLE! 😱 Turn lost!'
                          : currentPlayer.displayName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _hasFarkled
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Turn score: $turnScore  •  Target: ${state.targetScore}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _hasFarkled
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    if (heldCount > 0 && !_hasFarkled) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Held dice score: $heldScore',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Dice grid ────────────────────────────────
              if (_hasRolled)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    hasHeldNewScoringDie
                        ? 'Tap dice to hold them for scoring'
                        : 'Hold at least 1 newly rolled scoring die before rolling again',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: hasHeldNewScoringDie
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < state.currentTurnDice.length; i++)
                    _DieButton(
                      value: state.currentTurnDice[i],
                      held: _heldDice[i],
                      heldFromPrevious:
                          _heldDice[i] &&
                          _rollBatchByDie[i] < _currentRollBatch,
                      enabled:
                          _hasRolled &&
                          !_hasFarkled &&
                          _rollBatchByDie[i] == _currentRollBatch,
                      onTap:
                          _hasRolled &&
                              !_hasFarkled &&
                              _rollBatchByDie[i] == _currentRollBatch
                          ? () => setState(() => _heldDice[i] = !_heldDice[i])
                          : null,
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Action buttons ────────────────────────────
              if (_hasFarkled) ...[
                FilledButton.icon(
                  onPressed: () async {
                    final nextState =
                        const FarkleModule().applyAction(
                              state,
                              const FarkleFarkled(),
                            )
                            as FarkleState;
                    await ref
                        .read(activeSessionsNotifierProvider.notifier)
                        .recordScore(
                          session.id,
                          const FarkleFarkled(),
                          jsonEncode(nextState.toJson()),
                        );
                    _resetTurnState();
                  },
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Next Player'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: canRoll
                            ? () => _rollDice(session, state)
                            : null,
                        icon: const Icon(Icons.casino_outlined),
                        label: Text(
                          isHotDice
                              ? 'Hot Dice! Roll All 6'
                              : (_hasRolled
                                  ? 'Roll ($diceInPlay dice)'
                                  : 'Roll All Dice'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: canBank
                            ? () => _bank(session, state, currentRollHeldScore)
                            : null,
                        icon: const Icon(Icons.savings_outlined),
                        label: const Text('Bank Score'),
                      ),
                    ),
                  ],
                ),
                if (turnScore > 0 && turnScore < 500)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Need 500 to bank • current: $turnScore',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _showScoringHints(context, currentHints),
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('Scoring Hints'),
              ),
              const SizedBox(height: 16),

              // ── Leaderboard ──────────────────────────────
              for (final entry in standings) LeaderboardRow(entry: entry),
            ],
          ),
        );
      },
    );
  }

  List<SessionPlayer> _parsePlayers(String json) {
    final raw = jsonDecode(json) as List<dynamic>;
    return raw
        .map((item) => SessionPlayer.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _rollDice(db.GameSession session, FarkleState state) async {
    final currentRollHeldValues = [
      for (var i = 0; i < state.currentTurnDice.length; i++)
        if (_heldDice[i] && _rollBatchByDie[i] == _currentRollBatch)
          _ScoringDie(
            value: state.currentTurnDice[i],
            rollBatch: _rollBatchByDie[i],
          ),
    ];
    final currentRollHeldScore = _estimateScore(currentRollHeldValues).score;
    if (_hasRolled && currentRollHeldScore == 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Hold at least 1 newly rolled scoring die before rolling again.',
            ),
          ),
        );
      }
      return;
    }

    // Determine which dice indices to roll (those not held)
    final indicesToRoll = [
      for (var i = 0; i < 6; i++)
        if (!_heldDice[i]) i,
    ];

    if (indicesToRoll.isEmpty) {
      // HOT DICE: all 6 dice scored — roll all 6 again
      final newBatch = _currentRollBatch + 1;
      final newDice = List.generate(6, (_) => _random.nextInt(6) + 1);
      final rolledValues = [
        for (final v in newDice)
          _ScoringDie(value: v, rollBatch: newBatch),
      ];
      final rolledScore = _estimateScore(rolledValues);
      final accumulated = state.currentTurnScore + currentRollHeldScore;
      if (rolledScore.score == 0) {
        // Farkle on hot dice re-roll
        final farkleDiceState = state.copyWith(
          currentTurnDice: newDice,
          currentTurnScore: accumulated,
          diceBanked: 0,
        );
        await ref
            .read(appDatabaseProvider)
            .sessionDao
            .updateModuleState(session.id, jsonEncode(farkleDiceState.toJson()));
        setState(() {
          _hasFarkled = true;
          _hasRolled = true;
          _heldDice = List.filled(6, false);
          _rollBatchByDie = List.filled(6, 0);
          _currentRollBatch = 0;
        });
        return;
      }
      final updatedState = state.copyWith(
        currentTurnDice: newDice,
        currentTurnScore: accumulated,
        diceBanked: 0,
      );
      await ref
          .read(appDatabaseProvider)
          .sessionDao
          .updateModuleState(session.id, jsonEncode(updatedState.toJson()));
      setState(() {
        _hasRolled = true;
        _currentRollBatch = newBatch;
        _heldDice = List.filled(6, false);
        _rollBatchByDie = List.filled(6, newBatch);
      });
      return;
    }

    // Build new dice list keeping held values
    final newDice = [...state.currentTurnDice];
    final nextRollBatch = _currentRollBatch + 1;
    for (final i in indicesToRoll) {
      newDice[i] = _random.nextInt(6) + 1;
    }

    // Check if any of the newly rolled dice (not held) are scoring
    final rolledValues = [
      for (final i in indicesToRoll)
        _ScoringDie(value: newDice[i], rollBatch: nextRollBatch),
    ];
    final scored = _estimateScore(rolledValues);

    if (scored.score == 0) {
      // FARKLE! Save the rolled dice so they're visible before turn advances.
      // The turn will advance when the player taps "Next Player".
      final farkleDiceState = state.copyWith(
        currentTurnDice: newDice,
        diceBanked: _heldDice.where((held) => held).length,
      );
      await ref
          .read(appDatabaseProvider)
          .sessionDao
          .updateModuleState(session.id, jsonEncode(farkleDiceState.toJson()));
      setState(() {
        _hasFarkled = true;
        _hasRolled = true;
        _rollBatchByDie = List.filled(6, 0);
      });
      return;
    }

    // Update the dice display in DB without advancing turn
    final updatedState = state.copyWith(
      currentTurnDice: newDice,
      currentTurnScore: state.currentTurnScore + currentRollHeldScore,
      diceBanked: _heldDice.where((held) => held).length,
    );
    await ref
        .read(appDatabaseProvider)
        .sessionDao
        .updateModuleState(session.id, jsonEncode(updatedState.toJson()));

    setState(() {
      _hasRolled = true;
      _currentRollBatch = nextRollBatch;
      // Reset held state for non-held dice (newly rolled ones)
      for (final i in indicesToRoll) {
        _heldDice[i] = false;
        _rollBatchByDie[i] = nextRollBatch;
      }
    });
  }

  Future<void> _bank(
    db.GameSession session,
    FarkleState state,
    int currentRollHeldScore,
  ) async {
    final totalTurnScore = state.currentTurnScore + currentRollHeldScore;
    final action = FarkleBankScore(turnScore: totalTurnScore);
    final nextState =
        const FarkleModule().applyAction(state, action) as FarkleState;
    await ref
        .read(activeSessionsNotifierProvider.notifier)
        .recordScore(session.id, action, jsonEncode(nextState.toJson()));
    _resetTurnState();
  }

  Future<void> _showScoringHints(
    BuildContext context,
    List<String> currentHints,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Farkle Scoring Hints',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Current dice',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              for (final hint in currentHints)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('• $hint'),
                ),
              const SizedBox(height: 12),
              Text(
                'Quick rules',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text('• Single 1 = 100 points'),
              const Text('• Single 5 = 50 points'),
              const Text('• Three 1s rolled together = 1000 points'),
              const Text('• Three 2s–6s rolled together = face value × 100'),
              const Text(
                '• Three of a kind only counts when all three dice were rolled together.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRules(BuildContext context) {
    showRulesSheet(
      context,
      title: 'Farkle rules',
      summary:
          'Roll and bank points, but a non-scoring roll loses the whole turn.',
      bullets: const [
        '1s are worth 100 points and 5s are worth 50 points.',
        'Three of a kind, straights, and other combos score larger bonuses.',
        'Bank before you farkle or you lose the turn’s unbanked points.',
      ],
    );
  }
}

// ── Tappable die button ──────────────────────────────────────────────────────

class _DieButton extends StatelessWidget {
  const _DieButton({
    required this.value,
    required this.held,
    required this.enabled,
    required this.onTap,
    this.heldFromPrevious = false,
  });

  final int value;
  final bool held;
  final bool heldFromPrevious;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = heldFromPrevious
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.primary;
    final bgColor = heldFromPrevious
        ? Theme.of(
            context,
          ).colorScheme.secondaryContainer.withValues(alpha: 0.4)
        : Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.45);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: held ? bgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: held
              ? Border.all(color: borderColor, width: 3)
              : Border.all(color: Colors.transparent, width: 3),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _DieFace(value: value, size: 60),
            if (held)
              Positioned(
                bottom: 2,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    heldFromPrevious ? 'LOCK' : 'HOLD',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Minimal die face painter (embedded to avoid DieWidget size constraints)
class _DieFace extends StatelessWidget {
  const _DieFace({required this.value, required this.size});
  final int value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _DieFacePainter(value: value),
    );
  }
}

class _DieFacePainter extends CustomPainter {
  const _DieFacePainter({required this.value});
  final int value;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = Colors.white;
    final stroke = Paint()
      ..color = const Color(0xFF0C2340)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final pipPaint = Paint()..color = const Color(0xFF0C2340);
    final radius = Radius.circular(size.width * 0.18);
    final rect = Offset.zero & size;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), fill);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), stroke);
    for (final offset in _pipOffsets(value)) {
      canvas.drawCircle(offset * size.width, size.width * 0.07, pipPaint);
    }
  }

  List<Offset> _pipOffsets(int face) {
    const tl = Offset(0.28, 0.28);
    const tr = Offset(0.72, 0.28);
    const ml = Offset(0.28, 0.5);
    const mc = Offset(0.5, 0.5);
    const mr = Offset(0.72, 0.5);
    const bl = Offset(0.28, 0.72);
    const br = Offset(0.72, 0.72);
    switch (face.clamp(1, 6)) {
      case 1:
        return const [mc];
      case 2:
        return const [tl, br];
      case 3:
        return const [tl, mc, br];
      case 4:
        return const [tl, tr, bl, br];
      case 5:
        return const [tl, tr, mc, bl, br];
      default:
        return const [tl, tr, ml, mr, bl, br];
    }
  }

  @override
  bool shouldRepaint(covariant _DieFacePainter oldDelegate) =>
      oldDelegate.value != value;
}

class _ScoringDie {
  const _ScoringDie({required this.value, required this.rollBatch});

  final int value;
  final int rollBatch;
}

({int score, int usedDice}) _estimateScore(List<_ScoringDie> dice) {
  if (dice.isEmpty) return (score: 0, usedDice: 0);
  final countsByBatch = <int, Map<int, int>>{};
  for (final die in dice) {
    final batchCounts = countsByBatch.putIfAbsent(die.rollBatch, () => {});
    batchCounts[die.value] = (batchCounts[die.value] ?? 0) + 1;
  }
  var score = 0;
  var usedDice = 0;
  for (final batchCounts in countsByBatch.values) {
    batchCounts.forEach((value, count) {
      if (count >= 3) {
        score += value == 1 ? 1000 : value * 100;
        usedDice += 3;
        count -= 3;
      }
      if (value == 1 && count > 0) {
        score += count * 100;
        usedDice += count;
      } else if (value == 5 && count > 0) {
        score += count * 50;
        usedDice += count;
      }
    });
  }
  return (score: score, usedDice: usedDice);
}

List<String> _buildScoringHints(List<_ScoringDie> dice) {
  if (dice.isEmpty) {
    return const ['Roll the dice to see available scoring combinations.'];
  }
  final hints = <String>[];
  final countsByBatch = <int, Map<int, int>>{};
  for (final die in dice) {
    final batchCounts = countsByBatch.putIfAbsent(die.rollBatch, () => {});
    batchCounts[die.value] = (batchCounts[die.value] ?? 0) + 1;
  }
  for (final batchCounts in countsByBatch.values) {
    batchCounts.forEach((value, count) {
      if (count >= 3) {
        hints.add(
          'Three $value${value == 1 ? 's' : 's'} together = ${value == 1 ? 1000 : value * 100} points',
        );
        count -= 3;
      }
      if (value == 1 && count > 0) {
        hints.add('Single 1 × $count = ${count * 100} points');
      } else if (value == 5 && count > 0) {
        hints.add('Single 5 × $count = ${count * 50} points');
      }
    });
  }
  if (hints.isEmpty) {
    return const ['No scoring combinations on the current roll.'];
  }
  return hints;
}
