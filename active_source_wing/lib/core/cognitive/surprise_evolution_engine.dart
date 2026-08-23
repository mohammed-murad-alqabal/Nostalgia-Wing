import 'package:drift/drift.dart';
import '../services/db_service.dart';
import '../services/notification_service.dart';
import '../psychology/emotional_state.dart';
import 'psychological_context_manager.dart';
import '../data/app_database.dart';
import '../di/service_locator.dart';

/// 2.2 The Surprise & Evolution Engine
///
/// Function: Introduces an element of "purposeful chaos" and
/// "quantum mutations" into the relationship, to prevent monotony
/// and continuous growth. Aims to create unexpected moments of joy and
/// appreciation.
class SurpriseEvolutionEngine {
  /// Creates a new instance of [SurpriseEvolutionEngine].
  SurpriseEvolutionEngine({
    required DBService dbService,
    required NotificationService notificationService,
    required PsychologicalContextManager contextManager,
  })  : _dbService = dbService,
        _notificationService = notificationService,
        _contextManager = contextManager;

  final DBService _dbService;
  final NotificationService _notificationService;
  final PsychologicalContextManager _contextManager;

  /// 'Serendipity Cooling' timestamp
  DateTime? _lastSerendipityTime;

  /// Minimum interval between surprises (e.g., 4 hours)
  static const Duration _serendipityCoolingInterval = Duration(hours: 4);

  /// 'Programmed Serendipity Algorithm'
  ///
  /// Generates unexpected but deeply relevant events or messages for the user,
  /// based on analysis of their historical data and interests.
  Future<String> programmedSerendipityAlgorithm() async {
    // Implement Serendipity Cooling
    if (_lastSerendipityTime != null &&
        DateTime.now().difference(_lastSerendipityTime!) <
            _serendipityCoolingInterval) {
      return 'نطاق التشبع بالمفاجآت مكتمل حالياً. '
          'الفوضى الهادفة تتطلب صمتاً أحياناً.';
    }

    _lastSerendipityTime = DateTime.now();

    final List<Memory> memories = await _dbService.getMemories();

    String surpriseMessage;
    if (memories.isNotEmpty) {
      final Memory randomMemory =
          memories[DateTime.now().second % memories.length];
      surpriseMessage = 'أتذكر ${randomMemory.title}؟ كانت لحظة رائعة!\n'
          'تذكرت هذه اللحظة الجميلة وأردت أن أشاركها معكِ.';
    } else {
      surpriseMessage = 'لدي شعور بأن يومكِ سيكون مليئًا بالبهجة اليوم!';
    }

    _notificationService.showNotification(
      title: 'مفاجأة من جناح الحنين!',
      body: surpriseMessage,
      payload: 'surprise_message',
    );

    // Persist surprise securely
    await _persistSurprise(surpriseMessage, 'serendipity');

    return surpriseMessage;
  }

  /// 'Spiral Growth Algorithm'
  Future<String> spiralGrowthAlgorithm() async {
    final double density = _contextManager.getEmotionalDensity();

    final List<String> growthSuggestions = [
      'ما رأيكِ أن نتحدث اليوم عن أحلامنا المستقبلية المشتركة؟',
      'دعنا نكتشف هواية جديدة معًا هذا الأسبوع.',
      'هل فكرتِ يومًا في كتابة رسالة حب طويلة لبعضنا البعض؟',
      'لنجرب شيئًا جديدًا ومثيرًا اليوم!',
    ];

    String suggestion;
    if (density < 0.4) {
      suggestion = 'دعنا نركز اليوم على قضاء وقت هادئ ومريح معاً.';
    } else {
      suggestion =
          growthSuggestions[DateTime.now().second % growthSuggestions.length];
    }

    _notificationService.showNotification(
      title: 'فرصة للنمو معًا',
      body: suggestion,
      payload: 'growth_suggestion',
    );

    await _persistSurprise(suggestion, 'growth');

    return suggestion;
  }

  /// 'Micro-Transformation Algorithm'
  Future<String> microTransformationAlgorithm() async {
    final EmotionType dominant = _contextManager.getDominantEmotion();

    final List<String> microTransformations = [
      'تذكري أن تبتسمي اليوم، فابتسامتكِ تضيء العالم.',
      'خصصي بضع دقائق للتأمل في جمال يومكِ.',
      'عبري عن امتنانكِ لشخص ما اليوم.',
      'قومي بعمل لطيف وعشوائي لشخص لا تتوقعينه.',
    ];

    String transformation;
    if (dominant == EmotionType.anxious) {
      transformation = 'خذي نفساً عميقاً الآن، كل شيء سيكون بخير.';
    } else {
      transformation = microTransformations[
          DateTime.now().second % microTransformations.length];
    }

    _notificationService.showNotification(
      title: 'تحول صغير، تأثير كبير',
      body: transformation,
      payload: 'micro_transformation',
    );

    await _persistSurprise(transformation, 'transformation');

    return transformation;
  }

  Future<void> _persistSurprise(String content, String type) async {
    final encrypted = await sl.encryptionService.encrypt(content);
    await _dbService.insertSurprise(SurprisesCompanion.insert(
      type: type,
      encryptedContent: encrypted,
      status: const Value('pending'),
      createdAt: Value(DateTime.now()),
    ));
  }
}
