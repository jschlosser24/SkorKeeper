import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart' as db;

final sessionRedoStackProvider = StateProvider.autoDispose
    .family<List<db.ScoreEntry>, int>(
      (ref, sessionId) => const <db.ScoreEntry>[],
    );
