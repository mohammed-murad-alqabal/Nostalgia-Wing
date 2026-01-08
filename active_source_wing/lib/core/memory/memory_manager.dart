import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// نظام إدارة الذاكرة - Memory Management System
/// يدير استخدام الذاكرة ويمنع التسريبات
class MemoryManager with WidgetsBindingObserver {
  /// Factory constructor to return the singleton instance.
  factory MemoryManager() => _instance;
  MemoryManager._internal();
  static final MemoryManager _instance = MemoryManager._internal();

  final List<MemoryManagedResource> _resources = [];
  final Map<String, Timer> _cleanupTimers = {};

  bool _isInitialized = false;
  bool _isAppInBackground = false;

  /// تهيئة مدير الذاكرة
  void initialize() {
    if (_isInitialized) return;

    WidgetsBinding.instance.addObserver(this);
    _isInitialized = true;

    if (kDebugMode) {
      print('🧠 Memory Manager: Initialized');
    }
  }

  /// تنظيف مدير الذاكرة
  void dispose() {
    if (!_isInitialized) return;

    WidgetsBinding.instance.removeObserver(this);
    _cleanupAllResources();
    _cancelAllTimers();
    _isInitialized = false;

    if (kDebugMode) {
      print('🧠 Memory Manager: Disposed');
    }
  }

  /// تسجيل مورد للإدارة
  void registerResource(MemoryManagedResource resource) {
    _resources.add(resource);

    if (kDebugMode) {
      print('🧠 Memory Manager: Registered ${resource.name}');
    }
  }

  /// إلغاء تسجيل مورد
  void unregisterResource(MemoryManagedResource resource) {
    _resources.remove(resource);

    if (kDebugMode) {
      print('🧠 Memory Manager: Unregistered ${resource.name}');
    }
  }

  /// إيقاف جميع الموارد مؤقتاً
  void pauseAllResources() {
    for (final resource in _resources) {
      try {
        resource.pause();
      } catch (e) {
        if (kDebugMode) {
          print('🧠 Memory Manager: Failed to pause ${resource.name}: $e');
        }
      }
    }

    if (kDebugMode) {
      print('🧠 Memory Manager: Paused ${_resources.length} resources');
    }
  }

  /// استئناف جميع الموارد
  void resumeAllResources() {
    for (final resource in _resources) {
      try {
        resource.resume();
      } catch (e) {
        if (kDebugMode) {
          print('🧠 Memory Manager: Failed to resume ${resource.name}: $e');
        }
      }
    }

    if (kDebugMode) {
      print('🧠 Memory Manager: Resumed ${_resources.length} resources');
    }
  }

  /// تنظيف جميع الموارد
  void _cleanupAllResources() {
    for (final resource in _resources) {
      try {
        resource.cleanup();
      } catch (e) {
        if (kDebugMode) {
          print('🧠 Memory Manager: Failed to cleanup ${resource.name}: $e');
        }
      }
    }
    _resources.clear();
  }

  /// إلغاء جميع المؤقتات
  void _cancelAllTimers() {
    for (final timer in _cleanupTimers.values) {
      timer.cancel();
    }
    _cleanupTimers.clear();
  }

  /// جدولة تنظيف مؤجل
  void scheduleCleanup(String name, Duration delay, VoidCallback cleanup) {
    // إلغاء المؤقت السابق إن وجد
    _cleanupTimers[name]?.cancel();

    _cleanupTimers[name] = Timer(delay, () {
      cleanup();
      _cleanupTimers.remove(name);
    });
  }

  /// تشغيل تنظيف فوري للذاكرة
  void triggerImmediateCleanup() {
    if (kDebugMode) {
      print('🧠 Memory Manager: Triggering immediate cleanup');
    }

    // تنظيف الموارد غير المستخدمة
    final unusedResources = _resources.where((r) => !r.isActive).toList();
    for (final resource in unusedResources) {
      resource.cleanup();
      _resources.remove(resource);
    }

    // تشغيل garbage collection
    _forceGarbageCollection();
  }

  /// إجبار تشغيل garbage collection
  void _forceGarbageCollection() {
    // في Flutter، لا يمكننا إجبار GC مباشرة
    // لكن يمكننا تقليل الضغط على الذاكرة
    if (kDebugMode) {
      print('🧠 Memory Manager: Requesting garbage collection');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _isAppInBackground = true;
        pauseAllResources();

        // جدولة تنظيف بعد 30 ثانية في الخلفية
        scheduleCleanup('background_cleanup', const Duration(seconds: 30), () {
          if (_isAppInBackground) {
            triggerImmediateCleanup();
          }
        });
        break;

      case AppLifecycleState.resumed:
        _isAppInBackground = false;
        resumeAllResources();

        // إلغاء تنظيف الخلفية
        _cleanupTimers['background_cleanup']?.cancel();
        _cleanupTimers.remove('background_cleanup');
        break;

      case AppLifecycleState.inactive:
        // لا نفعل شيئاً في الحالة غير النشطة
        break;

      case AppLifecycleState.hidden:
        // حالة جديدة في Flutter 3.13+
        _isAppInBackground = true;
        pauseAllResources();
        break;
    }
  }

  /// الحصول على إحصائيات الذاكرة
  MemoryStats getMemoryStats() {
    final activeResources = _resources.where((r) => r.isActive).length;
    final pausedResources = _resources.where((r) => !r.isActive).length;

    return MemoryStats(
      totalResources: _resources.length,
      activeResources: activeResources,
      pausedResources: pausedResources,
      scheduledCleanups: _cleanupTimers.length,
      isAppInBackground: _isAppInBackground,
    );
  }
}

/// مورد مُدار بالذاكرة
abstract class MemoryManagedResource {
  /// The unique name of the resource.
  String get name;

  /// Whether the resource is currently active.
  bool get isActive;

  /// Pauses the resource.
  void pause();

  /// Resumes the resource.
  void resume();

  /// Cleans up the resource entirely.
  void cleanup();
}

/// إحصائيات الذاكرة
class MemoryStats {
  /// Creates a [MemoryStats] instance.
  const MemoryStats({
    required this.totalResources,
    required this.activeResources,
    required this.pausedResources,
    required this.scheduledCleanups,
    required this.isAppInBackground,
  });

  /// Total number of tracked resources.
  final int totalResources;

  /// Number of currently active resources.
  final int activeResources;

  /// Number of currently paused resources.
  final int pausedResources;

  /// Number of pending cleanup operations.
  final int scheduledCleanups;

  /// Whether the app is currently in the background.
  final bool isAppInBackground;
}

/// مورد حركة مُدار
class AnimationResource implements MemoryManagedResource {
  /// Creates an [AnimationResource] for tracking controllers.
  AnimationResource({
    required this.name,
    required this.controllers,
  });

  @override
  final String name;

  /// The list of controllers being managed.
  final List<AnimationController> controllers;
  bool _isActive = true;

  @override
  bool get isActive => _isActive;

  @override
  void pause() {
    for (final controller in controllers) {
      if (controller.isAnimating) {
        controller.stop();
      }
    }
    _isActive = false;
  }

  @override
  void resume() {
    for (final controller in controllers) {
      if (!controller.isAnimating) {
        controller.repeat();
      }
    }
    _isActive = true;
  }

  @override
  void cleanup() {
    for (final controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
    _isActive = false;
  }
}
