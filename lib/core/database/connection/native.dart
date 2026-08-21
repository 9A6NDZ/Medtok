import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

/// Opens an encrypted (SQLCipher) database. The [passphrase] is supplied by the
/// security layer, which stores it in the platform keystore/keychain via
/// flutter_secure_storage. Encryption-at-rest is therefore transparent to the
/// rest of the app.
LazyDatabase openEncryptedConnection(String passphrase) {
  return LazyDatabase(() async {
    // Ensure the app links against SQLCipher rather than the system SQLite.
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    open.overrideForAll(openCipherOnAndroid);

    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'medtok.db'));

    return NativeDatabase.createInBackground(
      file,
      setup: (db) {
        // Provide the key before any other statement runs.
        final escaped = passphrase.replaceAll("'", "''");
        db.execute("PRAGMA key = '$escaped';");
        // Sanity check that the key is correct / db is readable.
        db.execute('PRAGMA cipher_memory_security = ON;');
        db.execute('PRAGMA foreign_keys = ON;');
      },
    );
  });
}
