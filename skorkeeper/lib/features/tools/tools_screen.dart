import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  static const _tools = <({String title, IconData icon, String route})>[
    (title: 'Dice', icon: Icons.casino_outlined, route: '/tools/dice'),
    (title: 'Coin', icon: Icons.monetization_on_outlined, route: '/tools/coin'),
    (title: 'Spinner', icon: Icons.donut_large, route: '/tools/spinner'),
    (title: 'Timer', icon: Icons.hourglass_bottom, route: '/tools/timer'),
    (title: 'Stopwatch', icon: Icons.timer_outlined, route: '/tools/stopwatch'),
    (title: 'Lives', icon: Icons.favorite_outline, route: '/tools/lives'),
    (title: 'Tally', icon: Icons.exposure_plus_1, route: '/tools/tally'),
    (title: 'Notepad', icon: Icons.note_alt_outlined, route: '/tools/notepad'),
    (title: 'Teams', icon: Icons.groups_outlined, route: '/tools/team-picker'),
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(title: const Text('Game Tools')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: _tools.length,
        itemBuilder: (context, index) {
          final tool = _tools[index];
          return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.go(tool.route),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(tool.icon, size: 32, color: color),
                        const SizedBox(height: 12),
                        Text(
                          tool.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .animate(delay: Duration(milliseconds: 35 * index))
              .fadeIn(duration: 220.ms)
              .slideY(begin: 0.08, end: 0);
        },
      ),
    );
  }
}
