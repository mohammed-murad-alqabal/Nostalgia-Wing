import 'package:flutter/services.dart';
import '../infrastructure/wing_logger.dart';

/// خدمة التغذية الحسية
/// Sensory Feedback Service
/// Unifies Haptics and Audio for a resonant UX.
class SensoryFeedbackService {
  SensoryFeedbackService._();

  /// إرسال نبضة نجاح - حسية وصوتية
  /// Success Pulse: Subtle haptic and optional success chime.
  static Future<void> successPulse() async {
    await HapticFeedback.mediumImpact();
    // We could add a specific chime here if we had one in assets
    WingLogger.info('Sensory: Success pulse delivered', tag: 'Sensory');
  }

  /// إرسال نبضة خطأ - حسية قوية
  /// Error Pulse: Heavy haptic feedback.
  static Future<void> errorPulse() async {
    await HapticFeedback.heavyImpact();
    WingLogger.warning('Sensory: Error pulse delivered', tag: 'Sensory');
  }

  /// رنين عاطفي - تكرار خفيف للاهتزاز مع صوت
  /// Resonant Echo: Light haptic sequences.
  static Future<void> resonantEcho() async {
    await HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// تفاعل الضغط - اهتزاز خفيف جداً
  /// Subtle Tap: Selection click haptic.
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }
}
