# دليل المطور - البدء مع جناح الحنين

## مرحباً بك في فريق تطوير جناح الحنين 👨‍💻

هذا الدليل سيساعدك على فهم وتطوير تطبيق "جناح الحنين" - تطبيق ذكي عاطفياً مصمم لتعميق الروابط الزوجية من خلال التكنولوجيا المتقدمة والقيم الإسلامية الأصيلة.

## نظرة عامة على المشروع

### الهدف الأساسي
تطوير تطبيق Flutter متقدم يجمع بين:
- **الذكاء العاطفي**: محركات نفسية متطورة لتحليل المشاعر
- **القيم الإسلامية**: محتوى شرعي أصيل ومراجع
- **الأمان المطلق**: تشفير محلي متقدم بدون خوادم خارجية
- **تجربة مستخدم فريدة**: واجهات تكيفية وتأثيرات بصرية متقدمة

### التقييم الحالي: 95/100 (ممتاز بامتياز)

## متطلبات التطوير

### البيئة التقنية

#### Flutter & Dart
```bash
# Flutter SDK (مطلوب)
Flutter 3.22.2 أو أحدث
Dart 3.6.0 أو أحدث

# التحقق من الإصدار
flutter --version
dart --version
```

#### أدوات التطوير المطلوبة
```bash
# محرر النصوص (اختر واحد)
- Visual Studio Code + Flutter Extension
- Android Studio + Flutter Plugin
- IntelliJ IDEA + Flutter Plugin

# أدوات إضافية
- Git (إدارة الإصدارات)
- Android SDK (للتطوير على Android)
- Xcode (للتطوير على iOS - macOS فقط)
```

#### التبعيات الأساسية
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # إدارة الحالة
  provider: ^6.1.1
  
  # قاعدة البيانات المحلية
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # الأمان والتشفير
  crypto: ^3.0.3
  local_auth: ^2.1.6
  flutter_secure_storage: ^9.0.0
  
  # واجهة المستخدم
  lottie: ^2.7.0
  carousel_slider: ^4.2.1
  smooth_page_indicator: ^1.1.0
  
  # الصوت والإشعارات
  audioplayers: ^5.2.1
  flutter_tts: ^3.8.3
  flutter_local_notifications: ^16.3.0
  
  # أدوات مساعدة
  intl: ^0.18.1
  uuid: ^4.2.1
  collection: ^1.18.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # أدوات التطوير
  flutter_lints: ^3.0.1
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

## إعداد بيئة التطوير

### 1. استنساخ المشروع
```bash
# استنساخ المستودع
git clone [repository-url]
cd active_source_wing

# التحقق من الفروع المتاحة
git branch -a

# الانتقال لفرع التطوير
git checkout develop
```

### 2. تثبيت التبعيات
```bash
# تثبيت تبعيات Flutter
flutter pub get

# تشغيل مولد الكود (للنماذج)
flutter packages pub run build_runner build

# التحقق من صحة الإعداد
flutter doctor
```

### 3. إعداد المحرر

#### Visual Studio Code
```json
// .vscode/settings.json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.lineLength": 80,
  "editor.rulers": [80],
  "editor.formatOnSave": true,
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true
}
```

#### الإضافات المطلوبة
- Flutter
- Dart
- GitLens
- Error Lens
- Bracket Pair Colorizer

### 4. تشغيل التطبيق
```bash
# تشغيل على محاكي/جهاز
flutter run

# تشغيل في وضع التطوير مع إعادة التحميل السريع
flutter run --debug

# تشغيل على منصة محددة
flutter run -d android
flutter run -d ios
flutter run -d linux
```

## هيكل المشروع

### الهيكل العام
```
active_source_wing/
├── lib/                    # الكود المصدري
│   ├── core/              # الطبقة الأساسية
│   ├── features/          # الميزات
│   ├── shared/            # المكونات المشتركة
│   └── main.dart          # نقطة البداية
├── test/                  # الاختبارات
├── integration_test/      # اختبارات التكامل
├── assets/               # الأصول (صور، أصوات، بيانات)
├── docs/                 # التوثيق
└── pubspec.yaml          # إعدادات المشروع
```

### الطبقة الأساسية (`lib/core/`)
```
core/
├── cognitive/            # المحركات النفسية المتقدمة
│   ├── emotional_gravity_engine.dart
│   ├── surprise_evolution_engine.dart
│   ├── dual_truth_engine.dart
│   ├── emotional_entanglement_module.dart
│   ├── cosmic_synchronization_module.dart
│   ├── non_action_interface.dart
│   └── psychological_context_manager.dart
├── infrastructure/       # البنية التحتية
│   ├── app_initializer.dart
│   ├── wing_logger.dart
│   └── sef_governance_system.dart
├── models/              # نماذج البيانات
│   ├── memory_model.dart
│   ├── gratitude_entry_model.dart
│   └── verse_model.dart
├── psychology/          # النظام النفسي
│   ├── emotional_state.dart
│   ├── psychological_analysis_engine.dart
│   └── emotional_adaptation_system.dart
├── security/            # الأمان والحماية
│   ├── secure_data_manager.dart
│   └── safe_error_handler.dart
└── services/            # الخدمات الأساسية
    ├── db_service.dart
    ├── auth_service.dart
    ├── notification_service.dart
    ├── audio_service.dart
    ├── emotional_message_service.dart
    └── safety_box_service.dart
```

## المفاهيم الأساسية

### 1. المحركات النفسية المتقدمة

#### محرك الجاذبية العاطفية
```dart
class EmotionalGravityEngine {
  /// خوارزمية الصدى العاطفي
  Future<String> emotionalEchoAlgorithm(String userText, EmotionType userMood);
  
  /// خوارزمية التردد الوجودي
  Future<void> existentialFrequencyAlgorithm();
  
  /// خوارزمية النسبة الذهبية العاطفية
  Future<MessageTemplate> emotionalGoldenRatioAlgorithm();
}
```

**الاستخدام:**
```dart
final engine = Provider.of<EmotionalGravityEngine>(context, listen: false);
final response = await engine.emotionalEchoAlgorithm(
  "أشعر بالسعادة اليوم",
  EmotionType.happy,
);
```

#### محرك تطور المفاجآت
```dart
class SurpriseEvolutionEngine {
  /// توليد مفاجأة مخصصة
  Future<Surprise> generatePersonalizedSurprise();
  
  /// تحليل تأثير المفاجآت السابقة
  Future<SurpriseAnalysis> analyzePreviousSurprises();
}
```

### 2. النظام النفسي التكيفي

#### تحليل الحالة العاطفية
```dart
class PsychologicalAnalysisEngine {
  /// تحليل النص عاطفياً
  EmotionalAnalysis analyzeText(String text);
  
  /// تحديد المزاج الحالي
  EmotionType detectCurrentMood(List<UserInteraction> interactions);
  
  /// توقع الحالة العاطفية المستقبلية
  Future<EmotionType> predictFutureMood();
}
```

#### نظام التكيف العاطفي
```dart
class EmotionalAdaptationSystem {
  /// تكييف الثيم حسب المزاج
  ThemeData adaptThemeToEmotion(EmotionType emotion, ThemeData baseTheme);
  
  /// تكييف المحتوى حسب الحالة
  Widget adaptContentToEmotion(Widget content, EmotionType emotion);
  
  /// تكييف الواجهة حسب المزاج
  Widget adaptWidgetToEmotion(Widget widget, EmotionType emotion);
}
```

### 3. إدارة البيانات الآمنة

#### التشفير المحلي
```dart
class SecureDataManager {
  /// تشفير البيانات
  static Future<String> encryptData(String data);
  
  /// فك تشفير البيانات
  static Future<String> decryptData(String encryptedData);
  
  /// التحقق من سلامة البيانات
  static Future<bool> verifyDataIntegrity(String data);
}
```

#### خدمة قاعدة البيانات
```dart
class DBService {
  /// حفظ ذكرى
  Future<void> saveMemory(Memory memory);
  
  /// استرجاع الذكريات
  Future<List<Memory>> getAllMemories();
  
  /// البحث في الذكريات
  Future<List<Memory>> searchMemories(String query);
}
```

## أنماط التطوير

### 1. إدارة الحالة بـ Provider

#### إعداد Provider
```dart
MultiProvider(
  providers: [
    // الخدمات الأساسية
    Provider<DBService>.value(value: dbService),
    Provider<AuthService>.value(value: AuthService.instance),
    
    // المحركات النفسية
    Provider<EmotionalGravityEngine>(
      create: (context) => EmotionalGravityEngine(
        messageService: context.read<EmotionalMessageService>(),
        dbService: context.read<DBService>(),
        notificationService: context.read<NotificationService>(),
        contextManager: context.read<PsychologicalContextManager>(),
      ),
    ),
    
    // حالة التطبيق
    ChangeNotifierProvider<AppStateProvider>(
      create: (_) => AppStateProvider(),
    ),
  ],
  child: MaterialApp(/* ... */),
)
```

#### استخدام Provider
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // قراءة بدون استماع للتغييرات
    final dbService = Provider.of<DBService>(context, listen: false);
    
    // قراءة مع الاستماع للتغييرات
    final appState = Provider.of<AppStateProvider>(context);
    
    // استخدام Consumer للتحديثات الجزئية
    return Consumer<EmotionalAdaptationSystem>(
      builder: (context, adaptationSystem, child) {
        return adaptationSystem.adaptWidgetToEmotion(
          MyChildWidget(),
          appState.currentEmotion,
        );
      },
    );
  }
}
```

### 2. نمط Repository للبيانات

#### تعريف Repository
```dart
abstract class MemoryRepository {
  Future<List<Memory>> getAllMemories();
  Future<Memory?> getMemoryById(String id);
  Future<void> saveMemory(Memory memory);
  Future<void> deleteMemory(String id);
  Future<List<Memory>> searchMemories(String query);
}
```

#### تنفيذ Repository
```dart
class HiveMemoryRepository implements MemoryRepository {
  final Box<EncryptedMemory> _box;
  
  HiveMemoryRepository(this._box);
  
  @override
  Future<List<Memory>> getAllMemories() async {
    final encryptedMemories = _box.values.toList();
    final memories = <Memory>[];
    
    for (final encrypted in encryptedMemories) {
      try {
        final memory = await encrypted.toMemory();
        memories.add(memory);
      } catch (e) {
        WingLogger.error('فشل في فك تشفير الذكرى', tag: 'MemoryRepository');
      }
    }
    
    return memories;
  }
  
  @override
  Future<void> saveMemory(Memory memory) async {
    final encrypted = await EncryptedMemory.fromMemory(memory);
    await _box.put(memory.id, encrypted);
  }
}
```

### 3. معالجة الأخطاء

#### نظام معالجة الأخطاء الموحد
```dart
class SafeErrorHandler {
  static Future<T?> handleAsync<T>(
    Future<T> Function() operation, {
    String? context,
    T? fallback,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      WingLogger.error(
        'خطأ في العملية: ${context ?? 'غير محدد'}',
        tag: 'SafeErrorHandler',
        data: {'error': e.toString()},
        stackTrace: stackTrace,
      );
      
      return fallback;
    }
  }
  
  static T? handleSync<T>(
    T Function() operation, {
    String? context,
    T? fallback,
  }) {
    try {
      return operation();
    } catch (e, stackTrace) {
      WingLogger.error(
        'خطأ في العملية: ${context ?? 'غير محدد'}',
        tag: 'SafeErrorHandler',
        data: {'error': e.toString()},
        stackTrace: stackTrace,
      );
      
      return fallback;
    }
  }
}
```

#### استخدام معالج الأخطاء
```dart
// للعمليات غير المتزامنة
final memories = await SafeErrorHandler.handleAsync(
  () => dbService.getAllMemories(),
  context: 'استرجاع الذكريات',
  fallback: <Memory>[],
);

// للعمليات المتزامنة
final isValid = SafeErrorHandler.handleSync(
  () => InputValidator.validateText(userInput),
  context: 'التحقق من صحة المدخل',
  fallback: false,
);
```

## إرشادات الكود

### 1. معايير التسمية

#### الملفات والمجلدات
```dart
// ✅ صحيح
emotional_gravity_engine.dart
psychological_analysis_engine.dart
memory_detail_screen.dart

// ❌ خطأ
EmotionalGravityEngine.dart
psychologicalAnalysisEngine.dart
MemoryDetailScreen.dart
```

#### الفئات والدوال
```dart
// ✅ صحيح - فئات
class EmotionalGravityEngine { }
class PsychologicalAnalysisEngine { }

// ✅ صحيح - دوال ومتغيرات
void analyzeEmotionalState() { }
String currentUserName = '';
bool isAuthenticated = false;

// ✅ صحيح - ثوابت
static const String APP_NAME = 'جناح الحنين';
static const int MAX_RETRY_ATTEMPTS = 3;
```

### 2. التعليقات والتوثيق

#### التعليقات العربية للسياق الثقافي
```dart
/// محرك الجاذبية العاطفية
/// مسؤول عن تعديل "كثافة الحضور العاطفي" وتوليد المحتوى العاطفي
class EmotionalGravityEngine {
  /// خوارزمية الصدى العاطفي
  /// تحلل الكلمات والمشاعر وتولد استجابات تعكس وتضخم المشاعر الإيجابية
  Future<String> emotionalEchoAlgorithm(String userText, EmotionType userMood) async {
    // تتبع التفاعل في مدير السياق النفسي
    await _contextManager.trackInteraction(text: userText, type: userMood);
    
    // تحليل المشاعر باستخدام معالجة اللغة الطبيعية
    final sentiment = _analyzeSentiment(userText, userMood);
    
    return await _messageService.generateEmotionalResponse(userText, sentiment);
  }
}
```

#### التعليقات الإنجليزية للتنفيذ التقني
```dart
class SecureDataManager {
  /// Encrypts data using AES-256-CBC with HMAC for integrity verification
  static Future<String> encryptData(String data) async {
    // Generate secure random key if not exists
    final key = await _getOrCreateKey();
    final keyBytes = base64Decode(key);
    
    // Generate random IV for each encryption
    final iv = _generateRandomIV();
    
    // Encrypt using AES-256-CBC
    final encrypter = Encrypter(AES(Key(keyBytes)));
    final encrypted = encrypter.encrypt(data, iv: IV(iv));
    
    // Add HMAC for integrity verification
    final combined = iv + encrypted.bytes;
    final hmac = _generateHMAC(combined, keyBytes);
    
    return base64Encode(combined + hmac);
  }
}
```

### 3. تنظيم الاستيرادات
```dart
// Flutter/Dart imports first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

// Core imports
import '../core/services/db_service.dart';
import '../core/models/memory_model.dart';
import '../core/cognitive/emotional_gravity_engine.dart';

// Feature imports
import '../features/home/screens/home_screen.dart';
import '../features/memories/widgets/memory_card.dart';

// Shared imports
import '../shared/widgets/loading_indicator.dart';
import '../shared/utils/constants.dart';
```

## الاختبارات

### 1. اختبارات الوحدة

#### اختبار الخدمات
```dart
// test/core/services/db_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../lib/core/services/db_service.dart';
import '../../../lib/core/models/memory_model.dart';

void main() {
  group('DBService Tests', () {
    late DBService dbService;
    
    setUp(() {
      dbService = DBService();
    });
    
    test('should save memory successfully', () async {
      // Arrange
      final memory = Memory(
        id: 'test-id',
        title: 'Test Memory',
        content: 'Test content',
        createdAt: DateTime.now(),
      );
      
      // Act
      await dbService.saveMemory(memory);
      
      // Assert
      final savedMemory = await dbService.getMemoryById('test-id');
      expect(savedMemory, isNotNull);
      expect(savedMemory!.title, equals('Test Memory'));
    });
    
    test('should return empty list when no memories exist', () async {
      // Act
      final memories = await dbService.getAllMemories();
      
      // Assert
      expect(memories, isEmpty);
    });
  });
}
```

#### اختبار المحركات النفسية
```dart
// test/core/cognitive/emotional_gravity_engine_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('EmotionalGravityEngine Tests', () {
    late EmotionalGravityEngine engine;
    late MockEmotionalMessageService mockMessageService;
    
    setUp(() {
      mockMessageService = MockEmotionalMessageService();
      engine = EmotionalGravityEngine(
        messageService: mockMessageService,
        dbService: MockDBService(),
        notificationService: MockNotificationService(),
        contextManager: MockPsychologicalContextManager(),
      );
    });
    
    test('should generate positive response for happy mood', () async {
      // Arrange
      when(mockMessageService.generateEmotionalResponse(any, any))
          .thenAnswer((_) async => 'رائع! سعادتك تضيء يومي أيضاً ❤️');
      
      // Act
      final response = await engine.emotionalEchoAlgorithm(
        'أشعر بالسعادة اليوم',
        EmotionType.happy,
      );
      
      // Assert
      expect(response, contains('رائع'));
      expect(response, contains('❤️'));
    });
  });
}
```

### 2. اختبارات الواجهة

#### اختبار الشاشات
```dart
// test/features/home/screens/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('should display greeting message', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<DBService>.value(value: MockDBService()),
            Provider<AuthService>.value(value: MockAuthService()),
          ],
          child: MaterialApp(home: HomeScreen()),
        ),
      );
      
      // Act
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('مرحباً بك في جناح الحنين'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsWidgets);
    });
  });
}
```

### 3. تشغيل الاختبارات
```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل اختبارات محددة
flutter test test/core/services/

# تشغيل مع تقرير التغطية
flutter test --coverage

# عرض تقرير التغطية
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## أدوات التطوير

### 1. نظام السجلات (Logging)
```dart
// استخدام WingLogger بدلاً من print
WingLogger.info('تم تهيئة الخدمة بنجاح', tag: 'ServiceName');
WingLogger.warning('تحذير: قاعدة البيانات فارغة', tag: 'DBService');
WingLogger.error('خطأ في التشفير', tag: 'SecurityManager', data: {
  'error': e.toString(),
  'timestamp': DateTime.now().toIso8601String(),
});
```

### 2. أدوات التحليل
```bash
# تحليل الكود
flutter analyze

# إصلاح المشاكل التلقائية
dart fix --apply

# فحص التبعيات غير المستخدمة
flutter pub deps
```

### 3. أدوات الأداء
```bash
# بناء للإنتاج
flutter build apk --release
flutter build ios --release

# تحليل حجم التطبيق
flutter build apk --analyze-size

# قياس الأداء
flutter run --profile
```

## نصائح للتطوير

### 1. أفضل الممارسات

#### إدارة الحالة
- استخدم Provider للخدمات المشتركة
- استخدم ChangeNotifier للحالات المتغيرة
- تجنب الاستماع غير الضروري للتغييرات

#### الأداء
- استخدم const constructors عند الإمكان
- تجنب إعادة البناء غير الضرورية
- استخدم ListView.builder للقوائم الطويلة

#### الأمان
- شفر جميع البيانات الحساسة
- تحقق من صحة جميع المدخلات
- استخدم HTTPS للاتصالات الخارجية

### 2. تجنب الأخطاء الشائعة

#### ❌ أخطاء شائعة
```dart
// عدم معالجة الأخطاء
final data = await apiCall(); // قد يفشل

// استخدام print بدلاً من نظام السجلات
print('Debug message'); // غير مناسب للإنتاج

// عدم تحرير الموارد
StreamController controller; // لم يتم إغلاقه
```

#### ✅ الطريقة الصحيحة
```dart
// معالجة الأخطاء
try {
  final data = await apiCall();
  return data;
} catch (e) {
  WingLogger.error('فشل في استدعاء API', tag: 'Service');
  return null;
}

// استخدام نظام السجلات
WingLogger.info('رسالة تطوير', tag: 'ComponentName');

// تحرير الموارد
@override
void dispose() {
  controller.close();
  super.dispose();
}
```

## الدعم والمساعدة

### 📚 الموارد
- **التوثيق الفني**: `docs/` في المشروع
- **أمثلة الكود**: `examples/` في المشروع
- **اختبارات المرجع**: `test/` في المشروع

### 🤝 التواصل مع الفريق
- **المراجعة**: إنشاء Pull Request للمراجعة
- **الأسئلة**: استخدام Issues في Git
- **النقاش**: قنوات التطوير الداخلية

### 🐛 الإبلاغ عن الأخطاء
1. تحقق من Issues الموجودة
2. أنشئ Issue جديد مع:
   - وصف واضح للمشكلة
   - خطوات إعادة الإنتاج
   - البيئة التقنية
   - لقطات شاشة إن أمكن

---

## مرحباً بك في رحلة التطوير! 🚀

الآن أنت جاهز لبدء التطوير على "جناح الحنين". تذكر أن هذا المشروع ليس مجرد تطبيق تقني، بل رسالة سامية لتعزيز الحب والترابط بين الأزواج في إطار إسلامي أصيل.

**نصيحة أخيرة**: اكتب كود نظيف، اختبر بانتظام، وتذكر أن كل سطر كود تكتبه يساهم في سعادة الأزواج حول العالم.

*بارك الله في جهودك وجعل عملك في ميزان حسناتك* 🤲

---

*آخر تحديث: يناير 2025*  
*الإصدار: 2.1.0*  
*دليل المطور - جناح الحنين*