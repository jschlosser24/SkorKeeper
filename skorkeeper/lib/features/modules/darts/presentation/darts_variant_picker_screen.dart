import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DartsVariantPickerScreen extends StatelessWidget {
  const DartsVariantPickerScreen({super.key});

  static const variants = <Map<String, String>>[
    {'id': 'darts301', 'title': '301', 'subtitle': 'Quick x01'},
    {'id': 'darts501', 'title': '501', 'subtitle': 'Classic x01'},
    {'id': 'darts701', 'title': '701', 'subtitle': 'Long format'},
    {'id': 'dartsCricket', 'title': 'Cricket', 'subtitle': 'Close numbers'},
    {
      'id': 'dartsCutThroat',
      'title': 'Cut Throat',
      'subtitle': 'Score on rivals',
    },
    {
      'id': 'dartsAroundTheClock',
      'title': 'Around the Clock',
      'subtitle': 'Race targets',
    },
    {'id': 'dartsShanghai', 'title': 'Shanghai', 'subtitle': '7 target rounds'},
    {'id': 'dartsKiller', 'title': 'Killer', 'subtitle': 'Lives and knockouts'},
    {'id': 'dartsHalveIt', 'title': 'Halve It', 'subtitle': 'Miss and halve'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick a Darts Variant')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.15,
        ),
        itemCount: variants.length,
        itemBuilder: (context, index) {
          final variant = variants[index];
          return Card(
            child: InkWell(
              onTap: () => context.go('/home/new/${variant['id']}'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.gps_fixed),
                    const Spacer(),
                    Text(
                      variant['title']!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(variant['subtitle']!),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
