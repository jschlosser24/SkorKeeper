import 'package:flutter/material.dart';

import '../../../../core/models/session_player.dart';
import '../../../../ui/painters/bowling_sheet_painter.dart';
import '../domain/bowling_state.dart';

class BowlingSheetWidget extends StatelessWidget {
  const BowlingSheetWidget({
    required this.players,
    required this.state,
    super.key,
  });

  final List<SessionPlayer> players;
  final BowlingState state;

  @override
  Widget build(BuildContext context) {
    final playerNames = players.map((player) => player.displayName).toList();
    final framesByDisplayName = <String, List<BowlingFrame>>{
      for (final player in players)
        player.displayName: state.frames[player.id] ?? const [],
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: CustomPaint(
            size: Size(
              BowlingSheetPainter.labelWidth +
                  (9 * BowlingSheetPainter.frameWidth) +
                  BowlingSheetPainter.tenthFrameWidth,
              BowlingSheetPainter.rowHeight * players.length,
            ),
            painter: BowlingSheetPainter(
              playerNames: playerNames,
              framesByPlayer: framesByDisplayName,
              textStyle:
                  Theme.of(context).textTheme.bodySmall ?? const TextStyle(),
              colorScheme: Theme.of(context).colorScheme,
            ),
          ),
        ),
      ),
    );
  }
}
