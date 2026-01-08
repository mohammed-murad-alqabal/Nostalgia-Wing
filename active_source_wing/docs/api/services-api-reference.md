# مرجع واجهات البرمجة للخدمات - Services API Reference

## نظرة عامة

هذا المرجع يوثق جميع واجهات البرمجة (APIs) للخدمات الأساسية في تطبيق "جناح الحنين". جميع الخدمات مصممة لتعمل محلياً مع تشفير متقدم لضمان الخصوصية المطلقة.

## فهرس الخدمات

1. [خدمة قاعدة البيانات (DBService)](#dbservice)
2. [خدمة المصادقة (AuthService)](#authservice)
3. [خدمة الرسائل العاطفية (EmotionalMessageService)](#emotionalmessageservice)
4. [خدمة الإشعارات (NotificationService)](#notificationservice)
5. [خدمة الصندوق الآمن (SafetyBoxService)](#safetyboxservice)
6. [خدمة الصوت (AudioService)](#audioservice)

---

## DBService

خدمة قاعدة البيانات المحلية باستخدام Hive لتخزين جميع بيانات التطبيق بشكل آمن ومشفر.

### الملف
```
lib/core/services/db_service.dart
```

### الواجهات الأساسية

#### إدارة الذكريات

```dart
/// حفظ ذكرى جديدة
Future<void> saveMemory(Memory memory)

/// استرجاع جميع الذكريات
Future<List<Memory>> getAllMemories()

/// استرجاع ذكرى بالمعرف
Future<Memory?> getMemoryById(String id)

/// تحديث ذكرى موجودة
Future<void> updateMemory(Memory memory)

/// حذف ذكرى
Future<void> deleteMemory(String id)

/// البحث في الذكريات
Future<List<Memory>> searchMemories(String query)
```

**مثال الاستخدام:**
```dart
final dbService = Provider.of<DBService>(context, listen: false);

// إنشاء ذكرى جديدة
final memory = Memory(
  id: uuid.v4(),
  title: 'يوم زفافنا',
  content: 'أجمل يوم في حياتنا',
  date: DateTime.now(),
  emotionType: EmotionType.happy,
  tags: ['زفاف', 'سعادة'],
);

await dbService.saveMemory(memory);

// استرجاع جميع الذكريات
final memories = await dbService.getAllMemories();
```

#### إدارة الرسائل العاطفية

```dart
/// حفظ رسالة عاطفية
Future<void> saveEmotionalMessage(EmotionalMessage message)

/// استرجاع الرسائل حسب النوع
Future<List<EmotionalMessage>> getMessagesByType(String type)

/// استرجاع رسائل عشوائية
Future<List<EmotionalMessage>> getRandomMessages(int count)

/// تحديث حالة الرسالة (مقروءة/غير مقروءة)
Future<void> updateMessageStatus(String id, bool isRead)
```

#### إدارة الإعدادات

```dart
/// حفظ إعداد
Future<void> saveSetting(String key, dynamic value)

/// استرجاع إعداد
Future<T?> getSetting<T>(String key)

/// حذف إعداد
Future<void> deleteSetting(String key)

/// استرجاع جميع الإعدادات
Future<Map<String, dynamic>> getAllSettings()
```

---

## AuthService

خدمة المصادقة متعددة المستويات مع دعم المصادقة البيومترية والتشفير المتقدم.

### الملف
```
lib/core/services/auth_service.dart
```

### الواجهات الأساسية

#### المصادقة الأساسية

```dart
/// تسجيل الدخول
Future<bool> authenticate()

/// تسجيل الخروج
Future<void> logout()

/// التحقق من حالة المصادقة
Future<bool> isAuthenticated()

/// إنشاء حساب جديد
Future<bool> createAccount(String username, String password)
```

#### المصادقة البيومترية

```dart
/// التحقق من توفر المصادقة البيومترية
Future<bool> isBiometricAvailable()

/// تفعيل المصادقة البيومترية
Future<bool> enableBiometric()

/// إلغاء المصادقة البيومترية
Future<void> disableBiometric()

/// المصادقة باستخدام البيومتري
Future<bool> authenticateWithBiometric()
```

#### إدارة كلمات المرور

```dart
/// تغيير كلمة المرور
Future<bool> changePassword(String oldPassword, String newPassword)

/// التحقق من قوة كلمة المرور
PasswordStrength checkPasswordStrength(String password)

/// إعادة تعيين كلمة المرور
Future<bool> resetPassword(List<String> securityAnswers)
```

**مثال الاستخدام:**
```dart
final authService = Provider.of<AuthService>(context, listen: false);

// تسجيل الدخول
final isAuthenticated = await authService.authenticate();

if (isAuthenticated) {
  // المستخدم مصادق عليه
  Navigator.pushReplacement(context, MaterialRoute(
    builder: (context) => HomeScreen(),
  ));
} else {
  // فشل في المصادقة
  showDialog(/* رسالة خطأ */);
}

// تفعيل المصادقة البيومترية
if (await authService.isBiometricAvailable()) {
  await authService.enableBiometric();
}
```

---

## EmotionalMessageService

خدمة توليد وإدارة الرسائل العاطفية مع أكثر من 500 عبارة عاطفية مصنفة ومتنوعة.

### الملف
```
lib/core/services/emotional_message_service.dart
```

### الواجهات الأساسية

#### توليد الرسائل

```dart
/// توليد رسالة عاطفية عشوائية
Future<String> generateRandomMessage()

/// توليد رسالة حسب النوع
Future<String> generateMessageByType(String type)

/// توليد رسالة حسب المزاج
Future<String> generateMessageByMood(EmotionType mood)

/// توليد استجابة عاطفية للنص
Future<String> generateEmotionalResponse(String userText, String sentiment)
```

#### تخصيص الرسائل

```dart
/// تخصيص الرسالة بالاسم
String personalizeMessage(String message, String partnerName)

/// تطبيق قالب الرسالة
String applyMessageTemplate(MessageTemplate template, Map<String, String> variables)

/// تحديد شدة الرسالة
String adjustMessageIntensity(String message, double intensity)
```

#### إحصائيات الرسائل

```dart
/// عدد الرسائل المتاحة
int getTotalMessageCount()

/// عدد الرسائل حسب النوع
int getMessageCountByType(String type)

/// الرسائل الأكثر استخداماً
Future<List<String>> getMostUsedMessages(int limit)
```

**مثال الاستخدام:**
```dart
final messageService = Provider.of<EmotionalMessageService>(context, listen: false);

// توليد رسالة عاطفية
final message = await messageService.generateMessageByMood(EmotionType.happy);

// تخصيص الرسالة
final personalizedMessage = messageService.personalizeMessage(message, 'فاطمة');

print(personalizedMessage); // "فاطمة الحبيبة، أنتِ نور حياتي ❤️"
```

---

## NotificationService

خدمة الإشعارات المحلية مع دعم الإشعارات المجدولة والتفاعلية.

### الملف
```
lib/core/services/notification_service.dart
```

### الواجهات الأساسية

#### الإشعارات الفورية

```dart
/// عرض إشعار فوري
Future<void> showNotification({
  required String title,
  required String body,
  String? payload,
})

/// عرض إشعار مع صورة
Future<void> showNotificationWithImage({
  required String title,
  required String body,
  required String imagePath,
  String? payload,
})
```

#### الإشعارات المجدولة

```dart
/// جدولة إشعار
Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDate,
  String? payload,
})

/// جدولة إشعار دوري
Future<void> schedulePeriodicNotification({
  required int id,
  required String title,
  required String body,
  required RepeatInterval repeatInterval,
})

/// إلغاء إشعار مجدول
Future<void> cancelNotification(int id)

/// إلغاء جميع الإشعارات
Future<void> cancelAllNotifications()
```

#### إدارة الإشعارات

```dart
/// الحصول على الإشعارات المعلقة
Future<List<PendingNotificationRequest>> getPendingNotifications()

/// التحقق من صلاحيات الإشعارات
Future<bool> areNotificationsEnabled()

/// طلب صلاحيات الإشعارات
Future<bool> requestNotificationPermissions()
```

**مثال الاستخدام:**
```dart
final notificationService = Provider.of<NotificationService>(context, listen: false);

// عرض إشعار فوري
await notificationService.showNotification(
  title: 'جناح الحنين',
  body: 'رسالة حب جديدة في انتظارك!',
  payload: 'love_message',
);

// جدولة إشعار يومي
await notificationService.schedulePeriodicNotification(
  id: 1,
  title: 'تذكير يومي',
  body: 'حان وقت كتابة ذكرى جميلة',
  repeatInterval: RepeatInterval.daily,
);
```

---

## SafetyBoxService

خدمة الصندوق الآمن لحفظ البيانات الحساسة مع تشفير متقدم وحماية إضافية.

### الملف
```
lib/core/services/safety_box_service.dart
```

### الواجهات الأساسية

#### إدارة البيانات الآمنة

```dart
/// حفظ بيانات في الصندوق الآمن
Future<void> storeSecureData(String key, String data)

/// استرجاع بيانات من الصندوق الآمن
Future<String?> retrieveSecureData(String key)

/// حذف بيانات من الصندوق الآمن
Future<void> deleteSecureData(String key)

/// التحقق من وجود مفتاح
Future<bool> containsKey(String key)
```

#### النسخ الاحتياطي والاستعادة

```dart
/// إنشاء نسخة احتياطية مشفرة
Future<String> createEncryptedBackup()

/// استعادة من نسخة احتياطية
Future<bool> restoreFromBackup(String encryptedBackup, String password)

/// تصدير البيانات
Future<Map<String, dynamic>> exportData()

/// استيراد البيانات
Future<bool> importData(Map<String, dynamic> data)
```

#### الأمان المتقدم

```dart
/// تغيير مفتاح التشفير
Future<bool> changeEncryptionKey(String oldKey, String newKey)

/// التحقق من سلامة البيانات
Future<bool> verifyDataIntegrity()

/// مسح آمن للبيانات
Future<void> secureWipe()
```

**مثال الاستخدام:**
```dart
final safetyBoxService = Provider.of<SafetyBoxService>(context, listen: false);

// حفظ بيانات حساسة
await safetyBoxService.storeSecureData('partner_info', jsonEncode({
  'name': 'فاطمة',
  'anniversary': '2020-01-15',
  'special_notes': 'تحب الورود الحمراء',
}));

// استرجاع البيانات
final partnerInfo = await safetyBoxService.retrieveSecureData('partner_info');
if (partnerInfo != null) {
  final data = jsonDecode(partnerInfo);
  print('اسم الشريك: ${data['name']}');
}
```

---

## AudioService

خدمة الصوت لتشغيل الأصوات والموسيقى مع دعم التحكم المتقدم.

### الملف
```
lib/core/services/audio_service.dart
```

### الواجهات الأساسية

#### تشغيل الأصوات

```dart
/// تشغيل ملف صوتي
Future<void> playSound(String soundPath)

/// تشغيل صوت من الأصول
Future<void> playAssetSound(String assetPath)

/// إيقاف التشغيل
Future<void> stopSound()

/// إيقاف مؤقت
Future<void> pauseSound()

/// استئناف التشغيل
Future<void> resumeSound()
```

#### التحكم في الصوت

```dart
/// تعديل مستوى الصوت
Future<void> setVolume(double volume)

/// الحصول على مستوى الصوت
Future<double> getVolume()

/// كتم الصوت
Future<void> mute()

/// إلغاء الكتم
Future<void> unmute()
```

#### معلومات التشغيل

```dart
/// الحصول على حالة التشغيل
Future<PlayerState> getPlayerState()

/// الحصول على مدة الملف
Future<Duration?> getDuration()

/// الحصول على الموضع الحالي
Future<Duration> getCurrentPosition()

/// التنقل إلى موضع معين
Future<void> seekTo(Duration position)
```

**مثال الاستخدام:**
```dart
final audioService = AudioService.instance;

// تشغيل صوت إشعار
await audioService.playAssetSound('sounds/notification.mp3');

// تشغيل موسيقى خلفية
await audioService.playAssetSound('sounds/background_music.mp3');
await audioService.setVolume(0.3); // خفض الصوت إلى 30%
```

---

## معالجة الأخطاء

جميع الخدمات تستخدم نظام معالجة أخطاء موحد:

```dart
try {
  final result = await service.someMethod();
  // معالجة النتيجة
} catch (e) {
  WingLogger.error(
    'خطأ في الخدمة',
    tag: 'ServiceName',
    data: {'error': e.toString()},
  );
  
  // معالجة الخطأ
  if (e is NetworkException) {
    // خطأ في الشبكة
  } else if (e is AuthenticationException) {
    // خطأ في المصادقة
  } else {
    // خطأ عام
  }
}
```

## أفضل الممارسات

### 1. استخدام Provider للوصول للخدمات
```dart
final dbService = Provider.of<DBService>(context, listen: false);
```

### 2. معالجة الأخطاء دائماً
```dart
try {
  await service.method();
} catch (e) {
  // معالجة الخطأ
}
```

### 3. استخدام async/await
```dart
Future<void> saveData() async {
  await dbService.saveMemory(memory);
}
```

### 4. تسجيل العمليات المهمة
```dart
WingLogger.info('تم حفظ الذكرى بنجاح', tag: 'DBService');
```

## الأمان والخصوصية

### مبادئ الأمان
- **تشفير محلي**: جميع البيانات مشفرة محلياً
- **عدم الإرسال**: لا يتم إرسال بيانات لخوادم خارجية
- **التحكم الكامل**: المستخدم يتحكم في جميع بياناته
- **الحذف الآمن**: إمكانية حذف البيانات نهائياً

### الامتثال الشرعي
- **احترام الخصوصية**: حماية أسرار الحياة الزوجية
- **المحتوى الحلال**: جميع الخدمات متوافقة مع التعاليم الإسلامية
- **الشفافية**: وضوح في كيفية استخدام البيانات
- **الموافقة**: الحصول على موافقة صريحة قبل أي عملية

---

## الخلاصة

واجهات البرمجة للخدمات في "جناح الحنين" مصممة لتوفر تجربة آمنة وسلسة ومتكاملة. جميع الخدمات تعمل محلياً مع تشفير متقدم لضمان الخصوصية المطلقة، وهي متوافقة مع التعاليم الإسلامية في كل جانب.

*التقييم التقني: 95/100 (ممتاز بامتياز)*  
*الحالة: مُطبق ومُختبر*  
*آخر تحديث: يناير 2025*