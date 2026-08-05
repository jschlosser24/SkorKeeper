import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum DieType { d4, d6, d8, d10, d12, d20, d100 }

class DieWidget extends StatelessWidget {
  const DieWidget({
    required this.value,
    super.key,
    this.type = DieType.d6,
    this.size = 88,
    this.animateRoll = false,
  });

  final int value;
  final DieType type;
  final double size;
  final bool animateRoll;

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _DiePainter(value: value, type: type),
          ),
          if (type != DieType.d6)
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
        ],
      ),
    );
    return animateRoll
        ? child.animate().shake(duration: 350.ms).rotate(duration: 350.ms)
        : child;
  }
}

class _DiePainter extends CustomPainter {
  const _DiePainter({required this.value, required this.type});

  final int value;
  final DieType type;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final fill = Paint()..color = Colors.white;
    final stroke = Paint()
      ..color = const Color(0xFF0C2340)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final radius = Radius.circular(size.width * 0.18);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), fill);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), stroke);
    if (type != DieType.d6) {
      return;
    }
    final pipPaint = Paint()..color = const Color(0xFF0C2340);
    for (final offset in _pipOffsets(value)) {
      canvas.drawCircle(offset * size.width, size.width * 0.06, pipPaint);
    }
  }

  List<Offset> _pipOffsets(int face) {
    const tl = Offset(0.28, 0.28);
    const tr = Offset(0.72, 0.28);
    const ml = Offset(0.28, 0.5);
    const mc = Offset(0.5, 0.5);
    const mr = Offset(0.72, 0.5);
    const bl = Offset(0.28, 0.72);
    const br = Offset(0.72, 0.72);
    switch (face.clamp(1, 6)) {
      case 1:
        return const [mc];
      case 2:
        return const [tl, br];
      case 3:
        return const [tl, mc, br];
      case 4:
        return const [tl, tr, bl, br];
      case 5:
        return const [tl, tr, mc, bl, br];
      default:
        return const [tl, tr, ml, mr, bl, br];
    }
  }

  @override
  bool shouldRepaint(covariant _DiePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.type != type;
  }
}
