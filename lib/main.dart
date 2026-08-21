import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/database/app_database.dart';
import 'core/security/db_key_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain the encryption key from the platform keystore/keychain, then open
  // the encrypted database. Both must complete before the UI renders because
  // every screen depends on the DB.
  final key = await DbKeyManager().getOrCreateKey();
  final database = AppDatabase(key);

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const MedTokApp(),
    ),
  );
}
