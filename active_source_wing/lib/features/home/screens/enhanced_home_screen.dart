import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:math' as math;

// Core imports
import '../../../core/psychology/emotional_state.dart';
import '../../../core/performance/performance_monitor.dart';
import '../../../core/performance/performance_adaptation_service.dart';
import '../../../core/memory/memory_manager.dart';

// Mirrror Feature
import '../../mirror/presentation/screens/emotion_mirror_screen.dart';

// Widget imports
import '../widgets/enhanced_parallax_layer.dart';
import '../widgets/cognitive_identity_widgets.dart';
import '../../mirror/presentation/screens/intelligence_lab_screen.dart';
import '../../messages/screens/love_message_screen.dart';
import '../../memories/screens/memories_list_screen.dart';
import '../../settings/screens/settings_screen.dart';

/// Enhanced Home Screen
/// Provides advanced user experience with emotional intelligence
/// and visual effects.
class EnhancedHomeScreen extends StatefulWidget {
  /// Creates an [EnhancedHomeScreen].
  const EnhancedHomeScreen({super.key});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _mainAnimationController;
  late AnimationController _heartbeatController;
  late AnimationController _breathingController;

  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _heartbeatAnimation;
  late Animation<double> _breathingAnimation;

  EmotionType _currentEmotion = EmotionType.neutral;
  String _currentMessage = '';

  static final List<String> _neutralGreetings = [
    'مرحباً بكِ في جناح الحنين',
    'طاب يومكِ بكل خير وسعادة',
    'أهلاً بكِ في واحة الذكريات',
    'سعيد بلقائكِ مجدداً',
    'لنصنع ذكريات جميلة اليوم',
    'في انتظار همساتكِ الرقيقة',
  ];
  bool _isInteracting = false;
  int _selectedNavIndex = 0;

  // إدارة الأداء والذاكرة
  final PerformanceAdaptationService _adaptationService =
      PerformanceAdaptationService();
  final MemoryManager _memoryManager = MemoryManager();
  late AnimationResource _animationResource;
  bool _animationsPaused = false;
  bool _showPerformanceMenu = false;

  @override
  void initState() {
    super.initState();

    _currentMessage =
        _neutralGreetings[math.Random().nextInt(_neutralGreetings.length)];

    // تهيئة أنظمة الأداء والذاكرة
    _initializePerformanceMonitoring();
    _initializeMemoryManagement();

    // تهيئة الحركات
    _initializeAnimations();

    // بدء المحرك العاطفي
    _startEmotionalEngine();
  }

  /// تهيئة مراقبة الأداء
  void _initializePerformanceMonitoring() {
    PerformanceMonitor().startMonitoring();
    _adaptationService.addListener(_onPerformanceAdaptation);
  }

  void _onPerformanceAdaptation() {
    if (mounted) {
      setState(() {
        _adaptAnimationsToPerformance(
            _adaptationService.config.performanceLevel);
      });
    }
  }

  /// إيقاف الحركات غير الأساسية
  void _pauseNonEssentialAnimations() {
    _heartbeatController.stop();
    _breathingController.stop();
    _animationsPaused = true;
  }

  /// تهيئة إدارة الذاكرة
  void _initializeMemoryManagement() {
    _memoryManager.initialize();
    WidgetsBinding.instance.addObserver(this);
  }

  /// تكييف الحركات مع مستوى الأداء
  void _adaptAnimationsToPerformance(PerformanceLevel level) {
    final config = _adaptationService.config;

    switch (level) {
      case PerformanceLevel.high:
        // جميع الحركات مفعلة
        if (_animationsPaused) {
          _resumeAnimations();
        }
        break;

      case PerformanceLevel.medium:
        // تقليل سرعة الحركات
        _heartbeatController.duration = Duration(
            milliseconds: (1200 * (1 / config.animationSpeedFactor)).round());
        _breathingController.duration =
            Duration(seconds: (6 * (1 / config.animationSpeedFactor)).round());
        break;

      case PerformanceLevel.low:
        // إيقاف الحركات غير الأساسية
        _pauseNonEssentialAnimations();
        break;
    }
  }

  /// استئناف الحركات
  void _resumeAnimations() {
    if (_animationsPaused) {
      _heartbeatController.repeat(reverse: true);
      _breathingController.repeat(reverse: true);
      _animationsPaused = false;
    }
  }

  void _initializeAnimations() {
    try {
      // محرك الحركة الرئيسي
      _mainAnimationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );

      // محرك نبضات القلب
      _heartbeatController = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );

      // محرك التنفس
      _breathingController = AnimationController(
        duration: const Duration(seconds: 4),
        vsync: this,
      );

      // تسجيل الموارد مع مدير الذاكرة
      _animationResource = AnimationResource(
        name: 'enhanced_home_animations',
        controllers: [
          _mainAnimationController,
          _heartbeatController,
          _breathingController,
        ],
      );
      _memoryManager.registerResource(_animationResource);

      // حركة الظهور التدريجي
      _fadeInAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ));

      // حركة الانزلاق
      _slideAnimation = Tween<double>(
        begin: 50.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: _mainAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ));

      // حركة نبضات القلب
      _heartbeatAnimation = Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: _heartbeatController,
        curve: Curves.elasticOut,
      ));

      // حركة التنفس
      _breathingAnimation = Tween<double>(
        begin: 0.95,
        end: 1.05,
      ).animate(CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ));

      // بدء الحركات
      _mainAnimationController.forward();
      _heartbeatController.repeat(reverse: true);
      _breathingController.repeat(reverse: true);

      if (kDebugMode) {
        print('✨ Enhanced Home: Animations initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Enhanced Home: Animation initialization failed: $e');
      }
      // fallback: استخدام حركات بسيطة
      _initializeFallbackAnimations();
    }
  }

  /// تهيئة حركات احتياطية في حالة الفشل
  void _initializeFallbackAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_mainAnimationController);

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(_mainAnimationController);

    _mainAnimationController.forward();
  }

  void _startEmotionalEngine() {
    // محاكاة تشغيل المحرك العاطفي
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _updateEmotionalState(EmotionType.happy);
      }
    });
  }

  void _updateEmotionalState(EmotionType newEmotion) {
    setState(() {
      _currentEmotion = newEmotion;
      _currentMessage = _getEmotionalMessage(newEmotion);
    });

    // تحديث الحركات بناءً على المشاعر
    _adaptAnimationsToEmotion(newEmotion);
  }

  String _getEmotionalMessage(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return 'قلبي يزهر فرحاً لوجودك';
      case EmotionType.sad:
        return 'حنيني إليك لا ينطفئ';
      case EmotionType.excited:
        return 'بشوق كبير.. لدي ما يسرك';
      case EmotionType.calm:
        return 'في حضورك.. يسكن كل ضجيج';
      case EmotionType.anxious:
        return 'أرجو أن تكوني في أمان وطمأنينة';
      case EmotionType.grateful:
        return 'ممتن لكل لحظة جمعتنا';
      case EmotionType.nostalgic:
        return 'عطر ذكرياتنا يملأ المكان';
      case EmotionType.hopeful:
        return 'غداً أجمل.. ويدي بيدك';
      default:
        return _neutralGreetings[
            math.Random().nextInt(_neutralGreetings.length)];
    }
  }

  void _adaptAnimationsToEmotion(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        _heartbeatController.duration = const Duration(milliseconds: 800);
        break;
      case EmotionType.excited:
        _heartbeatController.duration = const Duration(milliseconds: 600);
        break;
      case EmotionType.calm:
        _heartbeatController.duration = const Duration(milliseconds: 1200);
        break;
      case EmotionType.sad:
        _heartbeatController.duration = const Duration(milliseconds: 1500);
        break;
      default:
        _heartbeatController.duration = const Duration(milliseconds: 1000);
    }
  }

  Color _getEmotionalColor(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return Colors.amber.shade300;
      case EmotionType.sad:
        return Colors.blue.shade300;
      case EmotionType.excited:
        return Colors.pink.shade300;
      case EmotionType.calm:
        return Colors.green.shade300;
      case EmotionType.anxious:
        return Colors.orange.shade300;
      case EmotionType.grateful:
        return Colors.purple.shade300;
      case EmotionType.nostalgic:
        return Colors.indigo.shade300;
      case EmotionType.hopeful:
        return Colors.teal.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  void dispose() {
    try {
      // تنظيف الموارد
      _adaptationService.removeListener(_onPerformanceAdaptation);
      PerformanceMonitor().stopMonitoring();
      _animationResource.cleanup();
      _memoryManager.unregisterResource(_animationResource);

      // تنظيف المراقبين
      WidgetsBinding.instance.removeObserver(this);

      if (kDebugMode) {
        print('🧹 Enhanced Home: Resources cleaned up successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Enhanced Home: Cleanup failed: $e');
      }
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // إيقاف الحركات عند الانتقال للخلفية
        _pauseNonEssentialAnimations();
        break;

      case AppLifecycleState.resumed:
        // استئناف الحركات عند العودة
        if (_adaptationService.config.performanceLevel !=
            PerformanceLevel.low) {
          _resumeAnimations();
        }
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // لا نفعل شيئاً في هذه الحالات
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final widget = Scaffold(
      body: Stack(
        children: [
          // الخلفية المعرفية المتحركة والمتغيرة
          _buildCognitiveBackground(),

          // المحتوى الرئيسي
          SafeArea(
            child: _buildAnimatedContent(),
          ),

          // شريط التنقل السفلي
          _buildBottomNavigationBar(),

          // مؤشر الأداء في وضع التطوير
          if (kDebugMode) _buildPerformanceIndicator(),

          // لوحة التحكم في الأداء (اختياري، تظهر عند النقر على مؤشر الأداء)
          if (_showPerformanceMenu) _buildPerformanceMenuOverlay(),
        ],
      ),
    );

    return widget;
  }

  /// بناء الخلفية المعرفية المحسنة
  Widget _buildCognitiveBackground() {
    final emotionalColor = _getCognitiveEmotionalColor(_currentEmotion);
    final config = _adaptationService.config;

    return Stack(
      children: [
        // خلفية المعرفية الرياضية
        Positioned.fill(
          child: CognitiveBackground(
            emotionalColor: emotionalColor,
            particleCount: config.particleCount,
          ),
        ),
        // طبقة تعتيم إضافية للوضوح
        if (config.useBlur)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),
      ],
    );
  }

  Color _getCognitiveEmotionalColor(EmotionType type) {
    switch (type) {
      case EmotionType.calm:
        return const Color(0xFF4ECDC4);
      case EmotionType.joy:
      case EmotionType.happy:
        return const Color(0xFFFFD93D);
      case EmotionType.nostalgic:
        return const Color(0xFFE4C1B1); // Rose Gold
      default:
        return const Color(0xFF45B7D1);
    }
  }

  /// بناء المحتوى المتحرك
  Widget _buildAnimatedContent() {
    if (_selectedNavIndex != 0) {
      return _buildSelectedScreen();
    }

    if (_animationsPaused) {
      // عرض بسيط بدون حركات معقدة
      return Opacity(
        opacity: _fadeInAnimation.value,
        child: _buildMainContent(),
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _fadeInAnimation,
        _slideAnimation,
        _heartbeatAnimation,
        _breathingAnimation,
      ]),
      builder: (context, child) => Transform.scale(
        scale:
            _adaptationService.config.performanceLevel == PerformanceLevel.high
                ? _breathingAnimation.value
                : 1.0,
        child: Opacity(
          opacity: _fadeInAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: _buildMainContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedScreen() {
    switch (_selectedNavIndex) {
      case 1:
        return LoveMessageScreen(
          onClose: () => setState(() => _selectedNavIndex = 0),
        );
      case 2:
        return const MemoriesListScreen();
      case 3:
        return const SettingsScreen();
      default:
        return _buildMainContent();
    }
  }

  /// مؤشر الأداء للتطوير
  Widget _buildPerformanceIndicator() {
    final isDynamic = _adaptationService.useDynamic;
    final mode = isDynamic ? 'Dynamic' : 'Manual';

    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: () => setState(() {
          _showPerformanceMenu = !_showPerformanceMenu;
        }),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Performance: '
                '${_adaptationService.config.performanceLevel.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Mode: $mode',
                style: TextStyle(
                  color: isDynamic ? Colors.greenAccent : Colors.orangeAccent,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceMenuOverlay() => Positioned.fill(
        child: GestureDetector(
          onTap: () => setState(() => _showPerformanceMenu = false),
          child: Container(
            color: Colors.black54,
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent closing when tapping inside
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'إعدادات الأداء',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildPerfOption('تلقائي (ديناميكي)', null,
                          _adaptationService.useDynamic),
                      _buildPerfOption(
                          'أداء عالي (جرافيك كامل)',
                          PerformanceLevel.high,
                          !_adaptationService.useDynamic &&
                              _adaptationService.overrideLevel ==
                                  PerformanceLevel.high),
                      _buildPerfOption(
                          'متوازن',
                          PerformanceLevel.medium,
                          !_adaptationService.useDynamic &&
                              _adaptationService.overrideLevel ==
                                  PerformanceLevel.medium),
                      _buildPerfOption(
                          'توفير طاقة (تبسيط)',
                          PerformanceLevel.low,
                          !_adaptationService.useDynamic &&
                              _adaptationService.overrideLevel ==
                                  PerformanceLevel.low),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () =>
                            setState(() => _showPerformanceMenu = false),
                        child: const Text('إغلاق',
                            style: TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildPerfOption(
          String title, PerformanceLevel? level, bool selected) =>
      ListTile(
        title: Text(title,
            style: TextStyle(
                color: selected ? Colors.amber : Colors.white, fontSize: 14)),
        trailing: selected
            ? const Icon(Icons.check_circle, color: Colors.amber, size: 20)
            : null,
        onTap: () async {
          await _adaptationService.setOverride(level);
          setState(() {
            _showPerformanceMenu = false;
          });
        },
      );

  Widget _buildMainContent() => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // العنوان الرئيسي
              _buildMainTitle(),

              const SizedBox(height: 30),

              // الرسالة العاطفية
              _buildEmotionalMessage(),

              const SizedBox(height: 40),

              // القلب النابض
              _buildHeartWidget(),

              const SizedBox(height: 40),

              // بطاقات الميزات
              _buildFeatureCards(),

              const SizedBox(height: 30),

              // أزرار التفاعل
              _buildInteractionButtons(),

              const SizedBox(height: 100), // مساحة للشريط السفلي
            ],
          ),
        ),
      );

  Widget _buildMainTitle() => EnhancedParallaxLayer(
        parallaxFactor: 0.3,
        enableScale: true,
        child: Column(
          children: [
            // الشعار المعرفي الرياضي
            const CognitiveLogo(size: 130),
            const SizedBox(height: 20),
            Text(
              'جناح الحنين',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'رفيق الروح في رحلة الحب',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      );

  Widget _buildEmotionalMessage() => EnhancedParallaxLayer(
        parallaxFactor: 0.4,
        child: LightEffectComponent(
          lightColor: _getEmotionalColor(_currentEmotion),
          intensity: 0.5,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              _currentMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      );

  Widget _buildHeartWidget() {
    // تحسين الأداء: استخدام حركة بسيطة في الأداء المنخفض
    if (_adaptationService.config.performanceLevel == PerformanceLevel.low) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _isInteracting = !_isInteracting;
          });
          _triggerHeartInteraction();
        },
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getEmotionalColor(_currentEmotion),
          ),
          child: const Icon(
            Icons.favorite,
            size: 60,
            color: Colors.white,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _heartbeatAnimation,
      builder: (context, child) => Transform.scale(
        scale: _animationsPaused ? 1.0 : _heartbeatAnimation.value,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isInteracting = !_isInteracting;
            });
            _triggerHeartInteraction();
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _getEmotionalColor(_currentEmotion),
                  _getEmotionalColor(_currentEmotion).withValues(alpha: 0.6),
                ],
              ),
              boxShadow: _adaptationService.config.useShadows
                  ? [
                      BoxShadow(
                        color: _getEmotionalColor(_currentEmotion)
                            .withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ]
                  : null,
            ),
            child: const Icon(
              Icons.favorite,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCards() => Column(
        children: [
          _buildFeatureCard(
            icon: Icons.chat_bubble_outline,
            title: 'رسائل الحب',
            subtitle: 'همسات من القلب',
            color: Colors.pink.shade300,
            onTap: () {
              // Navigation simulation with premium feedback
              _triggerHeartInteraction();
            },
          ),
          const SizedBox(height: 15),
          _buildFeatureCard(
            icon: Icons.auto_fix_high,
            title: 'مرآة الروح',
            subtitle: 'تأمل في مشاعرك',
            color: Colors.purple.shade300,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmotionMirrorScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          _buildFeatureCard(
            icon: Icons.science_outlined,
            title: 'مختبر الذكاء المعرفي',
            subtitle: 'تحليل الروابط العميقة',
            color: Colors.teal.shade300,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IntelligenceLabScreen(),
                ),
              );
            },
          ),
        ],
      );

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withValues(alpha: 0.6),
                size: 16,
              ),
            ],
          ),
        ),
      );

  Widget _buildInteractionButtons() => Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          _buildActionButton(
            icon: Icons.auto_awesome,
            label: 'مفاجأة',
            color: Colors.amber.shade300,
            onTap: _triggerSurprise,
          ),
          _buildActionButton(
            icon: Icons.biotech,
            label: 'مختبر الذكاء',
            color: Colors.teal.shade300,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IntelligenceLabScreen(),
                ),
              );
            },
          ),
          _buildActionButton(
            icon: Icons.psychology,
            label: 'تحليل المشاعر',
            color: Colors.blue.shade300,
            onTap: _analyzeEmotions,
          ),
        ],
      );

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: color.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildBottomNavigationBar() => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.home, 'الرئيسية'),
              _buildNavItem(1, Icons.message, 'الرسائل'),
              _buildNavItem(2, Icons.photo, 'الذكريات'),
              _buildNavItem(3, Icons.settings, 'الإعدادات'),
            ],
          ),
        ),
      );

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isActive = _selectedNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color:
                isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color:
                  isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _triggerHeartInteraction() {
    // محاكاة تفاعل القلب
    const emotions = EmotionType.values;
    final randomEmotion = emotions[math.Random().nextInt(emotions.length)];
    _updateEmotionalState(randomEmotion);

    // إظهار رسالة تفاعلية راقية
    final message = _getEmotionalMessage(randomEmotion);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor:
            _getEmotionalColor(randomEmotion).withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _triggerSurprise() {
    // محاكاة تفعيل المفاجأة
    final surpriseMessages = [
      'لديك رسالة حب جديدة!',
      'تم إضافة ذكرى جميلة لألبومك!',
      'مفاجأة! لقد حصلت على هدية رقمية!',
    ];

    final randomMessage =
        surpriseMessages[math.Random().nextInt(surpriseMessages.length)];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مفاجأة! 🎉'),
        content: Text(randomMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('شكراً لك'),
          ),
        ],
      ),
    );
  }

  void _analyzeEmotions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmotionMirrorScreen()),
    );
  }
}
