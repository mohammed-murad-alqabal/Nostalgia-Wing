import 'package:hive/hive.dart';
import '../models/interaction_models.dart';
import '../psychology/emotional_state.dart';
import '../infrastructure/wing_logger.dart';

/// NHW.MODULE.LIBRARY.v1.0 - Relational Memory Database Implementation
///
/// Manages the psychological context and relational memory of the system.
/// Tracks emotional density, conflict nodes, and interaction patterns.
class PsychologicalContextManager {
  /// The Hive box name for psychological context.
  static const String boxName = 'psychological_context';

  /// Internal reference to the Hive box.
  late Box<dynamic> _box;

  /// Initializes the manager and opens the Hive box.
  Future<void> initialize() async {
    _box = await Hive.openBox<dynamic>(boxName);
    WingLogger.info(
      'PsychologicalContextManager initialized',
      tag: 'CognitiveCore',
    );
  }

  /// Tracks a new interaction and updates the emotional density.
  Future<void> trackInteraction({
    required String text,
    required EmotionType type,
    Map<String, dynamic>? metadata,
  }) async {
    final timestamp = DateTime.now();
    final List interactionsRaw =
        _box.get('interactions', defaultValue: []) as List;
    final interactions = interactionsRaw.cast<Map>();

    interactions.add({
      'timestamp': timestamp.toIso8601String(),
      'text': text,
      'type': type.toString(),
      'metadata': metadata,
      'duration_ms': metadata?['duration_ms'] ?? 0,
      'content_type': metadata?['content_type'] ?? 'general',
      'interaction_type': metadata?['interaction_type'] ?? 'browsing',
    });

    // Keep only the last 100 interactions to avoid bloat
    if (interactions.length > 100) {
      interactions.removeAt(0);
    }

    await _box.put('interactions', interactions);
    await _updateEmotionalDensity(type);
  }

  /// Updates the density based on emotion type.
  Future<void> _updateEmotionalDensity(EmotionType lastType) async {
    double currentDensity = _box.get('emotional_density', defaultValue: 0.5);

    // Simple logic: positive emotions increase density, negative or
    // neutral ones slowly decrease or stabilize it.
    if (lastType == EmotionType.happy || lastType == EmotionType.calm) {
      currentDensity = (currentDensity + 0.05).clamp(0.0, 1.0);
    } else if (lastType == EmotionType.sad || lastType == EmotionType.anxious) {
      currentDensity = (currentDensity - 0.02).clamp(0.0, 1.0);
    }

    await _box.put('emotional_density', currentDensity);
    await _box.put('last_emotion_time', DateTime.now().toIso8601String());
  }

  /// Gets the current emotional density (Presence Density).
  double getEmotionalDensity() =>
      _box.get('emotional_density', defaultValue: 0.5);

  /// Identifies potential conflict nodes based on interaction history.
  List<String> identifyConflictNodes() {
    final interactions =
        (_box.get('interactions', defaultValue: []) as List).cast<Map>();
    final conflictNodes = <String>[];

    // Simple pattern recognition for keywords associated with conflict
    for (final interaction in interactions) {
      final text = (interaction['text'] as String).toLowerCase();
      if (text.contains('خلاف') ||
          text.contains('مشكلة') ||
          text.contains('تعب')) {
        conflictNodes.add(text);
      }
    }

    return conflictNodes;
  }

  /// Gets the dominant emotion from the last 10 interactions.
  EmotionType getDominantEmotion() {
    final interactions =
        (_box.get('interactions', defaultValue: []) as List).cast<Map>();
    if (interactions.isEmpty) return EmotionType.neutral;

    final recent = interactions.reversed.take(10);
    final counts = <String, int>{};

    for (final i in recent) {
      final type = i['type'] as String;
      counts[type] = (counts[type] ?? 0) + 1;
    }

    final dominantTypeStr =
        counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return EmotionType.values.firstWhere(
      (e) => e.toString() == dominantTypeStr,
      orElse: () => EmotionType.neutral,
    );
  }

  /// Gets all stored interactions as [UserInteraction] objects.
  List<UserInteraction> get interactions =>
      (_box.get('interactions', defaultValue: []) as List)
          .cast<Map>()
          .map((m) => UserInteraction(
                timestamp: DateTime.parse(m['timestamp'] as String),
                duration: Duration(milliseconds: m['duration_ms'] as int? ?? 0),
                contentType: m['content_type'] as String? ?? 'general',
                interactionType:
                    _parseInteractionType(m['interaction_type'] as String?),
                emotionalResponse: _parseEmotionType(m['type'] as String?),
              ))
          .toList();

  InteractionType _parseInteractionType(String? value) {
    if (value == null) return InteractionType.browsing;
    return InteractionType.values.firstWhere(
      (v) => v.toString() == value,
      orElse: () => InteractionType.browsing,
    );
  }

  EmotionType? _parseEmotionType(String? value) {
    if (value == null) return null;
    return EmotionType.values.firstWhere(
      (v) => v.toString() == value,
      orElse: () => EmotionType.neutral,
    );
  }
}
