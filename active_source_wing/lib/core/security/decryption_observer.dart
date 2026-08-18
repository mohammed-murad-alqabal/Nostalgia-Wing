/// Categories used to classify failures while decrypting local data.
enum DecryptionFailureKind {
  /// The Base64 wrapper could not be decoded.
  invalidEncoding,

  /// The payload structure is invalid or incomplete.
  malformedPayload,

  /// The payload uses an envelope version not supported by this build.
  unsupportedVersion,

  /// The key referenced by the payload is unavailable.
  missingKey,

  /// Authentication failed because ciphertext, metadata, or key material did
  /// not validate.
  authenticationFailed,

  /// Decrypted bytes are not valid UTF-8 text.
  invalidClearText,

  /// An unexpected failure occurred inside the decryption boundary.
  unknown,
}

/// A privacy-safe event emitted when decryption cannot complete.
///
/// The event deliberately excludes plaintext, ciphertext, secret-key bytes,
/// exception messages, and stack traces. [toSafeData] is suitable for logs or
/// future telemetry backends.
class DecryptionFailureEvent {
  /// Creates a decryption failure event.
  const DecryptionFailureEvent({
    required this.kind,
    required this.operation,
    this.keyId,
    this.envelopeVersion,
    this.payloadLength,
  });

  /// High-level reason for the failure.
  final DecryptionFailureKind kind;

  /// Public operation that was being attempted, such as `text` or `bytes`.
  final String operation;

  /// Sanitized envelope key ID when it is a known safe identifier.
  final String? keyId;

  /// Parsed envelope version, if available.
  final int? envelopeVersion;

  /// Length of the encoded or binary payload, never its contents.
  final int? payloadLength;

  /// Converts this event to fields safe for local logs and telemetry.
  Map<String, dynamic> toSafeData() {
    final data = <String, dynamic>{
      'kind': kind.name,
      'operation': operation,
    };
    if (keyId != null) data['keyId'] = keyId!;
    if (envelopeVersion != null) {
      data['envelopeVersion'] = envelopeVersion!;
    }
    if (payloadLength != null) data['payloadLength'] = payloadLength!;
    return data;
  }
}

/// Receives privacy-safe decryption failure events.
typedef DecryptionFailureObserver = void Function(
  DecryptionFailureEvent event,
);

/// A format error with a stable, privacy-safe classification.
class DecryptionFormatException extends FormatException {
  /// Creates a classified decryption format error.
  const DecryptionFormatException(this.kind, String message) : super(message);

  /// Classification associated with this format error.
  final DecryptionFailureKind kind;
}

/// Returns whether [error] is most likely an AES-GCM authentication failure.
///
/// The cryptography package has changed the concrete exception name across
/// releases. Matching the stable semantic name keeps this boundary compatible
/// without exposing the exception text to logs.
bool isAuthenticationFailure(Object error) =>
    error.runtimeType.toString().toLowerCase().contains('authentication');

/// Returns a key ID only when it follows this application's generated format.
String? safeDecryptionKeyId(String? keyId) {
  if (keyId == null || keyId == 'legacy') return keyId;
  return RegExp(r'^v[0-9]+$').hasMatch(keyId) ? keyId : null;
}
