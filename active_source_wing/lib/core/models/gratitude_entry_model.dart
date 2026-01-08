import 'package:hive/hive.dart';

part 'gratitude_entry_model.g.dart';

/// Model representing a gratitude journal entry.
@HiveType(typeId: 2)
class GratitudeEntry extends HiveObject {
  /// Creates a [GratitudeEntry].
  GratitudeEntry({
    required this.id,
    required this.text,
    required this.date,
    this.tags = const [],
  });

  /// Unique identifier.
  @HiveField(0)
  final String id;

  /// The gratitude text content.
  @HiveField(1)
  final String text;

  /// Date the entry was created.
  @HiveField(2)
  final DateTime date;

  /// Tags associated with this entry.
  @HiveField(3)
  final List<String> tags;

  /// Creates a copy of this entry with modified fields.
  GratitudeEntry copyWith({
    String? id,
    String? text,
    DateTime? date,
    List<String>? tags,
  }) =>
      GratitudeEntry(
        id: id ?? this.id,
        text: text ?? this.text,
        date: date ?? this.date,
        tags: tags ?? this.tags,
      );
}
