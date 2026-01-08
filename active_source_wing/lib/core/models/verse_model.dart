import 'package:hive/hive.dart';

part 'verse_model.g.dart';

/// Model representing a verse with Arabic text and translation.
@HiveType(typeId: 0)
class VerseModel extends HiveObject {
  /// Creates a [VerseModel].
  VerseModel({
    required this.id,
    required this.arabicText,
    required this.translation,
    required this.source,
    required this.category,
    required this.createdAt,
  });

  /// Creates a [VerseModel] from a JSON map.
  factory VerseModel.fromJson(Map<String, dynamic> json) => VerseModel(
        id: json['id'] ?? '',
        arabicText: json['arabic_text'] ?? '',
        translation: json['translation'] ?? '',
        source: json['source'] ?? '',
        category: json['category'] ?? '',
        createdAt:
            DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      );

  /// Unique identifier.
  @HiveField(0)
  final String id;

  /// The Arabic text of the verse.
  @HiveField(1)
  final String arabicText;

  /// The translation of the verse.
  @HiveField(2)
  final String translation;

  /// The source of the verse (e.g., poet name, book).
  @HiveField(3)
  final String source;

  /// The category of the verse (e.g., Love, Longing).
  @HiveField(4)
  final String category;

  /// The creation timestamp.
  @HiveField(5)
  final DateTime createdAt;

  /// Converts the model to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'arabic_text': arabicText,
        'translation': translation,
        'source': source,
        'category': category,
        'created_at': createdAt.toIso8601String(),
      };
}
