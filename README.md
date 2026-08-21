# MedTok

Pouzdano, offline-first praćenje terapije i uzimanja lijekova (Flutter, Android + iOS).

> MedTok ne zamjenjuje liječnika. Ne postavlja dijagnoze i ne mijenja propisanu
> terapiju. Za medicinska pitanja obratite se liječniku ili ljekarniku.

## Što je u ovom skeletonu (Faza 1)

- Flutter projekt + folder struktura (clean/modular: `core/` + `features/`)
- Dependencies (Riverpod, go_router, Drift + SQLCipher, notifications, security)
- Theme (light/dark, M3, veliki touch targeti za accessibility)
- Lokalizacija (HR + EN, ARB)
- Routing (go_router, StatefulShellRoute, 5 tabova)
- Navigation shell (Danas / Lijekovi / Kalendar / Izvještaji / Postavke)
- Enkriptirana baza (Drift + SQLCipher), ključ u secure storage
- Osnovni modeli/tablice: Medications, MedicationStocks, MedicationSchedules,
  MedicationDoses, MedicationPauses, AppSettings + DAO-i
- Radni **Danas** ekran (čita doze iz baze, UZEO/ODGODI/PRESKOČI)
- Testovi DB sloja (in-memory Drift)

Još **nije** implementirano (sljedeće faze): scheduling engine, notifikacije,
add-medication flow, kalendar, izvještaji/PDF, caregiver, sync.

## Preduvjeti

- Flutter SDK ≥ 3.24 (Dart ≥ 3.5)
- Android SDK / Xcode za ciljne platforme

## Pokretanje

Ovaj repo sadrži `lib/`, `test/`, `pubspec.yaml`, ali **ne** i native `android/`
i `ios/` foldere (generiraju se lokalno). Postupak:

```bash
# 1. Generiraj native platforme u istom folderu
flutter create --org com.example --project-name medtok .

# 2. Instaliraj pakete
flutter pub get

# 3. Generiraj Drift + Riverpod kod (*.g.dart)
dart run build_runner build --delete-conflicting-outputs

# 4. Generiraj lokalizaciju (app_localizations.dart)
flutter gen-l10n

# 5. Dodaj Android/iOS permissions (vidi android_manifest_permissions.md)

# 6. Pokreni
flutter run
```

## Testiranje

```bash
flutter test
```

DB testovi koriste in-memory Drift (bez native SQLCipher-a), pa rade i na CI-u
bez uređaja.

## Sljedeći korak

**Faza 7 – Scheduling engine**: iz `MedicationSchedules.configJson` generirati
konkretne `MedicationDoses` (daily / interval / weekdays / cikluse), poštujući
`MedicationPauses` i vremenske zone. Nakon toga **Faza 8 – notifikacije**.

Reci kad želiš da krenem na to; ne mijenjam arhitekturu bez tvog odobrenja.
