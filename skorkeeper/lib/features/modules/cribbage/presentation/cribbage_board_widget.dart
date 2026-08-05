import 'package:flutter/material.dart';

import '../../../../ui/painters/cribbage_board_painter.dart';
import '../domain/cribbage_state.dart';

class CribbageBoardWidget extends StatelessWidget {
  const CribbageBoardWidget({
    required this.positions,
    required this.colors,
    super.key,
  });

  final Map<String, CribbagePegPosition> positions;
  final Map<String, Color> colors;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 440,
      child: CustomPaint(
        painter: CribbageBoardPainter(
          positions: positions,
          colors: colors,
          isDark: isDark,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
