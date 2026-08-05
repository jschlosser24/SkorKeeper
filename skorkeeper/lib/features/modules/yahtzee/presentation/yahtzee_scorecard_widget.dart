import 'package:flutter/material.dart';

import '../../../../core/models/session_player.dart';
import '../domain/yahtzee_module.dart';
import '../domain/yahtzee_state.dart';

class YahtzeeScorecardWidget extends StatelessWidget {
  const YahtzeeScorecardWidget({
    required this.players,
    required this.state,
    required this.module,
    required this.onSelectCategory,
    super.key,
  });

  final List<SessionPlayer> players;
  final YahtzeeState state;
  final YahtzeeModule module;
  final Future<void> Function(
    String playerId,
    YahtzeeCategory category, {
    int? manualScore,
    bool? yahtzeeBonus,
  }) onSelectCategory;

  static const _upperCategories = [
    YahtzeeCategory.ones,
    YahtzeeCategory.twos,
    YahtzeeCategory.threes,
    YahtzeeCategory.fours,
    YahtzeeCategory.fives,
    YahtzeeCategory.sixes,
  ];

  static const _lowerCategories = [
    YahtzeeCategory.threeOfAKind,
    YahtzeeCategory.fourOfAKind,
    YahtzeeCategory.fullHouse,
    YahtzeeCategory.smallStraight,
    YahtzeeCategory.largeStraight,
    YahtzeeCategory.yahtzee,
    YahtzeeCategory.chance,
  ];

  @override
  Widget build(BuildContext context) {
    final currentPlayerId = state.playerOrder[state.currentPlayerIndex];
    final theme = Theme.of(context);
    final headerBg = theme.colorScheme.surfaceContainerHighest;
    final sectionBg = theme.colorScheme.primaryContainer.withValues(alpha: 0.3);
    final selectedColor = theme.colorScheme.primary;
    final selectedTextColor = Colors.white;
    final dividerColor = theme.colorScheme.outlineVariant;

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 300),
          child: Column(
            children: [
              // ── Header row ──────────────────────────────────
              _buildHeaderRow(context, headerBg),
              const Divider(height: 1),

              // ── UPPER SECTION ──────────────────────────────
              _buildSectionLabel(context, 'UPPER SECTION', sectionBg),
              for (final cat in _upperCategories)
                _buildCategoryRow(
                  context,
                  cat,
                  currentPlayerId,
                  selectedColor,
                  selectedTextColor,
                  dividerColor,
                ),
              // Upper bonus row
              _buildBonusRow(context, currentPlayerId, headerBg),
              // Upper subtotal
              _buildSubtotalRow(
                context,
                'Upper Total',
                currentPlayerId,
                _upperSubtotal,
                headerBg,
              ),

              // ── LOWER SECTION ──────────────────────────────
              _buildSectionLabel(context, 'LOWER SECTION', sectionBg),
              for (final cat in _lowerCategories)
                _buildCategoryRow(
                  context,
                  cat,
                  currentPlayerId,
                  selectedColor,
                  selectedTextColor,
                  dividerColor,
                ),
              // Yahtzee Bonus row
              _buildYahtzeeBonusRow(context, headerBg),
              // Grand total row
              _buildSubtotalRow(
                context,
                'GRAND TOTAL',
                currentPlayerId,
                _grandTotal,
                headerBg,
                bold: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context, Color bg) {
    final theme = Theme.of(context);
    final currentPlayerId = state.playerOrder[state.currentPlayerIndex];
    return Container(
      color: bg,
      child: Row(
        children: [
          _cell(context, 'Category', width: 130, isHeader: true),
          for (final player in players)
            _playerHeaderCell(
              context,
              player.displayName,
              isActive: player.id == currentPlayerId,
              theme: theme,
            ),
        ],
      ),
    );
  }

  Widget _playerHeaderCell(
    BuildContext context,
    String name, {
    required bool isActive,
    required ThemeData theme,
  }) {
    final bg = isActive
        ? (theme.brightness == Brightness.dark
                ? theme.colorScheme.secondaryContainer
                : theme.colorScheme.primaryContainer)
            .withValues(alpha: 0.8)
        : null;
    return Container(
      width: 72,
      height: 40,
      alignment: Alignment.center,
      decoration: bg != null ? BoxDecoration(color: bg) : null,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: isActive
              ? (theme.brightness == Brightness.dark
                  ? theme.colorScheme.onSecondaryContainer
                  : theme.colorScheme.onPrimaryContainer)
              : (theme.brightness == Brightness.light
                  ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55)
                  : theme.colorScheme.onSurfaceVariant),
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label, Color bg) {
    return Container(
      color: bg,
      child: Row(
        children: [
          _cell(context, label, width: 130, isHeader: true, bold: true),
          for (final _ in players) _cell(context, '', isHeader: true),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    YahtzeeCategory category,
    String currentPlayerId,
    Color selectedColor,
    Color selectedTextColor,
    Color dividerColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor, width: 0.5)),
      ),
      child: Row(
        children: [
          _cell(context, _label(category), width: 130),
          for (final player in players)
            _buildScoreCell(
              context,
              player,
              category,
              currentPlayerId,
              selectedColor,
              selectedTextColor,
            ),
        ],
      ),
    );
  }

  Widget _buildScoreCell(
    BuildContext context,
    SessionPlayer player,
    YahtzeeCategory category,
    String currentPlayerId,
    Color selectedColor,
    Color selectedTextColor,
  ) {
    final scorecard = state.scorecards[player.id]!;
    final locked = _scoreFor(scorecard, category);
    final isLocked = locked != null;
    final isCurrent = player.id == currentPlayerId;
    final canSelect = isCurrent &&
        !isLocked &&
        (state.useRealDice || state.currentRollNumber > 0);

    // Detect Joker in app-dice mode for potential score display.
    final isJokerRoll = !state.useRealDice &&
        state.currentRollNumber > 0 &&
        state.diceValues.toSet().length == 1 &&
        scorecard.yahtzee == 50;

    final potential = isCurrent && !isLocked && !state.useRealDice
        ? module.computeCategoryScore(
            state.diceValues,
            category,
            scorecard,
            isJoker: isJokerRoll,
          )
        : null;

    final bg = isLocked ? selectedColor.withValues(alpha: 0.15) : null;
    final textColor = isLocked
        ? selectedColor
        : (canSelect && potential != null && potential > 0
              ? _highlightColor(context)
              : Theme.of(context).colorScheme.onSurfaceVariant);

    // Yahtzee bonus count display (locked cell only).
    final bonusCount =
        category == YahtzeeCategory.yahtzee ? scorecard.yahtzeeBonusCount : 0;

    Future<void> handleTap() async {
      if (state.useRealDice) {
        final canHaveBonus = scorecard.yahtzee == 50 &&
            category != YahtzeeCategory.yahtzee;
        final result = await _showManualScoreDialog(
          context,
          category,
          canShowBonus: canHaveBonus,
        );
        if (result != null) {
          await onSelectCategory(
            player.id,
            category,
            manualScore: result.score,
            yahtzeeBonus: result.isYahtzeeBonus,
          );
        }
      } else {
        await onSelectCategory(
          player.id,
          category,
          yahtzeeBonus: isJokerRoll,
        );
      }
    }

    String cellText() {
      if (isLocked) {
        if (bonusCount > 0) return '50+$bonusCount×';
        return locked.toString();
      }
      if (state.useRealDice) return canSelect ? '?' : '—';
      return canSelect ? (potential?.toString() ?? '—') : '—';
    }

    return GestureDetector(
      onTap: canSelect ? handleTap : null,
      child: Container(
        width: 72,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        child: Text(
          cellText(),
          style: TextStyle(
            color: textColor,
            fontWeight: isLocked ? FontWeight.w700 : FontWeight.w400,
            fontSize: isLocked ? 15 : 13,
          ),
        ),
      ),
    );
  }

  /// Return type carrying both the entered score and whether a Yahtzee bonus was claimed.
  Future<({int score, bool isYahtzeeBonus})?> _showManualScoreDialog(
    BuildContext context,
    YahtzeeCategory category, {
    required bool canShowBonus,
  }) async {
    final label = _label(category);
    final faceValue = _upperFaceValue(category);
    if (faceValue != null) {
      // Upper section: show multiples buttons.
      return _showUpperSectionDialog(
        context,
        label: label,
        faceValue: faceValue,
        canShowBonus: canShowBonus,
      );
    }
    final fixedScore = _fixedScore(category);
    if (fixedScore != null) {
      // Fixed-score lower categories.
      return _showFixedScoreDialog(
        context,
        label: label,
        fixedScore: fixedScore,
        canShowBonus: canShowBonus,
      );
    }
    // Variable lower categories: 3-of-a-kind, 4-of-a-kind, Chance.
    return _showVariableScoreDialog(
      context,
      label: label,
      canShowBonus: canShowBonus,
    );
  }

  Future<({int score, bool isYahtzeeBonus})?> _showUpperSectionDialog(
    BuildContext context, {
    required String label,
    required int faceValue,
    required bool canShowBonus,
  }) async {
    final multiples = List.generate(6, (i) => faceValue * i); // 0,N,2N…5N
    bool bonusChecked = false;
    return showDialog<({int score, bool isYahtzeeBonus})>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(label),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('How many did you score?'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final value in multiples)
                    FilledButton.tonal(
                      onPressed: () => Navigator.pop(
                        ctx,
                        (score: value, isYahtzeeBonus: bonusChecked),
                      ),
                      child: Text(value == 0 ? 'Miss (0)' : '$value'),
                    ),
                ],
              ),
              if (canShowBonus) ...[
                const SizedBox(height: 12),
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: bonusChecked,
                  onChanged: (v) => setDialogState(() => bonusChecked = v!),
                  title: const Text('Yahtzee Bonus! (+100)'),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Future<({int score, bool isYahtzeeBonus})?> _showFixedScoreDialog(
    BuildContext context, {
    required String label,
    required int fixedScore,
    required bool canShowBonus,
  }) async {
    bool bonusChecked = false;
    return showDialog<({int score, bool isYahtzeeBonus})>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(label),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Did you score $fixedScore points or miss?'),
              if (canShowBonus) ...[
                const SizedBox(height: 12),
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: bonusChecked,
                  onChanged: (v) => setDialogState(() => bonusChecked = v!),
                  title: const Text('Yahtzee Bonus! (+100)'),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(
                ctx,
                (score: 0, isYahtzeeBonus: bonusChecked),
              ),
              child: const Text('Miss (0)'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(
                ctx,
                (score: fixedScore, isYahtzeeBonus: bonusChecked),
              ),
              child: Text('Score $fixedScore'),
            ),
          ],
        ),
      ),
    );
  }

  Future<({int score, bool isYahtzeeBonus})?> _showVariableScoreDialog(
    BuildContext context, {
    required String label,
    required bool canShowBonus,
  }) async {
    final controller = TextEditingController();
    bool bonusChecked = false;
    return showDialog<({int score, bool isYahtzeeBonus})>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(label),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Score',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (v) {
                  final parsed = int.tryParse(v);
                  if (parsed != null && parsed >= 0) {
                    Navigator.pop(
                      ctx,
                      (score: parsed, isYahtzeeBonus: bonusChecked),
                    );
                  }
                },
              ),
              if (canShowBonus) ...[
                const SizedBox(height: 12),
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: bonusChecked,
                  onChanged: (v) => setDialogState(() => bonusChecked = v!),
                  title: const Text('Yahtzee Bonus! (+100)'),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final parsed = int.tryParse(controller.text);
                if (parsed != null && parsed >= 0) {
                  Navigator.pop(
                    ctx,
                    (score: parsed, isYahtzeeBonus: bonusChecked),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  int? _fixedScore(YahtzeeCategory category) {
    switch (category) {
      case YahtzeeCategory.fullHouse:
        return 25;
      case YahtzeeCategory.smallStraight:
        return 30;
      case YahtzeeCategory.largeStraight:
        return 40;
      case YahtzeeCategory.yahtzee:
        return 50;
      default:
        return null;
    }
  }

  int? _upperFaceValue(YahtzeeCategory category) {
    switch (category) {
      case YahtzeeCategory.ones:
        return 1;
      case YahtzeeCategory.twos:
        return 2;
      case YahtzeeCategory.threes:
        return 3;
      case YahtzeeCategory.fours:
        return 4;
      case YahtzeeCategory.fives:
        return 5;
      case YahtzeeCategory.sixes:
        return 6;
      default:
        return null;
    }
  }

  Widget _buildYahtzeeBonusRow(BuildContext context, Color bg) {
    return Container(
      color: bg,
      child: Row(
        children: [
          _cell(context, 'Yahtzee Bonus (×100)', width: 130, isHeader: true),
          for (final player in players)
            _buildYahtzeeBonusCell(context, player),
        ],
      ),
    );
  }

  Widget _buildYahtzeeBonusCell(BuildContext context, SessionPlayer player) {
    final scorecard = state.scorecards[player.id]!;
    final count = scorecard.yahtzeeBonusCount;
    final bonusPts = count * 100;
    return Container(
      width: 72,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Text(
        count == 0 ? '—' : '+$bonusPts',
        style: TextStyle(
          color: count > 0
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: count > 0 ? FontWeight.w700 : FontWeight.w400,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildBonusRow(
    BuildContext context,
    String currentPlayerId,
    Color bg,
  ) {
    return Container(
      color: bg,
      child: Row(
        children: [
          _cell(context, 'Bonus (+35 if ≥63)', width: 130, isHeader: true),
          for (final player in players) _buildBonusCell(context, player),
        ],
      ),
    );
  }

  Widget _buildBonusCell(BuildContext context, SessionPlayer player) {
    final scorecard = state.scorecards[player.id]!;
    final upperSum = _upperSubtotal(scorecard);
    final bonus = upperSum >= 63 ? 35 : 0;
    final progress = upperSum.clamp(0, 63);
    return Container(
      width: 72,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            bonus > 0 ? '+35' : '$progress/63',
            style: TextStyle(
              color: bonus > 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: bonus > 0 ? FontWeight.w700 : FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtotalRow(
    BuildContext context,
    String label,
    String currentPlayerId,
    int Function(YahtzeeScorecard) compute,
    Color bg, {
    bool bold = false,
  }) {
    return Container(
      color: bg,
      child: Row(
        children: [
          _cell(context, label, width: 130, isHeader: true, bold: bold),
          for (final player in players)
            Container(
              width: 72,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              ),
              child: Text(
                compute(state.scorecards[player.id]!).toString(),
                style: TextStyle(
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  fontSize: bold ? 15 : 13,
                  color: bold
                      ? _highlightColor(context)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cell(
    BuildContext context,
    String text, {
    double width = 72,
    bool isHeader = false,
    bool highlighted = false,
    bool bold = false,
    Color? textColor,
  }) {
    return Container(
      width: width,
      height: isHeader ? 40 : 42,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      decoration: highlighted
          ? BoxDecoration(
              color:
                  (Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.primaryContainer)
                      .withValues(alpha: 0.5),
            )
          : null,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: (isHeader || bold) ? FontWeight.w600 : FontWeight.w400,
          fontSize: isHeader ? 11 : 13,
          color:
              textColor ??
              (isHeader
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : Theme.of(context).colorScheme.onSurface),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  int _upperSubtotal(YahtzeeScorecard sc) {
    return [
      sc.ones,
      sc.twos,
      sc.threes,
      sc.fours,
      sc.fives,
      sc.sixes,
    ].whereType<int>().fold<int>(0, (s, v) => s + v);
  }

  int _grandTotal(YahtzeeScorecard sc) => module.totalFor(sc);

  Color _highlightColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark
        ? theme.colorScheme.tertiary
        : theme.colorScheme.primary;
  }

  String _label(YahtzeeCategory category) {
    switch (category) {
      case YahtzeeCategory.ones:
        return 'Aces (1s)';
      case YahtzeeCategory.twos:
        return 'Twos';
      case YahtzeeCategory.threes:
        return 'Threes';
      case YahtzeeCategory.fours:
        return 'Fours';
      case YahtzeeCategory.fives:
        return 'Fives';
      case YahtzeeCategory.sixes:
        return 'Sixes';
      case YahtzeeCategory.threeOfAKind:
        return '3 of a Kind';
      case YahtzeeCategory.fourOfAKind:
        return '4 of a Kind';
      case YahtzeeCategory.fullHouse:
        return 'Full House (25)';
      case YahtzeeCategory.smallStraight:
        return 'Sm. Straight (30)';
      case YahtzeeCategory.largeStraight:
        return 'Lg. Straight (40)';
      case YahtzeeCategory.yahtzee:
        return 'Yahtzee! (50)';
      case YahtzeeCategory.chance:
        return 'Chance';
    }
  }

  int? _scoreFor(YahtzeeScorecard scorecard, YahtzeeCategory category) {
    switch (category) {
      case YahtzeeCategory.ones:
        return scorecard.ones;
      case YahtzeeCategory.twos:
        return scorecard.twos;
      case YahtzeeCategory.threes:
        return scorecard.threes;
      case YahtzeeCategory.fours:
        return scorecard.fours;
      case YahtzeeCategory.fives:
        return scorecard.fives;
      case YahtzeeCategory.sixes:
        return scorecard.sixes;
      case YahtzeeCategory.threeOfAKind:
        return scorecard.threeOfAKind;
      case YahtzeeCategory.fourOfAKind:
        return scorecard.fourOfAKind;
      case YahtzeeCategory.fullHouse:
        return scorecard.fullHouse;
      case YahtzeeCategory.smallStraight:
        return scorecard.smallStraight;
      case YahtzeeCategory.largeStraight:
        return scorecard.largeStraight;
      case YahtzeeCategory.yahtzee:
        return scorecard.yahtzee;
      case YahtzeeCategory.chance:
        return scorecard.chance;
    }
  }
}
