import 'package:drift/drift.dart';

import '../converters.dart';
import '../enums.dart';
import 'medications.dart';

/// A schedule attached to a medication. Detailed timing (times of day, weekday
/// masks, cycle lengths) is stored as JSON in [configJson] and interpreted by
/// the scheduling engine in a later phase. Keeping it as JSON avoids a rigid
/// schema while the engine design settles.
class MedicationSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id)();
  TextColumn get type => text().map(const ScheduleTypeConverter())();
  TextColumn get configJson => text().withDefault(const Constant('{}'))();
  TextColumn get mealRelation =>
      text().map(const MealRelationConverter()).nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A single concrete dose instance – one row per planned intake.
/// [plannedTime] is stored in UTC; the UI converts to the user's chosen zone.
class MedicationDoses extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id)();
  TextColumn get scheduleId =>
      text().nullable().references(MedicationSchedules, #id)();
  DateTimeColumn get plannedTime => dateTime()();
  DateTimeColumn get actualTime => dateTime().nullable()();
  RealColumn get amount => real().withDefault(const Constant(1))();
  TextColumn get status =>
      text().map(const DoseStatusConverter())
          .withDefault(const Constant('pending'))();
  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// A pause interval for a medication's therapy. During a pause, the scheduling
/// engine suppresses reminders and marks doses as paused.
class MedicationPauses extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()(); // null = until further notice
  TextColumn get reason => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
