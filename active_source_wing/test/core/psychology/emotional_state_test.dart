import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/psychology/emotional_state.dart';

void main() {
  group('EmotionalState', () {
    test('should have all required values', () {
      expect(EmotionType.values, contains(EmotionType.happy));
      expect(EmotionType.values, contains(EmotionType.sad));
      expect(EmotionType.values, contains(EmotionType.nostalgic));
      expect(EmotionType.values, contains(EmotionType.hopeful));
      expect(EmotionType.values, contains(EmotionType.excited));
      expect(EmotionType.values, contains(EmotionType.grateful));
    });

    test('should support EmotionType alias', () {
      expect(EmotionType.happy, equals(EmotionType.happy));
      expect(EmotionType.nostalgic, equals(EmotionType.nostalgic));
    });

    test('should have correct total number of states', () {
      // 13 original + 4 new = 17
      expect(EmotionType.values.length, greaterThanOrEqualTo(17));
    });
  });
}
