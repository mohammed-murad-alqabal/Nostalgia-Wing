/// محرك التحليل النفسي المتقدم - قلب النظام الذكي
/// يحلل الحالة النفسية والعاطفية للمستخدم ويقدم توصيات مخصصة
// ignore_for_file: unused_field
library;

import 'package:flutter/material.dart';
import '../infrastructure/wing_logger.dart';
import 'emotional_state.dart';
import '../models/interaction_models.dart';

/// محرك التحليل النفسي المتقدم
class PsychologicalAnalysisEngine {
  /// أوزان المشاعر المختلفة
  static const Map<EmotionType, double> _emotionalWeights = {
    EmotionType.joy: 1.0,
    EmotionType.calm: 0.9,
    EmotionType.grateful: 0.8,
    EmotionType.nostalgic: 0.7,
    EmotionType.neutral: 0.5,
    EmotionType.sad: 0.3,
    EmotionType.anxious: -0.5,
  };

  /// أوزان أنواع التفاعل
  static const Map<InteractionType, double> _interactionWeights = {
    InteractionType.reflection: 1.0,
    InteractionType.memoryCreation: 0.9,
    InteractionType.verseReading: 0.8,
    InteractionType.gratitudeWriting: 0.8,
    InteractionType.contentView: 0.6,
    InteractionType.browsing: 0.3,
  };

  /// تحليل الحالة النفسية الحالية للمستخدم
  Future<EmotionalState> analyzeUserState({
    required List<UserInteraction> recentInteractions,
    required TimeOfDay currentTime,
    required List<String> recentContent,
  }) async {
    WingLogger.info(
      'Starting psychological analysis',
      tag: 'PsychAnalysis',
      data: {
        'interactions_count': recentInteractions.length,
        'current_time': currentTime.toString(),
        'content_items': recentContent.length,
      },
    );

    try {
      // تحليل أنماط التفاعل
      final interactionPattern = _analyzeInteractionPattern(recentInteractions);

      // تحليل التوقيت والسياق الزمني
      final temporalContext = _analyzeTemporalContext(currentTime);

      // تحليل المحتوى المتفاعل معه
      final contentSentiment = await _analyzeContentSentiment(recentContent);

      // حساب المشاعر المهيمنة
      final dominantEmotion = _calculateDominantEmotion(
        interactionPattern,
        temporalContext,
        contentSentiment,
      );

      // حساب شدة المشاعر
      final intensity = _calculateIntensity(interactionPattern);

      // حساب الاستقرار العاطفي
      final stability = _calculateStability(recentInteractions);

      // توليد التوصيات
      final recommendations = _generateRecommendations(
        dominantEmotion,
        intensity,
        stability,
        interactionPattern,
        contentSentiment,
      );

      final result = EmotionalState(
        dominantEmotion: dominantEmotion,
        intensity: intensity,
        stability: stability,
        recommendations: recommendations,
      );

      WingLogger.info(
        'Psychological analysis completed',
        tag: 'PsychAnalysis',
        data: {
          'dominant_emotion': dominantEmotion.toString(),
          'intensity': intensity,
          'stability': stability,
          'recommendations_count': recommendations.length,
        },
      );

      return result;
    } catch (e, stackTrace) {
      WingLogger.error(
        'Error in psychological analysis',
        tag: 'PsychAnalysis',
        data: {'error': e.toString()},
        stackTrace: stackTrace,
      );

      // إرجاع حالة افتراضية آمنة
      return const EmotionalState(
        dominantEmotion: EmotionType.neutral,
        intensity: 0.5,
        stability: 0.5,
        recommendations: ['take_break', 'gentle_content'],
      );
    }
  }

  /// تحليل نمط التفاعل
  InteractionPattern _analyzeInteractionPattern(
      List<UserInteraction> interactions) {
    if (interactions.isEmpty) {
      return const InteractionPattern(
        averageDuration: Duration(),
        frequency: 0.0,
        preferredContentTypes: [],
      );
    }

    // حساب متوسط المدة
    final totalDuration = interactions
        .map((i) => i.duration.inMilliseconds)
        .reduce((a, b) => a + b);
    final avgDuration = Duration(
      milliseconds: (totalDuration / interactions.length).round(),
    );

    // حساب التكرار (تفاعلات في 24 ساعة)
    final now = DateTime.now();
    final last24Hours = interactions
        .where((i) => now.difference(i.timestamp).inHours <= 24)
        .length;
    final frequency = last24Hours.toDouble();

    // استخراج أنواع المحتوى المفضلة
    final contentTypeCount = <String, int>{};
    for (final interaction in interactions) {
      contentTypeCount[interaction.contentType] =
          (contentTypeCount[interaction.contentType] ?? 0) + 1;
    }

    final preferredContentTypes = contentTypeCount.entries
        .where((entry) => entry.value >= 2) // ظهر مرتين على الأقل
        .map((entry) => entry.key)
        .toList()
      ..sort((a, b) => contentTypeCount[b]!.compareTo(contentTypeCount[a]!));

    return InteractionPattern(
      averageDuration: avgDuration,
      frequency: frequency,
      preferredContentTypes: preferredContentTypes,
    );
  }

  /// تحليل السياق الزمني
  TemporalContext _analyzeTemporalContext(TimeOfDay currentTime) {
    final hour = currentTime.hour;

    // تحديد فترة اليوم
    DayPeriod period;
    if (hour >= 5 && hour < 12) {
      period = DayPeriod.morning;
    } else if (hour >= 12 && hour < 17) {
      period = DayPeriod.afternoon;
    } else if (hour >= 17 && hour < 21) {
      period = DayPeriod.evening;
    } else {
      period = DayPeriod.night;
    }

    // تحديد مستوى الطاقة المتوقع
    double energyLevel;
    switch (period) {
      case DayPeriod.morning:
        energyLevel = 0.8;
        break;
      case DayPeriod.afternoon:
        energyLevel = 0.9;
        break;
      case DayPeriod.evening:
        energyLevel = 0.6;
        break;
      case DayPeriod.night:
        energyLevel = 0.3;
        break;
    }

    return TemporalContext(
      period: period,
      energyLevel: energyLevel,
      isRestTime: period == DayPeriod.night,
    );
  }

  /// تحليل مشاعر المحتوى
  Future<ContentSentiment> _analyzeContentSentiment(
      List<String> content) async {
    if (content.isEmpty) {
      return const ContentSentiment(
        overallSentiment: 0.5,
        dominantThemes: [],
        emotionalTone: EmotionType.neutral,
      );
    }

    // تحليل مبسط للمحتوى العربي
    double positiveScore = 0.0;
    double negativeScore = 0.0;
    final themes = <String>[];

    // كلمات إيجابية شائعة
    const positiveWords = [
      'حب',
      'سعادة',
      'فرح',
      'امتنان',
      'شكر',
      'بركة',
      'خير',
      'جميل',
      'رائع',
      'ممتاز',
      'حلو',
      'لطيف',
      'مبارك'
    ];

    // كلمات سلبية شائعة
    const negativeWords = ['حزن', 'ألم', 'صعب', 'متعب', 'قلق', 'خوف', 'مشكلة'];

    // كلمات الحنين والشوق
    const nostalgicWords = [
      'ذكرى',
      'حنين',
      'شوق',
      'ماضي',
      'أيام',
      'زمان',
      'كان'
    ];

    for (final text in content) {
      final words = text.split(' ');

      for (final word in words) {
        if (positiveWords.contains(word)) {
          positiveScore += 1.0;
        } else if (negativeWords.contains(word)) {
          negativeScore += 1.0;
        } else if (nostalgicWords.contains(word)) {
          themes.add('nostalgic');
        }
      }
    }

    // حساب المشاعر الإجمالية
    final totalWords = positiveScore + negativeScore;
    final overallSentiment =
        totalWords > 0 ? (positiveScore / totalWords) : 0.5;

    // تحديد النبرة العاطفية المهيمنة
    EmotionType emotionalTone;
    if (themes.contains('nostalgic')) {
      emotionalTone = EmotionType.nostalgic;
    } else if (overallSentiment > 0.7) {
      emotionalTone = EmotionType.joy;
    } else if (overallSentiment > 0.5) {
      emotionalTone = EmotionType.calm;
    } else if (overallSentiment < 0.3) {
      emotionalTone = EmotionType.sad;
    } else {
      emotionalTone = EmotionType.neutral;
    }

    return ContentSentiment(
      overallSentiment: overallSentiment,
      dominantThemes: themes.toSet().toList(),
      emotionalTone: emotionalTone,
    );
  }

  /// حساب المشاعر المهيمنة
  EmotionType _calculateDominantEmotion(
    InteractionPattern interactionPattern,
    TemporalContext temporalContext,
    ContentSentiment contentSentiment,
  ) {
    // البدء بالنبرة العاطفية للمحتوى
    var dominantEmotion = contentSentiment.emotionalTone;

    // تعديل بناءً على مستوى التفاعل
    if (interactionPattern.engagementLevel > 0.8) {
      // مستوى تفاعل عالي يشير إلى مشاعر إيجابية
      if (dominantEmotion == EmotionType.neutral) {
        dominantEmotion = EmotionType.calm;
      }
    } else if (interactionPattern.engagementLevel < 0.3) {
      // مستوى تفاعل منخفض قد يشير إلى عدم الاهتمام أو التعب
      if (dominantEmotion == EmotionType.joy) {
        dominantEmotion = EmotionType.neutral;
      }
    }

    // تعديل بناءً على الوقت
    if (temporalContext.isRestTime && dominantEmotion == EmotionType.joy) {
      dominantEmotion = EmotionType.calm;
    }

    return dominantEmotion;
  }

  /// حساب شدة المشاعر
  double _calculateIntensity(InteractionPattern interactionPattern) {
    // الشدة تعتمد على مستوى التفاعل ومتوسط المدة
    final engagementFactor = interactionPattern.engagementLevel;
    final durationFactor =
        (interactionPattern.averageDuration.inMinutes / 30.0).clamp(0.0, 1.0);

    return ((engagementFactor + durationFactor) / 2.0).clamp(0.0, 1.0);
  }

  /// حساب الاستقرار العاطفي
  double _calculateStability(List<UserInteraction> interactions) {
    if (interactions.length < 2) return 0.5;

    // حساب التباين في أنواع الاستجابة العاطفية
    final responses = interactions.map((i) => i.emotionalResponse).toList();
    final uniqueResponses = responses.toSet().length;

    // كلما قل التنوع، زاد الاستقرار
    final stabilityScore =
        1.0 - (uniqueResponses / EmotionalResponse.values.length);

    return stabilityScore.clamp(0.0, 1.0);
  }

  /// توليد التوصيات المخصصة
  List<String> _generateRecommendations(
    EmotionType dominantEmotion,
    double intensity,
    double stability,
    InteractionPattern interactionPattern,
    ContentSentiment contentSentiment,
  ) {
    final recommendations = <String>[];

    // توصيات بناءً على المشاعر المهيمنة
    switch (dominantEmotion) {
      case EmotionType.joy:
      case EmotionType.happy:
      case EmotionType.love:
      case EmotionType.excited:
      case EmotionType.surprise: // Surprises can be joyful
        recommendations
            .addAll(['share_joy', 'create_memory', 'express_gratitude']);
        break;
      case EmotionType.calm:
      case EmotionType.trust:
      case EmotionType.anticipation: // Anticipation often needs calm
        recommendations
            .addAll(['continue_reflection', 'read_verse', 'meditate']);
        break;
      case EmotionType.nostalgic:
        recommendations
            .addAll(['explore_memories', 'write_reflection', 'connect_past']);
        break;
      case EmotionType.sad:
      case EmotionType.disgust:
        recommendations
            .addAll(['gentle_content', 'uplifting_verse', 'positive_memory']);
        break;
      case EmotionType.anxious:
      case EmotionType.fear:
      case EmotionType.anger:
        recommendations.addAll(
            ['calming_content', 'breathing_exercise', 'peaceful_verse']);
        break;
      case EmotionType.grateful:
        recommendations
            .addAll(['count_blessings', 'write_gratitude', 'share_thanks']);
        break;
      case EmotionType.neutral:
      case EmotionType.hopeful: // Hopeful is positive but handled gently here
        recommendations
            .addAll(['explore_content', 'discover_new', 'gentle_engagement']);
        break;
    }

    // توصيات بناءً على الشدة
    if (intensity < 0.3) {
      recommendations.add('increase_engagement');
    } else if (intensity > 0.8) {
      recommendations.add('take_break');
    }

    // توصيات بناءً على الاستقرار
    if (stability < 0.4) {
      recommendations.add('find_balance');
    }

    // توصيات بناءً على مستوى التفاعل
    if (interactionPattern.engagementLevel < 0.5) {
      recommendations.add('try_new_content');
    }

    return recommendations.take(5).toList(); // أقصى 5 توصيات
  }
}

/// السياق الزمني
class TemporalContext {
  /// إنشاء سياق زمني جديد
  const TemporalContext({
    required this.period,
    required this.energyLevel,
    required this.isRestTime,
  });

  /// فترة اليوم
  final DayPeriod period;

  /// مستوى الطاقة المتوقع
  final double energyLevel;

  /// هل هو وقت راحة؟
  final bool isRestTime;
}

/// فترات اليوم
enum DayPeriod {
  /// الصباح (5-12)
  morning,

  /// بعد الظهر (12-17)
  afternoon,

  /// المساء (17-21)
  evening,

  /// الليل (21-5)
  night,
}

/// مشاعر المحتوى
class ContentSentiment {
  /// إنشاء مشاعر محتوى جديدة
  const ContentSentiment({
    required this.overallSentiment,
    required this.dominantThemes,
    required this.emotionalTone,
  });

  /// المشاعر الإجمالية (0.0 سلبي - 1.0 إيجابي)
  final double overallSentiment;

  /// المواضيع المهيمنة
  final List<String> dominantThemes;

  /// النبرة العاطفية
  final EmotionType emotionalTone;
}
