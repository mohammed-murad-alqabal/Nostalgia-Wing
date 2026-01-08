import '../models/message_template.dart';
import '../psychology/emotional_state.dart';
import 'relational_analytics_service.dart';

/// Engine for calculating emotional resonance between messages and user state.
///
/// Distilled from Phase 8: Advanced Message Synthesis & Resonance.
class ResonanceEngine {
  /// Calculates the resonance score for a given template.
  ///
  /// Score is based on:
  /// 1. Stability match (relational delta)
  /// 2. Sentiment alignment
  /// 3. Intensity calibration
  double calculateResonanceScore({
    required MessageTemplate template,
    required EmotionType currentEmotion,
    required RelationalReport relationalReport,
    required double currentDensity,
  }) {
    // 1. Stability Alignment (Relational Resonance)
    final stabilityRef = template.optimalStability;
    final stabilityDelta = (relationalReport.stability - stabilityRef).abs();
    final stabilityResonance = 1.0 - stabilityDelta;

    // 2. Sentiment Alignment (Emotional Context)
    // Some message types resonate better with specific emotions
    final sentimentResonance = _calculateSentimentAlignment(
      templateType: template.type,
      currentEmotion: currentEmotion,
    );

    // 3. Intensity Calibration (Energy Levels)
    // Low density -> High intensity might be overwhelming
    // High density -> Low intensity might be unnoticeable
    final intensityDelta = (template.intensity - currentDensity).abs();
    final intensityResonance = 1.0 - intensityDelta;

    // 4. Threshold Check (Safety Lock)
    if (template.resonanceThreshold > 0.8 && stabilityResonance < 0.5) {
      // High-threshold messages require high stability
      return 0.0;
    }

    // Weighted average
    return (stabilityResonance * 0.4) +
        (sentimentResonance * 0.4) +
        (intensityResonance * 0.2);
  }

  /// Finds the best resonant template from a list.
  MessageTemplate? findBestResonantTemplate({
    required List<MessageTemplate> templates,
    required EmotionType currentEmotion,
    required RelationalReport relationalReport,
    required double currentDensity,
  }) {
    if (templates.isEmpty) return null;

    MessageTemplate? best;
    double maxScore = -1.0;

    for (final template in templates) {
      final score = calculateResonanceScore(
        template: template,
        currentEmotion: currentEmotion,
        relationalReport: relationalReport,
        currentDensity: currentDensity,
      );

      if (score > maxScore) {
        maxScore = score;
        best = template;
      }
    }

    return best;
  }

  double _calculateSentimentAlignment({
    required String templateType,
    required EmotionType currentEmotion,
  }) {
    final type = templateType.toLowerCase();

    // Core alignments
    if (type == 'love' || type == 'حب') {
      if (currentEmotion == EmotionType.love) return 1.0;
      if (currentEmotion == EmotionType.happy) return 0.8;
      if (currentEmotion == EmotionType.sad) return 0.6; // Comforting
    }

    if (type == 'missing' || type == 'شوق') {
      if (currentEmotion == EmotionType.nostalgic) return 1.0;
      if (currentEmotion == EmotionType.sad) return 0.8;
    }

    if (type == 'support' || type == 'دعم') {
      if (currentEmotion == EmotionType.sad) return 1.0;
      if (currentEmotion == EmotionType.neutral) return 0.8;
    }

    if (type == 'calm' || type == 'هدوء') {
      if (currentEmotion == EmotionType.calm) return 1.0;
      if (currentEmotion == EmotionType.neutral) return 0.9;
    }

    // Default alignment
    return 0.5;
  }

  /// Modulates message pitch/rate for TTS based on relational stability.
  double calculateOptimalPitch(double stability) => 0.8 + (stability * 0.4);
}
