import 'package:flutter/material.dart';

import '../../../core/modules/sport_game_state.dart';

/// Holds the in-progress list of player name/number entries for a single
/// team roster being built on a sport setup screen. Exposes the finished
/// entries as [SportPlayer]s (via [buildRoster]) once the game starts.
class RosterEditController extends ChangeNotifier {
  RosterEditController({int initialRows = 1}) {
    for (var i = 0; i < initialRows; i++) {
      _rows.add(_RosterRow());
    }
  }

  final List<_RosterRow> _rows = [];

  List<_RosterRow> get rows => List.unmodifiable(_rows);

  void addRow() {
    _rows.add(_RosterRow());
    notifyListeners();
  }

  void removeRow(int index) {
    if (_rows.length <= 1) {
      return;
    }
    _rows[index].dispose();
    _rows.removeAt(index);
    notifyListeners();
  }

  /// Builds the roster as [SportPlayer]s in row order (batting order for
  /// baseball), skipping rows with an empty name. IDs follow the existing
  /// '{prefix}_{index}' convention used elsewhere in the app.
  List<SportPlayer> buildRoster(String prefix) {
    final players = <SportPlayer>[];
    var index = 0;
    for (final row in _rows) {
      final name = row.nameController.text.trim();
      if (name.isEmpty) {
        continue;
      }
      index++;
      final number = row.numberController.text.trim();
      players.add(
        SportPlayer(
          id: '${prefix}_$index',
          name: name,
          number: number.isEmpty ? '$index' : number,
        ),
      );
    }
    return players;
  }

  @override
  void dispose() {
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }
}

class _RosterRow {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  void dispose() {
    nameController.dispose();
    numberController.dispose();
  }
}

/// A structured roster entry editor: one row per player with separate
/// Name and jersey Number fields, plus controls to add/remove rows.
class RosterEditorField extends StatefulWidget {
  const RosterEditorField({
    required this.controller,
    required this.label,
    this.addLabel = 'Add Player',
    super.key,
  });

  final RosterEditController controller;
  final String label;
  final String addLabel;

  @override
  State<RosterEditorField> createState() => _RosterEditorFieldState();
}

class _RosterEditorFieldState extends State<RosterEditorField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant RosterEditorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final rows = widget.controller.rows;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        for (var i = 0; i < rows.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: rows[i].nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: rows[i].numberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '#',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: rows.length <= 1
                      ? null
                      : () => widget.controller.removeRow(i),
                  icon: const Icon(Icons.remove_circle_outline),
                  tooltip: 'Remove player',
                ),
              ],
            ),
          ),
        OutlinedButton.icon(
          onPressed: widget.controller.addRow,
          icon: const Icon(Icons.add),
          label: Text(widget.addLabel),
        ),
      ],
    );
  }
}
