/// Represents the specific emotion type.
enum EmotionType {
  /// Represents happiness.
  happy,

  /// Represents sadness.
  sad,

  /// Represents anxiety.
  anxious,

  /// Represents calmness.
  calm,

  /// Represents a neutral state.
  neutral,

  /// Represents joy.
  joy,

  /// Represents love.
  love,

  /// Represents anger.
  anger,

  /// Represents fear.
  fear,

  /// Represents surprise.
  surprise,

  /// Represents disgust.
  disgust,

  /// Represents trust.
  trust,

  /// Represents anticipation.
  anticipation,

  /// A sentimental longing or wistful affection for the past.
  nostalgic,

  /// Feeling or inspiring optimism about a future event.
  hopeful,

  /// Very enthusiastic and eager.
  excited,

  /// Feeling or showing an appreciation of kindness; thankful.
  grateful,

  // --- Synonyms / Additional States required by legacy code ---
  // Removed during Phase 1 Refactor
}

/// Represents the comprehensive emotional analysis result.
/// Contains the dominant emotion, intensity, and recommendations.
class EmotionalState {
  /// Creates an [EmotionalState].
  const EmotionalState({
    required this.dominantEmotion,
    required this.intensity,
    required this.stability,
    required this.recommendations,
  });

  /// The dominant emotion detected.
  final EmotionType dominantEmotion;

  /// The intensity of the emotion (0.0 to 1.0).
  final double intensity;

  /// The stability of the emotional state (0.0 to 1.0).
  final double stability;

  /// Recommendations based on the emotional state.
  final List<String> recommendations;
}
