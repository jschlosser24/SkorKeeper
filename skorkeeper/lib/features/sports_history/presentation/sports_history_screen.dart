import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/modules/sport_enums.dart';
import '../../../core/providers/database_provider.dart';
import '../../modules/shared/sport_module_utils.dart';
import '../../sports_export/application/export_notifier.dart';

class SportsHistoryScreen extends ConsumerStatefulWidget {
  const SportsHistoryScreen({super.key});

  @override
  ConsumerState<SportsHistoryScreen> createState() => _SportsHistoryScreenState();
}

class _SportsHistoryScreenState extends ConsumerState<SportsHistoryScreen> {
  final Set<int> _selectedIds = <int>{};
  bool _selectMode = false;
  ExportFormat _format = ExportFormat.pdf;

  @override
  Widget build(BuildContext context) {
    final exportState = ref.watch(exportNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports History'),
        actions: [
          IconButton(
            onPressed: () => setState(() => _selectMode = !_selectMode),
            icon: Icon(_selectMode ? Icons.close : Icons.checklist),
          ),
        ],
      ),
      floatingActionButton: _selectMode
          ? FloatingActionButton.extended(
              onPressed: _selectedIds.isEmpty ? null : _exportSelected,
              label: const Text('Export Selected'),
              icon: exportState.isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.file_upload_outlined),
            )
          : null,
      body: FutureBuilder(
        future: ref.read(appDatabaseProvider).sportHistoryDao.getSportGames(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final records = snapshot.data!;
          final planCount = records
              .where((record) => record.meta.tierRequired == 'sports_plan')
              .length;
          return Column(
            children: [
              if (planCount >= 95)
                MaterialBanner(
                  content: Text(
                    'Sports Plan history is ${planCount >= 100 ? 'full' : 'nearing the 100-game limit'}.',
                  ),
                  actions: const [SizedBox.shrink()],
                ),
              if (_selectMode)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('PDF'),
                        selected: _format == ExportFormat.pdf,
                        onSelected: (_) => setState(() => _format = ExportFormat.pdf),
                      ),
                      ChoiceChip(
                        label: const Text('CSV'),
                        selected: _format == ExportFormat.csv,
                        onSelected: (_) => setState(() => _format = ExportFormat.csv),
                      ),
                      ChoiceChip(
                        label: const Text('JSON'),
                        selected: _format == ExportFormat.json,
                        onSelected: (_) => setState(() => _format = ExportFormat.json),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    final selected = _selectedIds.contains(record.session.id);
                    return Dismissible(
                      key: ValueKey(record.session.id),
                      onDismissed: (_) async {
                        await ref
                            .read(appDatabaseProvider)
                            .sportHistoryDao
                            .deleteSportGame(record.session.id);
                        setState(() {});
                      },
                      background: Container(
                        color: Theme.of(context).colorScheme.errorContainer,
                      ),
                      child: ListTile(
                        leading: _selectMode
                            ? Checkbox(
                                value: selected,
                                onChanged: (_) => _toggle(record.session.id),
                              )
                            : CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                child: Icon(
                                  SportModuleUtils.iconForSport(record.state.sportType),
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                        title: Text(
                          '${record.state.awayTeam.name} at ${record.state.homeTeam.name}',
                        ),
                        subtitle: Text(
                          '${record.state.awayTeam.score}-${record.state.homeTeam.score} • '
                          '${DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(record.session.startedAt))} • '
                          '${SportModuleUtils.formatClock(record.state.elapsedSeconds)}',
                        ),
                        onTap: _selectMode ? () => _toggle(record.session.id) : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggle(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _exportSelected() async {
    await ref
        .read(exportNotifierProvider.notifier)
        .exportGames(_selectedIds.toList(), _format);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.read(exportNotifierProvider).hasError ? 'Export failed' : 'Export complete')),
      );
    }
  }
}
