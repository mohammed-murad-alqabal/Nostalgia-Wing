/// Core interaction models for the system.
library;

import '../psychology/emotional_state.dart';

/// Types of interactions available in the system.
enum InteractionType {
  /// Reflection or deep thinking.
  reflection,

  /// Creating a new memory.
  memoryCreation,

  /// Reading a verse or quote.
  verseReading,

  /// Writing a gratitude entry.
  gratitudeWriting,

  /// Viewing content.
  contentView,

  /// General browsing.
  browsing,
}

/// Representation of a single user interaction.
class UserInteraction {
  /// Creates a [UserInteraction].
  const UserInteraction({
    required this.timestamp,
    required this.duration,
    required this.contentType,
    required this.interactionType,
    this.emotionalResponse,
  });

  /// Time when the interaction occurred.
  final DateTime timestamp;

  /// Duration of the interaction.
  final Duration duration;

  /// Type of content interacted with.
  final String contentType;

  /// Type of interaction.
  final InteractionType interactionType;

  /// Emotional response associated with this interaction, if any.
  final EmotionType? emotionalResponse;
}

/// Interaction pattern extracted from a set of interactions.
class InteractionPattern {
  /// Creates an [InteractionPattern].
  const InteractionPattern({
    required this.averageDuration,
    required this.frequency,
    required this.preferredContentTypes,
  });

  /// Average duration of interactions.
  final Duration averageDuration;

  /// Frequency of interactions per 24 hours.
  final double frequency;

  /// List of preferred content types.
  final List<String> preferredContentTypes;

  /// Calculates the engagement level (0.0 - 1.0).
  ///
  /// Based on frequency and average duration.
  double get engagementLevel {
    // Assuming 10 interactions/day is max score
    final freqScore = (frequency / 10.0).clamp(0.0, 1.0);
    // Assuming 15 mins avg is max score
    final durationScore = (averageDuration.inMinutes / 15.0).clamp(0.0, 1.0);
    return (freqScore * 0.7 + durationScore * 0.3).clamp(0.0, 1.0);
  }
}

/// Alias for [EmotionType] to maintain backward compatibility if needed.
typedef EmotionalResponse = EmotionType;
