import 'package:drift/drift.dart';

class NotepadEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withDefault(const Constant('Note'))();
  TextColumn get body => text().withDefault(const Constant(''))();
  IntColumn get updatedAt => integer()();
}
