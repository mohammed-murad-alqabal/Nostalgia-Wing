> **Status:** Current
> **Owner:** فريق تطوير مشروع جناح الحنين
> **Authority:** `AuthService` و`DBService` ومسار `AuthWrapper` في `main.dart`
> **Last verified:** 2026-08-18
> **Verified commit:** PR #17 branch under review
> **Related code:** `active_source_wing/lib/core/services/auth_service.dart`, `active_source_wing/lib/core/services/db_service.dart`, `active_source_wing/lib/main.dart`
> **Related tests:** `active_source_wing/test/core/services/auth_service_test.dart`, `active_source_wing/test/integration/services_integration_test.dart`, `active_source_wing/test/core/security/institutional_maintenance_test.dart`

## Purpose

يعرّف هذا المستند حدود المصادقة الحالية في تطبيق جناح الحنين. العقد الحالي هو **جلسة محلية مؤقتة داخل الذاكرة** تحمي حدود عمليات قاعدة البيانات في العملية الجارية. وهو ليس إثباتاً لهوية خارجية، ولا تسجيل دخول إلى حساب، ولا بديلاً عن PIN أو biometric أو Backend identity provider.

> **القاعدة الأمنية:** امتلاك التطبيق للجلسة المحلية لا يثبت أن شخصاً بعينه هو صاحب البيانات؛ لكنه يمنع طبقة التخزين المحمية من تنفيذ عملياتها قبل فتح جلسة محلية صريحة داخل العملية الحالية.

## دورة الحياة

| العملية | السلوك المعتمد | الأثر الأمني |
|---|---|---|
| `initialize()` | تهيئة idempotent ولا تفتح جلسة | لا تمنح صلاحية قاعدة البيانات وحدها |
| `authenticate()` | تهيئة الخدمة عند الحاجة وفتح جلسة محلية في الذاكرة | لا تتحقق من هوية خارجية |
| `isAuthenticated` | تعكس حالة الجلسة الحالية فقط | لا تعني وجود اعتماد دائم |
| `requireAuthenticated()` | ترمي `AuthenticationRequiredException` عند غياب الجلسة | حاجز إلزامي قبل عمليات `DBService` |
| `logout()` | يغلق الجلسة ويظل آمناً عند تكراره | يمنع العمليات المحمية بعد الإغلاق |
| `dispose()` | يغلق الجلسة ويعيد الخدمة لحالة غير مهيأة | يستخدم في reset وإعادة التهيئة |

الجلسة لا تُحفظ في `SharedPreferences` ولا في Hive ولا في Drift. لذلك ينتهي أثرها عند `logout()` أو `dispose()` أو انتهاء العملية. لا يُسمح بإضافة persistence للجلسة في هذا النطاق؛ أي تغيير من هذا النوع يحتاج مراجعة أمنية مستقلة.

## حماية قاعدة البيانات

يستدعي `DBService` الحارس قبل كل عملية قراءة أو كتابة أو حذف على جداول الذكريات والرسائل والمفاجآت. يجب أن تفشل العمليات المحمية قبل الوصول إلى Drift عندما لا توجد جلسة. بعد `logout()` يجب أن تفشل العمليات نفسها حتى لو بقي كائن `DBService` موجوداً في الذاكرة.

`PrivacyMaintenanceService` يملك مساراً مستقلاً للتصفير، ويغلق الجلسة أثناء العملية. لا ينبغي اعتبار تنفيذ التصفير عملية تتطلب جلسة قاعدة بيانات فعالة؛ التصفير هو مسار حماية وإلغاء بيانات، ويجب أن يبقى قابلاً للتنفيذ عند حدوث فشل أو حالة جلسة غير مكتملة.

## سلوك بدء التطبيق

يفتح `AuthWrapper` الجلسة المحلية تلقائياً أثناء بدء واجهة التطبيق الحالية. هذا السلوك يحقق عقد التخزين المحلي الحالي، لكنه لا يضيف تحقق هوية. إذا احتاج المنتج إلى شاشة PIN أو biometric أو Backend identity، فيجب إضافة مزود مصادقة حقيقي خلف عقد منفصل مع مراجعة للتهديدات والاحتفاظ بالأسرار؛ لا يجوز إعادة تسمية الجلسة الحالية على أنها مصادقة هوية.

## حدود النطاق

هذا العقد لا ينفذ تدوير المفاتيح، أو versioned encryption envelope، أو مزود هوية خارجي، أو مزامنة Backend، أو صلاحيات متعددة المستخدمين. وتبقى هذه المسارات `Proposed` حتى تعتمد مواصفاتها واختباراتها.

## معايير التحقق

يجب أن تثبت الاختبارات أن `initialize()` لا يفتح جلسة، وأن العمليات المحمية تُرفض قبل `authenticate()` وبعد `logout()`، وأن `authenticate()` و`logout()` idempotent، وأن `dispose()` يمسح حالة الجلسة ويسمح ببدء دورة تهيئة جديدة. كما يجب أن يثبت اختبار التكامل أن القراءة والكتابة عبر Drift لا تحدث دون جلسة محلية.

## References

[1]: https://github.com/mohammed-murad-alqabal/Nostalgia-Wing/blob/main/active_source_wing/lib/core/services/auth_service.dart "AuthService"

[2]: https://github.com/mohammed-murad-alqabal/Nostalgia-Wing/blob/main/active_source_wing/lib/core/services/db_service.dart "DBService"

[3]: https://github.com/mohammed-murad-alqabal/Nostalgia-Wing/blob/main/active_source_wing/lib/main.dart "Application startup and AuthWrapper"

[4]: https://github.com/mohammed-murad-alqabal/Nostalgia-Wing/blob/main/active_source_wing/lib/core/security/privacy_maintenance_service.dart "PrivacyMaintenanceService"

[5]: https://github.com/mohammed-murad-alqabal/Nostalgia-Wing/blob/main/active_source_wing/test/integration/services_integration_test.dart "Authentication and database integration tests"

[6]: https://github.com/mohammed-murad-alqabal/Nostalgia-Wing/blob/main/active_source_wing/test/core/security/institutional_maintenance_test.dart "Privacy reset contract tests"
