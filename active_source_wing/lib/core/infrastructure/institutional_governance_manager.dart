/// Institutional Governance & Ethics System.
///
/// This system serves as the all-encompassing layer permeating
/// all SEF layers, ensuring that all activities align with
/// ethical principles and organizational policies.
library;

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

/// Principles of Institutional Governance.
enum GovernancePrinciple {
  /// Full Transparency.
  transparency,

  /// Full Accountability.
  accountability,

  /// Ongoing Compliance.
  compliance,

  /// Fairness and Equity.
  fairness,

  /// Privacy and Security.
  privacy,
}

/// Types of audit events.
enum AuditEventType {
  /// User-initiated action.
  userAction,

  /// System-made decision.
  systemDecision,

  /// Data access event.
  dataAccess,

  /// Configuration change.
  configChange,

  /// Security-related event.
  securityEvent,

  /// Error occurrence.
  errorOccurrence,
}

/// Severity level for events.
enum SeverityLevel {
  /// Low severity.
  low,

  /// Medium severity.
  medium,

  /// High severity.
  high,

  /// Critical severity.
  critical,
}

/// Institutional Audit Log Entry.
class GovernanceAuditEntry {
  /// Creates a [GovernanceAuditEntry].
  const GovernanceAuditEntry({
    required this.id,
    required this.timestamp,
    required this.eventType,
    required this.severity,
    required this.description,
    required this.metadata,
    required this.digitalSignature,
    required this.userId,
    required this.sessionId,
  });

  /// Creates a [GovernanceAuditEntry] from JSON.
  factory GovernanceAuditEntry.fromJson(Map<String, dynamic> json) =>
      GovernanceAuditEntry(
        id: json['id'],
        timestamp: DateTime.parse(json['timestamp']),
        eventType: AuditEventType.values.byName(json['eventType']),
        severity: SeverityLevel.values.byName(json['severity']),
        description: json['description'],
        metadata: Map<String, dynamic>.from(json['metadata']),
        digitalSignature: json['digitalSignature'],
        userId: json['userId'],
        sessionId: json['sessionId'],
      );

  /// Unique ID of the log entry.
  final String id;

  /// Timestamp of the event.
  final DateTime timestamp;

  /// Type of the event.
  final AuditEventType eventType;

  /// Severity level of the event.
  final SeverityLevel severity;

  /// Description of the event.
  final String description;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Digital signature for integrity verification.
  final String digitalSignature;

  /// ID of the user associated with the event.
  final String userId;

  /// Session ID associated with the event.
  final String sessionId;

  /// Converts the log entry to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'eventType': eventType.name,
        'severity': severity.name,
        'description': description,
        'metadata': metadata,
        'digitalSignature': digitalSignature,
        'userId': userId,
        'sessionId': sessionId,
      };
}

/// Institutional Governance & Ethics System Manager.
class InstitutionalGovernanceManager {
  /// Factory constructor to return the singleton instance.
  factory InstitutionalGovernanceManager() => _instance;

  InstitutionalGovernanceManager._internal();

  static final InstitutionalGovernanceManager _instance =
      InstitutionalGovernanceManager._internal();

  /// Gets the singleton instance.
  static InstitutionalGovernanceManager get instance => _instance;

  final Logger _logger = Logger('InstitutionalGovernanceManager');
  final List<GovernanceAuditEntry> _auditLogs = [];
  late File _auditLogFile;
  bool _isInitialized = false;

  /// Initializes the governance system.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Setup audit log file
      final directory = await getApplicationDocumentsDirectory();
      _auditLogFile = File('${directory.path}/governance_audit_logs.json');

      // Load existing logs
      await _loadExistingLogs();

      // Log system start
      await logEvent(
        eventType: AuditEventType.systemDecision,
        severity: SeverityLevel.medium,
        description: 'Institutional Governance & Ethics System Initialized',
        metadata: {
          'version': '2.1.0',
          'principles': GovernancePrinciple.values.map((p) => p.name).toList(),
        },
        userId: 'system',
        sessionId: 'init',
      );

      _isInitialized = true;
      _logger.info('Institutional Governance System initialized successfully');
    } catch (e, stackTrace) {
      _logger.severe('Failed to initialize Governance System', e, stackTrace);
      rethrow;
    }
  }

  /// Loads existing logs from the file.
  Future<void> _loadExistingLogs() async {
    try {
      // File existence check required for loading logs
      // ignore: avoid_slow_async_io
      if (await _auditLogFile.exists()) {
        final content = await _auditLogFile.readAsString();
        final List<dynamic> jsonList = jsonDecode(content);

        _auditLogs.clear();
        _auditLogs.addAll(
          jsonList.map((json) => GovernanceAuditEntry.fromJson(json)).toList(),
        );

        _logger.info('Loaded ${_auditLogs.length} existing audit logs');
      }
    } catch (e) {
      _logger.warning('Failed to load existing logs: $e');
    }
  }

  /// Logs a new event to the audit log.
  Future<void> logEvent({
    required AuditEventType eventType,
    required SeverityLevel severity,
    required String description,
    required Map<String, dynamic> metadata,
    required String userId,
    required String sessionId,
  }) async {
    try {
      final timestamp = DateTime.now();
      final id = _generateEventId(timestamp, eventType, userId);

      // Generate digital signature
      final signature = _generateDigitalSignature(
        id,
        timestamp,
        eventType,
        description,
        metadata,
      );

      final auditLog = GovernanceAuditEntry(
        id: id,
        timestamp: timestamp,
        eventType: eventType,
        severity: severity,
        description: description,
        metadata: metadata,
        digitalSignature: signature,
        userId: userId,
        sessionId: sessionId,
      );

      // Add to memory
      _auditLogs.add(auditLog);

      // Save to file
      await _persistAuditLogs();

      // Log to system logger
      _logger.info('Audit event logged: $description');

      // Check compliance
      await _checkCompliance(auditLog);
    } catch (e, stackTrace) {
      _logger.severe('Failed to log audit event', e, stackTrace);
    }
  }

  /// Generates a unique event ID.
  String _generateEventId(
      DateTime timestamp, AuditEventType eventType, String userId) {
    final data =
        '${timestamp.millisecondsSinceEpoch}_${eventType.name}_$userId';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  /// Generates a digital signature for log integrity.
  String _generateDigitalSignature(
    String id,
    DateTime timestamp,
    AuditEventType eventType,
    String description,
    Map<String, dynamic> metadata,
  ) {
    final data = '$id${timestamp.toIso8601String()}${eventType.name}'
        '$description${jsonEncode(metadata)}';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Persists audit logs to file.
  Future<void> _persistAuditLogs() async {
    try {
      final jsonList = _auditLogs.map((log) => log.toJson()).toList();
      final content = jsonEncode(jsonList);
      await _auditLogFile.writeAsString(content);
    } catch (e) {
      _logger.severe('Failed to persist audit logs: $e');
    }
  }

  /// Checks for compliance violations.
  Future<void> _checkCompliance(GovernanceAuditEntry auditLog) async {
    try {
      // Check for critical events
      if (auditLog.severity == SeverityLevel.critical) {
        await _handleCriticalEvent(auditLog);
      }

      // Check for suspicious patterns
      await _detectSuspiciousPatterns(auditLog);

      // Check for privacy violations
      await _checkPrivacyViolations(auditLog);
    } catch (e) {
      _logger.warning('Failed during compliance check: $e');
    }
  }

  /// Handles critical events.
  Future<void> _handleCriticalEvent(GovernanceAuditEntry auditLog) async {
    _logger.severe('CRITICAL EVENT: ${auditLog.description}');

    // Immediate notification to admins (to be implemented)
    // await NotificationService.instance.sendCriticalAlert(auditLog);
  }

  /// Detects suspicious patterns.
  Future<void> _detectSuspiciousPatterns(GovernanceAuditEntry auditLog) async {
    // Pattern analysis (to be detailed in advanced phases)
    // Example: High number of failed access attempts
    // Example: Unusual activity at odd hours
  }

  /// Checks for potential privacy violations.
  Future<void> _checkPrivacyViolations(GovernanceAuditEntry auditLog) async {
    // Check for unauthorized access to sensitive data
    if (auditLog.eventType == AuditEventType.dataAccess) {
      final sensitiveData =
          auditLog.metadata['sensitiveData'] as bool? ?? false;
      if (sensitiveData) {
        _logger.warning('Sensitive data accessed: ${auditLog.description}');
      }
    }
  }

  /// Retrieves audit logs based on filters.
  List<GovernanceAuditEntry> getAuditLogs({
    AuditEventType? eventType,
    SeverityLevel? severity,
    String? userId,
    DateTime? fromDate,
    DateTime? toDate,
  }) =>
      _auditLogs.where((log) {
        if (eventType != null && log.eventType != eventType) return false;
        if (severity != null && log.severity != severity) return false;
        if (userId != null && log.userId != userId) return false;
        if (fromDate != null && log.timestamp.isBefore(fromDate)) return false;
        if (toDate != null && log.timestamp.isAfter(toDate)) return false;
        return true;
      }).toList();

  /// Generates a governance report.
  Map<String, dynamic> generateGovernanceReport({
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    final logs = getAuditLogs(fromDate: fromDate, toDate: toDate);

    final eventTypeCounts = <String, int>{};
    final severityCounts = <String, int>{};
    final userActivityCounts = <String, int>{};

    for (final log in logs) {
      eventTypeCounts[log.eventType.name] =
          (eventTypeCounts[log.eventType.name] ?? 0) + 1;
      severityCounts[log.severity.name] =
          (severityCounts[log.severity.name] ?? 0) + 1;
      userActivityCounts[log.userId] =
          (userActivityCounts[log.userId] ?? 0) + 1;
    }

    return {
      'reportGenerated': DateTime.now().toIso8601String(),
      'period': {
        'from': fromDate?.toIso8601String(),
        'to': toDate?.toIso8601String(),
      },
      'totalEvents': logs.length,
      'eventTypeBreakdown': eventTypeCounts,
      'severityBreakdown': severityCounts,
      'userActivityBreakdown': userActivityCounts,
      'complianceStatus': _assessComplianceStatus(logs),
    };
  }

  /// Assesses overall compliance status.
  String _assessComplianceStatus(List<GovernanceAuditEntry> logs) {
    final criticalEvents =
        logs.where((log) => log.severity == SeverityLevel.critical).length;
    final highEvents =
        logs.where((log) => log.severity == SeverityLevel.high).length;

    if (criticalEvents > 0) return 'Non-Compliant - Critical Events';
    if (highEvents > 5) return 'Warning - High Risk Events';
    return 'Compliant';
  }

  /// Cleans up old logs.
  Future<void> cleanupOldLogs({int retentionDays = 90}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: retentionDays));
      final initialCount = _auditLogs.length;

      _auditLogs.removeWhere((log) => log.timestamp.isBefore(cutoffDate));

      await _persistAuditLogs();

      final removedCount = initialCount - _auditLogs.length;
      _logger.info('Removed $removedCount old logs');
    } catch (e) {
      _logger.severe('Failed to clean up old logs: $e');
    }
  }

  /// Verifies the integrity of audit logs.
  Future<bool> verifyAuditLogIntegrity() async {
    try {
      for (final log in _auditLogs) {
        final expectedSignature = _generateDigitalSignature(
          log.id,
          log.timestamp,
          log.eventType,
          log.description,
          log.metadata,
        );

        if (log.digitalSignature != expectedSignature) {
          _logger.severe('Audit log tampering detected: ${log.id}');
          return false;
        }
      }

      _logger.info('All audit logs verified successfully');
      return true;
    } catch (e) {
      _logger.severe('Failed to verify log integrity: $e');
      return false;
    }
  }
}

/// Helper class for easy event logging.
class GovernanceHelper {
  /// Logs a user action.
  static Future<void> logUserAction(
    String action,
    String userId,
    String sessionId, {
    Map<String, dynamic>? metadata,
    SeverityLevel severity = SeverityLevel.low,
  }) async {
    await InstitutionalGovernanceManager.instance.logEvent(
      eventType: AuditEventType.userAction,
      severity: severity,
      description: 'User Action: $action',
      metadata: metadata ?? {},
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Logs a system decision.
  static Future<void> logSystemDecision(
    String decision,
    String context, {
    Map<String, dynamic>? metadata,
    SeverityLevel severity = SeverityLevel.medium,
  }) async {
    await InstitutionalGovernanceManager.instance.logEvent(
      eventType: AuditEventType.systemDecision,
      severity: severity,
      description: 'System Decision: $decision in context: $context',
      metadata: metadata ?? {},
      userId: 'system',
      sessionId: context,
    );
  }

  /// Logs a data access event.
  static Future<void> logDataAccess(
    String dataType,
    String userId,
    String sessionId, {
    bool sensitiveData = false,
    SeverityLevel severity = SeverityLevel.low,
  }) async {
    await InstitutionalGovernanceManager.instance.logEvent(
      eventType: AuditEventType.dataAccess,
      severity: severity,
      description: 'Data Access: $dataType',
      metadata: {
        'dataType': dataType,
        'sensitiveData': sensitiveData,
      },
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Logs a security event.
  static Future<void> logSecurityEvent(
    String event,
    String userId,
    String sessionId, {
    Map<String, dynamic>? metadata,
    SeverityLevel severity = SeverityLevel.high,
  }) async {
    await InstitutionalGovernanceManager.instance.logEvent(
      eventType: AuditEventType.securityEvent,
      severity: severity,
      description: 'Security Event: $event',
      metadata: metadata ?? {},
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Logs an error.
  static Future<void> logError(
    String error,
    String context, {
    Map<String, dynamic>? metadata,
    SeverityLevel severity = SeverityLevel.medium,
  }) async {
    await InstitutionalGovernanceManager.instance.logEvent(
      eventType: AuditEventType.errorOccurrence,
      severity: severity,
      description: 'Error: $error in context: $context',
      metadata: metadata ?? {},
      userId: 'system',
      sessionId: context,
    );
  }
}
