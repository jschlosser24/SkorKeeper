import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/database/app_database.dart';
import '../../core/monetization/monetized_banner.dart';
import '../../core/providers/history_provider.dart';
import '../../core/providers/pro_state_provider.dart';

enum _SortOption {
  newestFirst,
  oldestFirst,
  gameTypeAZ,
  winnerAZ;

  String get label {
    switch (this) {
      case _SortOption.newestFirst:
        return 'Newest first';
      case _SortOption.oldestFirst:
        return 'Oldest first';
      case _SortOption.gameTypeAZ,
          :
        return 'Game type (A–Z)';
      case _SortOption.winnerAZ:
        return 'Winner (A–Z)';
    }
  }

  IconData get icon {
    switch (this) {
      case _SortOption.newestFirst:
        return Icons.arrow_downward_rounded;
      case _SortOption.oldestFirst:
        return Icons.arrow_upward_rounded;
      case _SortOption.gameTypeAZ:
        return Icons.sort_by_alpha_rounded;
      case _SortOption.winnerAZ:
        return Icons.emoji_events_rounded;
    }
  }
}

class HistoryListScreen extends ConsumerStatefulWidget {
  const HistoryListScreen({super.key});

  @override
  ConsumerState<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends ConsumerState<HistoryListScreen> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  String? _selectedGameType;
  List<HistoryRecord>? _searchResults;
  bool _selectionMode = false;
  final Set<int> _selectedRecordIds = <int>{};
  _SortOption _sortOption = _SortOption.newestFirst;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyNotifierProvider);
    final isPro = ref.watch(proStateNotifierProvider).valueOrNull ?? false;
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        leading: _selectionMode
            ? IconButton(
                tooltip: 'Cancel selection',
                onPressed: _clearSelection,
                icon: const Icon(Icons.close),
              )
            : null,
        title: Text(
          _selectionMode ? '${_selectedRecordIds.length} selected' : 'History',
        ),
        actions: [
          if (_selectionMode)
            TextButton.icon(
              onPressed: _selectedRecordIds.isEmpty ? null : _deleteSelected,
              icon: const Icon(Icons.delete_outline),
              label: Text('Delete (${_selectedRecordIds.length})'),
            )
          else ...[
            IconButton(
              tooltip: 'Sort',
              icon: const Icon(Icons.sort_rounded),
              onPressed: () => _showSortSheet(context),
            ),
            if (isPro)
              IconButton(
                tooltip: 'Export CSV',
                icon: const Icon(Icons.download_rounded),
                onPressed: () => _exportCsv(context, historyAsync.valueOrNull ?? []),
              ),
          ],
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by player or game name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      bottomNavigationBar: const MonetizedBanner(),
      body: historyAsync.when(
        data: (history) {
          final visibleRecords = _applyLocalFilters(_searchResults ?? history);
          if (visibleRecords.isEmpty) {
            return const _HistoryEmptyState();
          }
          final gameTypes =
              history.map((record) => record.gameType).toSet().toList()..sort();
          return Column(
            children: [
              SizedBox(
                height: 52,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          'All',
                          style: TextStyle(
                            color: _selectedGameType == null
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onTertiaryContainer
                                : isLightMode
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : null,
                          ),
                        ),
                        selected: _selectedGameType == null,
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.tertiaryContainer,
                        checkmarkColor: Theme.of(
                          context,
                        ).colorScheme.onTertiaryContainer,
                        onSelected: (_) {
                          setState(() => _selectedGameType = null);
                          ref
                              .read(historyNotifierProvider.notifier)
                              .filterByGameType(null);
                        },
                      ),
                    ),
                    for (final gameType in gameTypes)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            _formatGameType(gameType),
                            style: TextStyle(
                              color: _selectedGameType == gameType
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onTertiaryContainer
                                  : isLightMode
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant
                                  : null,
                            ),
                          ),
                          selected: _selectedGameType == gameType,
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                          checkmarkColor: Theme.of(
                            context,
                          ).colorScheme.onTertiaryContainer,
                          onSelected: (_) {
                            setState(() => _selectedGameType = gameType);
                            ref
                                .read(historyNotifierProvider.notifier)
                                .filterByGameType(gameType);
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: visibleRecords.length,
                  itemBuilder: (context, index) {
                    final record = visibleRecords[index];
                    final tile = _HistoryTile(
                      record: record,
                      selectionMode: _selectionMode,
                      selected: _selectedRecordIds.contains(record.id),
                      onTap: () => _handleRecordTap(record),
                      onLongPress: () => _enterSelectionMode(record.id),
                      onSelectionChanged: (selected) =>
                          _toggleSelection(record.id, selected),
                    );
                    if (_selectionMode) {
                      return tile;
                    }
                    return Dismissible(
                      key: Key('history_${record.id}'),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _confirmDelete(record),
                      background: Container(
                        color: Theme.of(context).colorScheme.error,
                        padding: const EdgeInsets.only(right: 20),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      child: tile,
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) {
        return;
      }
      if (query.trim().isEmpty) {
        setState(() => _searchResults = null);
        return;
      }
      final results = await ref
          .read(historyNotifierProvider.notifier)
          .search(query);
      if (mounted) {
        setState(() => _searchResults = results);
      }
    });
  }

  void _handleRecordTap(HistoryRecord record) {
    if (_selectionMode) {
      _toggleSelection(record.id, !_selectedRecordIds.contains(record.id));
      return;
    }
    context.push('/history/${record.sessionId}');
  }

  void _enterSelectionMode(int recordId) {
    setState(() {
      _selectionMode = true;
      _selectedRecordIds.add(recordId);
    });
  }

  void _toggleSelection(int recordId, bool selected) {
    setState(() {
      _selectionMode = true;
      if (selected) {
        _selectedRecordIds.add(recordId);
      } else {
        _selectedRecordIds.remove(recordId);
      }
      if (_selectedRecordIds.isEmpty) {
        _selectionMode = false;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectionMode = false;
      _selectedRecordIds.clear();
    });
  }

  List<HistoryRecord> _applyLocalFilters(List<HistoryRecord> source) {
    var result = _selectedGameType == null
        ? source
        : source.where((r) => r.gameType == _selectedGameType).toList();
    result = List.of(result);
    switch (_sortOption) {
      case _SortOption.newestFirst:
        result.sort((a, b) => b.playedAt.compareTo(a.playedAt));
      case _SortOption.oldestFirst:
        result.sort((a, b) => a.playedAt.compareTo(b.playedAt));
      case _SortOption.gameTypeAZ:
        result.sort((a, b) => a.gameType.compareTo(b.gameType));
      case _SortOption.winnerAZ:
        result.sort((a, b) {
          final wa = a.winnerDisplayName ?? '';
          final wb = b.winnerDisplayName ?? '';
          return wa.compareTo(wb);
        });
    }
    return result;
  }

  Future<bool> _confirmDelete(HistoryRecord record) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete history entry?'),
            content: Text(
              'Remove ${record.sessionName ?? _formatGameType(record.gameType)} from history?',
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
      return false;
    }
    final deleted = await ref
        .read(historyNotifierProvider.notifier)
        .deleteEntry(record.id);
    if (!mounted || deleted == null) {
      return true;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${record.sessionName ?? _formatGameType(record.gameType)} deleted',
          ),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              ref.read(historyNotifierProvider.notifier).restoreEntry(deleted);
            },
          ),
        ),
      );
    return true;
  }

  Future<void> _deleteSelected() async {
    if (_selectedRecordIds.isEmpty) {
      return;
    }
    final count = _selectedRecordIds.length;
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete $count history ${count == 1 ? 'entry' : 'entries'}?',
            ),
            content: const Text(
              'This removes the selected completed sessions and their saved history.',
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
    final deletedEntries = await ref
        .read(historyNotifierProvider.notifier)
        .deleteEntries(_selectedRecordIds);
    if (!mounted) {
      return;
    }
    _clearSelection();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$count history ${count == 1 ? 'entry' : 'entries'} deleted',
          ),
          action: deletedEntries.isEmpty
              ? null
              : SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    ref
                        .read(historyNotifierProvider.notifier)
                        .restoreEntries(deletedEntries);
                  },
                ),
        ),
      );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text('Sort by', style: TextStyle(fontWeight: FontWeight.bold))),
            for (final option in _SortOption.values)
              RadioListTile<_SortOption>(
                title: Text(option.label),
                secondary: Icon(option.icon),
                value: option,
                groupValue: _sortOption,
                onChanged: (v) {
                  if (v != null) setState(() => _sortOption = v);
                  Navigator.of(ctx).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, List<HistoryRecord> all) async {
    final visible = _applyLocalFilters(_searchResults ?? all);
    if (visible.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No records to export.')),
      );
      return;
    }

    final buf = StringBuffer();
    buf.writeln('Date,Game,Session Name,Players,Winner,Duration (min)');
    final fmt = DateFormat('yyyy-MM-dd HH:mm');
    for (final r in visible) {
      final date = fmt.format(DateTime.fromMillisecondsSinceEpoch(r.playedAt));
      final game = _csvCell(_formatGameType(r.gameType));
      final name = _csvCell(r.sessionName ?? '');
      final players = _csvCell(r.playerNames);
      final winner = _csvCell(r.winnerDisplayName ?? '');
      final mins = r.durationSeconds != null
          ? (r.durationSeconds! / 60).toStringAsFixed(1)
          : '';
      buf.writeln('$date,$game,$name,$players,$winner,$mins');
    }

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/skorkeeper_history.csv');
      await file.writeAsString(buf.toString());
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv')],
        subject: 'SkorKeeper History',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  static String _csvCell(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  String _formatGameType(String gameType) {
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
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.record,
    required this.selectionMode,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    required this.onSelectionChanged,
  });

  final HistoryRecord record;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat(
      'MMM d, yyyy',
    ).format(DateTime.fromMillisecondsSinceEpoch(record.playedAt));
    return ListTile(
      leading: selectionMode
          ? Checkbox(
              value: selected,
              onChanged: (value) => onSelectionChanged(value ?? false),
            )
          : CircleAvatar(child: Icon(_iconForGameType(record.gameType))),
      title: Text(record.sessionName ?? _formatGameType(record.gameType)),
      subtitle: Text('${record.playerNames} • $date'),
      trailing: record.winnerDisplayName == null
          ? null
          : Chip(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              label: Text(
                record.winnerDisplayName!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
      selected: selected,
      selectedTileColor: Theme.of(
        context,
      ).colorScheme.tertiaryContainer.withValues(alpha: 0.22),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  static IconData _iconForGameType(String gameType) {
    if (gameType.contains('darts')) {
      return Icons.gps_fixed_rounded;
    }
    switch (gameType) {
      case 'golf9':
      case 'golf18':
      case 'minigolf':
        return Icons.sports_golf_rounded;
      case 'yahtzee':
      case 'farkle':
        return Icons.casino_rounded;
      case 'cribbage':
      case 'uno':
        return Icons.style_rounded;
      case 'bowling':
        return Icons.sports_rounded;
      case 'dominoes':
        return Icons.grid_view_rounded;
      default:
        return Icons.sports_esports_rounded;
    }
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
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Your completed games will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
