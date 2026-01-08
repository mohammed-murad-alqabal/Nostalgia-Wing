# دليل النشر للإنتاج - جناح الحنين

## 🚀 نظرة عامة

هذا الدليل يوضح خطوات نشر تطبيق "جناح الحنين" للإنتاج بأعلى معايير الجودة والأمان.

**الإصدار المستهدف**: 2.2.0+1  
**المنصات**: Android, iOS  
**البيئة**: Production  

---

## 📋 متطلبات ما قبل النشر

### 1. التحقق من الجودة
- [ ] جميع الاختبارات تمر بنجاح (100%)
- [ ] تغطية الاختبارات > 80%
- [ ] تحليل الكود بدون أخطاء
- [ ] مراجعة الأمان مكتملة
- [ ] المراجعة الشرعية معتمدة

### 2. الإعدادات المطلوبة
- [ ] شهادات التوقيع جاهزة
- [ ] متاجر التطبيقات معدة
- [ ] النسخ الاحتياطية محفوظة
- [ ] خطة الطوارئ جاهزة

### 3. البيانات والمحتوى
- [ ] قاعدة البيانات محدثة
- [ ] المحتوى الإسلامي مراجع
- [ ] الترجمات مكتملة
- [ ] الأصول محسنة

---

## 🔧 إعداد بيئة الإنتاج

### 1. تحديث الإعدادات
```yaml
# pubspec.yaml
name: wing_of_nostalgia
version: 2.2.0+1
environment:
  sdk: ">=3.6.0 <4.0.0"
  flutter: ">=3.22.2"
```

### 2. إعداد متغيرات البيئة
```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const bool isProduction = true;
  static const String appName = 'جناح الحنين';
  static const String version = '2.2.0';
  static const int buildNumber = 1;
}
```

### 3. تحسين الأداء
```dart
// main.dart - إعدادات الإنتاج
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تعطيل debug في الإنتاج
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  
  runApp(WingOfNostalgiaApp());
}
```

---

## 📱 نشر Android

### 1. إعداد التوقيع
```bash
# إنشاء keystore (مرة واحدة فقط)
keytool -genkey -v -keystore ~/wing-of-nostalgia-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias wing-nostalgia-key
```

### 2. إعداد gradle
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.wingofnostalgia.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "2.2.0"
        
        // تحسينات الأداء
        multiDexEnabled true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 3. بناء APK للإنتاج
```bash
# تنظيف المشروع
flutter clean
flutter pub get

# بناء AAB (مفضل لـ Play Store)
flutter build appbundle --release

# بناء APK
flutter build apk --release --split-per-abi

# التحقق من الحجم
ls -lh build/app/outputs/bundle/release/
ls -lh build/app/outputs/flutter-apk/
```

### 4. اختبار النسخة النهائية
```bash
# تثبيت واختبار
flutter install --release

# اختبار الأداء
flutter drive --target=integration_test/performance_test.dart --profile
```

---

## 🍎 نشر iOS

### 1. إعداد Xcode
```bash
# فتح مشروع iOS
open ios/Runner.xcworkspace
```

### 2. إعدادات المشروع
```plist
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>جناح الحنين</string>
<key>CFBundleIdentifier</key>
<string>com.wingofnostalgia.app</string>
<key>CFBundleVersion</key>
<string>1</string>
<key>CFBundleShortVersionString</key>
<string>2.2.0</string>
```

### 3. بناء للإنتاج
```bash
# بناء iOS
flutter build ios --release

# أرشفة في Xcode
# Product > Archive
```

### 4. رفع إلى App Store Connect
```bash
# استخدام Xcode Organizer
# أو التحميل المباشر
xcrun altool --upload-app -f "Runner.ipa" \
  --type ios -u "your-apple-id" \
  --password "app-specific-password"
```

---

## 🔒 فحوصات الأمان

### 1. تدقيق التبعيات
```bash
# فحص الثغرات الأمنية
flutter pub deps
dart pub audit

# تحديث التبعيات
flutter pub upgrade
```

### 2. فحص الكود
```bash
# تحليل أمني
flutter analyze --fatal-infos

# فحص الأذونات
grep -r "uses-permission" android/app/src/main/AndroidManifest.xml
```

### 3. اختبار الاختراق
```bash
# اختبار أمان التطبيق
# استخدام أدوات مثل MobSF أو QARK
```

---

## 📊 مراقبة الأداء

### 1. إعداد Analytics
```dart
// lib/core/services/analytics_service.dart
class AnalyticsService {
  static Future<void> trackEvent(String event, Map<String, dynamic> parameters) async {
    // تتبع الأحداث (مع احترام الخصوصية)
    if (AppConfig.isProduction) {
      // إرسال إحصائيات مجهولة فقط
    }
  }
}
```

### 2. مراقبة الأخطاء
```dart
// معالج الأخطاء العام
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kReleaseMode) {
      // تسجيل الأخطاء للمراجعة
      WingLogger.critical(
        'Flutter Error',
        tag: 'CrashReport',
        data: {'error': details.toString()},
      );
    }
  };
  
  runApp(WingOfNostalgiaApp());
}
```

---

## 🚀 عملية النشر

### 1. Google Play Store

#### أ. إعداد Store Listing
```
العنوان: جناح الحنين - تطبيق ذكي للعلاقات الزوجية
الوصف القصير: تطبيق ذكي يعزز الحب والحنين بين الأزواج باستخدام الذكاء الاصطناعي والمبادئ الإسلامية

الوصف الطويل:
جناح الحنين هو تطبيق ثوري يجمع بين التكنولوجيا المتقدمة والحكمة الإسلامية لتعزيز العلاقات الزوجية...

الكلمات المفتاحية:
- علاقات زوجية
- ذكاء اصطناعي
- إسلامي
- حب وحنين
- تطوير الذات
```

#### ب. رفع التطبيق
```bash
# رفع AAB
# استخدام Google Play Console
# App Bundle > Upload new release
```

### 2. Apple App Store

#### أ. إعداد App Store Connect
```
App Name: جناح الحنين
Subtitle: تطبيق ذكي للعلاقات الزوجية
Keywords: علاقات,زوجية,إسلامي,ذكاء,اصطناعي
Description: تطبيق متطور يستخدم الذكاء الاصطناعي...
```

#### ب. مراجعة Apple
- التأكد من اتباع App Store Guidelines
- عدم وجود محتوى مخالف
- وضوح الوظائف والأذونات
- جودة التصميم والأداء

---

## 📋 قائمة فحص ما قبل النشر

### التقنية:
- [ ] البناء ناجح بدون أخطاء
- [ ] الاختبارات تمر 100%
- [ ] الأداء مقبول (< 3 ثواني للتحميل)
- [ ] استهلاك البطارية معقول
- [ ] حجم التطبيق محسن

### المحتوى:
- [ ] النصوص مراجعة لغوياً
- [ ] المحتوى الإسلامي معتمد
- [ ] الصور والأيقونات محسنة
- [ ] الترجمات مكتملة

### القانونية:
- [ ] سياسة الخصوصية محدثة
- [ ] شروط الاستخدام واضحة
- [ ] الأذونات مبررة
- [ ] الامتثال للقوانين المحلية

### التسويق:
- [ ] وصف المتجر محسن
- [ ] لقطات الشاشة جذابة
- [ ] الكلمات المفتاحية مختارة
- [ ] خطة الإطلاق جاهزة

---

## 🔄 ما بعد النشر

### 1. المراقبة المستمرة
```bash
# مراقبة الأداء
# استخدام Firebase Performance
# أو أدوات مراقبة أخرى
```

### 2. جمع التغذية الراجعة
- مراقبة تقييمات المتجر
- تحليل تعليقات المستخدمين
- متابعة إحصائيات الاستخدام
- تتبع معدلات التحويل

### 3. التحديثات السريعة
```bash
# إصدار تحديث سريع
flutter build appbundle --release
# رفع إلى المتجر كتحديث
```

---

## 🆘 خطة الطوارئ

### في حالة مشاكل النشر:
1. **إيقاف النشر فوراً**
2. **تحليل المشكلة**
3. **إصلاح سريع أو rollback**
4. **اختبار الإصلاح**
5. **إعادة النشر**

### جهات الاتصال الطارئة:
- **فريق التطوير**: متاح 24/7
- **دعم المتاجر**: روابط الدعم السريع
- **الفريق القانوني**: للمشاكل القانونية

---

## 📈 مؤشرات النجاح

### الأسبوع الأول:
- [ ] 1000+ تحميل
- [ ] تقييم 4.5+ نجوم
- [ ] معدل تعطل < 1%
- [ ] وقت استجابة < 2 ثانية

### الشهر الأول:
- [ ] 10,000+ تحميل
- [ ] احتفاظ 70%+ بعد 7 أيام
- [ ] تقييمات إيجابية 90%+
- [ ] نمو عضوي 20%+

---

**"النجاح في النشر يتطلب التخطيط المدروس والتنفيذ الدقيق"**

---

*آخر تحديث: 30 ديسمبر 2025*  
*الإصدار: 1.0*  
*المسؤول: فريق النشر والعمليات*