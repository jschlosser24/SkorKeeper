import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HourglassWidget extends StatelessWidget {
  const HourglassWidget({required this.progress, super.key});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset(
            'assets/animations/hourglass.json',
            repeat: true,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.hourglass_bottom, size: 120),
          ),
          Positioned(
            bottom: 0,
            left: 24,
            right: 24,
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.22)
                  : const Color(0xFF0C2340).withValues(alpha: 0.22),
            ),
          ),
        ],
      ),
    );
  }
}
