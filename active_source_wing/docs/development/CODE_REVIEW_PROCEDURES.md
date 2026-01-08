# إجراءات مراجعة الكود - جناح الحنين

## نظرة عامة

هذا الدليل يحدد إجراءات وأفضل الممارسات لمراجعة الكود في مشروع "جناح الحنين"، مع التركيز على الجودة التقنية والامتثال الشرعي والأمان.

---

## 🎯 أهداف مراجعة الكود

### الأهداف الأساسية
1. **ضمان الجودة التقنية**: كود نظيف وقابل للصيانة
2. **الأمان والخصوصية**: حماية بيانات المستخدمين
3. **الامتثال الشرعي**: مراجعة المحتوى الإسلامي
4. **نقل المعرفة**: تعلم وتطوير الفريق
5. **الاتساق**: توحيد أسلوب الكود

### المعايير المطلوبة
- **الوضوح**: كود مفهوم وموثق جيداً
- **الأداء**: حلول محسنة وسريعة
- **الاختبارات**: تغطية شاملة للاختبارات
- **الأمان**: حماية من الثغرات الأمنية
- **الشرعية**: محتوى متوافق مع الأحكام الإسلامية

---

## 📋 قائمة مراجعة الكود

### ✅ المراجعة التقنية

#### 1. جودة الكود
```dart
// ✅ جيد - أسماء واضحة ووظائف صغيرة
class EmotionalMessageService {
  Future<String> generatePersonalizedMessage(
    String partnerName,
    EmotionType currentEmotion,
  ) async {
    final template = await _selectAppropriateTemplate(currentEmotion);
    return _personalizeMessage(template, partnerName);
  }
  
  Future<MessageTemplate> _selectAppropriateTemplate(EmotionType emotion) async {
    // منطق واضح ومحدد
  }
}

// ❌ سيء - أسماء غير واضحة ووظيفة معقدة
class EMS {
  Future<String> doStuff(String n, int t) async {
    // كود معقد وغير واضح
    if (t == 1) {
      // ...
    } else if (t == 2) {
      // ...
    }
    // 50 سطر من الكود المعقد
  }
}
```

#### 2. معالجة الأخطاء
```dart
// ✅ جيد - معالجة شاملة للأخطاء
Future<void> saveMemory(Memory memory) async {
  try {
    await _validateMemory(memory);
    await _encryptSensitiveData(memory);
    await _saveToDatabase(memory);
    
    WingLogger.info('تم حفظ الذكرى بنجاح', tag: 'MemoryService');
  } on ValidationException catch (e) {
    WingLogger.error('خطأ في التحقق من الذكرى: ${e.message}', tag: 'MemoryService');
    throw UserFriendlyException('يرجى التحقق من بيانات الذكرى');
  } on DatabaseException catch (e) {
    WingLogger.error('خطأ في قاعدة البيانات: ${e.message}', tag: 'MemoryService');
    throw UserFriendlyException('حدث خطأ في الحفظ، يرجى المحاولة مرة أخرى');
  } catch (e, stackTrace) {
    WingLogger.critical('خطأ غير متوقع في حفظ الذكرى', 
                       tag: 'MemoryService', 
                       data: {'memory_id': memory.id},
                       stackTrace: stackTrace);
    throw UserFriendlyException('حدث خطأ غير متوقع');
  }
}

// ❌ سيء - بدون معالجة أخطاء
Future<void> saveMemory(Memory memory) async {
  await database.insert('memories', memory.toJson());
}
```

#### 3. الأمان والخصوصية
```dart
// ✅ جيد - تشفير البيانات الحساسة
class SecureMemoryStorage {
  Future<void> savePrivateMemory(Memory memory) async {
    // تشفير المحتوى الحساس
    final encryptedContent = await SecureDataManager.encrypt(memory.content);
    final encryptedMemory = memory.copyWith(content: encryptedContent);
    
    // حفظ مع hash للتحقق من السلامة
    final hash = await SecureDataManager.generateHash(encryptedContent);
    await _saveWithIntegrityCheck(encryptedMemory, hash);
  }
}

// ❌ سيء - حفظ بيانات حساسة بدون تشفير
class MemoryStorage {
  Future<void> saveMemory(Memory memory) async {
    // خطر أمني - بيانات غير مشفرة
    await database.insert('memories', {
      'content': memory.content, // نص واضح!
      'partner_name': memory.partnerName, // معلومات شخصية!
    });
  }
}
```

#### 4. الاختبارات
```dart
// ✅ جيد - اختبارات شاملة
class EmotionalMessageServiceTest {
  group('EmotionalMessageService', () {
    late EmotionalMessageService service;
    
    setUp(() {
      service = EmotionalMessageService();
    });
    
    test('should generate personalized message for happy emotion', () async {
      // Arrange
      const partnerName = 'فاطمة';
      const emotion = EmotionType.happy;
      
      // Act
      final message = await service.generatePersonalizedMessage(partnerName, emotion);
      
      // Assert
      expect(message, contains(partnerName));
      expect(message, isNotEmpty);
      expect(message.length, greaterThan(10));
    });
    
    test('should handle invalid partner name gracefully', () async {
      // Arrange
      const invalidName = '';
      const emotion = EmotionType.neutral;
      
      // Act & Assert
      expect(
        () => service.generatePersonalizedMessage(invalidName, emotion),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
```

### ✅ المراجعة الشرعية

#### 1. المحتوى الإسلامي
```dart
// ✅ جيد - محتوى إسلامي صحيح ومراجع
class IslamicPrinciple {
  final String title;
  final String description;
  final String quranReference; // مرجع قرآني صحيح
  final String hadithReference; // مرجع حديث صحيح
  final String practicalApplication; // تطبيق عملي
  
  const IslamicPrinciple({
    required this.title,
    required this.description,
    required this.quranReference,
    required this.hadithReference,
    required this.practicalApplication,
  });
}

// مثال على مبدأ صحيح
final principle = IslamicPrinciple(
  title: 'الرحمة بين الزوجين',
  description: 'الرحمة أساس العلاقة الزوجية في الإسلام...',
  quranReference: 'الروم: 21', // مرجع صحيح
  hadithReference: 'صحيح البخاري: 5186', // مرجع صحيح
  practicalApplication: 'التعامل بلطف وحنان مع الشريك...',
);

// ❌ سيء - محتوى بدون مراجع أو غير دقيق
final badPrinciple = IslamicPrinciple(
  title: 'شيء ما',
  description: 'وصف غامض...',
  quranReference: 'سورة غير موجودة: 999', // خطأ!
  hadithReference: 'حديث ضعيف أو موضوع', // خطأ!
  practicalApplication: 'غير واضح...',
);
```

#### 2. الأدعية والنصوص الدينية
```dart
// ✅ جيد - دعاء صحيح مع التشكيل والمصدر
class Prayer {
  static const marriagePrayer = Prayer(
    arabicText: 'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ',
    transliteration: 'Rabbana hab lana min azwajina wa dhurriyyatina qurrata a\'yun',
    translation: 'ربنا هب لنا من أزواجنا وذرياتنا قرة أعين',
    source: 'القرآن الكريم - الفرقان: 74',
    verified: true, // تم التحقق من صحته
  );
}

// ❌ سيء - نص غير محقق أو خاطئ
class BadPrayer {
  static const unverifiedPrayer = Prayer(
    arabicText: 'نص غير محقق...', // بدون تشكيل أو مصدر
    source: 'مصدر غير معروف',
    verified: false, // غير محقق!
  );
}
```

### ✅ مراجعة الأداء

#### 1. استخدام الذاكرة
```dart
// ✅ جيد - إدارة فعالة للذاكرة
class MemoryManager {
  final Map<String, WeakReference<Memory>> _memoryCache = {};
  
  Future<Memory?> getMemory(String id) async {
    // فحص الكاش أولاً
    final weakRef = _memoryCache[id];
    final cachedMemory = weakRef?.target;
    
    if (cachedMemory != null) {
      return cachedMemory;
    }
    
    // تحميل من قاعدة البيانات
    final memory = await _loadFromDatabase(id);
    if (memory != null) {
      _memoryCache[id] = WeakReference(memory);
    }
    
    return memory;
  }
  
  void clearCache() {
    _memoryCache.clear(); // تنظيف الذاكرة
  }
}

// ❌ سيء - تسريب في الذاكرة
class BadMemoryManager {
  final Map<String, Memory> _memoryCache = {}; // Strong references!
  
  Future<Memory?> getMemory(String id) async {
    if (_memoryCache.containsKey(id)) {
      return _memoryCache[id];
    }
    
    final memory = await _loadFromDatabase(id);
    _memoryCache[id] = memory; // تراكم في الذاكرة!
    return memory;
  }
  
  // لا يوجد تنظيف للذاكرة!
}
```

#### 2. استعلامات قاعدة البيانات
```dart
// ✅ جيد - استعلامات محسنة
class OptimizedMemoryRepository {
  Future<List<Memory>> getRecentMemories({int limit = 10}) async {
    return await database.query(
      'memories',
      orderBy: 'created_at DESC',
      limit: limit, // تحديد العدد
      where: 'is_deleted = ?',
      whereArgs: [0],
    );
  }
  
  Future<List<Memory>> searchMemories(String query) async {
    // استخدام فهرس البحث
    return await database.rawQuery('''
      SELECT * FROM memories 
      WHERE memories MATCH ? 
      ORDER BY rank
      LIMIT 50
    ''', [query]);
  }
}

// ❌ سيء - استعلامات غير محسنة
class BadMemoryRepository {
  Future<List<Memory>> getRecentMemories() async {
    // تحميل جميع البيانات!
    final allMemories = await database.query('memories');
    
    // ترتيب في الذاكرة بدلاً من قاعدة البيانات
    allMemories.sort((a, b) => b['created_at'].compareTo(a['created_at']));
    
    return allMemories.take(10).toList(); // غير فعال!
  }
}
```

---

## 🔄 عملية مراجعة الكود

### المراحل الأساسية

#### 1. إنشاء Pull Request
```markdown
## وصف التغييرات
وصف واضح للتغييرات المطلوبة

## نوع التغيير
- [ ] إصلاح خطأ (bug fix)
- [ ] ميزة جديدة (feature)
- [ ] تحسين الأداء (performance)
- [ ] تحديث المحتوى الشرعي (islamic content)
- [ ] تحسين الأمان (security)

## قائمة التحقق
- [ ] تم اختبار الكود محلياً
- [ ] تم إضافة/تحديث الاختبارات
- [ ] تم تحديث التوثيق
- [ ] تم مراجعة المحتوى الشرعي (إن وجد)
- [ ] تم فحص الأمان والخصوصية

## لقطات الشاشة (إن وجدت)
إضافة لقطات شاشة للتغييرات في الواجهة

## ملاحظات إضافية
أي معلومات إضافية مهمة للمراجعين
```

#### 2. المراجعة الأولية (Self Review)
```bash
# قائمة تحقق المطور قبل إرسال PR
echo "🔍 مراجعة ذاتية قبل إرسال Pull Request"

# 1. فحص التنسيق
dart format .

# 2. تحليل الكود
flutter analyze

# 3. تشغيل الاختبارات
flutter test

# 4. فحص الأمان
grep -r "TODO\|FIXME\|password\|secret" lib/

# 5. مراجعة المحتوى الشرعي
python scripts/islamic_content_reviewer.py

echo "✅ جاهز للمراجعة"
```

#### 3. المراجعة من الأقران (Peer Review)

##### دور المراجع الأول (Technical Reviewer)
- **التركيز**: الجودة التقنية والأداء
- **المدة المتوقعة**: 2-4 ساعات
- **المسؤوليات**:
  - فحص منطق الكود
  - مراجعة الاختبارات
  - التحقق من الأداء
  - فحص معالجة الأخطاء

##### دور المراجع الثاني (Security & Islamic Reviewer)
- **التركيز**: الأمان والمحتوى الشرعي
- **المدة المتوقعة**: 1-2 ساعة
- **المسؤوليات**:
  - فحص الثغرات الأمنية
  - مراجعة المحتوى الإسلامي
  - التحقق من الخصوصية
  - فحص التشفير

#### 4. المراجعة النهائية (Senior Review)
- **المراجع**: Senior Developer أو Tech Lead
- **التركيز**: الهندسة المعمارية والقرارات التقنية
- **المعايير**:
  - توافق مع الهندسة العامة
  - قابلية التوسع
  - إمكانية الصيانة
  - التأثير على الأداء العام

---

## 📝 أفضل ممارسات المراجعة

### للمراجعين (Reviewers)

#### 1. كن بناءً وإيجابياً
```markdown
# ✅ جيد - تعليق بناء
"هذا الحل يعمل بشكل جيد، لكن يمكن تحسين الأداء باستخدام `StreamBuilder` بدلاً من `FutureBuilder` هنا لأن البيانات تتغير بشكل متكرر."

# ❌ سيء - تعليق سلبي
"هذا الكود سيء ولا يعمل بشكل صحيح."
```

#### 2. اقترح حلول بديلة
```dart
// تعليق المراجع:
// "يمكن تبسيط هذا الكود باستخدام null-aware operators:"

// الكود الحالي:
String getDisplayName(User? user) {
  if (user != null && user.name != null) {
    return user.name!;
  } else {
    return 'مستخدم غير معروف';
  }
}

// الاقتراح:
String getDisplayName(User? user) {
  return user?.name ?? 'مستخدم غير معروف';
}
```

#### 3. اشرح السبب
```markdown
# ✅ جيد - شرح السبب
"يفضل استخدام `const` constructor هنا لتحسين الأداء، لأن هذا الـ widget لا يتغير ويمكن إعادة استخدامه."

# ❌ سيء - بدون شرح
"استخدم const هنا."
```

### للمطورين (Authors)

#### 1. اكتب وصف واضح للـ PR
```markdown
## إضافة ميزة الرسائل العاطفية المخصصة

### ما تم إضافته:
- خدمة جديدة لتخصيص الرسائل حسب المشاعر
- واجهة مستخدم لاختيار نوع الرسالة
- اختبارات شاملة للخدمة الجديدة

### التغييرات التقنية:
- إضافة `EmotionalMessageCustomizer` class
- تحديث `MessageService` لدعم التخصيص
- إضافة 15 اختبار وحدة جديد

### المحتوى الشرعي:
- جميع الرسائل مراجعة شرعياً
- مصادر من القرآن والسنة الصحيحة
- مناسبة للثقافة الإسلامية

### الاختبار:
تم اختبار الميزة مع 5 مستخدمين وكانت النتائج إيجابية.
```

#### 2. استجب للتعليقات بإيجابية
```markdown
# ✅ جيد - استجابة إيجابية
"شكراً على الملاحظة! هذا اقتراح ممتاز. سأقوم بتطبيق التحسين المقترح."

# ❌ سيء - استجابة دفاعية
"الكود يعمل بشكل جيد كما هو، لا أرى مشكلة."
```

#### 3. اطلب التوضيح عند الحاجة
```markdown
"شكراً على المراجعة. هل يمكنك توضيح المقصود بـ 'تحسين الأداء' هنا؟ هل تقصد استخدام caching أم شيء آخر؟"
```

---

## 🛠️ أدوات المراجعة

### إعداد GitHub للمراجعة

#### 1. قالب Pull Request
```markdown
<!-- .github/pull_request_template.md -->
## 📋 وصف التغييرات
<!-- وصف واضح ومفصل للتغييرات -->

## 🔄 نوع التغيير
- [ ] 🐛 إصلاح خطأ (bug fix)
- [ ] ✨ ميزة جديدة (feature)
- [ ] ⚡ تحسين الأداء (performance)
- [ ] 🕌 تحديث المحتوى الشرعي (islamic content)
- [ ] 🔒 تحسين الأمان (security)
- [ ] 📚 تحديث التوثيق (documentation)
- [ ] 🧪 إضافة اختبارات (tests)

## ✅ قائمة التحقق
- [ ] تم اختبار الكود محلياً
- [ ] تم تشغيل `flutter analyze` بدون أخطاء
- [ ] تم تشغيل `flutter test` بنجاح
- [ ] تم إضافة/تحديث الاختبارات حسب الحاجة
- [ ] تم تحديث التوثيق حسب الحاجة
- [ ] تم مراجعة المحتوى الشرعي (إن وجد)
- [ ] تم فحص الأمان والخصوصية

## 🕌 المراجعة الشرعية (إن وجدت)
- [ ] جميع النصوص الدينية محققة ومراجعة
- [ ] المصادر صحيحة ومعتبرة
- [ ] المحتوى مناسب للثقافة الإسلامية
- [ ] لا يوجد محتوى مخالف للشريعة

## 🔒 الأمان والخصوصية
- [ ] لا توجد كلمات مرور أو مفاتيح مكشوفة
- [ ] البيانات الحساسة مشفرة
- [ ] تم اتباع أفضل ممارسات الأمان
- [ ] تم فحص الثغرات الأمنية المحتملة

## 📱 لقطات الشاشة (للتغييرات في الواجهة)
<!-- إضافة لقطات شاشة قبل وبعد التغيير -->

## 🧪 كيفية الاختبار
<!-- خطوات واضحة لاختبار التغييرات -->

## 📝 ملاحظات إضافية
<!-- أي معلومات إضافية مهمة للمراجعين -->

## 📊 تأثير الأداء
<!-- إذا كان هناك تأثير على الأداء، اذكره هنا -->

---
/cc @tech-lead @islamic-reviewer @security-reviewer
```

#### 2. إعداد CODEOWNERS
```bash
# .github/CODEOWNERS

# Global owners
* @tech-lead @senior-dev

# Core system
/lib/core/ @tech-lead @senior-dev @security-reviewer

# Islamic content
/assets/data/islamic_* @islamic-reviewer @tech-lead
/lib/core/islamic/ @islamic-reviewer @tech-lead

# Security
/lib/core/security/ @security-reviewer @tech-lead
/lib/core/services/auth_service.dart @security-reviewer @tech-lead

# Documentation
/docs/ @tech-lead @documentation-lead

# CI/CD
/.github/ @tech-lead @devops-lead
/scripts/ @tech-lead @devops-lead
```

### أدوات التحليل التلقائي

#### 1. إعداد SonarQube
```yaml
# sonar-project.properties
sonar.projectKey=wing-of-nostalgia
sonar.projectName=Wing of Nostalgia
sonar.projectVersion=1.0

sonar.sources=lib
sonar.tests=test
sonar.exclusions=**/*.g.dart,**/*.freezed.dart

sonar.dart.coverage.reportPaths=coverage/lcov.info
sonar.dart.analysis.reportPaths=dart-analysis.json

# Quality gates
sonar.qualitygate.wait=true
```

#### 2. إعداد CodeClimate
```yaml
# .codeclimate.yml
version: "2"

checks:
  argument-count:
    config:
      threshold: 4
  complex-logic:
    config:
      threshold: 4
  file-lines:
    config:
      threshold: 250
  method-complexity:
    config:
      threshold: 5
  method-count:
    config:
      threshold: 20
  method-lines:
    config:
      threshold: 25

plugins:
  dart:
    enabled: true
  fixme:
    enabled: true

exclude_patterns:
- "**/*.g.dart"
- "**/*.freezed.dart"
- "test/"
```

---

## 📊 مؤشرات جودة المراجعة

### مؤشرات الأداء

#### 1. سرعة المراجعة
```python
# scripts/review_metrics.py
class ReviewMetrics:
    def calculate_review_time(self, pr_data):
        """حساب متوسط وقت المراجعة"""
        created_at = pr_data['created_at']
        first_review = pr_data['first_review_at']
        
        if first_review:
            review_time = first_review - created_at
            return review_time.total_seconds() / 3600  # بالساعات
        
        return None
    
    def calculate_approval_time(self, pr_data):
        """حساب وقت الموافقة النهائية"""
        created_at = pr_data['created_at']
        approved_at = pr_data['approved_at']
        
        if approved_at:
            approval_time = approved_at - created_at
            return approval_time.total_seconds() / 3600  # بالساعات
        
        return None
```

#### 2. جودة المراجعة
```python
class ReviewQuality:
    def calculate_defect_escape_rate(self, releases):
        """حساب معدل الأخطاء التي تسربت للإنتاج"""
        total_defects = sum(r['defects_found'] for r in releases)
        escaped_defects = sum(r['defects_escaped'] for r in releases)
        
        if total_defects > 0:
            return (escaped_defects / total_defects) * 100
        
        return 0
    
    def calculate_review_coverage(self, pr_data):
        """حساب تغطية المراجعة"""
        lines_changed = pr_data['lines_changed']
        lines_reviewed = pr_data['lines_with_comments']
        
        if lines_changed > 0:
            return (lines_reviewed / lines_changed) * 100
        
        return 0
```

### تقارير دورية

#### التقرير الأسبوعي
```python
def generate_weekly_review_report():
    """إنشاء تقرير مراجعة أسبوعي"""
    report = {
        'period': 'أسبوعي',
        'metrics': {
            'total_prs': get_weekly_pr_count(),
            'average_review_time': calculate_average_review_time(),
            'approval_rate': calculate_approval_rate(),
            'defect_rate': calculate_defect_rate(),
        },
        'top_reviewers': get_top_reviewers(),
        'areas_for_improvement': identify_improvement_areas(),
    }
    
    send_report_to_team(report)
```

---

## 🎓 التدريب والتطوير

### برنامج تدريب المراجعين

#### المستوى الأول: المراجع المبتدئ
**المدة**: 2-3 أسابيع  
**المحتوى**:
- أساسيات مراجعة الكود
- أدوات المراجعة
- معايير الجودة الأساسية
- آداب المراجعة

**التقييم**:
- مراجعة 5 PRs تحت إشراف
- اجتياز اختبار نظري
- تقييم من المراجعين الأكبر

#### المستوى الثاني: المراجع المتوسط
**المدة**: 4-6 أسابيع  
**المحتوى**:
- مراجعة الأمان المتقدمة
- تحليل الأداء
- الهندسة المعمارية
- المحتوى الشرعي

**التقييم**:
- مراجعة 10 PRs معقدة
- تحديد وإصلاح مشاكل أمنية
- مراجعة محتوى إسلامي

#### المستوى الثالث: المراجع المتقدم
**المدة**: 6-8 أسابيع  
**المحتوى**:
- قيادة عملية المراجعة
- تدريب المراجعين الجدد
- وضع معايير الجودة
- حل النزاعات التقنية

### ورش العمل الدورية

#### ورشة "أفضل ممارسات المراجعة"
**التكرار**: شهرياً  
**المدة**: 2 ساعة  
**المحتوى**:
- مراجعة حالات واقعية
- مناقشة التحديات
- تبادل الخبرات
- تحديث المعايير

#### ورشة "الأمان في المراجعة"
**التكرار**: كل 3 أشهر  
**المدة**: 4 ساعات  
**المحتوى**:
- أحدث التهديدات الأمنية
- تقنيات الفحص المتقدمة
- دراسة حالات اختراق
- أدوات الأمان الجديدة

---

## 📚 الموارد والمراجع

### الأدلة الداخلية
- [دليل معايير الكود](./CODING_STANDARDS.md)
- [دليل الأمان والخصوصية](../security/SECURITY_GUIDE.md)
- [دليل المحتوى الشرعي](../islamic-compliance/ISLAMIC_CONTENT_GUIDE.md)
- [دليل الاختبارات](./TESTING_GUIDE.md)

### الأدوات المساعدة
- **GitHub**: نظام المراجعة الأساسي
- **SonarQube**: تحليل جودة الكود
- **CodeClimate**: مؤشرات الجودة
- **Dart Analyzer**: تحليل كود Dart
- **Flutter Inspector**: فحص الأداء

### المراجع الخارجية
- [Google's Code Review Guidelines](https://google.github.io/eng-practices/review/)
- [Flutter Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [OWASP Secure Code Review](https://owasp.org/www-project-code-review-guide/)

---

*آخر تحديث: 30 ديسمبر 2025*  
*إصدار الدليل: 1.0*  
*متوافق مع: GitHub Enterprise, Flutter 3.22.2+*