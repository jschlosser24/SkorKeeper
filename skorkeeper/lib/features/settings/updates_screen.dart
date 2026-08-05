import 'package:flutter/material.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  static const _updates = <_UpdateEntry>[
    _UpdateEntry(
      version: '1.0.0',
      releaseDate: 'Aug 5, 2026',
      highlights: ['Initial public release of SkorKeeper.'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("What's New")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _updates.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final update = _updates[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'v${update.version}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Chip(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        label: Text(
                          update.releaseDate,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  for (final highlight in update.highlights)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.circle,
                              size: 8,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(highlight)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _UpdateEntry {
  const _UpdateEntry({
    required this.version,
    required this.releaseDate,
    required this.highlights,
  });

  final String version;
  final String releaseDate;
  final List<String> highlights;
}
