import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/providers/database_provider.dart';

class NotepadListScreen extends ConsumerStatefulWidget {
  const NotepadListScreen({super.key});

  @override
  ConsumerState<NotepadListScreen> createState() => _NotepadListScreenState();
}

class _NotepadListScreenState extends ConsumerState<NotepadListScreen> {
  bool _selectionMode = false;
  final Set<int> _selectedNoteIds = <int>{};

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(appDatabaseProvider);
    return StreamBuilder<List<db.NotepadEntry>>(
      stream: database.toolsDao.watchNotes(),
      builder: (context, snapshot) {
        final notes = snapshot.data ?? const <db.NotepadEntry>[];
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
              _selectionMode
                  ? '${_selectedNoteIds.length} selected'
                  : 'Notepad',
            ),
            actions: [
              if (_selectionMode)
                TextButton.icon(
                  onPressed: _selectedNoteIds.isEmpty
                      ? null
                      : () => _deleteSelectedNotes(database),
                  icon: const Icon(Icons.delete_outline),
                  label: Text('Delete (${_selectedNoteIds.length})'),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'new_note_fab',
            onPressed: () async {
              final id = await database.toolsDao.insertNote(
                db.NotepadEntriesCompanion.insert(
                  title: const Value('Note'),
                  body: const Value(''),
                  updatedAt: DateTime.now().millisecondsSinceEpoch,
                ),
              );
              if (context.mounted) {
                context.go('/tools/notepad/$id');
              }
            },
            icon: const Icon(Icons.note_add_outlined),
            label: const Text('New Note'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final note in notes)
                _selectionMode
                    ? _buildNoteTile(context, note, database)
                    : Dismissible(
                        key: ValueKey<int>(note.id),
                        onDismissed: (_) =>
                            database.toolsDao.deleteNote(note.id),
                        child: _buildNoteTile(context, note, database),
                      ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoteTile(
    BuildContext context,
    db.NotepadEntry note,
    db.AppDatabase database,
  ) {
    return Card(
      child: ListTile(
        leading: _selectionMode
            ? Checkbox(
                value: _selectedNoteIds.contains(note.id),
                onChanged: (selected) =>
                    _toggleSelection(note.id, selected ?? false),
              )
            : null,
        title: Text(note.title),
        subtitle: Text(
          note.body.isEmpty ? 'No content yet' : note.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        selected: _selectedNoteIds.contains(note.id),
        onTap: () {
          if (_selectionMode) {
            _toggleSelection(note.id, !_selectedNoteIds.contains(note.id));
            return;
          }
          context.go('/tools/notepad/${note.id}');
        },
        onLongPress: () => _enterSelectionMode(note.id),
      ),
    );
  }

  void _enterSelectionMode(int noteId) {
    setState(() {
      _selectionMode = true;
      _selectedNoteIds.add(noteId);
    });
  }

  void _toggleSelection(int noteId, bool selected) {
    setState(() {
      _selectionMode = true;
      if (selected) {
        _selectedNoteIds.add(noteId);
      } else {
        _selectedNoteIds.remove(noteId);
      }
      if (_selectedNoteIds.isEmpty) {
        _selectionMode = false;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectionMode = false;
      _selectedNoteIds.clear();
    });
  }

  Future<void> _deleteSelectedNotes(db.AppDatabase database) async {
    final count = _selectedNoteIds.length;
    if (count == 0) {
      return;
    }
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete $count ${count == 1 ? 'note' : 'notes'}?'),
            content: const Text('This will permanently remove the selection.'),
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
    for (final noteId in _selectedNoteIds) {
      await database.toolsDao.deleteNote(noteId);
    }
    _clearSelection();
  }
}
