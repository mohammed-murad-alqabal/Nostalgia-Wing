# دليل المطور المحسن - جناح الحنين

## 🚀 مقدمة

مرحباً بك في مشروع "جناح الحنين" - تطبيق ذكي متطور لتعزيز العلاقات الزوجية باستخدام الذكاء الاصطناعي والمبادئ الإسلامية.

**الإصدار**: 2.2.0+1  
**Flutter**: >=3.22.2  
**Dart**: >=3.6.0  

---

## 📋 متطلبات النظام

### الحد الأدنى:
- **Flutter SDK**: 3.22.2 أو أحدث
- **Dart SDK**: 3.6.0 أو أحدث
- **Android Studio**: 2023.1 أو أحدث
- **VS Code**: 1.80 أو أحدث (اختياري)
- **Git**: 2.30 أو أحدث

### الموصى به:
- **RAM**: 16 GB أو أكثر
- **Storage**: 50 GB مساحة فارغة
- **CPU**: Intel i7 أو AMD Ryzen 7
- **GPU**: مدعوم للمحاكيات

---

## 🏗️ إعداد بيئة التطوير

### 1. استنساخ المشروع
```bash
git clone https://github.com/username/wing_of_nostalgia.git
cd wing_of_nostalgia/active_source_wing
```

### 2. تثبيت التبعيات
```bash
# تثبيت packages
flutter pub get

# تشغيل code generation
flutter packages pub run build_runner build

# التحقق من صحة الإعداد
flutter doctor -v
```

### 3. إعداد المحاكيات
```bash
# Android
flutter emulators --launch <emulator_id>

# iOS (macOS only)
open -a Simulator
```

---

## 🏛️ هيكل المشروع

### الهيكل العام:
```
active_source_wing/
├── lib/                    # الكود المصدري
│   ├── core/              # المكونات الأساسية
│   │   ├── cognitive/     # المحركات المعرفية
│   │   ├── infrastructure/# البنية التحتية
│   │   ├── models/        # نماذج البيانات
│   │   ├── psychology/    # النظام النفسي
│   │   ├── security/      # الأمان والحماية
│   │   └── services/      # الخدمات
│   ├── features/          # الميزات
│   │   ├── home/         # الشاشة الرئيسية
│   │   ├── memories/     # إدارة الذكريات
│   │   ├── messages/     # الرسائل العاطفية
│   │   ├── mirror/       # المرآة النفسية
│   │   └── settings/     # الإعدادات
│   └── main.dart         # نقطة البداية
├── test/                  # الاختبارات
├── assets/               # الأصول
├── docs/                 # التوثيق
└── logs/                 # ملفات السجل
```

### المكونات الأساسية:

#### Core Modules:
- **Cognitive**: المحركات الذكية (EmotionalGravityEngine, SurpriseEvolutionEngine)
- **Psychology**: النظام النفسي (EmotionalState, PsychologicalAnalysisEngine)
- **Services**: الخدمات (DBService, AuthService, NotificationService)
- **Security**: الأمان (SecureDataManager, SafeErrorHandler)

#### Features:
- **Home**: الواجهة الرئيسية مع التأثيرات البصرية
- **Memories**: إدارة الذكريات المشتركة
- **Messages**: نظام الرسائل العاطفية
- **Mirror**: المرآة النفسية للتحليل الذاتي

---

## 🔧 أوامر التطوير الأساسية

### البناء والتشغيل:
```bash
# تشغيل في وضع التطوير
flutter run

# تشغيل مع hot reload
flutter run --hot

# بناء للإنتاج (Android)
flutter build apk --release

# بناء للإنتاج (iOS)
flutter build ios --release
```

### الاختبارات:
```bash
# تشغيل جميع الاختبارات
flutter test

# اختبارات مع تغطية
flutter test --coverage

# اختبارات الأداء
flutter test test/performance/

# اختبارات التكامل
flutter drive --target=integration_test/app_flow_test.dart
```

### جودة الكود:
```bash
# تحليل الكود
flutter analyze

# تنسيق الكود
dart format .

# إصلاح المشاكل التلقائية
dart fix --apply
```

---

## 🧠 النظام المعرفي المتقدم

### المحركات الأساسية:

#### 1. Emotional Gravity Engine
```dart
// مثال على الاستخدام
final engine = Provider.of<EmotionalGravityEngine>(context);
final response = await engine.emotionalEchoAlgorithm(
  userText: "أشعر بالحزن اليوم",
  userMood: EmotionType.sad,
);
```

#### 2. Surprise Evolution Engine
```dart
// إنشاء مفاجأة ذكية
final surprise = await surpriseEngine.createIntelligentSurprise(
  context: currentContext,
  intensity: 0.8,
);
```

#### 3. Dual Truth Engine
```dart
// تحليل الحقائق المزدوجة
final analysis = await dualTruthEngine.analyzeDualPerspective(
  situation: "خلاف زوجي",
  perspective1: wifeView,
  perspective2: husbandView,
);
```

---

## 🔒 الأمان والخصوصية

### مبادئ الأمان:
1. **تشفير محلي**: جميع البيانات مشفرة بـ AES-256
2. **عدم إرسال البيانات**: معالجة محلية 100%
3. **مصادقة قوية**: دعم البصمة والوجه
4. **نسخ احتياطية آمنة**: تشفير end-to-end

### تطبيق الأمان:
```dart
// تشفير البيانات
final encryptedData = await SecureDataManager.encrypt(sensitiveData);

// حفظ آمن
await SafetyBoxService.store(key: 'user_secret', value: encryptedData);

// استرجاع آمن
final decryptedData = await SafetyBoxService.retrieve('user_secret');
```

---

## 🎨 نظام التصميم

### الألوان الأساسية:
```dart
// الألوان العاطفية
const Color joyfulColor = Color(0xFFFFD700);      // ذهبي للفرح
const Color calmColor = Color(0xFF87CEEB);        // أزرق فاتح للهدوء
const Color nostalgicColor = Color(0xFFDDA0DD);   // بنفسجي للحنين
const Color loveColor = Color(0xFFFF69B4);        // وردي للحب
```

### التأثيرات البصرية:
```dart
// Glassmorphism Effect
Container(
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withOpacity(0.3)),
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: content,
  ),
)
```

---

## 🧪 استراتيجية الاختبار

### أنواع الاختبارات:

#### 1. Unit Tests
```dart
// مثال على اختبار وحدة
testWidgets('EmotionalGravityEngine should generate appropriate response', (tester) async {
  final engine = EmotionalGravityEngine(/* dependencies */);
  final response = await engine.emotionalEchoAlgorithm(
    "أحبك كثيراً",
    EmotionType.happy,
  );
  expect(response, contains('حب'));
});
```

#### 2. Integration Tests
```dart
// اختبار التكامل
testWidgets('Full user journey test', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // محاكاة رحلة المستخدم الكاملة
  await tester.tap(find.byKey(Key('memory_button')));
  await tester.pumpAndSettle();
  
  expect(find.text('ذكرياتنا الجميلة'), findsOneWidget);
});
```

#### 3. Performance Tests
```dart
// اختبار الأداء
testWidgets('Home screen performance test', (tester) async {
  final stopwatch = Stopwatch()..start();
  
  await tester.pumpWidget(HomeScreen());
  await tester.pumpAndSettle();
  
  stopwatch.stop();
  expect(stopwatch.elapsedMilliseconds, lessThan(1000));
});
```

---

## 📱 إرشادات التطوير

### أفضل الممارسات:

#### 1. تسمية الملفات والمتغيرات:
```dart
// ✅ صحيح
class EmotionalGravityEngine { }
final String userMessage = "مرحبا";
const Duration animationDuration = Duration(milliseconds: 300);

// ❌ خاطئ
class emotionalengine { }
final String msg = "hi";
const Duration d = Duration(milliseconds: 300);
```

#### 2. التعليقات:
```dart
/// محرك الجاذبية العاطفية
/// 
/// يقوم بتحليل المشاعر وتوليد استجابات عاطفية مناسبة
/// لتعزيز الارتباط بين الزوجين.
class EmotionalGravityEngine {
  /// تحليل النص العاطفي وتوليد رد مناسب
  /// 
  /// [userText] النص المدخل من المستخدم
  /// [userMood] الحالة المزاجية الحالية
  /// 
  /// Returns استجابة عاطفية مخصصة
  Future<String> emotionalEchoAlgorithm(String userText, EmotionType userMood) async {
    // تنفيذ الخوارزمية...
  }
}
```

#### 3. معالجة الأخطاء:
```dart
try {
  final result = await riskyOperation();
  return result;
} catch (e, stackTrace) {
  WingLogger.error(
    'فشل في العملية',
    tag: 'OperationName',
    data: {'error': e.toString()},
    stackTrace: stackTrace,
  );
  
  // معالجة مناسبة للخطأ
  return fallbackValue;
}
```

---

## 🔄 سير العمل (Workflow)

### Git Workflow:
```bash
# إنشاء فرع جديد
git checkout -b feature/new-emotional-engine

# تطوير الميزة...
git add .
git commit -m "feat: إضافة محرك عاطفي جديد"

# دفع التغييرات
git push origin feature/new-emotional-engine

# إنشاء Pull Request
```

### Code Review Checklist:
- [ ] الكود يتبع معايير المشروع
- [ ] التعليقات واضحة ومفيدة
- [ ] الاختبارات تغطي الوظائف الجديدة
- [ ] لا توجد مشاكل أمنية
- [ ] الأداء مقبول
- [ ] التوثيق محدث

---

## 🐛 استكشاف الأخطاء وإصلاحها

### المشاكل الشائعة:

#### 1. مشاكل البناء:
```bash
# تنظيف المشروع
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### 2. مشاكل المحاكي:
```bash
# إعادة تشغيل المحاكي
flutter emulators --launch <emulator_id>

# تنظيف cache
flutter clean
```

#### 3. مشاكل الاختبارات:
```bash
# تشغيل اختبار محدد
flutter test test/specific_test.dart

# تشغيل مع تفاصيل أكثر
flutter test --verbose
```

---

## 📚 موارد إضافية

### الوثائق الداخلية:
- [دليل المعمارية](ARCHITECTURE.md)
- [دليل الأمان](docs/security/security-implementation-guide.md)
- [دليل الاختبار](docs/development/TESTING_STRATEGY.md)
- [دليل النشر](docs/deployment/APP_STORE_DEPLOYMENT.md)

### الموارد الخارجية:
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Provider Package](https://pub.dev/packages/provider)
- [Hive Database](https://docs.hivedb.dev/)

---

## 🤝 المساهمة

### كيفية المساهمة:
1. Fork المشروع
2. إنشاء فرع للميزة الجديدة
3. تطوير واختبار الميزة
4. إنشاء Pull Request
5. مراجعة الكود والموافقة

### معايير المساهمة:
- اتباع معايير الكود المحددة
- كتابة اختبارات شاملة
- توثيق واضح للتغييرات
- احترام المبادئ الإسلامية للمشروع

---

## 📞 الدعم والمساعدة

### قنوات الدعم:
- **GitHub Issues**: للمشاكل التقنية
- **Discussions**: للنقاشات العامة
- **Email**: للاستفسارات الخاصة

### ساعات الدعم:
- **الأحد - الخميس**: 9:00 - 17:00 (GMT+3)
- **الجمعة - السبت**: دعم محدود

---

**"الكود الجيد هو أفضل توثيق لنفسه"** - Steve McConnell

---

*آخر تحديث: 30 ديسمبر 2025*  
*الإصدار: 2.0*  
*المؤلف: فريق تطوير جناح الحنين*