import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/db_service.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';
import '../services/emotional_message_service.dart';
import '../services/safety_box_service.dart';
import '../cognitive/psychological_context_manager.dart';
import '../cognitive/relational_analytics_service.dart';
import '../cognitive/resonance_engine.dart';
import 'institutional_governance_manager.dart';
import 'living_documentation_system.dart';
import 'wing_logger.dart';
import '../di/service_locator.dart';
import '../models/verse_model.dart';
import '../models/gratitude_entry_model.dart';
import '../models/message_template.dart';

/// Handles application initialization.
class AppInitializer {
  /// Initializes all core services and systems.
  static Future<InitializationResult> initialize() async {
    final stopwatch = Stopwatch()..start();
    WingLogger.info('Initializing App Services...', tag: 'AppInitializer');

    // Initialize Security & Core Data Foundation (Service Locator)
    await sl.initialize();

    try {
      // 1. Critical Base Infrastructure (Sequential)
      await Hive.initFlutter();
      _registerAdapters();

      // 2. Parallel Service Initialization
      final governanceFuture =
          InstitutionalGovernanceManager.instance.initialize();
      final docsFuture = LivingDocumentationSystem.instance.initialize();

      final dbService = DBService();
      final dbFuture = dbService.init();

      final notificationService = NotificationService();
      // System Resilience: Non-blocking init for platform-sensitive services
      unawaited(notificationService.init());

      final audioFuture = AudioService.instance.initialize();
      final authFuture = AuthService.instance.initialize();

      final contextManager = PsychologicalContextManager();
      final contextFuture = contextManager.initialize();

      final safetyBoxService = SafetyBoxService();
      final safetyBoxFuture = safetyBoxService.initialize();

      // Wait for all to complete
      await Future.wait([
        governanceFuture,
        docsFuture,
        dbFuture,
        audioFuture,
        authFuture,
        contextFuture,
        safetyBoxFuture,
      ]);

      stopwatch.stop();
      WingLogger.info(
        'Initialization Completed',
        tag: 'AppInitializer',
        data: {'duration_ms': stopwatch.elapsedMilliseconds},
      );

      final analyticsService = RelationalAnalyticsService();
      final resonanceEngine = ResonanceEngine();

      return InitializationResult(
        dbService: dbService,
        notificationService: notificationService,
        emotionalMessageService: EmotionalMessageService(
          analyticsService: analyticsService,
          resonanceEngine: resonanceEngine,
          contextManager: contextManager,
          dbService: dbService,
        ),
        contextManager: contextManager,
        safetyBoxService: safetyBoxService,
      );
    } catch (e, stack) {
      WingLogger.critical(
        'Initialization Failed',
        tag: 'AppInitializer',
        data: {'error': e.toString()},
        stackTrace: stack,
      );
      rethrow;
    }
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VerseModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(GratitudeEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(MessageTemplateAdapter());
    }
  }
}

/// Result of application initialization.
class InitializationResult {
  /// Creates [InitializationResult].
  InitializationResult({
    required this.dbService,
    required this.notificationService,
    required this.emotionalMessageService,
    required this.contextManager,
    required this.safetyBoxService,
  });

  /// Database service instance.
  final DBService dbService;

  /// Notification service instance.
  final NotificationService notificationService;

  /// Emotional message service instance.
  final EmotionalMessageService emotionalMessageService;

  /// Psychological context manager instance.
  final PsychologicalContextManager contextManager;

  /// Safety box service instance.
  final SafetyBoxService safetyBoxService;
}
