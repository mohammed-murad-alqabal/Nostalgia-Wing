import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/models/interaction_models.dart';
import 'package:wing_of_nostalgia/core/psychology/emotional_state.dart';
import 'package:wing_of_nostalgia/core/cognitive/relational_analytics_service.dart'; // ignore: lines_longer_than_80_chars

void main() {
  late RelationalAnalyticsService service;

  setUp(() {
    service = RelationalAnalyticsService();
  });

  group('RelationalAnalyticsService Tests', () {
    test('calculateRelationalHealth with empty interactions', () async {
      final report = await service.analyzeRelationalHealth([]);
      expect(report.stability, equals(0.5));
      expect(report.engagementVelocity, equals(0.0));
      expect(report.dominantSentiment, equals(EmotionType.neutral));
      expect(report.insights.first, contains('Not enough data'));
    });

    test('calculateRelationalHealth with stable happy interactions', () async {
      final now = DateTime.now();
      final interactions = [
        UserInteraction(
          timestamp: now.subtract(const Duration(days: 2)),
          duration: const Duration(minutes: 10),
          contentType: 'memory',
          interactionType: InteractionType.memoryCreation,
          emotionalResponse: EmotionType.happy,
        ),
        UserInteraction(
          timestamp: now.subtract(const Duration(days: 1)),
          duration: const Duration(minutes: 5),
          contentType: 'memory',
          interactionType: InteractionType.memoryCreation,
          emotionalResponse: EmotionType.happy,
        ),
        UserInteraction(
          timestamp: now,
          duration: const Duration(minutes: 8),
          contentType: 'memory',
          interactionType: InteractionType.memoryCreation,
          emotionalResponse: EmotionType.happy,
        ),
      ];

      final report = await service.analyzeRelationalHealth(interactions);
      expect(report.stability, greaterThan(0.8));
      expect(report.engagementVelocity, equals(1.5)); // 3 interactions / 2 days
      expect(report.dominantSentiment, equals(EmotionType.happy));
      expect(
        report.insights,
        contains(
          'العلاقة تبدو مستقرة جداً وثابتة عاطفياً.',
        ),
      );
    });

    test('calculateRelationalHealth with unstable interactions', () async {
      final now = DateTime.now();
      final interactions = [
        UserInteraction(
          timestamp: now.subtract(const Duration(hours: 4)),
          duration: const Duration(minutes: 2),
          contentType: 'browsing',
          interactionType: InteractionType.browsing,
          emotionalResponse: EmotionType.happy,
        ),
        UserInteraction(
          timestamp: now.subtract(const Duration(hours: 3)),
          duration: const Duration(minutes: 2),
          contentType: 'browsing',
          interactionType: InteractionType.browsing,
          emotionalResponse: EmotionType.sad,
        ),
        UserInteraction(
          timestamp: now.subtract(const Duration(hours: 2)),
          duration: const Duration(minutes: 2),
          contentType: 'browsing',
          interactionType: InteractionType.browsing,
          emotionalResponse: EmotionType.anxious,
        ),
        UserInteraction(
          timestamp: now.subtract(const Duration(hours: 1)),
          duration: const Duration(minutes: 2),
          contentType: 'browsing',
          interactionType: InteractionType.browsing,
          emotionalResponse: EmotionType.calm,
        ),
      ];

      final report = await service.analyzeRelationalHealth(interactions);
      // Many unique emotions in same context = lower stability
      expect(report.stability, lessThan(0.7));
      expect(
        report.insights,
        contains(
          'هناك تذبذب عاطفي ملحوظ، قد يحتاج الأمر لمساحة من الهدوء.',
        ),
      );
    });
  });
}
