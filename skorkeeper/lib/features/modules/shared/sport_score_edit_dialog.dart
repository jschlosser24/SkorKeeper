import 'package:flutter/material.dart';

/// Result payload returned from [SportScoreEditDialog.show].
class SportScoreEditResult {
  const SportScoreEditResult({
    required this.homeScore,
    required this.awayScore,
    this.period,
    this.remainingSeconds,
  });

  final int homeScore;
  final int awayScore;

  /// Edited period/quarter/half/set number, or null if not editable.
  final int? period;

  /// Edited remaining countdown clock time in seconds, or null if the sport
  /// has no countdown clock.
  final int? remainingSeconds;
}

/// Centered dialog for manually correcting a sport game's score, current
/// period, and (optionally) the remaining countdown clock time.
///
/// Shared across all non-baseball sport game screens (basketball, football,
/// hockey, lacrosse, soccer, tennis, volleyball) so corrections behave
/// consistently everywhere.
class SportScoreEditDialog extends StatefulWidget {
  const SportScoreEditDialog({
    required this.homeName,
    required this.awayName,
    required this.homeScore,
    required this.awayScore,
    this.period,
    this.periodLabel = 'Period',
    this.remainingSeconds,
    super.key,
  });

  final String homeName;
  final String awayName;
  final int homeScore;
  final int awayScore;

  /// Current period/quarter/half/set number. When null, no period field is
  /// shown.
  final int? period;

  /// Label used for the period field (e.g. 'Quarter', 'Half', 'Set').
  final String periodLabel;

  /// Current remaining countdown clock time, in seconds. When null, no
  /// clock field is shown.
  final int? remainingSeconds;

  /// Shows the dialog and returns the edited values, or null if cancelled.
  static Future<SportScoreEditResult?> show(
    BuildContext context, {
    required String homeName,
    required String awayName,
    required int homeScore,
    required int awayScore,
    int? period,
    String periodLabel = 'Period',
    int? remainingSeconds,
  }) {
    return showDialog<SportScoreEditResult>(
      context: context,
      builder: (context) => SportScoreEditDialog(
        homeName: homeName,
        awayName: awayName,
        homeScore: homeScore,
        awayScore: awayScore,
        period: period,
        periodLabel: periodLabel,
        remainingSeconds: remainingSeconds,
      ),
    );
  }

  @override
  State<SportScoreEditDialog> createState() => _SportScoreEditDialogState();
}

class _SportScoreEditDialogState extends State<SportScoreEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _homeController;
  late final TextEditingController _awayController;
  late final TextEditingController _periodController;
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();
    _homeController = TextEditingController(text: '${widget.homeScore}');
    _awayController = TextEditingController(text: '${widget.awayScore}');
    _periodController = TextEditingController(
      text: widget.period == null ? '' : '${widget.period}',
    );
    final remaining = widget.remainingSeconds ?? 0;
    _minutesController = TextEditingController(text: '${remaining ~/ 60}');
    _secondsController = TextEditingController(
      text: (remaining % 60).toString().padLeft(2, '0'),
    );
  }

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    _periodController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Score'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _homeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${widget.homeName} score',
                  border: const OutlineInputBorder(),
                ),
                validator: _validateNonNegative,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _awayController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${widget.awayName} score',
                  border: const OutlineInputBorder(),
                ),
                validator: _validateNonNegative,
              ),
              if (widget.period != null) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _periodController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: widget.periodLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: _validatePositive,
                ),
              ],
              if (widget.remainingSeconds != null) ...[
                const SizedBox(height: 12),
                Text('Time Remaining', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minutesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateNonNegative,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _secondsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Seconds',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateNonNegative,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }

  String? _validateNonNegative(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed < 0) {
      return 'Enter a valid number';
    }
    return null;
  }

  String? _validatePositive(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed < 1) {
      return 'Enter a valid number';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final home = int.parse(_homeController.text.trim());
    final away = int.parse(_awayController.text.trim());
    final period = widget.period == null
        ? null
        : int.parse(_periodController.text.trim());
    int? remainingSeconds;
    if (widget.remainingSeconds != null) {
      final minutes = int.parse(_minutesController.text.trim());
      final seconds = int.parse(_secondsController.text.trim());
      remainingSeconds = minutes * 60 + seconds;
    }
    Navigator.of(context).pop(
      SportScoreEditResult(
        homeScore: home,
        awayScore: away,
        period: period,
        remainingSeconds: remainingSeconds,
      ),
    );
  }
}
