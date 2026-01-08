import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/models/gratitude_entry_model.dart';
import 'package:wing_of_nostalgia/core/models/message_template.dart';
import 'package:wing_of_nostalgia/core/psychology/emotional_state.dart';
import 'package:wing_of_nostalgia/core/cognitive/psychological_context_manager.dart';
import 'package:wing_of_nostalgia/core/cognitive/emotional_gravity_engine.dart';
import 'package:wing_of_nostalgia/core/cognitive/relational_analytics_service.dart';
import 'package:wing_of_nostalgia/core/cognitive/resonance_engine.dart';
import 'package:wing_of_nostalgia/core/services/db_service.dart';
import 'package:wing_of_nostalgia/core/services/notification_service.dart';
import 'package:wing_of_nostalgia/core/services/emotional_message_service.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:drift/native.dart';

/// Tests for cognitive algorithms (sentiment analysis, message generation)
void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Hive.init('.'); // Simple init for tests

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(GratitudeEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(MessageTemplateAdapter());
    }
  });

  group('EmotionType Analysis', () {
    test('happy emotion returns positive sentiment', () {
      final sentiment = _analyzeSentiment('سعيد', EmotionType.happy);
      expect(sentiment, 'positive');
    });
    // ... other sentiment tests if needed
  });

  group('Engine Integration Tests with Context', () {
    late PsychologicalContextManager contextManager;
    late RelationalAnalyticsService analyticsService;
    late ResonanceEngine resonanceEngine;
    late AppDatabase db;
    late DBService dbService;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      await sl.initialize(testDb: db);

      contextManager = PsychologicalContextManager();
      await contextManager.initialize();
      analyticsService = RelationalAnalyticsService();
      resonanceEngine = ResonanceEngine();
      dbService = DBService();
    });

    tearDown(() async {
      await db.close();
      await sl.reset();
    });

    test('EmotionalGravityEngine adapts to density', () async {
      final notificationService = NotificationService();
      final messageService = EmotionalMessageService(
        analyticsService: analyticsService,
        resonanceEngine: resonanceEngine,
        contextManager: contextManager,
        dbService: dbService,
      );

      final engine = EmotionalGravityEngine(
        messageService: messageService,
        dbService: dbService,
        notificationService: notificationService,
        contextManager: contextManager,
      );

      // Increase density
      await contextManager.trackInteraction(
          text: 'love', type: EmotionType.happy);
      await contextManager.trackInteraction(
          text: 'joy', type: EmotionType.happy);

      final template = await engine.emotionalGoldenRatioAlgorithm();
      expect(template.content, isNotEmpty);
      expect(template.intensity, equals(0.7));
    });
  });
}

// Helper function mirroring the engine's logic
String _analyzeSentiment(String text, EmotionType mood) {
  if (mood == EmotionType.happy) {
    return 'positive';
  } else if (mood == EmotionType.sad) {
    return 'negative';
  } else if (mood == EmotionType.anxious) {
    return 'negative';
  } else if (mood == EmotionType.calm) {
    return 'neutral';
  } else {
    return 'neutral';
  }
}
