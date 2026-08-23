import 'dart:math';

/// Utilities for password policy checks and local password generation.
///
/// This class deliberately contains no encryption implementation. Sensitive
/// payloads must use [SecurityService] and [VersionedEncryptionService].
class PasswordSecurityUtils {
  PasswordSecurityUtils._();

  /// Returns a simple policy score from 0 to 5.
  static int checkStrength(String password) {
    var strength = 0;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength;
  }

  /// Generates a cryptographically secure random password.
  static String generate({int length = 16}) {
    if (length < 1) {
      throw ArgumentError.value(length, 'length', 'must be positive');
    }

    const chars = 'abcdefghijklmnopqrstuvwxyz'
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        '0123456789'
        '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    final random = Random.secure();
    final result = StringBuffer();

    for (var index = 0; index < length; index++) {
      result.write(chars[random.nextInt(chars.length)]);
    }

    return result.toString();
  }
}
