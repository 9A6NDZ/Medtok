// Smoke test. The full app needs an encrypted database (native SQLCipher),
// so instead of pumping MedTokApp we verify the DB layer separately in
// test/core/medication_dao_test.dart. This file just asserts the test harness
// runs. Replace with a proper widget test once a DB test-double is injected.

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test harness runs', () {
    expect(1 + 1, 2);
  });
}
