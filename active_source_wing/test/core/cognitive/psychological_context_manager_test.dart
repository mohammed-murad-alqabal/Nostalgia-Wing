import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:wing_of_nostalgia/core/cognitive/psychological_context_manager.dart'; // ignore: lines_longer_than_80_chars
import 'package:wing_of_nostalgia/core/psychology/emotional_state.dart';

void main() {
  late Directory tempDir;
  late PsychologicalContextManager manager;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('psych_context_test_');
    Hive.init(tempDir.path);
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  setUp(() async {
    manager = PsychologicalContextManager();
    await manager.initialize();
  });

  group('PsychologicalContextManager Tests', () {
    test('initial density is 0.5', () {
      expect(manager.getEmotionalDensity(), 0.5);
    });

    test('positive interaction increases density', () async {
      final initial = manager.getEmotionalDensity();
      await manager.trackInteraction(
        text: 'أحبك كثيرًا',
        type: EmotionType.happy,
      );
      expect(manager.getEmotionalDensity(), greaterThan(initial));
    });

    test('negative interaction decreases density', () async {
      // First increase it to have some room to decrease
      await manager.trackInteraction(
        text: 'يوم رائع',
        type: EmotionType.happy,
      );
      final mid = manager.getEmotionalDensity();

      await manager.trackInteraction(
        text: 'أشعر بالحزن',
        type: EmotionType.sad,
      );
      expect(manager.getEmotionalDensity(), lessThan(mid));
    });

    test('identifies conflict nodes', () async {
      await manager.trackInteraction(
        text: 'لدينا مشكلة في الوقت',
        type: EmotionType.anxious,
      );

      final nodes = manager.identifyConflictNodes();
      expect(nodes, isNotEmpty);
      expect(nodes.first, contains('مشكلة'));
    });

    test('identifies dominant emotion', () async {
      await manager.trackInteraction(text: '1', type: EmotionType.happy);
      await manager.trackInteraction(text: '2', type: EmotionType.happy);
      await manager.trackInteraction(text: '3', type: EmotionType.sad);

      expect(manager.getDominantEmotion(), EmotionType.happy);
    });
  });
}
