import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/modules/game_module.dart';

class GameModuleCard extends StatelessWidget {
  const GameModuleCard({required this.module, super.key});

  final GameModule module;

  @override
  Widget build(BuildContext context) {
    return Semantics(
          button: true,
          label: '${module.displayName} — ${module.description}',
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.go('/home/new/' + module.gameTypeId),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 56,
                      width: 56,
                      child: SvgPicture.string(module.iconAsset),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      module.displayName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: Text(module.description)),
                    const SizedBox(height: 12),
                    Chip(
                      label: Text(
                        module.minPlayers.toString() +
                            '–' +
                            module.maxPlayers.toString() +
                            ' players',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 220.ms)
        .slideY(begin: 0.08, end: 0, duration: 220.ms);
  }
}
