import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/providers/database_provider.dart';

class TallyCounterScreen extends ConsumerWidget {
  const TallyCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);
    return StreamBuilder<List<db.TallyCounter>>(
      stream: database.toolsDao.watchTallyCounters(),
      builder: (context, snapshot) {
        final counters = snapshot.data ?? const <db.TallyCounter>[];
        return Scaffold(
          appBar: AppBar(title: const Text('Tally Counter')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => database.toolsDao.upsertTallyCounter(
              db.TallyCountersCompanion(
                name: Value('Counter ${counters.length + 1}'),
                value: const Value(0),
                updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Counter'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final counter in counters)
                Dismissible(
                  key: ValueKey<int>(counter.id),
                  onDismissed: (_) =>
                      database.toolsDao.deleteTallyCounter(counter.id),
                  child: Card(
                    child: ListTile(
                      title: Text(counter.name),
                      subtitle: Text(
                        'Updated ${DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(counter.updatedAt))}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              HapticFeedback.selectionClick();
                              await database.toolsDao.upsertTallyCounter(
                                db.TallyCountersCompanion(
                                  id: Value(counter.id),
                                  name: Value(counter.name),
                                  value: Value(counter.value - 1),
                                  updatedAt: Value(
                                    DateTime.now().millisecondsSinceEpoch,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          SizedBox(
                            width: 56,
                            child: Text(
                              counter.value.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              HapticFeedback.selectionClick();
                              await database.toolsDao.upsertTallyCounter(
                                db.TallyCountersCompanion(
                                  id: Value(counter.id),
                                  name: Value(counter.name),
                                  value: Value(counter.value + 1),
                                  updatedAt: Value(
                                    DateTime.now().millisecondsSinceEpoch,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                      onTap: () => _renameCounter(context, database, counter),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _renameCounter(
    BuildContext context,
    db.AppDatabase database,
    db.TallyCounter counter,
  ) async {
    final controller = TextEditingController(text: counter.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename counter'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) {
      return;
    }
    await database.toolsDao.upsertTallyCounter(
      db.TallyCountersCompanion(
        id: Value(counter.id),
        name: Value(name),
        value: Value(counter.value),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
