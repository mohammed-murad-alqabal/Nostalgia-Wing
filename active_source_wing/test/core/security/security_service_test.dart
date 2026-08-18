import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/security/security_service.dart';

void main() {
  final service = SecurityService();
  final key = SecretKeyData(List<int>.generate(32, (index) => index));

  test('AES-GCM writes a versioned envelope with a key ID', () async {
    const clearText = 'ذكرى حساسة يجب حمايتها';

    final cipherText = await service.encrypt(
      clearText,
      key,
      keyId: 'v1',
    );

    expect(service.keyIdFromBase64(cipherText), 'v1');
    expect(
      service.versionFromBytes(Uint8List.fromList(base64.decode(cipherText))),
      SecurityService.currentEnvelopeVersion,
    );
    expect(await service.decrypt(cipherText, key), clearText);
  });

  test('AES-GCM encrypts with a fresh nonce and decrypts correctly', () async {
    const clearText = 'ذكرى حساسة يجب حمايتها';

    final firstCipherText = await service.encrypt(clearText, key);
    final secondCipherText = await service.encrypt(clearText, key);

    expect(firstCipherText, isNot(secondCipherText));
    expect(await service.decrypt(firstCipherText, key), clearText);
    expect(await service.decrypt(secondCipherText, key), clearText);
  });

  test('reads the historical unversioned nonce/ciphertext/MAC payload',
      () async {
    const clearText = 'بيانات تاريخية قابلة للقراءة';
    final secretBox = await service.algorithm.encrypt(
      utf8.encode(clearText),
      secretKey: key,
    );
    final legacyPayload = Uint8List.fromList(<int>[
      ...secretBox.nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);
    final encoded = base64.encode(legacyPayload);

    expect(service.keyIdFromBase64(encoded), isNull);
    expect(service.versionFromBytes(legacyPayload), isNull);
    expect(await service.decrypt(encoded, key), clearText);
  });

  test('AES-GCM encrypts and decrypts binary payloads through the envelope',
      () async {
    final source = Uint8List.fromList(List<int>.generate(64, (i) => i));

    final encrypted = await service.encryptBytes(source, key, keyId: 'v2');
    final decrypted = await service.decryptBytes(encrypted, key);

    expect(service.keyIdFromBytes(encrypted), 'v2');
    expect(decrypted, source);
  });

  test('authenticated envelope metadata rejects tampering', () async {
    final cipherText = await service.encrypt('لا تقبل العبث', key, keyId: 'v1');
    final bytes = base64.decode(cipherText);
    bytes[6] ^= 0x01;

    await expectLater(
      service.decrypt(base64.encode(bytes), key),
      throwsA(isA<Object>()),
    );
  });

  test('rejects unsupported envelope versions', () async {
    final cipherText = await service.encrypt('إصدار غير مدعوم', key);
    final bytes = base64.decode(cipherText);
    bytes[4] = SecurityService.currentEnvelopeVersion + 1;

    await expectLater(
      service.decrypt(base64.encode(bytes), key),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects payloads shorter than nonce and MAC', () async {
    final malformed = base64.encode(<int>[1, 2, 3]);

    await expectLater(
      service.decrypt(malformed, key),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects a modified authenticated payload', () async {
    final cipherText = await service.encrypt('لا تقبل العبث', key);
    final bytes = base64.decode(cipherText);
    bytes[bytes.length - 1] ^= 0x01;

    await expectLater(
      service.decrypt(base64.encode(bytes), key),
      throwsA(isA<Object>()),
    );
  });
}
