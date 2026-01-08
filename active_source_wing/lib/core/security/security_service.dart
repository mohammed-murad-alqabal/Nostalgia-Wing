import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

/// [SecurityService] handles encryption of sensitive marital data.
/// It uses AES-256-GCM for authenticated encryption.
class SecurityService {
  /// The AES-GCM algorithm instance.
  final AesGcm algorithm = AesGcm.with256bits();

  /// Encrypts a [plainText] using the provided [secretKey].
  /// Returns a Base64 encoded string containing [nonce + cipherText + mac].
  Future<String> encrypt(String plainText, SecretKey secretKey) async {
    final clearTextBytes = utf8.encode(plainText);

    // Generate a random nonce for each encryption
    final secretBox = await algorithm.encrypt(
      clearTextBytes,
      secretKey: secretKey,
    );

    // Combine nonce + cipherText + mac for storage
    final combined = BytesBuilder();
    combined.add(secretBox.nonce);
    combined.add(secretBox.cipherText);
    combined.add(secretBox.mac.bytes);

    return base64.encode(combined.toBytes());
  }

  /// Decrypts a [cipherBase64] using the provided [secretKey].
  Future<String> decrypt(String cipherBase64, SecretKey secretKey) async {
    final combinedBytes = base64.decode(cipherBase64);

    // AES-GCM nonce is typically 12 bytes
    final nonce = combinedBytes.sublist(0, 12);
    // MAC is typically 16 bytes for AES-GCM
    final macBytes = combinedBytes.sublist(combinedBytes.length - 16);
    final cipherText = combinedBytes.sublist(12, combinedBytes.length - 16);

    final secretBox = SecretBox(
      cipherText,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    final clearTextBytes = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return utf8.decode(clearTextBytes);
  }

  /// Encrypts raw [bytes] using the provided [secretKey].
  Future<Uint8List> encryptBytes(Uint8List bytes, SecretKey secretKey) async {
    final secretBox = await algorithm.encrypt(
      bytes,
      secretKey: secretKey,
    );

    final combined = BytesBuilder();
    combined.add(secretBox.nonce);
    combined.add(secretBox.cipherText);
    combined.add(secretBox.mac.bytes);

    return combined.toBytes();
  }

  /// Decrypts [encryptedBytes] using the provided [secretKey].
  Future<Uint8List> decryptBytes(
      Uint8List encryptedBytes, SecretKey secretKey) async {
    final nonce = encryptedBytes.sublist(0, 12);
    final macBytes = encryptedBytes.sublist(encryptedBytes.length - 16);
    final cipherText = encryptedBytes.sublist(12, encryptedBytes.length - 16);

    final secretBox = SecretBox(
      cipherText,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    final clearTextBytes = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return Uint8List.fromList(clearTextBytes);
  }
}
