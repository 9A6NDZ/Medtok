import 'package:drift/drift.dart';

import '../app_database.dart';
import '../enums.dart';
import '../tables/medications.dart';
import '../tables/schedules.dart';

part 'medication_dao.g.dart';

@DriftAccessor(
  tables: [Medications, MedicationStocks, MedicationDoses],
)
class MedicationDao extends DatabaseAccessor<AppDatabase>
    with _$MedicationDaoMixin {
  MedicationDao(super.db);

  /// Active (non-deleted) medications, newest first.
  Stream<List<Medication>> watchActiveMedications() {
    return (select(medications)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> insertMedication(MedicationsCompanion medication) {
    return into(medications).insert(medication);
  }

  /// Soft delete – keeps history and audit references intact.
  Future<void> softDeleteMedication(String id) {
    return (update(medications)..where((t) => t.id.equals(id))).write(
      MedicationsCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Doses planned within [from, to), ordered by planned time. Used by the
  /// Today screen (with from = start of day, to = start of next day).
  Stream<List<MedicationDose>> watchDosesBetween(
    DateTime from,
    DateTime to,
  ) {
    return (select(medicationDoses)
          ..where((t) =>
              t.plannedTime.isBiggerOrEqualValue(from) &
              t.plannedTime.isSmallerThanValue(to))
          ..orderBy([(t) => OrderingTerm.asc(t.plannedTime)]))
        .watch();
  }

  /// Records the outcome of a dose. Setting [actualTime] is the caller's job
  /// for a 'taken' status (usually DateTime.now()).
  Future<void> setDoseStatus(
    String doseId,
    DoseStatus status, {
    DateTime? actualTime,
  }) {
    return (update(medicationDoses)..where((t) => t.id.equals(doseId))).write(
      MedicationDosesCompanion(
        status: Value(status),
        actualTime: Value(actualTime),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
