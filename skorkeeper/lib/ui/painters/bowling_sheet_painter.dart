import 'package:flutter/material.dart';

import '../../features/modules/bowling/domain/bowling_state.dart';

class BowlingSheetPainter extends CustomPainter {
  BowlingSheetPainter({
    required this.playerNames,
    required this.framesByPlayer,
    required this.textStyle,
    required this.colorScheme,
  });

  final List<String> playerNames;
  final Map<String, List<BowlingFrame>> framesByPlayer;
  final TextStyle textStyle;
  final ColorScheme colorScheme;

  static const double rowHeight = 72;
  static const double labelWidth = 96;
  static const double frameWidth = 44;
  static const double tenthFrameWidth = 68;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..style = PaintingStyle.stroke;
    final backgroundPaint = Paint()
      ..color = colorScheme.surfaceContainerHighest.withValues(alpha: 0.35);
    var top = 0.0;
    for (final playerName in playerNames) {
      final rect = Rect.fromLTWH(0, top, size.width, rowHeight);
      canvas.drawRect(rect, backgroundPaint);
      canvas.drawRect(rect, borderPaint);
      _paintText(
        canvas,
        playerName,
        Offset(8, top + 24),
        maxWidth: labelWidth - 16,
      );
      var left = labelWidth;
      for (var frame = 1; frame <= 10; frame++) {
        final width = frame == 10 ? tenthFrameWidth : frameWidth;
        final frameRect = Rect.fromLTWH(left, top, width, rowHeight);
        canvas.drawRect(frameRect, borderPaint);
        canvas.drawLine(
          Offset(left, top + 28),
          Offset(left + width, top + 28),
          borderPaint,
        );
        final rolls = _rollDisplay(
          framesByPlayer[playerName] ?? const <BowlingFrame>[],
          frame,
        );
        final score = _scoreDisplay(
          framesByPlayer[playerName] ?? const <BowlingFrame>[],
          frame,
        );
        _paintText(
          canvas,
          rolls,
          Offset(left + 6, top + 6),
          maxWidth: width - 12,
        );
        _paintText(
          canvas,
          score,
          Offset(left + 6, top + 38),
          maxWidth: width - 12,
          align: TextAlign.center,
        );
        left += width;
      }
      top += rowHeight;
    }
  }

  String _rollDisplay(List<BowlingFrame> frames, int frameNumber) {
    final frame = frames.where((item) => item.frame == frameNumber).firstOrNull;
    if (frame == null) {
      return '';
    }
    final buffer = <String>[];
    for (var i = 0; i < frame.rolls.length; i++) {
      final roll = frame.rolls[i];
      if (frameNumber < 10 && i == 0 && roll == 10) {
        buffer.add('X');
      } else if (i > 0 &&
          frame.rolls[i - 1] != 10 &&
          frame.rolls[i - 1] + roll == 10) {
        buffer.add('/');
      } else if (roll == 10) {
        buffer.add('X');
      } else {
        buffer.add(roll.toString());
      }
    }
    return buffer.join('  ');
  }

  String _scoreDisplay(List<BowlingFrame> frames, int frameNumber) {
    final frame = frames.where((item) => item.frame == frameNumber).firstOrNull;
    return frame?.cumulativeScore?.toString() ?? '';
  }

  void _paintText(
    Canvas canvas,
    String text,
    Offset offset, {
    required double maxWidth,
    TextAlign align = TextAlign.left,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: align,
      maxLines: 2,
    )..layout(maxWidth: maxWidth);
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant BowlingSheetPainter oldDelegate) {
    return oldDelegate.framesByPlayer != framesByPlayer ||
        oldDelegate.playerNames.join('|') != playerNames.join('|') ||
        oldDelegate.colorScheme != colorScheme ||
        oldDelegate.textStyle != textStyle;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
