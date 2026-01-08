// ignore_for_file: avoid_print
import 'dart:io';

/// Institutional Task Discovery Engine
/// Scans the project for TODOs, FIXMEs, and custom Institutional markers.
void main() {
  final directory = Directory('lib');
  print('🚀 Scanning for Institutional Tasks...');

  int taskCount = 0;

  directory.listSync(recursive: true).forEach((file) {
    if (file is File && file.path.endsWith('.dart')) {
      final lines = file.readAsLinesSync();
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.contains('TODO') ||
            line.contains('FIXME') ||
            line.contains('// institutional-task')) {
          print('[${file.path}:${i + 1}] ${line.trim()}');
          taskCount++;
        }
      }
    }
  });

  print('\n✅ Found $taskCount tasks. Stay Institutional.');
}
