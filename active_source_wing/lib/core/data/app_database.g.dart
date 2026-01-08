// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MemoriesTable extends Memories with TableInfo<$MemoriesTable, Memory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _encryptedContentMeta =
      const VerificationMeta('encryptedContent');
  @override
  late final GeneratedColumn<String> encryptedContent = GeneratedColumn<String>(
      'encrypted_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _mediaPathMeta =
      const VerificationMeta('mediaPath');
  @override
  late final GeneratedColumn<String> mediaPath = GeneratedColumn<String>(
      'media_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emotionalScoreMeta =
      const VerificationMeta('emotionalScore');
  @override
  late final GeneratedColumn<int> emotionalScore = GeneratedColumn<int>(
      'emotional_score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _viewCountMeta =
      const VerificationMeta('viewCount');
  @override
  late final GeneratedColumn<int> viewCount = GeneratedColumn<int>(
      'view_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        encryptedContent,
        createdAt,
        mediaPath,
        emotionalScore,
        viewCount,
        color
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memories';
  @override
  VerificationContext validateIntegrity(Insertable<Memory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('encrypted_content')) {
      context.handle(
          _encryptedContentMeta,
          encryptedContent.isAcceptableOrUnknown(
              data['encrypted_content']!, _encryptedContentMeta));
    } else if (isInserting) {
      context.missing(_encryptedContentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('media_path')) {
      context.handle(_mediaPathMeta,
          mediaPath.isAcceptableOrUnknown(data['media_path']!, _mediaPathMeta));
    }
    if (data.containsKey('emotional_score')) {
      context.handle(
          _emotionalScoreMeta,
          emotionalScore.isAcceptableOrUnknown(
              data['emotional_score']!, _emotionalScoreMeta));
    }
    if (data.containsKey('view_count')) {
      context.handle(_viewCountMeta,
          viewCount.isAcceptableOrUnknown(data['view_count']!, _viewCountMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Memory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Memory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      encryptedContent: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}encrypted_content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      mediaPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}media_path']),
      emotionalScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}emotional_score']),
      viewCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}view_count'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
    );
  }

  @override
  $MemoriesTable createAlias(String alias) {
    return $MemoriesTable(attachedDatabase, alias);
  }
}

class Memory extends DataClass implements Insertable<Memory> {
  /// Primary key for memories.
  final int id;

  /// Title of the memory.
  final String title;

  /// Optional description.
  final String? description;

  /// Encrypted content using AES-256.
  final String encryptedContent;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Path to local encrypted media file.
  final String? mediaPath;

  /// Sentiment analysis result (1-100).
  final int? emotionalScore;

  /// Number of times viewed.
  final int viewCount;

  /// Associated hex color.
  final String? color;
  const Memory(
      {required this.id,
      required this.title,
      this.description,
      required this.encryptedContent,
      required this.createdAt,
      this.mediaPath,
      this.emotionalScore,
      required this.viewCount,
      this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['encrypted_content'] = Variable<String>(encryptedContent);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || mediaPath != null) {
      map['media_path'] = Variable<String>(mediaPath);
    }
    if (!nullToAbsent || emotionalScore != null) {
      map['emotional_score'] = Variable<int>(emotionalScore);
    }
    map['view_count'] = Variable<int>(viewCount);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  MemoriesCompanion toCompanion(bool nullToAbsent) {
    return MemoriesCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      encryptedContent: Value(encryptedContent),
      createdAt: Value(createdAt),
      mediaPath: mediaPath == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaPath),
      emotionalScore: emotionalScore == null && nullToAbsent
          ? const Value.absent()
          : Value(emotionalScore),
      viewCount: Value(viewCount),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
    );
  }

  factory Memory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Memory(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      encryptedContent: serializer.fromJson<String>(json['encryptedContent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      mediaPath: serializer.fromJson<String?>(json['mediaPath']),
      emotionalScore: serializer.fromJson<int?>(json['emotionalScore']),
      viewCount: serializer.fromJson<int>(json['viewCount']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'encryptedContent': serializer.toJson<String>(encryptedContent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'mediaPath': serializer.toJson<String?>(mediaPath),
      'emotionalScore': serializer.toJson<int?>(emotionalScore),
      'viewCount': serializer.toJson<int>(viewCount),
      'color': serializer.toJson<String?>(color),
    };
  }

  Memory copyWith(
          {int? id,
          String? title,
          Value<String?> description = const Value.absent(),
          String? encryptedContent,
          DateTime? createdAt,
          Value<String?> mediaPath = const Value.absent(),
          Value<int?> emotionalScore = const Value.absent(),
          int? viewCount,
          Value<String?> color = const Value.absent()}) =>
      Memory(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        encryptedContent: encryptedContent ?? this.encryptedContent,
        createdAt: createdAt ?? this.createdAt,
        mediaPath: mediaPath.present ? mediaPath.value : this.mediaPath,
        emotionalScore:
            emotionalScore.present ? emotionalScore.value : this.emotionalScore,
        viewCount: viewCount ?? this.viewCount,
        color: color.present ? color.value : this.color,
      );
  Memory copyWithCompanion(MemoriesCompanion data) {
    return Memory(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      encryptedContent: data.encryptedContent.present
          ? data.encryptedContent.value
          : this.encryptedContent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      mediaPath: data.mediaPath.present ? data.mediaPath.value : this.mediaPath,
      emotionalScore: data.emotionalScore.present
          ? data.emotionalScore.value
          : this.emotionalScore,
      viewCount: data.viewCount.present ? data.viewCount.value : this.viewCount,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Memory(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('encryptedContent: $encryptedContent, ')
          ..write('createdAt: $createdAt, ')
          ..write('mediaPath: $mediaPath, ')
          ..write('emotionalScore: $emotionalScore, ')
          ..write('viewCount: $viewCount, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, encryptedContent,
      createdAt, mediaPath, emotionalScore, viewCount, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Memory &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.encryptedContent == this.encryptedContent &&
          other.createdAt == this.createdAt &&
          other.mediaPath == this.mediaPath &&
          other.emotionalScore == this.emotionalScore &&
          other.viewCount == this.viewCount &&
          other.color == this.color);
}

class MemoriesCompanion extends UpdateCompanion<Memory> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> encryptedContent;
  final Value<DateTime> createdAt;
  final Value<String?> mediaPath;
  final Value<int?> emotionalScore;
  final Value<int> viewCount;
  final Value<String?> color;
  const MemoriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.encryptedContent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.mediaPath = const Value.absent(),
    this.emotionalScore = const Value.absent(),
    this.viewCount = const Value.absent(),
    this.color = const Value.absent(),
  });
  MemoriesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String encryptedContent,
    this.createdAt = const Value.absent(),
    this.mediaPath = const Value.absent(),
    this.emotionalScore = const Value.absent(),
    this.viewCount = const Value.absent(),
    this.color = const Value.absent(),
  })  : title = Value(title),
        encryptedContent = Value(encryptedContent);
  static Insertable<Memory> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? encryptedContent,
    Expression<DateTime>? createdAt,
    Expression<String>? mediaPath,
    Expression<int>? emotionalScore,
    Expression<int>? viewCount,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (encryptedContent != null) 'encrypted_content': encryptedContent,
      if (createdAt != null) 'created_at': createdAt,
      if (mediaPath != null) 'media_path': mediaPath,
      if (emotionalScore != null) 'emotional_score': emotionalScore,
      if (viewCount != null) 'view_count': viewCount,
      if (color != null) 'color': color,
    });
  }

  MemoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? encryptedContent,
      Value<DateTime>? createdAt,
      Value<String?>? mediaPath,
      Value<int?>? emotionalScore,
      Value<int>? viewCount,
      Value<String?>? color}) {
    return MemoriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      encryptedContent: encryptedContent ?? this.encryptedContent,
      createdAt: createdAt ?? this.createdAt,
      mediaPath: mediaPath ?? this.mediaPath,
      emotionalScore: emotionalScore ?? this.emotionalScore,
      viewCount: viewCount ?? this.viewCount,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (encryptedContent.present) {
      map['encrypted_content'] = Variable<String>(encryptedContent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (mediaPath.present) {
      map['media_path'] = Variable<String>(mediaPath.value);
    }
    if (emotionalScore.present) {
      map['emotional_score'] = Variable<int>(emotionalScore.value);
    }
    if (viewCount.present) {
      map['view_count'] = Variable<int>(viewCount.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('encryptedContent: $encryptedContent, ')
          ..write('createdAt: $createdAt, ')
          ..write('mediaPath: $mediaPath, ')
          ..write('emotionalScore: $emotionalScore, ')
          ..write('viewCount: $viewCount, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $ReflectionsTable extends Reflections
    with TableInfo<$ReflectionsTable, Reflection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReflectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _memoryIdMeta =
      const VerificationMeta('memoryId');
  @override
  late final GeneratedColumn<int> memoryId = GeneratedColumn<int>(
      'memory_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES memories (id)'));
  static const VerificationMeta _ayahReferenceMeta =
      const VerificationMeta('ayahReference');
  @override
  late final GeneratedColumn<String> ayahReference = GeneratedColumn<String>(
      'ayah_reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hadithReferenceMeta =
      const VerificationMeta('hadithReference');
  @override
  late final GeneratedColumn<String> hadithReference = GeneratedColumn<String>(
      'hadith_reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aiInsightMeta =
      const VerificationMeta('aiInsight');
  @override
  late final GeneratedColumn<String> aiInsight = GeneratedColumn<String>(
      'ai_insight', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reflectedAtMeta =
      const VerificationMeta('reflectedAt');
  @override
  late final GeneratedColumn<DateTime> reflectedAt = GeneratedColumn<DateTime>(
      'reflected_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, memoryId, ayahReference, hadithReference, aiInsight, reflectedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reflections';
  @override
  VerificationContext validateIntegrity(Insertable<Reflection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('memory_id')) {
      context.handle(_memoryIdMeta,
          memoryId.isAcceptableOrUnknown(data['memory_id']!, _memoryIdMeta));
    } else if (isInserting) {
      context.missing(_memoryIdMeta);
    }
    if (data.containsKey('ayah_reference')) {
      context.handle(
          _ayahReferenceMeta,
          ayahReference.isAcceptableOrUnknown(
              data['ayah_reference']!, _ayahReferenceMeta));
    }
    if (data.containsKey('hadith_reference')) {
      context.handle(
          _hadithReferenceMeta,
          hadithReference.isAcceptableOrUnknown(
              data['hadith_reference']!, _hadithReferenceMeta));
    }
    if (data.containsKey('ai_insight')) {
      context.handle(_aiInsightMeta,
          aiInsight.isAcceptableOrUnknown(data['ai_insight']!, _aiInsightMeta));
    } else if (isInserting) {
      context.missing(_aiInsightMeta);
    }
    if (data.containsKey('reflected_at')) {
      context.handle(
          _reflectedAtMeta,
          reflectedAt.isAcceptableOrUnknown(
              data['reflected_at']!, _reflectedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reflection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reflection(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      memoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}memory_id'])!,
      ayahReference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ayah_reference']),
      hadithReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}hadith_reference']),
      aiInsight: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ai_insight'])!,
      reflectedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reflected_at'])!,
    );
  }

  @override
  $ReflectionsTable createAlias(String alias) {
    return $ReflectionsTable(attachedDatabase, alias);
  }
}

class Reflection extends DataClass implements Insertable<Reflection> {
  /// Primary key for reflections.
  final int id;

  /// Foreign key to [Memories].
  final int memoryId;

  /// Quranic reference citation.
  final String? ayahReference;

  /// Hadith reference citation.
  final String? hadithReference;

  /// AI-generated spiritual insight.
  final String aiInsight;

  /// Timestamp of reflection.
  final DateTime reflectedAt;
  const Reflection(
      {required this.id,
      required this.memoryId,
      this.ayahReference,
      this.hadithReference,
      required this.aiInsight,
      required this.reflectedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['memory_id'] = Variable<int>(memoryId);
    if (!nullToAbsent || ayahReference != null) {
      map['ayah_reference'] = Variable<String>(ayahReference);
    }
    if (!nullToAbsent || hadithReference != null) {
      map['hadith_reference'] = Variable<String>(hadithReference);
    }
    map['ai_insight'] = Variable<String>(aiInsight);
    map['reflected_at'] = Variable<DateTime>(reflectedAt);
    return map;
  }

  ReflectionsCompanion toCompanion(bool nullToAbsent) {
    return ReflectionsCompanion(
      id: Value(id),
      memoryId: Value(memoryId),
      ayahReference: ayahReference == null && nullToAbsent
          ? const Value.absent()
          : Value(ayahReference),
      hadithReference: hadithReference == null && nullToAbsent
          ? const Value.absent()
          : Value(hadithReference),
      aiInsight: Value(aiInsight),
      reflectedAt: Value(reflectedAt),
    );
  }

  factory Reflection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reflection(
      id: serializer.fromJson<int>(json['id']),
      memoryId: serializer.fromJson<int>(json['memoryId']),
      ayahReference: serializer.fromJson<String?>(json['ayahReference']),
      hadithReference: serializer.fromJson<String?>(json['hadithReference']),
      aiInsight: serializer.fromJson<String>(json['aiInsight']),
      reflectedAt: serializer.fromJson<DateTime>(json['reflectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'memoryId': serializer.toJson<int>(memoryId),
      'ayahReference': serializer.toJson<String?>(ayahReference),
      'hadithReference': serializer.toJson<String?>(hadithReference),
      'aiInsight': serializer.toJson<String>(aiInsight),
      'reflectedAt': serializer.toJson<DateTime>(reflectedAt),
    };
  }

  Reflection copyWith(
          {int? id,
          int? memoryId,
          Value<String?> ayahReference = const Value.absent(),
          Value<String?> hadithReference = const Value.absent(),
          String? aiInsight,
          DateTime? reflectedAt}) =>
      Reflection(
        id: id ?? this.id,
        memoryId: memoryId ?? this.memoryId,
        ayahReference:
            ayahReference.present ? ayahReference.value : this.ayahReference,
        hadithReference: hadithReference.present
            ? hadithReference.value
            : this.hadithReference,
        aiInsight: aiInsight ?? this.aiInsight,
        reflectedAt: reflectedAt ?? this.reflectedAt,
      );
  Reflection copyWithCompanion(ReflectionsCompanion data) {
    return Reflection(
      id: data.id.present ? data.id.value : this.id,
      memoryId: data.memoryId.present ? data.memoryId.value : this.memoryId,
      ayahReference: data.ayahReference.present
          ? data.ayahReference.value
          : this.ayahReference,
      hadithReference: data.hadithReference.present
          ? data.hadithReference.value
          : this.hadithReference,
      aiInsight: data.aiInsight.present ? data.aiInsight.value : this.aiInsight,
      reflectedAt:
          data.reflectedAt.present ? data.reflectedAt.value : this.reflectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reflection(')
          ..write('id: $id, ')
          ..write('memoryId: $memoryId, ')
          ..write('ayahReference: $ayahReference, ')
          ..write('hadithReference: $hadithReference, ')
          ..write('aiInsight: $aiInsight, ')
          ..write('reflectedAt: $reflectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, memoryId, ayahReference, hadithReference, aiInsight, reflectedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reflection &&
          other.id == this.id &&
          other.memoryId == this.memoryId &&
          other.ayahReference == this.ayahReference &&
          other.hadithReference == this.hadithReference &&
          other.aiInsight == this.aiInsight &&
          other.reflectedAt == this.reflectedAt);
}

class ReflectionsCompanion extends UpdateCompanion<Reflection> {
  final Value<int> id;
  final Value<int> memoryId;
  final Value<String?> ayahReference;
  final Value<String?> hadithReference;
  final Value<String> aiInsight;
  final Value<DateTime> reflectedAt;
  const ReflectionsCompanion({
    this.id = const Value.absent(),
    this.memoryId = const Value.absent(),
    this.ayahReference = const Value.absent(),
    this.hadithReference = const Value.absent(),
    this.aiInsight = const Value.absent(),
    this.reflectedAt = const Value.absent(),
  });
  ReflectionsCompanion.insert({
    this.id = const Value.absent(),
    required int memoryId,
    this.ayahReference = const Value.absent(),
    this.hadithReference = const Value.absent(),
    required String aiInsight,
    this.reflectedAt = const Value.absent(),
  })  : memoryId = Value(memoryId),
        aiInsight = Value(aiInsight);
  static Insertable<Reflection> custom({
    Expression<int>? id,
    Expression<int>? memoryId,
    Expression<String>? ayahReference,
    Expression<String>? hadithReference,
    Expression<String>? aiInsight,
    Expression<DateTime>? reflectedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memoryId != null) 'memory_id': memoryId,
      if (ayahReference != null) 'ayah_reference': ayahReference,
      if (hadithReference != null) 'hadith_reference': hadithReference,
      if (aiInsight != null) 'ai_insight': aiInsight,
      if (reflectedAt != null) 'reflected_at': reflectedAt,
    });
  }

  ReflectionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? memoryId,
      Value<String?>? ayahReference,
      Value<String?>? hadithReference,
      Value<String>? aiInsight,
      Value<DateTime>? reflectedAt}) {
    return ReflectionsCompanion(
      id: id ?? this.id,
      memoryId: memoryId ?? this.memoryId,
      ayahReference: ayahReference ?? this.ayahReference,
      hadithReference: hadithReference ?? this.hadithReference,
      aiInsight: aiInsight ?? this.aiInsight,
      reflectedAt: reflectedAt ?? this.reflectedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (memoryId.present) {
      map['memory_id'] = Variable<int>(memoryId.value);
    }
    if (ayahReference.present) {
      map['ayah_reference'] = Variable<String>(ayahReference.value);
    }
    if (hadithReference.present) {
      map['hadith_reference'] = Variable<String>(hadithReference.value);
    }
    if (aiInsight.present) {
      map['ai_insight'] = Variable<String>(aiInsight.value);
    }
    if (reflectedAt.present) {
      map['reflected_at'] = Variable<DateTime>(reflectedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReflectionsCompanion(')
          ..write('id: $id, ')
          ..write('memoryId: $memoryId, ')
          ..write('ayahReference: $ayahReference, ')
          ..write('hadithReference: $hadithReference, ')
          ..write('aiInsight: $aiInsight, ')
          ..write('reflectedAt: $reflectedAt')
          ..write(')'))
        .toString();
  }
}

class $SentMessagesTable extends SentMessages
    with TableInfo<$SentMessagesTable, SentMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SentMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _encryptedContentMeta =
      const VerificationMeta('encryptedContent');
  @override
  late final GeneratedColumn<String> encryptedContent = GeneratedColumn<String>(
      'encrypted_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipientIdMeta =
      const VerificationMeta('recipientId');
  @override
  late final GeneratedColumn<String> recipientId = GeneratedColumn<String>(
      'recipient_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
      'sent_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, encryptedContent, type, recipientId, sentAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sent_messages';
  @override
  VerificationContext validateIntegrity(Insertable<SentMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('encrypted_content')) {
      context.handle(
          _encryptedContentMeta,
          encryptedContent.isAcceptableOrUnknown(
              data['encrypted_content']!, _encryptedContentMeta));
    } else if (isInserting) {
      context.missing(_encryptedContentMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('recipient_id')) {
      context.handle(
          _recipientIdMeta,
          recipientId.isAcceptableOrUnknown(
              data['recipient_id']!, _recipientIdMeta));
    }
    if (data.containsKey('sent_at')) {
      context.handle(_sentAtMeta,
          sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SentMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SentMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      encryptedContent: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}encrypted_content'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      recipientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipient_id']),
      sentAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sent_at'])!,
    );
  }

  @override
  $SentMessagesTable createAlias(String alias) {
    return $SentMessagesTable(attachedDatabase, alias);
  }
}

class SentMessage extends DataClass implements Insertable<SentMessage> {
  /// Primary key for sent messages.
  final int id;

  /// Encrypted content of the message.
  final String encryptedContent;

  /// Type of message (morning, evening, etc.).
  final String type;

  /// Recipient identifier.
  final String? recipientId;

  /// Timestamp of sending.
  final DateTime sentAt;
  const SentMessage(
      {required this.id,
      required this.encryptedContent,
      required this.type,
      this.recipientId,
      required this.sentAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['encrypted_content'] = Variable<String>(encryptedContent);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || recipientId != null) {
      map['recipient_id'] = Variable<String>(recipientId);
    }
    map['sent_at'] = Variable<DateTime>(sentAt);
    return map;
  }

  SentMessagesCompanion toCompanion(bool nullToAbsent) {
    return SentMessagesCompanion(
      id: Value(id),
      encryptedContent: Value(encryptedContent),
      type: Value(type),
      recipientId: recipientId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipientId),
      sentAt: Value(sentAt),
    );
  }

  factory SentMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SentMessage(
      id: serializer.fromJson<int>(json['id']),
      encryptedContent: serializer.fromJson<String>(json['encryptedContent']),
      type: serializer.fromJson<String>(json['type']),
      recipientId: serializer.fromJson<String?>(json['recipientId']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'encryptedContent': serializer.toJson<String>(encryptedContent),
      'type': serializer.toJson<String>(type),
      'recipientId': serializer.toJson<String?>(recipientId),
      'sentAt': serializer.toJson<DateTime>(sentAt),
    };
  }

  SentMessage copyWith(
          {int? id,
          String? encryptedContent,
          String? type,
          Value<String?> recipientId = const Value.absent(),
          DateTime? sentAt}) =>
      SentMessage(
        id: id ?? this.id,
        encryptedContent: encryptedContent ?? this.encryptedContent,
        type: type ?? this.type,
        recipientId: recipientId.present ? recipientId.value : this.recipientId,
        sentAt: sentAt ?? this.sentAt,
      );
  SentMessage copyWithCompanion(SentMessagesCompanion data) {
    return SentMessage(
      id: data.id.present ? data.id.value : this.id,
      encryptedContent: data.encryptedContent.present
          ? data.encryptedContent.value
          : this.encryptedContent,
      type: data.type.present ? data.type.value : this.type,
      recipientId:
          data.recipientId.present ? data.recipientId.value : this.recipientId,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SentMessage(')
          ..write('id: $id, ')
          ..write('encryptedContent: $encryptedContent, ')
          ..write('type: $type, ')
          ..write('recipientId: $recipientId, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, encryptedContent, type, recipientId, sentAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SentMessage &&
          other.id == this.id &&
          other.encryptedContent == this.encryptedContent &&
          other.type == this.type &&
          other.recipientId == this.recipientId &&
          other.sentAt == this.sentAt);
}

class SentMessagesCompanion extends UpdateCompanion<SentMessage> {
  final Value<int> id;
  final Value<String> encryptedContent;
  final Value<String> type;
  final Value<String?> recipientId;
  final Value<DateTime> sentAt;
  const SentMessagesCompanion({
    this.id = const Value.absent(),
    this.encryptedContent = const Value.absent(),
    this.type = const Value.absent(),
    this.recipientId = const Value.absent(),
    this.sentAt = const Value.absent(),
  });
  SentMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String encryptedContent,
    required String type,
    this.recipientId = const Value.absent(),
    this.sentAt = const Value.absent(),
  })  : encryptedContent = Value(encryptedContent),
        type = Value(type);
  static Insertable<SentMessage> custom({
    Expression<int>? id,
    Expression<String>? encryptedContent,
    Expression<String>? type,
    Expression<String>? recipientId,
    Expression<DateTime>? sentAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (encryptedContent != null) 'encrypted_content': encryptedContent,
      if (type != null) 'type': type,
      if (recipientId != null) 'recipient_id': recipientId,
      if (sentAt != null) 'sent_at': sentAt,
    });
  }

  SentMessagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? encryptedContent,
      Value<String>? type,
      Value<String?>? recipientId,
      Value<DateTime>? sentAt}) {
    return SentMessagesCompanion(
      id: id ?? this.id,
      encryptedContent: encryptedContent ?? this.encryptedContent,
      type: type ?? this.type,
      recipientId: recipientId ?? this.recipientId,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (encryptedContent.present) {
      map['encrypted_content'] = Variable<String>(encryptedContent.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (recipientId.present) {
      map['recipient_id'] = Variable<String>(recipientId.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SentMessagesCompanion(')
          ..write('id: $id, ')
          ..write('encryptedContent: $encryptedContent, ')
          ..write('type: $type, ')
          ..write('recipientId: $recipientId, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }
}

class $SurprisesTable extends Surprises
    with TableInfo<$SurprisesTable, Surprise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurprisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _encryptedContentMeta =
      const VerificationMeta('encryptedContent');
  @override
  late final GeneratedColumn<String> encryptedContent = GeneratedColumn<String>(
      'encrypted_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, encryptedContent, status, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surprises';
  @override
  VerificationContext validateIntegrity(Insertable<Surprise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('encrypted_content')) {
      context.handle(
          _encryptedContentMeta,
          encryptedContent.isAcceptableOrUnknown(
              data['encrypted_content']!, _encryptedContentMeta));
    } else if (isInserting) {
      context.missing(_encryptedContentMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Surprise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Surprise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      encryptedContent: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}encrypted_content'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SurprisesTable createAlias(String alias) {
    return $SurprisesTable(attachedDatabase, alias);
  }
}

class Surprise extends DataClass implements Insertable<Surprise> {
  /// Primary key for surprises.
  final int id;

  /// Type of surprise (serendipity, growth, transformation).
  final String type;

  /// Encrypted message content.
  final String encryptedContent;

  /// Status of the surprise (dismissed, acted_upon, etc.).
  final String status;

  /// Timestamp of creation.
  final DateTime createdAt;
  const Surprise(
      {required this.id,
      required this.type,
      required this.encryptedContent,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['encrypted_content'] = Variable<String>(encryptedContent);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SurprisesCompanion toCompanion(bool nullToAbsent) {
    return SurprisesCompanion(
      id: Value(id),
      type: Value(type),
      encryptedContent: Value(encryptedContent),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Surprise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Surprise(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      encryptedContent: serializer.fromJson<String>(json['encryptedContent']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'encryptedContent': serializer.toJson<String>(encryptedContent),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Surprise copyWith(
          {int? id,
          String? type,
          String? encryptedContent,
          String? status,
          DateTime? createdAt}) =>
      Surprise(
        id: id ?? this.id,
        type: type ?? this.type,
        encryptedContent: encryptedContent ?? this.encryptedContent,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  Surprise copyWithCompanion(SurprisesCompanion data) {
    return Surprise(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      encryptedContent: data.encryptedContent.present
          ? data.encryptedContent.value
          : this.encryptedContent,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Surprise(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('encryptedContent: $encryptedContent, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, encryptedContent, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surprise &&
          other.id == this.id &&
          other.type == this.type &&
          other.encryptedContent == this.encryptedContent &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class SurprisesCompanion extends UpdateCompanion<Surprise> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> encryptedContent;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const SurprisesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.encryptedContent = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SurprisesCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String encryptedContent,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : type = Value(type),
        encryptedContent = Value(encryptedContent);
  static Insertable<Surprise> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? encryptedContent,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (encryptedContent != null) 'encrypted_content': encryptedContent,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SurprisesCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? encryptedContent,
      Value<String>? status,
      Value<DateTime>? createdAt}) {
    return SurprisesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      encryptedContent: encryptedContent ?? this.encryptedContent,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (encryptedContent.present) {
      map['encrypted_content'] = Variable<String>(encryptedContent.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurprisesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('encryptedContent: $encryptedContent, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MemoriesTable memories = $MemoriesTable(this);
  late final $ReflectionsTable reflections = $ReflectionsTable(this);
  late final $SentMessagesTable sentMessages = $SentMessagesTable(this);
  late final $SurprisesTable surprises = $SurprisesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [memories, reflections, sentMessages, surprises];
}

typedef $$MemoriesTableCreateCompanionBuilder = MemoriesCompanion Function({
  Value<int> id,
  required String title,
  Value<String?> description,
  required String encryptedContent,
  Value<DateTime> createdAt,
  Value<String?> mediaPath,
  Value<int?> emotionalScore,
  Value<int> viewCount,
  Value<String?> color,
});
typedef $$MemoriesTableUpdateCompanionBuilder = MemoriesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> description,
  Value<String> encryptedContent,
  Value<DateTime> createdAt,
  Value<String?> mediaPath,
  Value<int?> emotionalScore,
  Value<int> viewCount,
  Value<String?> color,
});

final class $$MemoriesTableReferences
    extends BaseReferences<_$AppDatabase, $MemoriesTable, Memory> {
  $$MemoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReflectionsTable, List<Reflection>>
      _reflectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.reflections,
          aliasName:
              $_aliasNameGenerator(db.memories.id, db.reflections.memoryId));

  $$ReflectionsTableProcessedTableManager get reflectionsRefs {
    final manager = $$ReflectionsTableTableManager($_db, $_db.reflections)
        .filter((f) => f.memoryId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_reflectionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MemoriesTableFilterComposer
    extends Composer<_$AppDatabase, $MemoriesTable> {
  $$MemoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptedContent => $composableBuilder(
      column: $table.encryptedContent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaPath => $composableBuilder(
      column: $table.mediaPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get emotionalScore => $composableBuilder(
      column: $table.emotionalScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get viewCount => $composableBuilder(
      column: $table.viewCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  Expression<bool> reflectionsRefs(
      Expression<bool> Function($$ReflectionsTableFilterComposer f) f) {
    final $$ReflectionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reflections,
        getReferencedColumn: (t) => t.memoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReflectionsTableFilterComposer(
              $db: $db,
              $table: $db.reflections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MemoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoriesTable> {
  $$MemoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptedContent => $composableBuilder(
      column: $table.encryptedContent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaPath => $composableBuilder(
      column: $table.mediaPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get emotionalScore => $composableBuilder(
      column: $table.emotionalScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get viewCount => $composableBuilder(
      column: $table.viewCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));
}

class $$MemoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoriesTable> {
  $$MemoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get encryptedContent => $composableBuilder(
      column: $table.encryptedContent, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get mediaPath =>
      $composableBuilder(column: $table.mediaPath, builder: (column) => column);

  GeneratedColumn<int> get emotionalScore => $composableBuilder(
      column: $table.emotionalScore, builder: (column) => column);

  GeneratedColumn<int> get viewCount =>
      $composableBuilder(column: $table.viewCount, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> reflectionsRefs<T extends Object>(
      Expression<T> Function($$ReflectionsTableAnnotationComposer a) f) {
    final $$ReflectionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reflections,
        getReferencedColumn: (t) => t.memoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReflectionsTableAnnotationComposer(
              $db: $db,
              $table: $db.reflections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MemoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MemoriesTable,
    Memory,
    $$MemoriesTableFilterComposer,
    $$MemoriesTableOrderingComposer,
    $$MemoriesTableAnnotationComposer,
    $$MemoriesTableCreateCompanionBuilder,
    $$MemoriesTableUpdateCompanionBuilder,
    (Memory, $$MemoriesTableReferences),
    Memory,
    PrefetchHooks Function({bool reflectionsRefs})> {
  $$MemoriesTableTableManager(_$AppDatabase db, $MemoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> encryptedContent = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> mediaPath = const Value.absent(),
            Value<int?> emotionalScore = const Value.absent(),
            Value<int> viewCount = const Value.absent(),
            Value<String?> color = const Value.absent(),
          }) =>
              MemoriesCompanion(
            id: id,
            title: title,
            description: description,
            encryptedContent: encryptedContent,
            createdAt: createdAt,
            mediaPath: mediaPath,
            emotionalScore: emotionalScore,
            viewCount: viewCount,
            color: color,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            required String encryptedContent,
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> mediaPath = const Value.absent(),
            Value<int?> emotionalScore = const Value.absent(),
            Value<int> viewCount = const Value.absent(),
            Value<String?> color = const Value.absent(),
          }) =>
              MemoriesCompanion.insert(
            id: id,
            title: title,
            description: description,
            encryptedContent: encryptedContent,
            createdAt: createdAt,
            mediaPath: mediaPath,
            emotionalScore: emotionalScore,
            viewCount: viewCount,
            color: color,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MemoriesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({reflectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reflectionsRefs) db.reflections],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reflectionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$MemoriesTableReferences._reflectionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MemoriesTableReferences(db, table, p0)
                                .reflectionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.memoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MemoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MemoriesTable,
    Memory,
    $$MemoriesTableFilterComposer,
    $$MemoriesTableOrderingComposer,
    $$MemoriesTableAnnotationComposer,
    $$MemoriesTableCreateCompanionBuilder,
    $$MemoriesTableUpdateCompanionBuilder,
    (Memory, $$MemoriesTableReferences),
    Memory,
    PrefetchHooks Function({bool reflectionsRefs})>;
typedef $$ReflectionsTableCreateCompanionBuilder = ReflectionsCompanion
    Function({
  Value<int> id,
  required int memoryId,
  Value<String?> ayahReference,
  Value<String?> hadithReference,
  required String aiInsight,
  Value<DateTime> reflectedAt,
});
typedef $$ReflectionsTableUpdateCompanionBuilder = ReflectionsCompanion
    Function({
  Value<int> id,
  Value<int> memoryId,
  Value<String?> ayahReference,
  Value<String?> hadithReference,
  Value<String> aiInsight,
  Value<DateTime> reflectedAt,
});

final class $$ReflectionsTableReferences
    extends BaseReferences<_$AppDatabase, $ReflectionsTable, Reflection> {
  $$ReflectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MemoriesTable _memoryIdTable(_$AppDatabase db) =>
      db.memories.createAlias(
          $_aliasNameGenerator(db.reflections.memoryId, db.memories.id));

  $$MemoriesTableProcessedTableManager? get memoryId {
    if ($_item.memoryId == null) return null;
    final manager = $$MemoriesTableTableManager($_db, $_db.memories)
        .filter((f) => f.id($_item.memoryId!));
    final item = $_typedResult.readTableOrNull(_memoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReflectionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReflectionsTable> {
  $$ReflectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ayahReference => $composableBuilder(
      column: $table.ayahReference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hadithReference => $composableBuilder(
      column: $table.hadithReference,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aiInsight => $composableBuilder(
      column: $table.aiInsight, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reflectedAt => $composableBuilder(
      column: $table.reflectedAt, builder: (column) => ColumnFilters(column));

  $$MemoriesTableFilterComposer get memoryId {
    final $$MemoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memoryId,
        referencedTable: $db.memories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MemoriesTableFilterComposer(
              $db: $db,
              $table: $db.memories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReflectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReflectionsTable> {
  $$ReflectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ayahReference => $composableBuilder(
      column: $table.ayahReference,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hadithReference => $composableBuilder(
      column: $table.hadithReference,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aiInsight => $composableBuilder(
      column: $table.aiInsight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reflectedAt => $composableBuilder(
      column: $table.reflectedAt, builder: (column) => ColumnOrderings(column));

  $$MemoriesTableOrderingComposer get memoryId {
    final $$MemoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memoryId,
        referencedTable: $db.memories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MemoriesTableOrderingComposer(
              $db: $db,
              $table: $db.memories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReflectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReflectionsTable> {
  $$ReflectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ayahReference => $composableBuilder(
      column: $table.ayahReference, builder: (column) => column);

  GeneratedColumn<String> get hadithReference => $composableBuilder(
      column: $table.hadithReference, builder: (column) => column);

  GeneratedColumn<String> get aiInsight =>
      $composableBuilder(column: $table.aiInsight, builder: (column) => column);

  GeneratedColumn<DateTime> get reflectedAt => $composableBuilder(
      column: $table.reflectedAt, builder: (column) => column);

  $$MemoriesTableAnnotationComposer get memoryId {
    final $$MemoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memoryId,
        referencedTable: $db.memories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MemoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.memories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReflectionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReflectionsTable,
    Reflection,
    $$ReflectionsTableFilterComposer,
    $$ReflectionsTableOrderingComposer,
    $$ReflectionsTableAnnotationComposer,
    $$ReflectionsTableCreateCompanionBuilder,
    $$ReflectionsTableUpdateCompanionBuilder,
    (Reflection, $$ReflectionsTableReferences),
    Reflection,
    PrefetchHooks Function({bool memoryId})> {
  $$ReflectionsTableTableManager(_$AppDatabase db, $ReflectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReflectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReflectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReflectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> memoryId = const Value.absent(),
            Value<String?> ayahReference = const Value.absent(),
            Value<String?> hadithReference = const Value.absent(),
            Value<String> aiInsight = const Value.absent(),
            Value<DateTime> reflectedAt = const Value.absent(),
          }) =>
              ReflectionsCompanion(
            id: id,
            memoryId: memoryId,
            ayahReference: ayahReference,
            hadithReference: hadithReference,
            aiInsight: aiInsight,
            reflectedAt: reflectedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int memoryId,
            Value<String?> ayahReference = const Value.absent(),
            Value<String?> hadithReference = const Value.absent(),
            required String aiInsight,
            Value<DateTime> reflectedAt = const Value.absent(),
          }) =>
              ReflectionsCompanion.insert(
            id: id,
            memoryId: memoryId,
            ayahReference: ayahReference,
            hadithReference: hadithReference,
            aiInsight: aiInsight,
            reflectedAt: reflectedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReflectionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({memoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (memoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.memoryId,
                    referencedTable:
                        $$ReflectionsTableReferences._memoryIdTable(db),
                    referencedColumn:
                        $$ReflectionsTableReferences._memoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReflectionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReflectionsTable,
    Reflection,
    $$ReflectionsTableFilterComposer,
    $$ReflectionsTableOrderingComposer,
    $$ReflectionsTableAnnotationComposer,
    $$ReflectionsTableCreateCompanionBuilder,
    $$ReflectionsTableUpdateCompanionBuilder,
    (Reflection, $$ReflectionsTableReferences),
    Reflection,
    PrefetchHooks Function({bool memoryId})>;
typedef $$SentMessagesTableCreateCompanionBuilder = SentMessagesCompanion
    Function({
  Value<int> id,
  required String encryptedContent,
  required String type,
  Value<String?> recipientId,
  Value<DateTime> sentAt,
});
typedef $$SentMessagesTableUpdateCompanionBuilder = SentMessagesCompanion
    Function({
  Value<int> id,
  Value<String> encryptedContent,
  Value<String> type,
  Value<String?> recipientId,
  Value<DateTime> sentAt,
});

class $$SentMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $SentMessagesTable> {
  $$SentMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptedContent => $composableBuilder(
      column: $table.encryptedContent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipientId => $composableBuilder(
      column: $table.recipientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnFilters(column));
}

class $$SentMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $SentMessagesTable> {
  $$SentMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptedContent => $composableBuilder(
      column: $table.encryptedContent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipientId => $composableBuilder(
      column: $table.recipientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnOrderings(column));
}

class $$SentMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SentMessagesTable> {
  $$SentMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get encryptedContent => $composableBuilder(
      column: $table.encryptedContent, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get recipientId => $composableBuilder(
      column: $table.recipientId, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);
}

class $$SentMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SentMessagesTable,
    SentMessage,
    $$SentMessagesTableFilterComposer,
    $$SentMessagesTableOrderingComposer,
    $$SentMessagesTableAnnotationComposer,
    $$SentMessagesTableCreateCompanionBuilder,
    $$SentMessagesTableUpdateCompanionBuilder,
    (
      SentMessage,
      BaseReferences<_$AppDatabase, $SentMessagesTable, SentMessage>
    ),
    SentMessage,
    PrefetchHooks Function()> {
  $$SentMessagesTableTableManager(_$AppDatabase db, $SentMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SentMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SentMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SentMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> encryptedContent = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> recipientId = const Value.absent(),
            Value<DateTime> sentAt = const Value.absent(),
          }) =>
              SentMessagesCompanion(
            id: id,
            encryptedContent: encryptedContent,
            type: type,
            recipientId: recipientId,
            sentAt: sentAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String encryptedContent,
            required String type,
            Value<String?> recipientId = const Value.absent(),
            Value<DateTime> sentAt = const Value.absent(),
          }) =>
              SentMessagesCompanion.insert(
            id: id,
            encryptedContent: encryptedContent,
            type: type,
            recipientId: recipientId,
            sentAt: sentAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SentMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SentMessagesTable,
    SentMessage,
    $$SentMessagesTableFilterComposer,
    $$SentMessagesTableOrderingComposer,
    $$SentMessagesTableAnnotationComposer,
    $$SentMessagesTableCreateCompanionBuilder,
    $$SentMessagesTableUpdateCompanionBuilder,
    (
      SentMessage,
      BaseReferences<_$AppDatabase, $SentMessagesTable, SentMessage>
    ),
    SentMessage,
    PrefetchHooks Function()>;
typedef $$SurprisesTableCreateCompanionBuilder = SurprisesCompanion Function({
  Value<int> id,
  required String type,
  required String encryptedContent,
  Value<String> status,
  Value<DateTime> createdAt,
});
typedef $$SurprisesTableUpdateCompanionBuilder = SurprisesCompanion Function({
  Value<int> id,
  Value<String> type,
  Value<String> encryptedContent,
  Value<String> status,
  Value<DateTime> createdAt,
});

class $$SurprisesTableFilterComposer
    extends Composer<_$AppDatabase, $SurprisesTable> {
  $$SurprisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptedContent => $composableBuilder(
      column: $table.encryptedContent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SurprisesTableOrderingComposer
    extends Composer<_$AppDatabase, $SurprisesTable> {
  $$SurprisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptedContent => $composableBuilder(
      column: $table.encryptedContent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SurprisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurprisesTable> {
  $$SurprisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get encryptedContent => $composableBuilder(
      column: $table.encryptedContent, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SurprisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SurprisesTable,
    Surprise,
    $$SurprisesTableFilterComposer,
    $$SurprisesTableOrderingComposer,
    $$SurprisesTableAnnotationComposer,
    $$SurprisesTableCreateCompanionBuilder,
    $$SurprisesTableUpdateCompanionBuilder,
    (Surprise, BaseReferences<_$AppDatabase, $SurprisesTable, Surprise>),
    Surprise,
    PrefetchHooks Function()> {
  $$SurprisesTableTableManager(_$AppDatabase db, $SurprisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurprisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurprisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurprisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> encryptedContent = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SurprisesCompanion(
            id: id,
            type: type,
            encryptedContent: encryptedContent,
            status: status,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required String encryptedContent,
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SurprisesCompanion.insert(
            id: id,
            type: type,
            encryptedContent: encryptedContent,
            status: status,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SurprisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SurprisesTable,
    Surprise,
    $$SurprisesTableFilterComposer,
    $$SurprisesTableOrderingComposer,
    $$SurprisesTableAnnotationComposer,
    $$SurprisesTableCreateCompanionBuilder,
    $$SurprisesTableUpdateCompanionBuilder,
    (Surprise, BaseReferences<_$AppDatabase, $SurprisesTable, Surprise>),
    Surprise,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MemoriesTableTableManager get memories =>
      $$MemoriesTableTableManager(_db, _db.memories);
  $$ReflectionsTableTableManager get reflections =>
      $$ReflectionsTableTableManager(_db, _db.reflections);
  $$SentMessagesTableTableManager get sentMessages =>
      $$SentMessagesTableTableManager(_db, _db.sentMessages);
  $$SurprisesTableTableManager get surprises =>
      $$SurprisesTableTableManager(_db, _db.surprises);
}
