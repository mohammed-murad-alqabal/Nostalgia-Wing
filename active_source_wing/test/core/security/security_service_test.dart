import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/security/security_service.dart';

void main() {
  final service = SecurityService();
  final key = SecretKeyData(List<int>.generate(32, (index) => index));

  test('AES-GCM encrypts with a fresh nonce and decrypts correctly', () async {
    const clearText = 'ذكرى حساسة يجب حمايتها';

    final firstCipherText = await service.encrypt(clearText, key);
    final secondCipherText = await service.encrypt(clearText, key);

    expect(firstCipherText, isNot(secondCipherText));
    expect(await service.decrypt(firstCipherText, key), clearText);
    expect(await service.decrypt(secondCipherText, key), clearText);
  });

  test('AES-GCM rejects payloads shorter than nonce and MAC', () async {
    final malformed = base64.encode(<int>[1, 2, 3]);

    await expectLater(
      service.decrypt(malformed, key),
      throwsA(isA<FormatException>()),
    );
  });

  test('AES-GCM rejects a modified authenticated payload', () async {
    final cipherText = await service.encrypt('لا تقبل العبث', key);
    final bytes = base64.decode(cipherText);
    bytes[bytes.length - 1] ^= 0x01;

    await expectLater(
      service.decrypt(base64.encode(bytes), key),
      throwsA(isA<Object>()),
    );
  });
}
