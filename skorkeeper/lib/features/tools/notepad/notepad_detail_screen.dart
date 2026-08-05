import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/providers/database_provider.dart';

class NotepadDetailScreen extends ConsumerStatefulWidget {
  const NotepadDetailScreen({required this.noteId, super.key});

  final int noteId;

  @override
  ConsumerState<NotepadDetailScreen> createState() =>
      _NotepadDetailScreenState();
}

class _NotepadDetailScreenState extends ConsumerState<NotepadDetailScreen> {
  late final Future<db.NotepadEntry?> _noteFuture;
  TextEditingController? _titleController;
  TextEditingController? _bodyController;
  String _savedTitle = '';
  String _savedBody = '';
  bool _deleteOnDiscard = false;
  bool _hasChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _noteFuture = ref.read(appDatabaseProvider).toolsDao.getNote(widget.noteId);
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _bodyController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(appDatabaseProvider);
    return FutureBuilder<db.NotepadEntry?>(
      future: _noteFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final note = snapshot.data;
        if (note == null) {
          return const Scaffold(body: Center(child: Text('Note not found.')));
        }
        _initializeControllers(note);
        final titleController = _titleController!;
        final bodyController = _bodyController!;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) {
              return;
            }
            await _handleBack(database);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Edit Note'),
              leading: BackButton(onPressed: () => _handleBack(database)),
              actions: [
                IconButton(
                  tooltip: 'Delete note',
                  onPressed: () => _deleteNote(context, database),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: bodyController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        labelText: 'Body',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _handleBack(database),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _hasChanges && !_isSaving
                              ? () => _saveNote(context, database)
                              : null,
                          child: Text(_isSaving ? 'Saving...' : 'Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _initializeControllers(db.NotepadEntry note) {
    if (_titleController != null && _bodyController != null) {
      return;
    }
    _savedTitle = note.title;
    _savedBody = note.body;
    _deleteOnDiscard = note.title == 'Note' && note.body.isEmpty;
    _titleController = TextEditingController(text: note.title)
      ..addListener(_onChanged);
    _bodyController = TextEditingController(text: note.body)
      ..addListener(_onChanged);
  }

  void _onChanged() {
    final hasChanges =
        _titleController!.text != _savedTitle ||
        _bodyController!.text != _savedBody;
    if (hasChanges == _hasChanges || !mounted) {
      return;
    }
    setState(() => _hasChanges = hasChanges);
  }

  Future<void> _saveNote(BuildContext context, db.AppDatabase database) async {
    setState(() => _isSaving = true);
    final nextTitle = _titleController!.text.trim().isEmpty
        ? 'Note'
        : _titleController!.text.trim();
    final nextBody = _bodyController!.text;
    await database.toolsDao.updateNote(widget.noteId, nextTitle, nextBody);
    _savedTitle = nextTitle;
    _savedBody = nextBody;
    _deleteOnDiscard = false;
    _titleController!.text = nextTitle;
    if (!mounted || !context.mounted) {
      return;
    }
    setState(() {
      _isSaving = false;
      _hasChanges = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _handleBack(db.AppDatabase database) async {
    final canPop = await _discardAndExit(database);
    if (canPop && mounted && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _discardAndExit(db.AppDatabase database) async {
    if (_deleteOnDiscard) {
      await database.toolsDao.deleteNote(widget.noteId);
    }
    _titleController?.text = _savedTitle;
    _bodyController?.text = _savedBody;
    return true;
  }

  Future<void> _deleteNote(
    BuildContext context,
    db.AppDatabase database,
  ) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete note?'),
            content: const Text('This note will be removed permanently.'),
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
    await database.toolsDao.deleteNote(widget.noteId);
    if (mounted && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
