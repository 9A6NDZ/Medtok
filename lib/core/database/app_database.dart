import 'package:drift/drift.dart';

import 'connection/native.dart';
import 'converters.dart';
import 'daos/medication_dao.dart';
import 'daos/settings_dao.dart';
import 'enums.dart';
import 'tables/app_settings.dart';
import 'tables/medications.dart';
import 'tables/schedules.dart';

// The generated code references the enums (DoseStatus, MedicationForm, ...) and
// their converters. Keeping these imports non-hidden ensures the *.g.dart part
// file can resolve them. The `ignore` silences the "unused import" lint since
// the symbols are used only in the generated part.
// ignore_for_file: unused_import

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Medications,
    MedicationStocks,
    MedicationSchedules,
    MedicationDoses,
    MedicationPauses,
    AppSettingsTable,
  ],
  daos: [
    MedicationDao,
    SettingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Production constructor: opens an encrypted database using [passphrase].
  AppDatabase(String passphrase)
      : super(openEncryptedConnection(passphrase));

  /// Test/in-memory constructor. Pass an unencrypted [NativeDatabase.memory]
  /// from tests to avoid needing SQLCipher/native libs.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
