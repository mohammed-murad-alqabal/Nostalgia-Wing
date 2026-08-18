import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// [SecurityService] handles authenticated encryption for sensitive data.
///
/// New payloads use a versioned envelope containing a key ID. Legacy payloads
/// in the historical `nonce + cipherText + mac` format remain readable.
class SecurityService {
  /// Current envelope version.
  static const int currentEnvelopeVersion = 1;

  static const int _nonceLength = 12;
  static const int _macLength = 16;
  static const List<int> _magic = <int>[0x57, 0x4f, 0x4e, 0x45];
  static const int _envelopePrefixLength = 6;

  /// The AES-GCM algorithm instance.
  final AesGcm algorithm = AesGcm.with256bits();

  /// Encrypts [plainText] with a versioned envelope and [keyId].
  Future<String> encrypt(
    String plainText,
    SecretKey secretKey, {
    String keyId = 'legacy',
  }) async {
    final encrypted = await encryptBytes(
      Uint8List.fromList(utf8.encode(plainText)),
      secretKey,
      keyId: keyId,
    );
    return base64.encode(encrypted);
  }

  /// Decrypts a versioned or historical Base64 payload.
  Future<String> decrypt(String cipherBase64, SecretKey secretKey) async {
    final decrypted = await decryptBytes(
      Uint8List.fromList(base64.decode(cipherBase64)),
      secretKey,
    );
    return utf8.decode(decrypted);
  }

  /// Encrypts raw [bytes] with a versioned envelope and [keyId].
  Future<Uint8List> encryptBytes(
    Uint8List bytes,
    SecretKey secretKey, {
    String keyId = 'legacy',
  }) async {
    final keyIdBytes = utf8.encode(keyId);
    if (keyIdBytes.isEmpty || keyIdBytes.length > 255) {
      throw ArgumentError.value(keyId, 'keyId', 'must be 1-255 UTF-8 bytes');
    }

    final header = <int>[
      ..._magic,
      currentEnvelopeVersion,
      keyIdBytes.length,
      ...keyIdBytes,
    ];
    final secretBox = await algorithm.encrypt(
      bytes,
      secretKey: secretKey,
      aad: header,
    );

    return Uint8List.fromList(<int>[
      ...header,
      ...secretBox.nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);
  }

  /// Decrypts a versioned or historical raw payload.
  Future<Uint8List> decryptBytes(
    Uint8List encryptedBytes,
    SecretKey secretKey,
  ) async {
    final parsed = _parsePayload(encryptedBytes);
    final secretBox = SecretBox(
      encryptedBytes.sublist(parsed.cipherTextStart, parsed.macStart),
      nonce: encryptedBytes.sublist(parsed.nonceStart, parsed.cipherTextStart),
      mac: Mac(encryptedBytes.sublist(parsed.macStart)),
    );

    final clearTextBytes = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
      aad: parsed.aad,
    );

    return Uint8List.fromList(clearTextBytes);
  }

  /// Returns the envelope key ID, or `null` for historical unversioned data.
  String? keyIdFromBase64(String cipherBase64) =>
      keyIdFromBytes(Uint8List.fromList(base64.decode(cipherBase64)));

  /// Returns the envelope key ID, or `null` for historical unversioned data.
  String? keyIdFromBytes(Uint8List payload) => _parsePayload(payload).keyId;

  /// Returns the envelope version, or `null` for historical data.
  int? versionFromBytes(Uint8List payload) => _parsePayload(payload).version;

  _ParsedPayload _parsePayload(List<int> payload) {
    if (!_hasMagic(payload)) {
      _validateLegacyPayload(payload);
      return _ParsedPayload.legacy(
        nonceStart: 0,
        cipherTextStart: _nonceLength,
        macStart: payload.length - _macLength,
      );
    }

    if (payload.length < _envelopePrefixLength) {
      throw const FormatException('Encrypted envelope header is incomplete.');
    }
    final version = payload[4];
    if (version != currentEnvelopeVersion) {
      throw FormatException('Unsupported encrypted envelope version: $version');
    }
    final keyIdLength = payload[5];
    final nonceStart = _envelopePrefixLength + keyIdLength;
    final minimumLength = nonceStart + _nonceLength + _macLength;
    if (keyIdLength == 0 || payload.length < minimumLength) {
      throw const FormatException('Encrypted envelope is malformed.');
    }

    final keyId =
        utf8.decode(payload.sublist(_envelopePrefixLength, nonceStart));
    if (keyId.isEmpty) {
      throw const FormatException('Encrypted envelope key ID is empty.');
    }

    return _ParsedPayload(
      version: version,
      keyId: keyId,
      nonceStart: nonceStart,
      cipherTextStart: nonceStart + _nonceLength,
      macStart: payload.length - _macLength,
      aad: payload.sublist(0, nonceStart),
    );
  }

  bool _hasMagic(List<int> payload) {
    if (payload.length < _magic.length) return false;
    for (var index = 0; index < _magic.length; index++) {
      if (payload[index] != _magic[index]) return false;
    }
    return true;
  }

  void _validateLegacyPayload(List<int> payload) {
    if (payload.length < _nonceLength + _macLength) {
      throw const FormatException(
        'Encrypted payload is too short for AES-GCM.',
      );
    }
  }
}

class _ParsedPayload {
  const _ParsedPayload({
    required this.version,
    required this.keyId,
    required this.nonceStart,
    required this.cipherTextStart,
    required this.macStart,
    required this.aad,
  });

  const _ParsedPayload.legacy({
    required this.nonceStart,
    required this.cipherTextStart,
    required this.macStart,
  })  : version = null,
        keyId = null,
        aad = const <int>[];

  final int? version;
  final String? keyId;
  final int nonceStart;
  final int cipherTextStart;
  final int macStart;
  final List<int> aad;
}
