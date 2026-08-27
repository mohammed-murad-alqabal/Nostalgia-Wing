import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/security/secure_data_manager.dart';

import '../fixtures/legacy_xor_contract_fixture.dart';

/// Contract tests for the historical SecureDataManager payload format.
///
/// These tests intentionally preserve legacy read behavior. They do not
/// authorize the legacy format for new encryption and do not remove the
/// production implementation.
void main() {
  group('SecureDataManager legacy XOR contract', () {
    test('decrypts a deterministic historical payload', () {
      final decrypted = SecureDataManager.decryptData(
        LegacyXorContractFixture.payload,
        userKey: LegacyXorContractFixture.userKey,
      );

      expect(decrypted, LegacyXorContractFixture.plaintext);
    });

    test('rejects a payload with a modified signature', () {
      const payload = LegacyXorContractFixture.payload;
      final tampered = '${payload.substring(0, payload.length - 2)}AA';

      expect(
        () => SecureDataManager.decryptData(
          tampered,
          userKey: LegacyXorContractFixture.userKey,
        ),
        throwsA(isA<SecurityException>()),
      );
    });

    test('rejects a valid payload with the wrong user key', () {
      expect(
        () => SecureDataManager.decryptData(
          LegacyXorContractFixture.payload,
          userKey: 'wrong-contract-key',
        ),
        throwsA(isA<SecurityException>()),
      );
    });
  });
}
