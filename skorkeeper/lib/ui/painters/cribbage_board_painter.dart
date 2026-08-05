import 'package:flutter/material.dart';

import '../../features/modules/cribbage/domain/cribbage_state.dart';

class CribbageBoardPainter extends CustomPainter {
  const CribbageBoardPainter({
    required this.positions,
    required this.colors,
    required this.isDark,
  });

  final Map<String, CribbagePegPosition> positions;
  final Map<String, Color> colors;
  final bool isDark;
  static const _segmentCount = 4;
  static const _pegsPerSegment = 30;

  @override
  void paint(Canvas canvas, Size size) {
    const boardColor = Color(0xFFD4A96A);
    final holeColor = Colors.black.withValues(alpha: 0.30);

    final board = Paint()..color = boardColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(24)),
      board,
    );

    final grainPaint = Paint()
      ..color = const Color(0xFFBE8A42).withValues(alpha: 0.4)
      ..strokeWidth = 1;
    for (var y = 20.0; y < size.height; y += 18) {
      canvas.drawLine(Offset(12, y), Offset(size.width - 12, y), grainPaint);
    }

    final offsets = _holeOffsets(size);
    final contentRect = Rect.fromLTWH(
      24,
      28,
      size.width - 48,
      size.height - 56,
    );
    final holePaint = Paint()..color = holeColor;
    final accentPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1.5;
    final majorHolePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.34);

    _drawStartEndLabels(canvas, size);
    _drawLaneGuides(canvas, contentRect, accentPaint);
    _drawMarkers(canvas, offsets, accentPaint, majorHolePaint);

    for (final entry in offsets.entries) {
      final radius = entry.key != 0 && entry.key % 5 == 0 ? 5.8 : 4.7;
      final paint = entry.key != 0 && entry.key % 5 == 0
          ? majorHolePaint
          : holePaint;
      canvas.drawCircle(entry.value, radius, paint);
    }

    final teamEntries = positions.entries.toList();
    for (var index = 0; index < teamEntries.length; index++) {
      final entry = teamEntries[index];
      final color = colors[entry.key] ?? Colors.orange;
      final rear = offsets[entry.value.rear.clamp(0, 121)]!;
      final front = offsets[entry.value.front.clamp(0, 121)]!;
      final teamOffset = _teamHorizontalOffset(index, teamEntries.length);
      final rearTrackOffset = Offset(_rearPegOffset(teamOffset), 0);
      canvas.drawCircle(
        rear + rearTrackOffset,
        7,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = color,
      );
      final frontTrackOffset = Offset(_frontPegOffset(teamOffset), 0);
      canvas.drawCircle(front + frontTrackOffset, 7, Paint()..color = color);
      canvas.drawCircle(
        front + frontTrackOffset,
        7,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.black.withValues(alpha: 0.3),
      );
    }
  }

  Map<int, Offset> _holeOffsets(Size size) {
    final offsets = <int, Offset>{};
    const horizontalPadding = 48.0;
    const top = 52.0;
    final bottom = size.height - 52;
    final usableWidth = size.width - (horizontalPadding * 2);
    final laneGap = usableWidth / (_segmentCount - 1);
    for (var score = 0; score <= 119; score++) {
      final segment = score ~/ _pegsPerSegment;
      final indexInSegment = score % _pegsPerSegment;
      final x = horizontalPadding + (laneGap * segment);
      final ratio = indexInSegment / (_pegsPerSegment - 1);
      final ascending = segment.isEven;
      final y = ascending
          ? bottom - ((bottom - top) * ratio)
          : top + ((bottom - top) * ratio);
      offsets[score] = Offset(x, y);
    }
    offsets[120] = Offset(size.width - horizontalPadding, size.height - 52);
    offsets[121] = Offset(size.width - 28, size.height - 52);
    return offsets;
  }

  void _drawStartEndLabels(Canvas canvas, Size size) {
    const labelStyle = TextStyle(
      color: Color(0xFF5C3912),
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
    );
    _paintText(canvas, const Offset(18, 16), 'START', labelStyle);
    _paintText(
      canvas,
      Offset(size.width - 68, size.height - 36),
      'END / WIN',
      labelStyle,
    );
  }

  void _drawLaneGuides(Canvas canvas, Rect contentRect, Paint paint) {
    final laneGap = contentRect.width / (_segmentCount - 1);
    for (var segment = 0; segment < _segmentCount; segment++) {
      final x = contentRect.left + (laneGap * segment);
      canvas.drawLine(
        Offset(x, contentRect.top),
        Offset(x, contentRect.bottom),
        paint..strokeWidth = 1,
      );
    }
  }

  void _drawMarkers(
    Canvas canvas,
    Map<int, Offset> offsets,
    Paint tickPaint,
    Paint majorHolePaint,
  ) {
    const numberStyle = TextStyle(
      color: Color(0xFF5C3912),
      fontSize: 10,
      fontWeight: FontWeight.w700,
    );
    for (var score = 5; score <= 120; score += 5) {
      final offset = offsets[score];
      if (offset == null) {
        continue;
      }
      final segment = score == 120
          ? _segmentCount - 1
          : score ~/ _pegsPerSegment;
      final labelOnLeft = segment.isOdd;
      canvas.drawLine(
        offset.translate(labelOnLeft ? -16 : 16, 0),
        offset.translate(labelOnLeft ? -5 : 5, 0),
        tickPaint,
      );
      canvas.drawCircle(offset, 6.2, majorHolePaint);
      _paintText(
        canvas,
        offset.translate(labelOnLeft ? -34 : 12, -8),
        '$score',
        numberStyle,
      );
    }
  }

  double _teamHorizontalOffset(int index, int teamCount) {
    if (teamCount >= 3) {
      const offsets = <double>[-12, 0, 12];
      return offsets[index.clamp(0, offsets.length - 1)];
    }
    const offsets = <double>[-10, 10];
    return offsets[index.clamp(0, offsets.length - 1)];
  }

  double _frontPegOffset(double teamOffset) {
    if (teamOffset == 0) {
      return 4;
    }
    return teamOffset < 0 ? teamOffset - 3 : teamOffset + 3;
  }

  double _rearPegOffset(double teamOffset) {
    if (teamOffset == 0) {
      return -4;
    }
    return teamOffset < 0 ? teamOffset + 3 : teamOffset - 3;
  }

  void _paintText(Canvas canvas, Offset offset, String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CribbageBoardPainter oldDelegate) {
    return oldDelegate.positions != positions ||
        oldDelegate.colors != colors ||
        oldDelegate.isDark != isDark;
  }
}
