import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/database/daos/medication_dao.dart';
import '../core/database/daos/settings_dao.dart';

/// The database is created asynchronously (needs the secure key) and injected
/// at the top of the widget tree via an override in main.dart. Reading it
/// before override throws, which surfaces wiring mistakes immediately.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden in main()');
});

final medicationDaoProvider = Provider<MedicationDao>(
  (ref) => ref.watch(databaseProvider).medicationDao,
);

final settingsDaoProvider = Provider<SettingsDao>(
  (ref) => ref.watch(databaseProvider).settingsDao,
);

// ---- App-level preferences backed by the settings table ----

const _kThemeMode = 'theme_mode';
const _kLocale = 'locale';

final themeModeProvider =
    StreamProvider<ThemeMode>((ref) {
  final dao = ref.watch(settingsDaoProvider);
  return dao.watch(_kThemeMode).map(_parseThemeMode);
});

final localeProvider = StreamProvider<Locale?>((ref) {
  final dao = ref.watch(settingsDaoProvider);
  return dao.watch(_kLocale).map((v) => v == null ? null : Locale(v));
});

/// Imperative helpers used by Settings screen.
final settingsControllerProvider =
    Provider<SettingsController>((ref) => SettingsController(ref));

class SettingsController {
  SettingsController(this._ref);
  final Ref _ref;

  Future<void> setThemeMode(ThemeMode mode) =>
      _ref.read(settingsDaoProvider).set(_kThemeMode, mode.name);

  Future<void> setLocale(String? code) =>
      _ref.read(settingsDaoProvider).set(_kLocale, code ?? 'system');
}

ThemeMode _parseThemeMode(String? value) {
  switch (value) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}
