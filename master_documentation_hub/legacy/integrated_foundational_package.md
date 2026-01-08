# الحزمة التأسيسية المتكاملة [PACKAGE.FOUNDATIONAL.INTEGRATED.v1.0]

## 1. المقدمة

تمثل هذه الوثيقة "الحزمة التأسيسية المتكاملة" لمشروع "جناح الحنين"، وهي مصممة لتوفير جميع الموارد الأساسية المطلوبة لتكوين بيئة تطوير Flutter مؤسسية ومستقرة. تلتزم هذه الحزمة بالمعايير المحددة في "الميثاق التأسيسي للبيئة الهندسية المؤسسية" [CHARTER.institutional.ENGINEERING.ENVIRONMENT.v1.0] و "بروتوكول التكوين المؤسسي" [PROTOCOL.CONFIGURATION.institutional.v1.0].

الهدف هو توفير نقطة انطلاق موحدة وموثوقة لجميع عمليات التكوين، مما يضمن التوافق الكامل ويقلل من أي تباينات محتملة في بيئات التطوير.

## 2. مكونات الحزمة وروابط التحميل المباشرة

تتضمن الحزمة التأسيسية المكونات التالية، مع توفير روابط تحميل مباشرة ورسمية لأحدث الإصدارات المستقرة الموصى بها.

### 2.1. Java Development Kit (JDK) 17 LTS

**الوصف:** بيئة تشغيل وتطوير Java، ضرورية لتشغيل أدوات بناء Android مثل Gradle.
**الإصدار الموصى به:** JDK 17 (Long-Term Support).
**روابط التحميل المباشرة (اختر ما يناسب نظام التشغيل الخاص بك):**

*   **Oracle JDK 17 LTS:**
    *   [Windows x64 Installer](https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.exe)
    *   [macOS ARM64 DMG](https://download.oracle.com/java/17/latest/jdk-17_macos-aarch64_bin.dmg)
    *   [macOS x64 DMG](https://download.oracle.com/java/17/latest/jdk-17_macos-x64_bin.dmg)
    *   [Linux x64 Compressed Archive](https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz)

*   **Adoptium OpenJDK 17 LTS (Temurin):**
    *   [Windows x64 Installer](https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.11%2B9/OpenJDK17U-jdk_x64_windows_hotspot_17.0.11_9.msi)
    *   [macOS x64 PKG](https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.11%2B9/OpenJDK17U-jdk_x64_mac_hotspot_17.0.11_9.pkg)
    *   [Linux x64 Tar.gz](https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.11%2B9/OpenJDK17U-jdk_x64_linux_hotspot_17.0.11_9.tar.gz)

### 2.2. Flutter SDK (Stable Channel)

**الوصف:** إطار عمل Google لبناء تطبيقات متعددة المنصات من قاعدة كود واحدة.
**الإصدار الموصى به:** أحدث إصدار مستقر.
**روابط التحميل المباشرة (اختر ما يناسب نظام التشغيل الخاص بك):**

*   **Flutter SDK (Stable Channel) - أحدث إصدار:**
    *   [Windows Zip](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.22.2-stable.zip) (قد يتغير الإصدار، يرجى التحقق من [Flutter SDK Archive](https://docs.flutter.dev/release/archive) لأحدث إصدار مستقر)
    *   [macOS ARM64 Tar.gz](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.22.2-stable.zip) (قد يتغير الإصدار، يرجى التحقق من [Flutter SDK Archive](https://docs.flutter.dev/release/archive) لأحدث إصدار مستقر)
    *   [Linux Tar.xz](https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz) (قد يتغير الإصدار، يرجى التحقق من [Flutter SDK Archive](https://docs.flutter.dev/release/archive) لأحدث إصدار مستقر)

### 2.3. Android Studio

**الوصف:** بيئة تطوير متكاملة (IDE) رسمية لتطوير تطبيقات Android.
**الإصدار الموصى به:** أحدث إصدار مستقر.
**روابط التحميل المباشرة (اختر ما يناسب نظام التشغيل الخاص بك):**

*   **Android Studio (أحدث إصدار مستقر):**
    *   [Windows Installer](https://redirector.gvt1.com/edgedl/android/studio/install/2023.3.1.0/android-studio-2023.3.1.0-windows.exe)
    *   [macOS ARM64 DMG](https://redirector.gvt1.com/edgedl/android/studio/install/2023.3.1.0/android-studio-2023.3.1.0-mac_arm.dmg)
    *   [macOS x64 DMG](https://redirector.gvt1.com/edgedl/android/studio/install/2023.3.1.0/android-studio-2023.3.1.0-mac.dmg)
    *   [Linux Tar.gz](https://redirector.gvt1.com/edgedl/android/studio/install/2023.3.1.0/android-studio-2023.3.1.0-linux.tar.gz)

## 3. ملاحظات هامة

*   **التحقق من الإصدارات:** يرجى دائمًا التحقق من المواقع الرسمية (خاصة لـ Flutter) لأحدث الإصدارات المستقرة، حيث قد تتغير الروابط بمرور الوقت.
*   **اتباع بروتوكول التكوين:** بعد تحميل المكونات، يجب اتباع الإرشادات المفصلة في "بروتوكول التكوين المؤسسي" [PROTOCOL.CONFIGURATION.institutional.v1.0] لتثبيت وتكوين البيئة بشكل صحيح.
*   **التحقق النهائي:** بعد الانتهاء من التكوين، قم بتشغيل الأمر `flutter doctor -v` في الطرفية للتحقق من أن جميع المكونات تم تثبيتها وتكوينها بشكل صحيح.

هذه الحزمة هي نقطة البداية لضمان بيئة تطوير موحدة ومستقرة لمشروع "جناح الحنين"، مما يمهد الطريق لتجسيد رؤيته الكاملة بأقصى درجات الفعالية والقوة.

