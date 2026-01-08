import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/models/message_template.dart';
import 'package:wing_of_nostalgia/core/psychology/emotional_state.dart';
import 'package:wing_of_nostalgia/core/cognitive/resonance_engine.dart';
import 'package:wing_of_nostalgia/core/cognitive/relational_analytics_service.dart'; // ignore: lines_longer_than_80_chars

void main() {
  late ResonanceEngine engine;

  setUp(() {
    engine = ResonanceEngine();
  });

  group('ResonanceEngine Tests', () {
    test('calculateResonanceScore with perfect match', () {
      final template = MessageTemplate(
        id: 'res-1',
        type: 'love',
        content: 'I love you',
        intensity: 0.8,
        tags: ['love'],
        optimalStability: 0.8,
      );

      const report = RelationalReport(
        stability: 0.8,
        engagementVelocity: 1.0,
        dominantSentiment: EmotionType.love,
        insights: [],
      );

      final score = engine.calculateResonanceScore(
        template: template,
        currentEmotion: EmotionType.love,
        relationalReport: report,
        currentDensity: 0.8,
      );

      expect(score, closeTo(1.0, 0.1));
    });

    test('calculateResonanceScore with stability delta', () {
      final template = MessageTemplate(
        id: 'res-2',
        type: 'love',
        content: 'I love you',
        intensity: 0.5,
        tags: ['love'],
        optimalStability: 1.0,
      );

      const report = RelationalReport(
        stability: 0.5,
        engagementVelocity: 1.0,
        dominantSentiment: EmotionType.neutral,
        insights: [],
      );

      final score = engine.calculateResonanceScore(
        template: template,
        currentEmotion: EmotionType.neutral,
        relationalReport: report,
        currentDensity: 0.5,
      );

      // Stability resonance will be 0.5 (1.0 - abs(0.5-1.0))
      // Sentiment alignment will be 0.5 (default)
      // Intensity resonance will be 1.0
      // Weighted: (0.5*0.4) + (0.5*0.4) + (1.0*0.2) = 0.2 + 0.2 + 0.2 = 0.6
      expect(score, closeTo(0.6, 0.05));
    });

    test('findBestResonantTemplate selects most suitable', () {
      final t1 = MessageTemplate(
        id: 't1',
        type: 'love',
        content: 'High stability love',
        intensity: 0.5,
        tags: ['love'],
        optimalStability: 0.9,
      );

      final t2 = MessageTemplate(
        id: 't2',
        type: 'support',
        content: 'Low stability support',
        intensity: 0.5,
        tags: ['support'],
        optimalStability: 0.2,
      );

      const report = RelationalReport(
        stability: 0.2,
        engagementVelocity: 1.0,
        dominantSentiment: EmotionType.sad,
        insights: [],
      );

      final best = engine.findBestResonantTemplate(
        templates: [t1, t2],
        currentEmotion: EmotionType.sad,
        relationalReport: report,
        currentDensity: 0.5,
      );

      expect(best?.id, 't2');
    });

    test('calculateOptimalPitch modulation', () {
      expect(engine.calculateOptimalPitch(1.0), closeTo(1.2, 0.0001));
      expect(engine.calculateOptimalPitch(0.0), closeTo(0.8, 0.0001));
      expect(engine.calculateOptimalPitch(0.5), closeTo(1.0, 0.0001));
    });
  });
}
