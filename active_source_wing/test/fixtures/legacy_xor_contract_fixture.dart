/// Deterministic synthetic vector for the historical SecureDataManager format.
///
/// This fixture is not derived from user data. It preserves the legacy
/// contract so a future migration can prove that old payloads remain readable
/// before the legacy implementation is removed.
class LegacyXorContractFixture {
  const LegacyXorContractFixture._();

  static const userKey = 'contract-key-2026';
  static const plaintext = 'Sensitive data: أهلاً وسهلاً';
  static const timestamp = '1735689600000';
  static const payload =
      'D6FnLzQm09ZXhUCUGyTWPEdjYPCEVQoFJpJvjmm7B0rnEY2e2rkza0ds+'
      'HyYxwKArciuXWY=.KcO8og6zzYgmq1z5hrzXm+YBwtQZElWHwapudisxCpM=';
}
