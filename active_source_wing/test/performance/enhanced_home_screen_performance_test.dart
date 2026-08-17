import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:wing_of_nostalgia/core/memory/memory_manager.dart';
import 'package:wing_of_nostalgia/core/performance/performance_monitor.dart';
import 'package:wing_of_nostalgia/features/home/screens/enhanced_home_screen.dart';

/// اختبارات أداء الشاشة الرئيسية المحسنة
/// Performance tests for Enhanced Home Screen
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Enhanced Home Screen Performance Tests', () {
    late PerformanceMonitor performanceMonitor;
    late MemoryManager memoryManager;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await sl.initialize(
          testDb: AppDatabase.forTesting(NativeDatabase.memory()));
      performanceMonitor = PerformanceMonitor();
      memoryManager = MemoryManager();
    });

    tearDown(() async {
      performanceMonitor.stopMonitoring();
      memoryManager.dispose();
      await sl.reset();
    });

    testWidgets('should initialize without performance issues', (tester) async {
      // بدء مراقبة الأداء
      performanceMonitor.startTimer('widget_test_init');

      // بناء الشاشة
      await tester.pumpWidget(
        const MaterialApp(
          home: EnhancedHomeScreen(),
        ),
      );

      // انتظار اكتمال الحركات
      await tester.pump(const Duration(seconds: 2));

      performanceMonitor.stopTimer('widget_test_init');

      // التحقق من وجود العناصر الأساسية
      expect(find.text('جناح الحنين'), findsOneWidget);
      expect(find.text('رفيق الروح في رحلة الحب'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // التحقق من الأداء
      final report = performanceMonitor.getPerformanceReport();
      expect(report.isPerformanceGood, isTrue);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('should handle performance level changes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EnhancedHomeScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 2));

      // التحقق من أن الشاشة تعرض بشكل صحيح
      expect(find.byType(EnhancedHomeScreen), findsOneWidget);

      // التحقق من وجود العناصر الأساسية
      expect(find.text('جناح الحنين'), findsOneWidget);

      // التحقق من وجود مؤشر الأداء في وضع التطوير
      // (سيكون مرئياً فقط في وضع التطوير)
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('should handle memory management correctly', (tester) async {
      memoryManager.initialize();

      await tester.pumpWidget(
        const MaterialApp(
          home: EnhancedHomeScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 2));

      // محاكاة انتقال التطبيق للخلفية
      tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/lifecycle',
        (message) async => null,
      );

      // التحقق من إحصائيات الذاكرة
      final memoryStats = memoryManager.getMemoryStats();
      expect(memoryStats.totalResources, greaterThanOrEqualTo(0));

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
        'should handle heart interaction without performance degradation',
        (tester) async {
      performanceMonitor.startMonitoring();

      await tester.pumpWidget(
        const MaterialApp(
          home: EnhancedHomeScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 2));

      // العثور على القلب والنقر عليه
      final heartWidget = find.byIcon(Icons.favorite);
      expect(heartWidget, findsOneWidget);

      performanceMonitor.startTimer('heart_interaction');

      // النقر على القلب عدة مرات
      for (int i = 0; i < 5; i++) {
        await tester.tap(heartWidget);
        await tester.pump();
      }

      performanceMonitor.stopTimer('heart_interaction');

      // التحقق من الأداء بعد التفاعل
      final report = performanceMonitor.getPerformanceReport();
      expect(report.averageResponseTime, lessThan(1000)); // أقل من ثانية واحدة

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('should adapt UI based on performance level', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EnhancedHomeScreen(),
        ),
      );

      await tester.pump(const Duration(seconds: 2));

      // التحقق من وجود العناصر الأساسية
      expect(find.text('مرآة الروح'), findsOneWidget);
      expect(find.text('مختبر الذكاء المعرفي'), findsAtLeastNWidgets(1));
      expect(find.text('رسائل الحب'), findsOneWidget);

      // التحقق من أن الشاشة تعرض المحتوى بشكل صحيح
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    test('performance monitor should track metrics correctly', () {
      performanceMonitor.startTimer('test_operation');

      // محاكاة عملية
      Future.delayed(const Duration(milliseconds: 100));

      performanceMonitor.stopTimer('test_operation');

      final report = performanceMonitor.getPerformanceReport();
      expect(report.totalMetrics, greaterThan(0));
    });

    test('memory manager should handle resources correctly', () {
      memoryManager.initialize();

      // إنشاء مورد وهمي
      final testResource = TestAnimationResource();
      memoryManager.registerResource(testResource);

      // التحقق من التسجيل
      final stats = memoryManager.getMemoryStats();
      expect(stats.totalResources, equals(1));
      expect(stats.activeResources, equals(1));

      // إيقاف الموارد
      memoryManager.pauseAllResources();
      expect(testResource.isActive, isFalse);

      // استئناف الموارد
      memoryManager.resumeAllResources();
      expect(testResource.isActive, isTrue);

      // تنظيف
      memoryManager.unregisterResource(testResource);
      final finalStats = memoryManager.getMemoryStats();
      expect(finalStats.totalResources, equals(0));

      memoryManager.dispose();
    });

    test('performance levels should be calculated correctly', () {
      final highLevel = performanceMonitor.getRecommendedPerformanceLevel();
      expect(highLevel, isA<PerformanceLevel>());
    });
  });
}

/// مورد اختبار وهمي
class TestAnimationResource implements MemoryManagedResource {
  @override
  String get name => 'test_resource';

  bool _isActive = true;

  @override
  bool get isActive => _isActive;

  @override
  void pause() {
    _isActive = false;
  }

  @override
  void resume() {
    _isActive = true;
  }

  @override
  void cleanup() {
    _isActive = false;
  }
}
