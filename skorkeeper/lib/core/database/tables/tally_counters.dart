import 'package:drift/drift.dart';

class TallyCounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant('Counter'))();
  IntColumn get value => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();
}
