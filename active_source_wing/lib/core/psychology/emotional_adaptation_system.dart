/// نظام التكيف العاطفي المتقدم - قلب التجربة التفاعلية
/// يكيف واجهة المستخدم والمحتوى حسب الحالة العاطفية
library;

import 'package:flutter/material.dart';
import '../infrastructure/wing_logger.dart';
import 'emotional_state.dart';

/// نظام التكيف العاطفي الذكي
class EmotionalAdaptationSystem {
  /// تكوينات الثيمات العاطفية
  static const Map<EmotionType, ThemeConfiguration> _emotionalThemes = {
    EmotionType.joy: ThemeConfiguration(
      primaryColor: Color(0xFFFFD700), // ذهبي دافئ
      accentColor: Color(0xFFFF6B6B), // وردي مرجاني
      backgroundGradient: [
        Color(0xFFFFF8DC),
        Color(0xFFFFE4B5)
      ], // تدرج ذهبي فاتح
      textColor: Color(0xFF2C3E50), // أزرق داكن للنص
      fontWeight: FontWeight.w500,
      animationDuration: Duration(milliseconds: 300),
      borderRadius: 12.0,
      elevation: 4.0,
    ),
    EmotionType.calm: ThemeConfiguration(
      primaryColor: Color(0xFF4A90E2), // أزرق هادئ
      accentColor: Color(0xFF7ED321), // أخضر طبيعي
      backgroundGradient: [
        Color(0xFFE8F4FD),
        Color(0xFFF0F8FF)
      ], // تدرج أزرق فاتح
      textColor: Color(0xFF34495E), // رمادي أزرق للنص
      fontWeight: FontWeight.w400,
      animationDuration: Duration(milliseconds: 500),
      borderRadius: 16.0,
      elevation: 2.0,
    ),
    EmotionType.nostalgic: ThemeConfiguration(
      primaryColor: Color(0xFF8B4513), // بني دافئ
      accentColor: Color(0xFFDAA520), // ذهبي قديم
      backgroundGradient: [
        Color(0xFFFDF5E6),
        Color(0xFFF5DEB3)
      ], // تدرج بيج دافئ
      textColor: Color(0xFF5D4037), // بني للنص
      fontWeight: FontWeight.w600,
      animationDuration: Duration(milliseconds: 800),
      borderRadius: 20.0,
      elevation: 6.0,
    ),
    EmotionType.grateful: ThemeConfiguration(
      primaryColor: Color(0xFF9C27B0), // بنفسجي دافئ
      accentColor: Color(0xFFE91E63), // وردي عميق
      backgroundGradient: [
        Color(0xFFF3E5F5),
        Color(0xFFE1BEE7)
      ], // تدرج بنفسجي فاتح
      textColor: Color(0xFF4A148C), // بنفسجي داكن للنص
      fontWeight: FontWeight.w500,
      animationDuration: Duration(milliseconds: 400),
      borderRadius: 14.0,
      elevation: 3.0,
    ),
    EmotionType.sad: ThemeConfiguration(
      primaryColor: Color(0xFF607D8B), // رمادي أزرق
      accentColor: Color(0xFF90A4AE), // رمادي فاتح
      backgroundGradient: [
        Color(0xFFECEFF1),
        Color(0xFFCFD8DC)
      ], // تدرج رمادي فاتح
      textColor: Color(0xFF37474F), // رمادي داكن للنص
      fontWeight: FontWeight.w400,
      animationDuration: Duration(milliseconds: 600),
      borderRadius: 8.0,
      elevation: 1.0,
    ),
    EmotionType.anxious: ThemeConfiguration(
      primaryColor: Color(0xFF795548), // بني مهدئ
      accentColor: Color(0xFFA1887F), // بني فاتح
      backgroundGradient: [
        Color(0xFFF5F5F5),
        Color(0xFFEEEEEE)
      ], // تدرج رمادي مهدئ
      textColor: Color(0xFF3E2723), // بني داكن للنص
      fontWeight: FontWeight.w300,
      animationDuration: Duration(milliseconds: 200),
      borderRadius: 6.0,
      elevation: 0.5,
    ),
    EmotionType.neutral: ThemeConfiguration(
      primaryColor: Color(0xFF2196F3), // أزرق متوسط
      accentColor: Color(0xFF03DAC6), // تركوازي
      backgroundGradient: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
      textColor: Color(0xFF212121),
      fontWeight: FontWeight.w400,
      animationDuration: Duration(milliseconds: 300),
      borderRadius: 10.0,
      elevation: 2.0,
    ),
    EmotionType.hopeful: ThemeConfiguration(
      primaryColor: Color(0xFF00BCD4), // سماوي متفائل
      accentColor: Color(0xFFE1F5FE),
      backgroundGradient: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
      textColor: Color(0xFF006064),
      fontWeight: FontWeight.w500,
      animationDuration: Duration(milliseconds: 400),
      borderRadius: 12.0,
      elevation: 3.0,
    ),
    EmotionType.excited: ThemeConfiguration(
      primaryColor: Color(0xFFFF5722), // برتقالي حيوي
      accentColor: Color(0xFFFFCCBC),
      backgroundGradient: [Color(0xFFFBE9E7), Color(0xFFFFCCBC)],
      textColor: Color(0xFFBF360C),
      fontWeight: FontWeight.w700,
      animationDuration: Duration(milliseconds: 200),
      borderRadius: 8.0,
      elevation: 5.0,
    ),
    EmotionType.anger: ThemeConfiguration(
      primaryColor: Color(0xFFD32F2F), // أحمر غاضب
      accentColor: Color(0xFFFFCDD2),
      backgroundGradient: [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
      textColor: Color(0xFFB71C1C),
      fontWeight: FontWeight.w800,
      animationDuration: Duration(milliseconds: 150),
      borderRadius: 4.0,
      elevation: 1.0,
    ),
    EmotionType.fear: ThemeConfiguration(
      primaryColor: Color(0xFF4527A0), // أرجواني عميق (خوف)
      accentColor: Color(0xFFD1C4E9),
      backgroundGradient: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
      textColor: Color(0xFF311B92),
      fontWeight: FontWeight.w300,
      animationDuration: Duration(milliseconds: 400),
      borderRadius: 20.0,
      elevation: 0.5,
    ),
    EmotionType.surprise: ThemeConfiguration(
      primaryColor: Color(0xFFFFEB3B), // أصفر مفاجأة
      accentColor: Color(0xFFFFF9C4),
      backgroundGradient: [Color(0xFFFFFDE7), Color(0xFFFFF9C4)],
      textColor: Color(0xFFFBC02D),
      fontWeight: FontWeight.w600,
      animationDuration: Duration(milliseconds: 250),
      borderRadius: 30.0,
      elevation: 4.0,
    ),
    EmotionType.trust: ThemeConfiguration(
      primaryColor: Color(0xFF8BC34A), // أخضر ثقة
      accentColor: Color(0xFFDCEDC8),
      backgroundGradient: [Color(0xFFF1F8E9), Color(0xFFDCEDC8)],
      textColor: Color(0xFF33691E),
      fontWeight: FontWeight.w500,
      animationDuration: Duration(milliseconds: 500),
      borderRadius: 15.0,
      elevation: 3.0,
    ),
    EmotionType.love: ThemeConfiguration(
      primaryColor: Color(0xFFE91E63), // وردي حب
      accentColor: Color(0xFFF8BBD0),
      backgroundGradient: [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
      textColor: Color(0xFF880E4F),
      fontWeight: FontWeight.w600,
      animationDuration: Duration(milliseconds: 600),
      borderRadius: 18.0,
      elevation: 4.0,
    ),
    EmotionType.happy: ThemeConfiguration(
      primaryColor: Color(0xFFFFEB3B), // أصفر سعيد
      accentColor: Color(0xFFFFF9C4),
      backgroundGradient: [Color(0xFFFFFDE7), Color(0xFFFFF9C4)],
      textColor: Color(0xFFFBC02D),
      fontWeight: FontWeight.w500,
      animationDuration: Duration(milliseconds: 300),
      borderRadius: 12.0,
      elevation: 3.0,
    ),
    EmotionType.anticipation: ThemeConfiguration(
      primaryColor: Color(0xFFFF9800), // برتقالي انتظار
      accentColor: Color(0xFFFFE0B2),
      backgroundGradient: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
      textColor: Color(0xFFE65100),
      fontWeight: FontWeight.w400,
      animationDuration: Duration(milliseconds: 450),
      borderRadius: 10.0,
      elevation: 2.0,
    ),
    EmotionType.disgust: ThemeConfiguration(
      primaryColor: Color(0xFF388E3C), // أخضر داكن
      accentColor: Color(0xFFC8E6C9),
      backgroundGradient: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
      textColor: Color(0xFF1B5E20),
      fontWeight: FontWeight.w400,
      animationDuration: Duration(milliseconds: 500),
      borderRadius: 8.0,
      elevation: 1.0,
    ),
  };

  /// تكييف الثيم حسب المشاعر
  ThemeData adaptThemeToEmotion(EmotionType emotion, ThemeData baseTheme) {
    final config =
        _emotionalThemes[emotion] ?? _emotionalThemes[EmotionType.neutral]!;

    WingLogger.debug(
      'Adapting theme to emotion',
      tag: 'EmotionalAdaptation',
      data: {
        'emotion': emotion.toString(),
        'primary_color': config.primaryColor.toARGB32().toRadixString(16),
        'animation_duration': config.animationDuration.inMilliseconds,
      },
    );

    return baseTheme.copyWith(
      primaryColor: config.primaryColor,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: config.primaryColor,
        secondary: config.accentColor,
        surface: config.backgroundGradient.first,
        onSurface: config.textColor,
      ),
      textTheme: baseTheme.textTheme.apply(
        bodyColor: config.textColor,
        displayColor: config.textColor,
      ),
      cardTheme: CardThemeData(
        elevation: config.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: config.primaryColor,
          foregroundColor: Colors.white,
          elevation: config.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(config.borderRadius),
          ),
        ),
      ),
    );
  }

  /// تكييف الويدجت حسب المشاعر
  Widget adaptWidgetToEmotion(Widget child, EmotionType emotion) {
    final config =
        _emotionalThemes[emotion] ?? _emotionalThemes[EmotionType.neutral]!;

    return AnimatedContainer(
      duration: config.animationDuration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: config.backgroundGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }

  /// إنشاء حاوية عاطفية مخصصة
  Widget createEmotionalContainer({
    required Widget child,
    required EmotionType emotion,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
  }) {
    final config =
        _emotionalThemes[emotion] ?? _emotionalThemes[EmotionType.neutral]!;

    return AnimatedContainer(
      duration: config.animationDuration,
      curve: Curves.easeInOut,
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16.0),
      margin: margin ?? const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: config.backgroundGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(config.borderRadius),
        boxShadow: [
          BoxShadow(
            color: config.primaryColor.withValues(alpha: 0.2),
            blurRadius: config.elevation * 2,
            offset: Offset(0, config.elevation),
          ),
        ],
      ),
      child: child,
    );
  }

  /// إنشاء نص عاطفي مخصص
  Widget createEmotionalText(
    String text, {
    required EmotionType emotion,
    TextStyle? baseStyle,
    TextAlign? textAlign,
  }) {
    final config =
        _emotionalThemes[emotion] ?? _emotionalThemes[EmotionType.neutral]!;

    final emotionalStyle = (baseStyle ?? const TextStyle()).copyWith(
      color: config.textColor,
      fontWeight: config.fontWeight,
    );

    return AnimatedDefaultTextStyle(
      duration: config.animationDuration,
      style: emotionalStyle,
      child: Text(
        text,
        textAlign: textAlign,
      ),
    );
  }

  /// إنشاء زر عاطفي مخصص
  Widget createEmotionalButton({
    required String text,
    required VoidCallback onPressed,
    required EmotionType emotion,
    IconData? icon,
  }) {
    final config =
        _emotionalThemes[emotion] ?? _emotionalThemes[EmotionType.neutral]!;

    return AnimatedContainer(
      duration: config.animationDuration,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: config.primaryColor,
          foregroundColor: Colors.white,
          elevation: config.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(config.borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  /// تكييف الألوان حسب الشدة العاطفية
  Color adaptColorIntensity(Color baseColor, double intensity) {
    // تعديل التشبع والإضاءة حسب الشدة
    final hsl = HSLColor.fromColor(baseColor);

    final adaptedSaturation =
        (hsl.saturation * (0.5 + intensity * 0.5)).clamp(0.0, 1.0);
    final adaptedLightness =
        (hsl.lightness * (0.7 + intensity * 0.3)).clamp(0.0, 1.0);

    return hsl
        .withSaturation(adaptedSaturation)
        .withLightness(adaptedLightness)
        .toColor();
  }

  /// إنشاء تأثير انتقالي عاطفي
  Widget createEmotionalTransition({
    required Widget child,
    required EmotionType fromEmotion,
    required EmotionType toEmotion,
    required Duration duration,
  }) {
    final fromConfig =
        _emotionalThemes[fromEmotion] ?? _emotionalThemes[EmotionType.neutral]!;
    final toConfig =
        _emotionalThemes[toEmotion] ?? _emotionalThemes[EmotionType.neutral]!;

    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        // interpolatedColor was unused, removing it.

        final interpolatedGradient = [
          Color.lerp(fromConfig.backgroundGradient[0],
              toConfig.backgroundGradient[0], value)!,
          Color.lerp(fromConfig.backgroundGradient[1],
              toConfig.backgroundGradient[1], value)!,
        ];

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: interpolatedGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  // Removed unused _getFontWeightDelta method

  /// الحصول على تكوين المشاعر
  ThemeConfiguration getEmotionConfiguration(EmotionType emotion) =>
      _emotionalThemes[emotion] ?? _emotionalThemes[EmotionType.neutral]!;

  /// تحديد ما إذا كان يجب تحديث الواجهة
  bool shouldUpdateUI(EmotionType currentEmotion, EmotionType newEmotion,
      double intensityChange) {
    // تحديث إذا تغيرت المشاعر أو تغيرت الشدة بشكل كبير
    final emotionChanged = currentEmotion != newEmotion;
    final significantIntensityChange = intensityChange.abs() > 0.3;

    return emotionChanged || significantIntensityChange;
  }
}

/// تكوين الثيم العاطفي
class ThemeConfiguration {
  /// إنشاء تكوين ثيم جديد
  const ThemeConfiguration({
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundGradient,
    required this.textColor,
    required this.fontWeight,
    required this.animationDuration,
    required this.borderRadius,
    required this.elevation,
  });

  /// اللون الأساسي
  final Color primaryColor;

  /// اللون المساعد
  final Color accentColor;

  /// تدرج الخلفية
  final List<Color> backgroundGradient;

  /// لون النص
  final Color textColor;

  /// وزن الخط
  final FontWeight fontWeight;

  /// مدة الحركة
  final Duration animationDuration;

  /// نصف قطر الحدود
  final double borderRadius;

  /// الارتفاع (الظل)
  final double elevation;

  /// نسخة محدثة من التكوين
  ThemeConfiguration copyWith({
    Color? primaryColor,
    Color? accentColor,
    List<Color>? backgroundGradient,
    Color? textColor,
    FontWeight? fontWeight,
    Duration? animationDuration,
    double? borderRadius,
    double? elevation,
  }) =>
      ThemeConfiguration(
        primaryColor: primaryColor ?? this.primaryColor,
        accentColor: accentColor ?? this.accentColor,
        backgroundGradient: backgroundGradient ?? this.backgroundGradient,
        textColor: textColor ?? this.textColor,
        fontWeight: fontWeight ?? this.fontWeight,
        animationDuration: animationDuration ?? this.animationDuration,
        borderRadius: borderRadius ?? this.borderRadius,
        elevation: elevation ?? this.elevation,
      );
}
