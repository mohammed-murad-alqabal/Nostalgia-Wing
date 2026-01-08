import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';

/// Extension for Memory model tests.
extension MemoryExtension on Memory {
  /// Returns the age of the memory in days.
  int get ageInDays => DateTime.now().difference(createdAt).inDays;
}

void main() {
  group('Memory Model (Drift Authoritative)', () {
    test('Should create a valid Memory instance', () {
      final now = DateTime.now();
      final memory = Memory(
        id: 1,
        title: 'First Memory',
        encryptedContent: 'Encrypted Content',
        createdAt: now,
        viewCount: 0,
        color: '#FFFFFF',
      );

      expect(memory.id, 1);
      expect(memory.title, 'First Memory');
      expect(memory.encryptedContent, 'Encrypted Content');
      expect(memory.viewCount, 0);
      expect(memory.createdAt, now);
    });

    test('copyWith should create a new instance with updated fields', () {
      final now = DateTime.now();
      final original = Memory(
        id: 2,
        title: 'Original Title',
        encryptedContent: 'Content',
        createdAt: now,
        viewCount: 0,
      );

      final updated = original.copyWith(title: 'Updated Title');

      expect(original.title, 'Original Title');
      expect(updated.title, 'Updated Title');
      expect(updated.id, original.id);
      expect(updated.createdAt, original.createdAt);
    });

    test('ageInDays should calculate correctly', () {
      final pastDate =
          DateTime.now().subtract(const Duration(days: 10, hours: 1));
      final memory = Memory(
        id: 3,
        title: 'Old Memory',
        encryptedContent: 'Content',
        createdAt: pastDate,
        viewCount: 0,
      );

      expect(memory.ageInDays, 10);
    });
  });
}
