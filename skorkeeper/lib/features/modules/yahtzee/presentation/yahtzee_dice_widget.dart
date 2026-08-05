import 'package:flutter/material.dart';

import '../../../../ui/widgets/die_widget.dart';

class YahtzeeDiceWidget extends StatelessWidget {
  const YahtzeeDiceWidget({
    required this.values,
    required this.held,
    required this.heldAtRoll,
    required this.onToggleHold,
    required this.onRoll,
    required this.rollsUsed,
    super.key,
  });

  final List<int> values;
  final List<bool> held;
  final List<int> heldAtRoll;
  final ValueChanged<int> onToggleHold;
  final VoidCallback onRoll;
  final int rollsUsed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (var i = 0; i < values.length; i++)
                  GestureDetector(
                    onTap: () => onToggleHold(i),
                    child: _YahtzeeDie(
                      value: values[i],
                      held: held[i],
                      heldFromPreviousRoll:
                          held[i] &&
                          heldAtRoll[i] > 0 &&
                          heldAtRoll[i] < rollsUsed,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: rollsUsed >= 3 ? null : onRoll,
              icon: const Icon(Icons.casino),
              label: Text('Roll (${3 - rollsUsed} left)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _YahtzeeDie extends StatelessWidget {
  const _YahtzeeDie({
    required this.value,
    required this.held,
    required this.heldFromPreviousRoll,
  });

  final int value;
  final bool held;
  final bool heldFromPreviousRoll;

  @override
  Widget build(BuildContext context) {
    final borderColor = held
        ? (heldFromPreviousRoll
              ? Theme.of(context).colorScheme.secondary
              : Colors.green)
        : Colors.transparent;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: held
            ? (heldFromPreviousRoll
                  ? Theme.of(
                      context,
                    ).colorScheme.secondaryContainer.withValues(alpha: 0.35)
                  : Colors.green.withValues(alpha: 0.12))
            : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 3),
      ),
      child: DieWidget(value: value, animateRoll: false),
    );
  }
}
