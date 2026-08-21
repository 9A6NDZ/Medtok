import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages the SQLCipher passphrase. The key is generated once on first launch
/// and stored in the platform keystore (Android) / keychain (iOS). It never
/// leaves the device and is never written to logs or backups in plaintext.
class DbKeyManager {
  DbKeyManager([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  static const _keyName = 'medtok_db_key_v1';
  final FlutterSecureStorage _storage;

  /// Returns the existing passphrase, or generates and persists a new one.
  Future<String> getOrCreateKey() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null && existing.isNotEmpty) return existing;

    final key = _generateKey();
    await _storage.write(key: _keyName, value: key);
    return key;
  }

  String _generateKey() {
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    return base64UrlEncode(bytes);
  }
}
