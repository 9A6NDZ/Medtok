import 'package:drift/drift.dart';

import 'connection/native.dart';
import 'daos/medication_dao.dart';
import 'daos/settings_dao.dart';
import 'tables/app_settings.dart';
import 'tables/medications.dart';
import 'tables/schedules.dart';

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
