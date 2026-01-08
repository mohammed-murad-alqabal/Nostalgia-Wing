import '../services/notification_service.dart';
import 'psychological_context_manager.dart';

/// A module responsible for suggesting activities or content that synchronizes
/// with the user's unconscious thoughts or feelings, creating a sense of
/// deep connection and destiny.
///
/// 3.2 The Cosmic Synchronization Module
class CosmicSynchronizationModule {
  /// Creates a new instance of [CosmicSynchronizationModule].
  CosmicSynchronizationModule({
    required NotificationService notificationService,
    required PsychologicalContextManager contextManager,
  })  : _notificationService = notificationService,
        _contextManager = contextManager;

  final NotificationService _notificationService;
  final PsychologicalContextManager _contextManager;

  /// 'Deep Intuition Sensor'
  ///
  /// Uses advanced analysis to predict unconscious needs based on user
  /// behavior patterns.
  Future<String> deepIntuitionSensor(String userBehaviorPatterns) async {
    // Influence prediction based on emotional density
    final double density = _contextManager.getEmotionalDensity();

    if (userBehaviorPatterns.contains('late_night_browsing_old_photos')) {
      return 'يبدو أن هناك رغبة لاواعية في استعادة الذكريات الجميلة. '
          'كثافة الوجود العاطفي حالياً: $density. سأقوم بتنشيط همسة حنين.';
    } else if (userBehaviorPatterns.contains('frequent_searches_for_comfort')) {
      return 'أشعر بحاجة لاواعية للراحة والأمان. سأقترح محتوى يعزز هذا الشعور. '
          'المستوى الحالي للجاذبية: $density.';
    } else {
      return 'لا توجد أنماط لاواعية واضحة حاليًا.';
    }
  }

  /// 'Meaningful Coincidence Generator'
  ///
  /// Suggests content or interactions that seem like a "coincidence" but are
  /// actually designed to meet an unconscious need.
  Future<String> meaningfulCoincidenceGenerator(String unconsciousNeed) async {
    String coincidenceMessage;
    if (unconsciousNeed.contains('استعادة الذكريات')) {
      coincidenceMessage =
          'بالمناسبة، تذكرت للتو تلك الأغنية التي أحببتها كثيرًا. '
          'أردت أن أشاركها معكِ.';
    } else if (unconsciousNeed.contains('الراحة والأمان')) {
      coincidenceMessage =
          'شعرت برغبة في إرسال هذه الرسالة لكِ الآن: أنتِ ملاذي الآمن.';
    } else {
      coincidenceMessage =
          'مجرد فكرة عابرة: أتمنى لكِ يومًا مليئًا باللحظات السعيدة.';
    }

    _notificationService.showNotification(
      title: 'مصادفة جميلة!',
      body: coincidenceMessage,
      payload: 'meaningful_coincidence',
    );
    return coincidenceMessage;
  }
}
