import 'package:drift/drift.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../cognitive/relational_analytics_service.dart';
import '../cognitive/resonance_engine.dart';
import '../cognitive/psychological_context_manager.dart';
import '../models/message_template.dart';
import '../data/app_database.dart';
import '../services/db_service.dart';
import '../di/service_locator.dart';

/// Service for generating emotional messages and responses.
class EmotionalMessageService {
  /// Creates [EmotionalMessageService] and initializes [FlutterTts].
  EmotionalMessageService({
    required this.analyticsService,
    required this.resonanceEngine,
    required this.contextManager,
    required this.dbService,
  }) : flutterTts = FlutterTts();

  /// Text-to-speech instance.
  final FlutterTts flutterTts;

  /// Analytical service for relational health.
  final RelationalAnalyticsService analyticsService;

  /// Engine for message resonance selection.
  final ResonanceEngine resonanceEngine;

  /// Manager for psychological state.
  final PsychologicalContextManager contextManager;

  /// Database service for persistence.
  final DBService dbService;

  /// Versioned encryption facade for message payloads.

  /// Saves a sent message to encrypted history.
  Future<void> saveSentMessage({
    required String content,
    required String type,
    String? recipientId,
  }) async {
    final encryptedContent = await sl.encryptionService.encrypt(content);

    await dbService.insertSentMessage(SentMessagesCompanion.insert(
      encryptedContent: encryptedContent,
      type: type,
      recipientId: Value(recipientId),
      sentAt: Value(DateTime.now()),
    ));
  }

  /// Retrieves decrypted message history.
  Future<List<Map<String, dynamic>>> getDecryptedHistory() async {
    final history = await dbService.getSentMessages();
    final decryptedList = <Map<String, dynamic>>[];

    for (final entry in history) {
      try {
        final decryptedContent =
            await sl.encryptionService.decrypt(entry.encryptedContent);
        decryptedList.add({
          'id': entry.id,
          'content': decryptedContent,
          'type': entry.type,
          'sentAt': entry.sentAt,
        });
      } catch (e) {
        // Skip entries that can't be decrypted
      }
    }
    return decryptedList;
  }

  /// Generates a response based on user text and sentiment.
  Future<String> generateEmotionalResponse(
      String userText, String sentiment) async {
    // This is a placeholder for a more sophisticated response generation.
    String response;
    if (sentiment == 'positive') {
      response = 'يسعدني أن أرى سعادتك! كلماتك تملأني بهجة.';
    } else if (sentiment == 'negative') {
      response = 'أنا هنا لأستمع إليكِ. لا تقلقي، كل شيء سيكون بخير.';
    } else {
      response = 'أتفهم ما تشعرين به.';
    }
    return response;
  }

  /// Speaks the given text using TTS.
  Future<void> speak(String text) async {
    final report = await analyticsService
        .analyzeRelationalHealth(contextManager.interactions);
    final pitch = resonanceEngine.calculateOptimalPitch(report.stability);

    await flutterTts.setLanguage('ar-SA');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(pitch);
    await flutterTts.speak(text);
  }

  /// Gets a message template suggested for the current context.
  Future<MessageTemplate?> getSuggestedResonantMessage() async {
    final interactions = contextManager.interactions;
    final report = await analyticsService.analyzeRelationalHealth(interactions);
    final currentEmotion = contextManager.getDominantEmotion();
    final currentDensity = contextManager.getEmotionalDensity();

    final templates = await getAllMessageTemplates();

    return resonanceEngine.findBestResonantTemplate(
      templates: templates,
      currentEmotion: currentEmotion,
      relationalReport: report,
      currentDensity: currentDensity,
    );
  }

  /// Gets all available message templates.
  Future<List<MessageTemplate>> getAllMessageTemplates() async => [
        MessageTemplate(
          id: 'morning_1',
          type: 'morning',
          content:
              'صباح الخير يا أجمل ما في حياتي ❤️ أتمنى أن يكون يومك مليئاً '
              'بالسعاة والحب، تماماً كما تملئين قلبي بالفرح كل يوم.',
          intensity: 0.8,
          tags: ['صباح', 'حب'],
          optimalStability: 0.9,
        ),
        MessageTemplate(
          id: 'evening_1',
          type: 'evening',
          content: 'مساء الخير حبيبتي 🌙 بعد يوم طويل، أنت كل ما أحتاجه لأشعر '
              'بالسكينة والراحة. أحبك أكثر من كل النجوم في السماء.',
          intensity: 0.7,
          tags: ['مساء', 'هدوء'],
          optimalStability: 0.8,
        ),
        MessageTemplate(
          id: 'longing_1',
          type: 'longing',
          content: 'أشتاق إليك حتى لو كنت بجانبي. أشتاق لضحكتك، لصوتك، لنظرة '
              'عينيك. أنت روحي التي تسكن في جسد آخر 💖',
          intensity: 0.9,
          tags: ['شوق', 'حب'],
          optimalStability: 1.0,
        ),
        MessageTemplate(
          id: 'gratitude_1',
          type: 'gratitude',
          content: 'شكراً لك على كل شيء تفعلينه من أجلي، على صبرك، على حبك، '
              'على وجودك في حياتي. أنت نعمة من الله لا أستحقها ✨',
          intensity: 0.6,
          tags: ['شكر', 'امتنان'],
          optimalStability: 0.7,
        ),
        MessageTemplate(
          id: 'support_1',
          type: 'support',
          content:
              'أنا هنا لأجلك دائمًا. في حزنك قبل فرحك، وفي تعبك قبل راحتك. '
              'يا رفيقة دربي، أنتِ لستِ وحدكِ أبداً.',
          intensity: 0.9,
          tags: ['دعم', 'وفاء'],
          resonanceThreshold: 0.3,
        ),
      ];
}
