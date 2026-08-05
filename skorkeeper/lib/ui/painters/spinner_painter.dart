import 'dart:math';

import 'package:flutter/material.dart';

class SpinnerSegment {
  const SpinnerSegment({required this.label, required this.color});

  final String label;
  final Color color;
}

class SpinnerPainter extends CustomPainter {
  const SpinnerPainter({
    required this.segments,
    required this.rotationAngle,
    this.highlightedIndex,
  });

  final List<SpinnerSegment> segments;
  final double rotationAngle;
  final int? highlightedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2;
    final sweep = (2 * pi) / segments.length;
    var start = rotationAngle - pi / 2;
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final paint = Paint()..color = segment.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        true,
        paint,
      );
      if (highlightedIndex == i) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          start,
          sweep,
          true,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.18)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6,
        );
      }
      // Draw border line from center to edge
      final edgeX = center.dx + cos(start) * radius;
      final edgeY = center.dy + sin(start) * radius;
      canvas.drawLine(center, Offset(edgeX, edgeY), borderPaint);
      final labelAngle = start + sweep / 2;
      final textOffset = Offset(
        center.dx + cos(labelAngle) * radius * 0.55,
        center.dy + sin(labelAngle) * radius * 0.55,
      );
      final textPainter = TextPainter(
        text: TextSpan(
          text: segment.label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 2,
      )..layout(maxWidth: radius * 0.5);
      canvas.save();
      canvas.translate(textOffset.dx, textOffset.dy);
      canvas.rotate(labelAngle);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
      start += sweep;
    }
    // Draw outer circle border
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant SpinnerPainter oldDelegate) {
    return oldDelegate.segments != segments ||
        oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.highlightedIndex != highlightedIndex;
  }
}
