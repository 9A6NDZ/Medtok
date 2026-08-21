import 'package:drift/drift.dart';

/// Simple key/value store for app-level preferences (theme, locale, etc.).
/// Kept in the DB so it is covered by the same encryption + backup as data.
class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}
