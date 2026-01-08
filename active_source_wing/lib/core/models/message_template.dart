/// Model for an emotional message template.
///
/// Representative of an emotional message template containing:
/// - Textural content of the message
/// - Category and emotional tone
/// - Emotional intensity level
/// - Tags and keywords
library;

import 'package:hive/hive.dart';

part 'message_template.g.dart';

/// Model for an emotional message template.
@HiveType(typeId: 4)
class MessageTemplate extends HiveObject {
  /// Constructor for the model.
  MessageTemplate({
    required this.id,
    required this.type,
    required this.content,
    required this.intensity,
    required this.tags,
    DateTime? createdAt,
    this.lastUsedAt,
    this.usageCount = 0,
    this.isFavorite = false,
    this.userRating,
    this.notes,
    this.resonanceThreshold = 0.5,
    this.optimalStability = 0.5,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create from JSON.
  factory MessageTemplate.fromJson(Map<String, dynamic> json) =>
      MessageTemplate(
        id: json['id'] as String,
        type: json['type'] as String,
        content: json['content'] as String,
        intensity: (json['intensity'] as num).toDouble(),
        tags: List<String>.from(json['tags'] as List),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        lastUsedAt: json['lastUsedAt'] != null
            ? DateTime.parse(json['lastUsedAt'] as String)
            : null,
        usageCount: json['usageCount'] as int? ?? 0,
        isFavorite: json['isFavorite'] as bool? ?? false,
        userRating: json['userRating'] != null
            ? (json['userRating'] as num).toDouble()
            : null,
        notes: json['notes'] as String?,
        resonanceThreshold:
            (json['resonanceThreshold'] as num?)?.toDouble() ?? 0.5,
        optimalStability: (json['optimalStability'] as num?)?.toDouble() ?? 0.5,
      );

  /// Unique identifier for the template.
  @HiveField(0)
  final String id;

  /// Message category (love, missing, support, gratitude, etc.).
  @HiveField(1)
  final String type;

  /// Textual content of the message.
  @HiveField(2)
  final String content;

  /// Emotional intensity level (0.0 - 1.0).
  @HiveField(3)
  final double intensity;

  /// Tags and keywords.
  @HiveField(4)
  final List<String> tags;

  /// Creation date.
  @HiveField(5)
  final DateTime createdAt;

  /// Last used date.
  @HiveField(6)
  DateTime? lastUsedAt;

  /// Number of times used.
  @HiveField(7)
  int usageCount;

  /// Is the message a favorite?
  @HiveField(8)
  bool isFavorite;

  /// User rating for the message (1-5).
  @HiveField(9)
  double? userRating;

  /// Additional notes.
  @HiveField(10)
  String? notes;

  /// Resonance threshold (0.0 - 1.0).
  @HiveField(11)
  final double resonanceThreshold;

  /// Optimal stability for this message (0.0 - 1.0).
  @HiveField(12)
  final double optimalStability;

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'content': content,
        'intensity': intensity,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
        'lastUsedAt': lastUsedAt?.toIso8601String(),
        'usageCount': usageCount,
        'isFavorite': isFavorite,
        'userRating': userRating,
        'notes': notes,
        'resonanceThreshold': resonanceThreshold,
        'optimalStability': optimalStability,
      };

  /// Copy the model with modifications.
  MessageTemplate copyWith({
    String? id,
    String? type,
    String? content,
    double? intensity,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    int? usageCount,
    bool? isFavorite,
    double? userRating,
    String? notes,
    double? resonanceThreshold,
    double? optimalStability,
  }) =>
      MessageTemplate(
        id: id ?? this.id,
        type: type ?? this.type,
        content: content ?? this.content,
        intensity: intensity ?? this.intensity,
        tags: tags ?? this.tags,
        createdAt: createdAt ?? this.createdAt,
        lastUsedAt: lastUsedAt ?? this.lastUsedAt,
        usageCount: usageCount ?? this.usageCount,
        isFavorite: isFavorite ?? this.isFavorite,
        userRating: userRating ?? this.userRating,
        notes: notes ?? this.notes,
        resonanceThreshold: resonanceThreshold ?? this.resonanceThreshold,
        optimalStability: optimalStability ?? this.optimalStability,
      );

  /// Record message usage.
  void markAsUsed() {
    lastUsedAt = DateTime.now();
    usageCount++;
    save(); // Save to Hive
  }

  /// Toggle favorite status.
  void toggleFavorite() {
    isFavorite = !isFavorite;
    save(); // Save to Hive
  }

  /// Update rating.
  void updateRating(double rating) {
    if (rating >= 1.0 && rating <= 5.0) {
      userRating = rating;
      save(); // Save to Hive
    }
  }

  /// Update notes.
  void updateNotes(String newNotes) {
    notes = newNotes;
    save(); // Save to Hive
  }

  /// Get a short description of the message.
  String get shortDescription {
    if (content.length <= 50) return content;
    return '${content.substring(0, 47)}...';
  }

  /// Get intensity level as text.
  String get intensityLevel {
    if (intensity >= 0.8) return 'High';
    if (intensity >= 0.6) return 'Medium';
    if (intensity >= 0.4) return 'Low';
    return 'Calm';
  }

  /// Get a suitable color for the category.
  String get color {
    switch (type.toLowerCase()) {
      case 'love':
      case 'حب':
        return '#FF6B9D';
      case 'missing':
      case 'شوق':
        return '#4ECDC4';
      case 'support':
      case 'دعم':
        return '#45B7D1';
      case 'gratitude':
      case 'امتنان':
        return '#96CEB4';
      case 'encouragement':
      case 'تشجيع':
        return '#FFEAA7';
      default:
        return '#A8A8A8';
    }
  }

  /// Validate data.
  bool get isValid =>
      id.isNotEmpty &&
      type.isNotEmpty &&
      content.isNotEmpty &&
      intensity >= 0.0 &&
      intensity <= 1.0 &&
      tags.isNotEmpty;

  /// Compare models.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageTemplate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  /// String representation of the model.
  @override
  String toString() =>
      'MessageTemplate(id: $id, type: $type, content: $shortDescription, '
      'intensity: $intensity)';
}
