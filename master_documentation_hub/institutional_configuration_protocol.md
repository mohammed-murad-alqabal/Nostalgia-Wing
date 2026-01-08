# بروتوكول التكوين المعرفي [PROTOCOL.CONFIGURATION.institutional.v1.0]

## 1. المقدمة

يهدف هذا البروتوكول إلى توفير إرشادات دقيقة ومفصلة لتكوين بيئة تطوير Flutter معرفية ومستقرة لمشروع "جناح الحنين". تضمن هذه البيئة التوافق الأمثل، وتقليل التعارضات، وتوفير أساس متين للتطوير المستمر، بما يتماشى مع "الميثاق التأسيسي للبيئة الهندسية المعرفية" [CHARTER.institutional.ENGINEERING.ENVIRONMENT.v1.0] و "بروتوكول التشغيل المعرفي المستقل" (ASOP) [PROTOCOL.ASOP.Ω.v1.0].

إن تحقيق بيئة تطوير قابلة للتكرار بدقة هو أمر بالغ الأهمية لضمان سلامة واستمرارية "الأثر العاطفي" للمشروع، حيث يقلل من "الضوضاء التقنية" ويسمح بالتركيز الكامل على الإبداع الهندسي.

## 2. المكونات المعتمدة للنواة المستقرة

لضمان الاستقرار والتوافق، يجب الالتزام الصارم بالمكونات والإصدارات التالية:

### 2.1. Java Development Kit (JDK)

*   **الإصدار المعتمد:** JDK 17 (Long-Term Support - LTS).
*   **السبب:** يوفر هذا الإصدار الاستقرار والأداء الأمثل، وهو متوافق بشكل كامل مع متطلبات Gradle و Android Studio.
*   **روابط التحميل الرسمية:**
    *   [Oracle JDK 17 LTS](https://www.oracle.com/java/technologies/downloads/#jdk17-windows)
    *   [Adoptium OpenJDK 17 LTS](https://adoptium.net/temurin/releases/?version=17)

### 2.2. Flutter SDK

*   **القناة المعتمدة:** Stable Channel.
*   **السبب:** تضمن قناة Stable أقصى درجات الاستقرار والموثوقية، وتجنب المشاكل الناتجة عن التغييرات المتكررة في قنوات التطوير (Beta, Dev, Master).
*   **الإصدار المعتمد:** أحدث إصدار مستقر متاح وقت التكوين.
*   **روابط التحميل الرسمية:**
    *   [Flutter SDK Archive](https://docs.flutter.dev/release/archive)

### 2.3. Android Studio

*   **الإصدار المعتمد:** أحدث إصدار مستقر متاح.
*   **السبب:** يوفر Android Studio بيئة تطوير متكاملة (IDE) قوية لتطوير تطبيقات Android، وهو ضروري لإدارة SDKs، المحاكيات، وتصحيح الأخطاء.
*   **روابط التحميل الرسمية:**
    *   [Android Studio Download](https://developer.android.com/studio/install)

### 2.4. إضافات IDE الرسمية

*   **الإضافات المطلوبة:**
    *   Dart
    *   Flutter
*   **السبب:** توفر هذه الإضافات الدعم الكامل للغة Dart وإطار عمل Flutter داخل Android Studio، بما في ذلك إكمال الكود، تصحيح الأخطاء، وتحليل الكود.
*   **التثبيت:** يتم تثبيتها مباشرة من داخل Android Studio (File > Settings > Plugins).

## 3. خطوات التكوين المعرفي

لضمان بيئة تطوير متطابقة، اتبع الخطوات التالية بدقة:

### 3.1. تثبيت JDK 17

1.  قم بتحميل مثبت JDK 17 (LTS) من أحد الروابط الرسمية المذكورة أعلاه.
2.  اتبع تعليمات التثبيت الافتراضية.
3.  **تكوين متغيرات البيئة (Environment Variables):**
    *   **Windows:**
        *   أضف مسار `bin` الخاص بـ JDK إلى متغير `Path`.
        *   أنشئ متغير نظام جديد باسم `JAVA_HOME` بقيمة مسار تثبيت JDK (مثال: `C:\Program Files\Java\jdk-17`).
    *   **macOS/Linux:**
        *   أضف `export JAVA_HOME=/path/to/jdk-17` و `export PATH=$PATH:$JAVA_HOME/bin` إلى ملف `~/.bashrc` أو `~/.zshrc`.
4.  **التحقق:** افتح نافذة طرفية جديدة ونفذ الأمر `java -version`. يجب أن يعرض الإصدار 17.

### 3.2. تثبيت Flutter SDK

1.  قم بتحميل ملف Flutter SDK المضغوط (zip/tar.gz) من قناة Stable.
2.  استخرج الملفات إلى مجلد آمن ومناسب (مثال: `C:\src\flutter` على Windows، أو `~/development/flutter` على macOS/Linux).
3.  **تكوين متغيرات البيئة (Environment Variables):**
    *   أضف مسار مجلد `bin` الخاص بـ Flutter إلى متغير `Path`.
    *   **Windows:** `C:\src\flutter\bin`
    *   **macOS/Linux:** `~/development/flutter/bin`
4.  **التحقق:** افتح نافذة طرفية جديدة ونفذ الأمر `flutter doctor`. يجب أن يعرض قائمة بالمكونات المثبتة.

### 3.3. تثبيت Android Studio وتكوينه

1.  قم بتحميل وتثبيت Android Studio من الرابط الرسمي.
2.  عند التشغيل الأول، اتبع معالج الإعداد لتثبيت Android SDK Platform-Tools و Android SDK Build-Tools وأي مكونات أخرى مقترحة.
3.  **تثبيت إضافات Dart و Flutter:**
    *   في Android Studio، اذهب إلى `File > Settings > Plugins` (أو `Android Studio > Preferences > Plugins` على macOS).
    *   ابحث عن 

