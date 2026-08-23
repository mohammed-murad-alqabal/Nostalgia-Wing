import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core Infrastructure
import 'core/infrastructure/wing_logger.dart';
import 'core/infrastructure/dependency_health_monitor.dart';
import 'core/infrastructure/institutional_governance_manager.dart';
import 'core/infrastructure/app_initializer.dart';

// Psychology System
import 'core/psychology/emotional_state.dart';
import 'core/psychology/psychological_analysis_engine.dart';
import 'core/psychology/emotional_adaptation_system.dart';

// Cognitive Modules
import 'core/cognitive/emotional_gravity_engine.dart';
import 'core/cognitive/relational_analytics_service.dart';
import 'core/cognitive/surprise_evolution_engine.dart';
import 'core/cognitive/dual_truth_engine.dart';
import 'core/cognitive/emotional_entanglement_module.dart';
import 'core/cognitive/cosmic_synchronization_module.dart';
import 'core/cognitive/non_action_interface.dart';
import 'core/cognitive/psychological_context_manager.dart';

// Services
import 'core/services/db_service.dart';
import 'core/services/safety_box_service.dart';
import 'core/services/audio_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/emotional_message_service.dart';

// Screens
import 'features/home/screens/home_screen.dart';
import 'features/home/widgets/cognitive_identity_widgets.dart';

/// التطبيق الرئيسي - جناح الحنين
/// كيان هندسي حي للحب والحنين مع نظام ذكاء عاطفي متقدم
Future<void> main() async {
  // تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // تسجيل بداية التطبيق
  WingLogger.info('تطبيق جناح الحنين يبدأ التشغيل', tag: 'Main');

  try {
    // تهيئة Hive لقاعدة البيانات المحلية (تم نقلها إلى AppInitializer)

    // تهيئة الخدمات الأساسية
    final result = await AppInitializer.initialize();

    // تسجيل النجاح
    await GovernanceHelper.logSystemDecision(
      'تم تهيئة جميع خدمات SEF بنجاح',
      'system_initialization',
      metadata: {
        'version': '2.1.0',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    // تشغيل التطبيق مع الخدمات المهيأة
    runApp(
      WingOfNostalgiaApp(
        dbService: result.dbService,
        notificationService: result.notificationService,
        emotionalMessageService: result.emotionalMessageService,
        contextManager: result.contextManager,
        safetyBoxService: result.safetyBoxService,
      ),
    );
  } catch (e, stackTrace) {
    final incidentId =
        DateTime.now().microsecondsSinceEpoch.toRadixString(36).toUpperCase();

    WingLogger.critical(
      'فشل في تهيئة التطبيق',
      tag: 'Main',
      data: {'incident_id': incidentId, 'error': e.toString()},
      stackTrace: stackTrace,
    );

    // لا تُمرر تفاصيل الاستثناء إلى واجهة المستخدم أو مراقب الصحة.
    DependencyHealthMonitor.reportFailure('startup', 'initialization_failed');

    // تشغيل التطبيق في وضع طوارئ آمن مع معرّف يمكن ربطه بالسجل.
    runApp(EmergencyApp(incidentId: incidentId, onRetry: main));
  }
}

/// Main application widget with advanced psychological system.
class WingOfNostalgiaApp extends StatefulWidget {
  /// Creates [WingOfNostalgiaApp].
  const WingOfNostalgiaApp({
    super.key,
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

  @override
  State<WingOfNostalgiaApp> createState() => _WingOfNostalgiaAppState();
}

class _WingOfNostalgiaAppState extends State<WingOfNostalgiaApp> {
  late final PsychologicalAnalysisEngine _psychEngine;
  late final EmotionalAdaptationSystem _adaptationSystem;

  EmotionType _currentEmotion = EmotionType.neutral;
  ThemeData _currentTheme = ThemeData.light();

  @override
  void initState() {
    super.initState();

    // تهيئة النظام النفسي
    _psychEngine = PsychologicalAnalysisEngine();
    _adaptationSystem = EmotionalAdaptationSystem();

    // تطبيق الثيم الأولي
    _currentTheme = _adaptationSystem.adaptThemeToEmotion(
      _currentEmotion,
      ThemeData.light(),
    );

    WingLogger.info('تم تهيئة النظام النفسي المتقدم', tag: 'PsychSystem');
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          // خدمات التطبيق (تم تهيئتها مسبقاً)
          Provider<DBService>.value(value: widget.dbService),
          Provider<AudioService>.value(value: AudioService.instance),
          Provider<NotificationService>.value(
              value: widget.notificationService),
          Provider<AuthService>.value(value: AuthService.instance),
          Provider<EmotionalMessageService>.value(
            value: widget.emotionalMessageService,
          ),
          Provider<SafetyBoxService>.value(value: widget.safetyBoxService),

          // النظام النفسي
          Provider<PsychologicalAnalysisEngine>.value(value: _psychEngine),
          Provider<EmotionalAdaptationSystem>.value(value: _adaptationSystem),

          // حالة التطبيق
          ChangeNotifierProvider<AppStateProvider>(
            create: (_) => AppStateProvider(),
          ),
          Provider<RelationalAnalyticsService>(
            create: (_) => RelationalAnalyticsService(),
          ),

          // Psychological Context Manager
          Provider<PsychologicalContextManager>.value(
              value: widget.contextManager),

          // Cognitive Modules - Provided as singletons
          // These still need to be created as they depend on services
          // available in context.
          Provider<EmotionalGravityEngine>(
            create: (context) => EmotionalGravityEngine(
              messageService: Provider.of<EmotionalMessageService>(
                context,
                listen: false,
              ),
              dbService: Provider.of<DBService>(context, listen: false),
              notificationService: Provider.of<NotificationService>(
                context,
                listen: false,
              ),
              contextManager: Provider.of<PsychologicalContextManager>(
                context,
                listen: false,
              ),
            ),
          ),
          Provider<SurpriseEvolutionEngine>(
            create: (context) => SurpriseEvolutionEngine(
              dbService: Provider.of<DBService>(context, listen: false),
              notificationService: Provider.of<NotificationService>(
                context,
                listen: false,
              ),
              contextManager: Provider.of<PsychologicalContextManager>(
                context,
                listen: false,
              ),
            ),
          ),
          Provider<DualTruthEngine>(
            create: (context) => DualTruthEngine(
              dbService: Provider.of<DBService>(context, listen: false),
              contextManager: Provider.of<PsychologicalContextManager>(
                context,
                listen: false,
              ),
            ),
          ),
          Provider<EmotionalEntanglementModule>(
            create: (context) => EmotionalEntanglementModule(
              dbService: Provider.of<DBService>(context, listen: false),
              contextManager: Provider.of<PsychologicalContextManager>(
                context,
                listen: false,
              ),
            ),
          ),
          Provider<CosmicSynchronizationModule>(
            create: (context) => CosmicSynchronizationModule(
              notificationService: Provider.of<NotificationService>(
                context,
                listen: false,
              ),
              contextManager: Provider.of<PsychologicalContextManager>(
                context,
                listen: false,
              ),
            ),
          ),
          Provider<NonActionInterface>(
            create: (context) => NonActionInterface(
              emotionalGravityEngine: Provider.of<EmotionalGravityEngine>(
                context,
                listen: false,
              ),
              surpriseEvolutionEngine: Provider.of<SurpriseEvolutionEngine>(
                context,
                listen: false,
              ),
              dualTruthEngine:
                  Provider.of<DualTruthEngine>(context, listen: false),
              emotionalEntanglementModule:
                  Provider.of<EmotionalEntanglementModule>(
                context,
                listen: false,
              ),
              cosmicSynchronizationModule:
                  Provider.of<CosmicSynchronizationModule>(
                context,
                listen: false,
              ),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'جناح الحنين',
          debugShowCheckedModeBanner: false,

          // الثيم المتكيف عاطفياً
          theme: _currentTheme,

          // الاتجاه العربي
          locale: const Locale('ar', 'SA'),

          // الشاشة الرئيسية
          home: AdaptiveUISystem(
            userId: 'default_user',
            onEmotionChanged: _onEmotionChanged, // سيتم تحديثه مع نظام المصادقة
            child: const AuthWrapper(),
          ),

          // معالج الأخطاء
          builder: (context, child) =>
              _ErrorBoundary(child: child ?? const SizedBox.shrink()),
        ),
      );

  /// معالج تغيير المشاعر
  void _onEmotionChanged(EmotionType newEmotion) {
    if (_currentEmotion != newEmotion) {
      setState(() {
        _currentEmotion = newEmotion;
        _currentTheme = _adaptationSystem.adaptThemeToEmotion(
          newEmotion,
          ThemeData.light(),
        );
      });

      WingLogger.info(
        'تم تحديث الثيم العاطفي',
        tag: 'EmotionalUI',
        data: {
          'previous_emotion': _currentEmotion.toString(),
          'new_emotion': newEmotion.toString(),
        },
      );
    }
  }
}

/// نظام الواجهة التكيفية
/// Adaptive User Interface System.
class AdaptiveUISystem extends StatefulWidget {
  /// Creates [AdaptiveUISystem].
  const AdaptiveUISystem({
    super.key,
    required this.child,
    required this.userId,
    this.onEmotionChanged,
  });

  /// The child widget.
  final Widget child;

  /// The user ID.
  final String userId;

  /// Callback when emotion changes.
  final Function(EmotionType)? onEmotionChanged;

  @override
  State<AdaptiveUISystem> createState() => _AdaptiveUISystemState();
}

class _AdaptiveUISystemState extends State<AdaptiveUISystem> {
  final EmotionType _currentEmotionType = EmotionType.neutral;

  @override
  void initState() {
    super.initState();
    _initializeAdaptiveSystem();
  }

  void _initializeAdaptiveSystem() {
    // بدء مراقبة التكيف (سيتم تنفيذه في المراحل القادمة)
    WingLogger.info('تم تهيئة النظام التكيفي', tag: 'AdaptiveUI');
  }

  @override
  Widget build(BuildContext context) {
    final adaptationSystem = Provider.of<EmotionalAdaptationSystem>(context);

    return adaptationSystem.adaptWidgetToEmotion(
      widget.child,
      _currentEmotionType,
    );
  }
}

/// مزود حالة التطبيق
/// Application State Provider.
class AppStateProvider extends ChangeNotifier {
  bool _isInitialized = false;
  String? _currentUserId;

  /// Whether the app is initialized.
  bool get isInitialized => _isInitialized;

  /// The current user ID.
  String? get currentUserId => _currentUserId;

  /// Sets initialization state.
  void setInitialized(bool initialized) {
    _isInitialized = initialized;
    notifyListeners();
  }

  /// Sets the current user.
  void setCurrentUser(String? userId) {
    _currentUserId = userId;
    notifyListeners();
  }
}

/// غلاف المصادقة
/// Authentication Wrapper.
class AuthWrapper extends StatefulWidget {
  /// Creates [AuthWrapper].
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    try {
      final authService = context.read<AuthService>();
      final isAuthenticated = await authService.authenticate();

      if (mounted) {
        setState(() {
          _isAuthenticated = isAuthenticated;
          _isLoading = false;
        });
      }

      WingLogger.info(
        'تم فحص المصادقة',
        tag: 'Auth',
        data: {'authenticated': isAuthenticated},
      );

      // If we implement login screen later, we will use isAuthenticated here.
    } catch (e, stackTrace) {
      WingLogger.error(
        'فشل في فحص المصادقة',
        tag: 'Auth',
        data: {'error_type': e.runtimeType.toString()},
        stackTrace: stackTrace,
      );

      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Stack(
          children: [
            // خلفية المعرفية الرياضية
            Positioned.fill(
              child: CognitiveBackground(emotionalColor: Color(0xFF45B7D1)),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الشعار المعرفي الرياضي
                  CognitiveLogo(size: 180),
                  SizedBox(height: 24),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'جناح الحنين',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'يتم تهيئة كيان الحب...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (!_isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'تعذر التحقق من صلاحية الوصول. يرجى إعادة فتح التطبيق.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _checkAuthentication,
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const HomeScreen();
  }
}

/// حدود الأخطاء لحماية التطبيق
class _ErrorBoundary extends StatelessWidget {
  const _ErrorBoundary({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// تطبيق الطوارئ في حالة فشل التهيئة
/// Emergency application widget shown when initialization fails.
class EmergencyApp extends StatefulWidget {
  /// Creates [EmergencyApp].
  const EmergencyApp({super.key, required this.incidentId, this.onRetry});

  /// رمز حادثة آمن لربط رسالة المستخدم بالسجلات التشخيصية.
  final String incidentId;

  /// إعادة محاولة تهيئة التطبيق دون كشف تفاصيل الفشل للمستخدم.
  final Future<void> Function()? onRetry;

  @override
  State<EmergencyApp> createState() => _EmergencyAppState();
}

class _EmergencyAppState extends State<EmergencyApp> {
  bool _isRetrying = false;

  Future<void> _retryInitialization() async {
    final onRetry = widget.onRetry;
    if (onRetry == null || _isRetrying) {
      return;
    }

    setState(() => _isRetrying = true);
    try {
      await onRetry();
    } finally {
      if (mounted) {
        setState(() => _isRetrying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'جناح الحنين - وضع الطوارئ',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Stack(
            children: [
              const Positioned.fill(
                child: CognitiveBackground(emotionalColor: Color(0xFF45B7D1)),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CognitiveLogo(),
                      const SizedBox(height: 24),
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 48,
                        color: Colors.orangeAccent,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'جناح الحنين',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'تعذر بدء التطبيق بأمان. يمكنك إعادة المحاولة الآن.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'رمز الحادثة: ${widget.incidentId}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                      if (widget.onRetry != null) ...[
                        const SizedBox(height: 24),
                        OutlinedButton(
                          onPressed: _isRetrying ? null : _retryInitialization,
                          child: _isRetrying
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('إعادة المحاولة'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
