import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../core/providers/preferences_provider.dart';

part 'shake_provider.g.dart';

@riverpod
Stream<int> shakeTrigger(Ref ref) {
  final prefs = ref.watch(preferencesNotifierProvider).valueOrNull;
  final enabled = prefs?.shakeToRollEnabled ?? true;
  final threshold = prefs?.shakeSensitivity ?? 15.0;
  if (!enabled) {
    return const Stream<int>.empty();
  }
  final controller = StreamController<int>();
  DateTime lastTrigger = DateTime.fromMillisecondsSinceEpoch(0);
  var count = 0;
  final stream = SensorsPlatform.instance.userAccelerometerEventStream();
  final subscription = stream.listen(
    (event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      final now = DateTime.now();
      if (magnitude >= threshold &&
          now.difference(lastTrigger) >= const Duration(milliseconds: 800)) {
        lastTrigger = now;
        count++;
        controller.add(count);
      }
    },
    onError: (_) {
      controller.close();
    },
  );
  ref.onDispose(() async {
    await subscription.cancel();
    await controller.close();
  });
  return controller.stream;
}
