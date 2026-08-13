import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/performance/performance_monitor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('memory cleanup never requests the platform to close the application',
      () async {
    final platformCalls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      platformCalls.add(call);
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final monitor = PerformanceMonitor();
    for (var index = 0; index < 55; index++) {
      final name = 'cleanup-metric-$index';
      monitor.startTimer(name);
      monitor.stopTimer(name);
    }

    monitor.triggerMemoryCleanupForTesting();

    expect(monitor.retainedMetricsCount, lessThanOrEqualTo(50));
    expect(
      platformCalls.where((call) => call.method == 'SystemNavigator.pop'),
      isEmpty,
    );
  });
}
