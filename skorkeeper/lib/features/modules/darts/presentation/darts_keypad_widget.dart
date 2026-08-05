import 'package:flutter/material.dart';

class DartsKeypadWidget extends StatefulWidget {
  const DartsKeypadWidget({
    required this.onConfirmThrow,
    required this.previewBuilder,
    super.key,
  });

  final Future<void> Function(int score, int multiplier) onConfirmThrow;
  final String Function(int score, int multiplier) previewBuilder;

  @override
  State<DartsKeypadWidget> createState() => _DartsKeypadWidgetState();
}

class _DartsKeypadWidgetState extends State<DartsKeypadWidget> {
  int _selectedScore = 20;
  int _selectedMultiplier = 1;

  @override
  Widget build(BuildContext context) {
    final isBullSelected = _selectedScore == 25;
    final preview = widget.previewBuilder(_selectedScore, _selectedMultiplier);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Throw Preview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              preview,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final multiplier in isBullSelected ? [1, 2] : [1, 2, 3])
                  ChoiceChip(
                    label: Text('×$multiplier'),
                    selected: _selectedMultiplier == multiplier,
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    showCheckmark: false,
                    labelStyle: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(
                          color: _selectedMultiplier == multiplier
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                    onSelected: (selected) {
                      if (!selected) {
                        return;
                      }
                      setState(() {
                        _selectedMultiplier = multiplier;
                        if (_selectedScore == 25 && _selectedMultiplier == 3) {
                          _selectedMultiplier = 2;
                        }
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.2,
              children: [
                for (var score = 1; score <= 20; score++)
                  _ScoreButton(
                    label: score.toString(),
                    selected: _selectedScore == score,
                    onTap: () => setState(() => _selectedScore = score),
                  ),
                _ScoreButton(
                  label: 'Bull',
                  selected: _selectedScore == 25,
                  onTap: () => setState(() {
                    _selectedScore = 25;
                    if (_selectedMultiplier == 3) {
                      _selectedMultiplier = 2;
                    }
                  }),
                ),
                _ScoreButton(
                  label: 'Miss',
                  selected: _selectedScore == 0,
                  onTap: () => setState(() {
                    _selectedScore = 0;
                    _selectedMultiplier = 1;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () =>
                  widget.onConfirmThrow(_selectedScore, _selectedMultiplier),
              icon: const Icon(Icons.sports_score),
              label: const Text('Confirm Throw'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreButton extends StatelessWidget {
  const _ScoreButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: selected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
