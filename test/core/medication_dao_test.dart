import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medtok/core/database/app_database.dart';
import 'package:medtok/core/database/enums.dart';
import 'package:medtok/core/database/tables/medications.dart';
import 'package:medtok/core/database/tables/schedules.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // In-memory, unencrypted DB – no native SQLCipher needed for unit tests.
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  test('insert + watch active medications', () async {
    await db.medicationDao.insertMedication(
      MedicationsCompanion.insert(
        id: 'm1',
        name: 'Lijek A',
        strength: const Value('500'),
        strengthUnit: const Value('mg'),
      ),
    );

    final meds = await db.medicationDao.watchActiveMedications().first;
    expect(meds, hasLength(1));
    expect(meds.first.name, 'Lijek A');
  });

  test('soft delete hides medication from active list', () async {
    await db.medicationDao.insertMedication(
      MedicationsCompanion.insert(id: 'm1', name: 'Lijek A'),
    );
    await db.medicationDao.softDeleteMedication('m1');

    final meds = await db.medicationDao.watchActiveMedications().first;
    expect(meds, isEmpty);
  });

  test('setDoseStatus records taken with actual time', () async {
    await db.medicationDao.insertMedication(
      MedicationsCompanion.insert(id: 'm1', name: 'Lijek A'),
    );
    final planned = DateTime.utc(2026, 8, 21, 8);
    await db.into(db.medicationDoses).insert(
          MedicationDosesCompanion.insert(
            id: 'd1',
            medicationId: 'm1',
            plannedTime: planned,
          ),
        );

    final taken = DateTime.utc(2026, 8, 21, 8, 4);
    await db.medicationDao
        .setDoseStatus('d1', DoseStatus.taken, actualTime: taken);

    final doses = await db.medicationDao
        .watchDosesBetween(
          DateTime.utc(2026, 8, 21),
          DateTime.utc(2026, 8, 22),
        )
        .first;
    expect(doses.single.status, DoseStatus.taken);
    expect(doses.single.actualTime, isNotNull);
    expect(doses.single.actualTime!.isAtSameMomentAs(taken), isTrue);
  });

  test('settings dao round-trips values', () async {
    await db.settingsDao.set('theme_mode', 'dark');
    expect(await db.settingsDao.get('theme_mode'), 'dark');
    await db.settingsDao.set('theme_mode', 'light');
    expect(await db.settingsDao.get('theme_mode'), 'light');
  });
}
