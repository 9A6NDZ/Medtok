import 'package:drift/drift.dart';

import '../converters.dart';
import '../enums.dart';

/// A medication the user takes. Deletions are soft (deletedAt) so history and
/// audit logs never lose their references.
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get genericName => text().nullable()();
  TextColumn get brandName => text().nullable()();
  TextColumn get strength => text().nullable()(); // e.g. "500"
  TextColumn get strengthUnit => text().nullable()(); // e.g. "mg"
  TextColumn get form =>
      text().map(const MedicationFormConverter()).nullable()();
  TextColumn get manufacturer => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get doctor => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isChronic =>
      boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Running inventory for a medication, updated when a dose is confirmed.
class MedicationStocks extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id)();
  RealColumn get packageSize => real().nullable()();
  RealColumn get currentQuantity => real().withDefault(const Constant(0))();
  IntColumn get lowStockThresholdDays =>
      integer().withDefault(const Constant(7))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
