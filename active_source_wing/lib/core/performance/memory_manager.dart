import 'dart:developer' as developer;
import 'package:flutter/widgets.dart';

/// Wing of Nostalgia: Memory Manager
/// Manages the lifecycle of memory-intensive resources.
/// Hooks into WidgetsBinding to respond to system memory pressure
/// and application lifecycle changes.
class MemoryManager with WidgetsBindingObserver {
  /// Factory constructor to return the singleton instance.
  factory MemoryManager() => _instance;

  /// Internal constructor.
  MemoryManager._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  static final MemoryManager _instance = MemoryManager._internal();

  final Set<MemoryManagedResource> _resources = {};

  /// Registers a resource to be managed.
  void registerResource(MemoryManagedResource resource) {
    _resources.add(resource);
    developer.log('Resource registered: ${resource.runtimeType}',
        name: 'MemoryManager');
  }

  /// Unregisters a resource.
  void unregisterResource(MemoryManagedResource resource) {
    _resources.remove(resource);
    developer.log('Resource unregistered: ${resource.runtimeType}',
        name: 'MemoryManager');
  }

  @override
  void didHaveMemoryPressure() {
    developer.log('System Memory Pressure Detected!',
        name: 'MemoryManager', level: 1000);
    _performEmergencyCleanup();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    developer.log('App Lifecycle State Changed: $state', name: 'MemoryManager');
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _onAppBackgrounded();
    } else if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  void _performEmergencyCleanup() {
    for (var resource in _resources) {
      resource.onMemoryPressure();
    }
  }

  void _onAppBackgrounded() {
    for (var resource in _resources) {
      resource.onBackground();
    }
  }

  void _onAppResumed() {
    for (var resource in _resources) {
      resource.onForeground();
    }
  }

  /// Disposes the manager and its observer.
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _resources.clear();
  }
}

/// Interface for resources that want to be managed by [MemoryManager].
abstract class MemoryManagedResource {
  /// Called when the system is low on memory.
  void onMemoryPressure();

  /// Called when the app goes to the background.
  void onBackground();

  /// Called when the app returns to the foreground.
  void onForeground();

  /// Called to explicitly free memory.
  void dispose();
}
