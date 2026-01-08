/// The Living Documentation System
///
/// Based on the principle of "Living Documentation" where documentation is
/// automatically generated from source code, tests, and
/// specifications, ensuring that the documentation is always
/// up-to-date and reflects the true state of the system.
library;

import 'dart:convert';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

/// The type of documentation.
enum DocumentationType {
  /// Documentation related to the codebase structure and logic.
  codeDocumentation,

  /// Specifications for APIs.
  apiSpecification,

  /// Guides for end-users.
  userGuide,

  /// Records of architectural decisions (ADR).
  architectureDecision,

  /// Specifications for testing procedures.
  testSpecification,

  /// Reports on system performance.
  performanceReport,

  /// Audits related to system security.
  securityAudit,

  /// Logs of changes and updates.
  changeLog,
}

/// The status of a documentation item.
enum DocumentationStatus {
  /// Initial draft stage.
  draft,

  /// Currently under review.
  review,

  /// Approved for use.
  approved,

  /// Published and accessible.
  published,

  /// No longer in use or valid.
  deprecated,
}

/// The importance level of the documentation.
enum ImportanceLevel {
  /// Low priority.
  low,

  /// Medium priority.
  medium,

  /// High priority.
  high,

  /// Critical priority.
  critical,
}

/// Represents a single living document in the system.
class LivingDocument {
  /// Creates a new instance of [LivingDocument].
  const LivingDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.importance,
    required this.content,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.tags,
    required this.version,
  });

  /// Creates a [LivingDocument] from a JSON map.
  factory LivingDocument.fromJson(Map<String, dynamic> json) => LivingDocument(
        id: json['id'],
        title: json['title'],
        type: DocumentationType.values.byName(json['type']),
        status: DocumentationStatus.values.byName(json['status']),
        importance: ImportanceLevel.values.byName(json['importance']),
        content: json['content'],
        metadata: Map<String, dynamic>.from(json['metadata']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        author: json['author'],
        tags: List<String>.from(json['tags']),
        version: json['version'],
      );

  /// The unique identifier of the document.
  final String id;

  /// The title of the document.
  final String title;

  /// The type of the document.
  final DocumentationType type;

  /// The current status of the document.
  final DocumentationStatus status;

  /// The importance level of the document.
  final ImportanceLevel importance;

  /// The content of the document (usually Markdown).
  final String content;

  /// Additional metadata associated with the document.
  final Map<String, dynamic> metadata;

  /// The date and time when the document was created.
  final DateTime createdAt;

  /// The date and time when the document was last updated.
  final DateTime updatedAt;

  /// The author of the document.
  final String author;

  /// Tags for categorization and search.
  final List<String> tags;

  /// The version string of the document.
  final String version;

  /// Converts the document to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.name,
        'status': status.name,
        'importance': importance.name,
        'content': content,
        'metadata': metadata,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'author': author,
        'tags': tags,
        'version': version,
      };

  /// Creates a copy of this document with updated fields.
  LivingDocument copyWith({
    String? title,
    DocumentationType? type,
    DocumentationStatus? status,
    ImportanceLevel? importance,
    String? content,
    Map<String, dynamic>? metadata,
    DateTime? updatedAt,
    String? author,
    List<String>? tags,
    String? version,
  }) =>
      LivingDocument(
        id: id,
        title: title ?? this.title,
        type: type ?? this.type,
        status: status ?? this.status,
        importance: importance ?? this.importance,
        content: content ?? this.content,
        metadata: metadata ?? this.metadata,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
        author: author ?? this.author,
        tags: tags ?? this.tags,
        version: version ?? this.version,
      );
}

/// Represents an Architecture Decision Record (ADR).
class ArchitectureDecisionRecord {
  /// Creates a new [ArchitectureDecisionRecord].
  const ArchitectureDecisionRecord({
    required this.id,
    required this.title,
    required this.context,
    required this.decision,
    required this.consequences,
    required this.status,
    required this.dateDecided,
    required this.decisionMaker,
    required this.alternatives,
  });

  /// The unique identifier of the ADR.
  final String id;

  /// The title of the decision.
  final String title;

  /// The context surrounding the decision.
  final String context;

  /// The decision that was made.
  final String decision;

  /// The consequences (positive and negative) of the decision.
  final String consequences;

  /// The status of the decision.
  final DocumentationStatus status;

  /// The date the decision was made.
  final DateTime dateDecided;

  /// The person or entity who made the decision.
  final String decisionMaker;

  /// Alternatives that were considered.
  final List<String> alternatives;

  /// Converts the ADR to a [LivingDocument].
  LivingDocument toLivingDocument() => LivingDocument(
        id: id,
        title: 'ADR: $title',
        type: DocumentationType.architectureDecision,
        status: status,
        importance: ImportanceLevel.high,
        content: _generateADRContent(),
        metadata: {
          'context': context,
          'decision': decision,
          'consequences': consequences,
          'alternatives': alternatives,
          'decisionMaker': decisionMaker,
        },
        createdAt: dateDecided,
        updatedAt: dateDecided,
        author: decisionMaker,
        tags: ['architecture', 'decision', 'adr'],
        version: '1.0',
      );

  /// Generates the Markdown content for the ADR.
  String _generateADRContent() => '''
# $title

**التاريخ:** ${dateDecided.toIso8601String().split('T')[0]}
**صانع القرار:** $decisionMaker
**الحالة:** ${status.name}

## السياق
$context

## القرار
$decision

## العواقب
$consequences

## البدائل المدروسة
${alternatives.map((alt) => '- $alt').join('\n')}

---
*تم توليد هذا المستند آلياً بواسطة نظام التوثيق الحي*
''';
}

/// The core system for managing living documentation.
class LivingDocumentationSystem {
  /// Factory constructor to return the singleton instance.
  factory LivingDocumentationSystem() => _instance;

  LivingDocumentationSystem._internal();

  static final LivingDocumentationSystem _instance =
      LivingDocumentationSystem._internal();

  /// Gets the singleton instance of the system.
  static LivingDocumentationSystem get instance => _instance;

  final Logger _logger = Logger('LivingDocumentationSystem');
  final Map<String, LivingDocument> _documents = {};
  late Directory _docsDirectory;
  bool _isInitialized = false;

  /// Initializes the documentation system.
  ///
  /// Creates the necessary directory and loads existing documents.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Create documentation directory
      final appDir = await getApplicationDocumentsDirectory();
      _docsDirectory = Directory('${appDir.path}/living_docs');

      // File existence check required for initialization
      // ignore: avoid_slow_async_io
      if (!await _docsDirectory.exists()) {
        await _docsDirectory.create(recursive: true);
      }

      // Load existing documents
      await _loadExistingDocuments();

      // Create initialization log
      await createDocument(
        title: 'تهيئة نظام التوثيق الحي',
        type: DocumentationType.changeLog,
        content: 'تم تهيئة نظام التوثيق الحي بنجاح في ${DateTime.now()}',
        author: 'system',
        tags: ['initialization', 'system'],
        metadata: {
          'version': '2.1.0',
          'features': [
            'التوثيق المضمن في الكود',
            'المواصفات القابلة للتنفيذ',
            'التقارير والتحليلات الآلية',
            'سجل قرارات المعمارية',
            'البوابة المعرفية الموحدة',
          ],
        },
      );

      _isInitialized = true;
      _logger.info('تم تهيئة نظام التوثيق الحي بنجاح');
    } catch (e, stackTrace) {
      _logger.severe('فشل في تهيئة نظام التوثيق الحي', e, stackTrace);
      rethrow;
    }
  }

  /// Loads existing documents from the local filesystem.
  Future<void> _loadExistingDocuments() async {
    try {
      final files = await _docsDirectory.list().toList();

      for (final file in files) {
        if (file is File && file.path.endsWith('.json')) {
          final content = await file.readAsString();
          final json = jsonDecode(content);
          final document = LivingDocument.fromJson(json);
          _documents[document.id] = document;
        }
      }

      _logger.info('تم تحميل ${_documents.length} وثيقة موجودة');
    } catch (e) {
      _logger.warning('فشل في تحميل الوثائق الموجودة: $e');
    }
  }

  /// Creates a new document.
  Future<String> createDocument({
    required String title,
    required DocumentationType type,
    required String content,
    required String author,
    List<String> tags = const [],
    Map<String, dynamic> metadata = const {},
    ImportanceLevel importance = ImportanceLevel.medium,
    DocumentationStatus status = DocumentationStatus.draft,
  }) async {
    try {
      final id = _generateDocumentId(title, type);
      final now = DateTime.now();

      final document = LivingDocument(
        id: id,
        title: title,
        type: type,
        status: status,
        importance: importance,
        content: content,
        metadata: metadata,
        createdAt: now,
        updatedAt: now,
        author: author,
        tags: tags,
        version: '1.0',
      );

      // Save to memory
      _documents[id] = document;

      // Save to file
      await _persistDocument(document);

      _logger.info('تم إنشاء وثيقة جديدة: $title');
      return id;
    } catch (e, stackTrace) {
      _logger.severe('فشل في إنشاء الوثيقة', e, stackTrace);
      rethrow;
    }
  }

  /// Updates an existing document.
  Future<void> updateDocument(
    String id, {
    String? title,
    String? content,
    DocumentationStatus? status,
    ImportanceLevel? importance,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    String? author,
  }) async {
    try {
      final existingDoc = _documents[id];
      if (existingDoc == null) {
        throw Exception('الوثيقة غير موجودة: $id');
      }

      // Create new version
      final newVersion = _incrementVersion(existingDoc.version);

      final updatedDoc = existingDoc.copyWith(
        title: title,
        content: content,
        status: status,
        importance: importance,
        tags: tags,
        metadata: metadata,
        author: author,
        version: newVersion,
      );

      // Update in memory
      _documents[id] = updatedDoc;

      // Save to file
      await _persistDocument(updatedDoc);

      _logger.info('تم تحديث الوثيقة: ${updatedDoc.title}');
    } catch (e, stackTrace) {
      _logger.severe('فشل في تحديث الوثيقة', e, stackTrace);
      rethrow;
    }
  }

  /// Deletes a document by ID.
  Future<void> deleteDocument(String id) async {
    try {
      final document = _documents[id];
      if (document == null) {
        throw Exception('الوثيقة غير موجودة: $id');
      }

      // Remove from memory
      _documents.remove(id);

      // Delete file
      final file = File('${_docsDirectory.path}/$id.json');
      // File existence check required before deletion
      // ignore: avoid_slow_async_io
      if (await file.exists()) {
        await file.delete();
      }

      _logger.info('تم حذف الوثيقة: ${document.title}');
    } catch (e, stackTrace) {
      _logger.severe('فشل في حذف الوثيقة', e, stackTrace);
      rethrow;
    }
  }

  /// Searches documents based on standard filters.
  List<LivingDocument> searchDocuments({
    String? query,
    DocumentationType? type,
    DocumentationStatus? status,
    ImportanceLevel? importance,
    List<String>? tags,
    String? author,
  }) =>
      _documents.values.where((doc) {
        if (query != null &&
            !doc.title.toLowerCase().contains(query.toLowerCase()) &&
            !doc.content.toLowerCase().contains(query.toLowerCase())) {
          return false;
        }

        if (type != null && doc.type != type) return false;
        if (status != null && doc.status != status) return false;
        if (importance != null && doc.importance != importance) return false;
        if (author != null && doc.author != author) return false;

        if (tags != null && tags.isNotEmpty) {
          final hasMatchingTag = tags.any((tag) => doc.tags.contains(tag));
          if (!hasMatchingTag) return false;
        }

        return true;
      }).toList();

  /// Gets a document by its ID.
  LivingDocument? getDocument(String id) => _documents[id];

  /// Gets all documents.
  List<LivingDocument> getAllDocuments() => _documents.values.toList();

  /// Creates a new Architecture Decision Record (ADR).
  Future<String> createArchitectureDecisionRecord({
    required String title,
    required String context,
    required String decision,
    required String consequences,
    required String decisionMaker,
    List<String> alternatives = const [],
    DocumentationStatus status = DocumentationStatus.approved,
  }) async {
    final adr = ArchitectureDecisionRecord(
      id: _generateDocumentId(
          'ADR: $title', DocumentationType.architectureDecision),
      title: title,
      context: context,
      decision: decision,
      consequences: consequences,
      status: status,
      dateDecided: DateTime.now(),
      decisionMaker: decisionMaker,
      alternatives: alternatives,
    );

    final document = adr.toLivingDocument();
    _documents[document.id] = document;
    await _persistDocument(document);

    _logger.info('تم إنشاء قرار معماري جديد: $title');
    return document.id;
  }

  /// Generates a statistical report of the current documentation validation.
  Map<String, dynamic> generateDocumentationReport() {
    final docs = _documents.values.toList();

    final typeCounts = <String, int>{};
    final statusCounts = <String, int>{};
    final importanceCounts = <String, int>{};
    final authorCounts = <String, int>{};

    for (final doc in docs) {
      typeCounts[doc.type.name] = (typeCounts[doc.type.name] ?? 0) + 1;
      statusCounts[doc.status.name] = (statusCounts[doc.status.name] ?? 0) + 1;
      importanceCounts[doc.importance.name] =
          (importanceCounts[doc.importance.name] ?? 0) + 1;
      authorCounts[doc.author] = (authorCounts[doc.author] ?? 0) + 1;
    }

    return {
      'reportGenerated': DateTime.now().toIso8601String(),
      'totalDocuments': docs.length,
      'typeBreakdown': typeCounts,
      'statusBreakdown': statusCounts,
      'importanceBreakdown': importanceCounts,
      'authorBreakdown': authorCounts,
      'recentlyUpdated': docs
          .where((doc) => DateTime.now().difference(doc.updatedAt).inDays <= 7)
          .length,
      'needsReview':
          docs.where((doc) => doc.status == DocumentationStatus.draft).length,
    };
  }

  /// Generates a markdown index of all documents.
  String generateDocumentationIndex() {
    final docs = _documents.values.toList()
      ..sort((a, b) => a.type.name.compareTo(b.type.name));

    final buffer = StringBuffer();
    buffer.writeln('# فهرس الوثائق الحية');
    buffer.writeln();
    buffer.writeln('تم التوليد في: ${DateTime.now()}');
    buffer.writeln();

    final groupedDocs = <DocumentationType, List<LivingDocument>>{};
    for (final doc in docs) {
      groupedDocs.putIfAbsent(doc.type, () => []).add(doc);
    }

    for (final type in DocumentationType.values) {
      final typeDocs = groupedDocs[type] ?? [];
      if (typeDocs.isEmpty) continue;

      buffer.writeln('## ${_getTypeDisplayName(type)}');
      buffer.writeln();

      for (final doc in typeDocs) {
        final statusIcon = _getStatusIcon(doc.status);
        final importanceIcon = _getImportanceIcon(doc.importance);

        buffer.writeln('- $statusIcon $importanceIcon **${doc.title}**');
        buffer.writeln('  - المؤلف: ${doc.author}');
        buffer.writeln(
            '  - آخر تحديث: ${doc.updatedAt.toIso8601String().split('T')[0]}');
        buffer.writeln('  - الإصدار: ${doc.version}');
        if (doc.tags.isNotEmpty) {
          buffer.writeln('  - العلامات: ${doc.tags.join(', ')}');
        }
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  /// Persists a document to a JSON file.
  Future<void> _persistDocument(LivingDocument document) async {
    try {
      final file = File('${_docsDirectory.path}/${document.id}.json');
      final content = jsonEncode(document.toJson());
      await file.writeAsString(content);
    } catch (e) {
      _logger.severe('فشل في حفظ الوثيقة: $e');
    }
  }

  /// Generates a unique document ID.
  String _generateDocumentId(String title, DocumentationType type) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final cleanTitle =
        title.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
    return '${type.name}_${cleanTitle}_$timestamp';
  }

  /// Increments the semantic version string.
  String _incrementVersion(String currentVersion) {
    final parts = currentVersion.split('.');
    if (parts.length >= 2) {
      final minor = int.tryParse(parts[1]) ?? 0;
      return '${parts[0]}.${minor + 1}';
    }
    return '1.1';
  }

  /// Helper to get friendly names for enum types.
  String _getTypeDisplayName(DocumentationType type) {
    switch (type) {
      case DocumentationType.codeDocumentation:
        return 'توثيق الكود';
      case DocumentationType.apiSpecification:
        return 'مواصفات API';
      case DocumentationType.userGuide:
        return 'دليل المستخدم';
      case DocumentationType.architectureDecision:
        return 'قرارات المعمارية';
      case DocumentationType.testSpecification:
        return 'مواصفات الاختبار';
      case DocumentationType.performanceReport:
        return 'تقارير الأداء';
      case DocumentationType.securityAudit:
        return 'تدقيق الأمان';
      case DocumentationType.changeLog:
        return 'سجل التغييرات';
    }
  }

  /// Helper to get icons/emojis for status.
  String _getStatusIcon(DocumentationStatus status) {
    switch (status) {
      case DocumentationStatus.draft:
        return '📝';
      case DocumentationStatus.review:
        return '👀';
      case DocumentationStatus.approved:
        return '✅';
      case DocumentationStatus.published:
        return '📢';
      case DocumentationStatus.deprecated:
        return '⚠️';
    }
  }

  /// Helper to get icons/emojis for importance.
  String _getImportanceIcon(ImportanceLevel importance) {
    switch (importance) {
      case ImportanceLevel.low:
        return '🔵';
      case ImportanceLevel.medium:
        return '🟡';
      case ImportanceLevel.high:
        return '🟠';
      case ImportanceLevel.critical:
        return '🔴';
    }
  }
}

/// Helper class for creating standard documentation types easily.
class DocumentationHelper {
  /// Creates a standardized Code Documentation document.
  static Future<String> createCodeDocumentation(
    String className,
    String description,
    String author, {
    List<String> methods = const [],
    Map<String, dynamic> metadata = const {},
  }) async =>
      await LivingDocumentationSystem.instance.createDocument(
        title: 'توثيق الكلاس: $className',
        type: DocumentationType.codeDocumentation,
        content: '''
# $className

## الوصف
$description

## الطرق المتاحة
${methods.map((method) => '- `$method`').join('\n')}

## معلومات إضافية
${metadata.entries.map((e) => '- **${e.key}**: ${e.value}').join('\n')}
''',
        author: author,
        tags: ['code', 'class', className.toLowerCase()],
        metadata: metadata,
      );

  /// Creates a standardized API Specification document.
  static Future<String> createAPIDocumentation(
    String endpoint,
    String method,
    String description,
    String author, {
    Map<String, dynamic> parameters = const {},
    Map<String, dynamic> responses = const {},
  }) async =>
      await LivingDocumentationSystem.instance.createDocument(
        title: 'API: $method $endpoint',
        type: DocumentationType.apiSpecification,
        content: '''
# $method $endpoint

## الوصف
$description

## المعلمات
${parameters.entries.map((e) => '- **${e.key}**: ${e.value}').join('\n')}

## الاستجابات
${responses.entries.map((e) => '- **${e.key}**: ${e.value}').join('\n')}
''',
        author: author,
        tags: ['api', method.toLowerCase(), 'endpoint'],
        metadata: {
          'endpoint': endpoint,
          'method': method,
          'parameters': parameters,
          'responses': responses,
        },
      );

  /// Creates a standardized Change Log document.
  static Future<String> createChangeLog(
    String version,
    List<String> changes,
    String author,
  ) async =>
      await LivingDocumentationSystem.instance.createDocument(
        title: 'سجل التغييرات - الإصدار $version',
        type: DocumentationType.changeLog,
        content: '''
# التغييرات في الإصدار $version

## التاريخ
${DateTime.now().toIso8601String().split('T')[0]}

## التغييرات
${changes.map((change) => '- $change').join('\n')}
''',
        author: author,
        tags: ['changelog', 'version', version],
        metadata: {
          'version': version,
          'changes': changes,
        },
      );
}
