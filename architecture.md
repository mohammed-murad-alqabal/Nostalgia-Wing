# المعمارية الحالية



> **Status:** Current
>
> **Owner:** فريق التطوير
>
> **Authority:** Code + Dependencies
>
> **Last verified:** 13 أغسطس 2026
>
> **Verified commit:** `868efdf`
>
> **Related code:** `active_source_wing/lib/main.dart`, `active_source_wing/lib/core/`
>
> **Related tests:** `active_source_wing/test/`
>
> **إعداد:** إعداد فريق تطوير مشروع جناح الحنين
>


## نظرة عامة



المعمارية الحالية هي تطبيق Flutter/Dart يعمل محلياً، مع فصل عملي بين واجهات `features` وخدمات ونماذج وبنية تحتية داخل `core`. يستخدم التطبيق `Provider` لحقن الاعتماديات وحالة التطبيق، ويستخدم Drift وHive لأغراض تخزين مختلفة. لا تُعد هذه الوثيقة وعداً بوجود Backend أو نموذج ذكاء اصطناعي خارجي أو محلي ما لم يثبت ذلك في التبعيات والكود والاختبارات.



## طبقات التنفيذ الفعلية



| الطبقة | المكونات المثبتة | الملاحظات |

|---|---|---|

| Presentation | شاشات الذاكرة والرسائل والمفاجآت والإعدادات والصفحة الرئيسية | Flutter Widgets داخل `features/` |

| Application/State | `MultiProvider`, `AppStateProvider`, خدمات التطبيق | Provider هو الأسلوب الفعلي الحالي |

| Cognitive/Psychology | `EmotionalGravityEngine`, `SurpriseEvolutionEngine`, `DualTruthEngine`, `PsychologicalContextManager` وغيرها | وحدات Dart محلية، ويجب عدم مساواتها بنموذج LLM |

| Data | `DBService`, `AppDatabase`, Drift، Hive | توجد قاعدة Drift ونماذج Hive |

| Security | `KeyManager`, `SecurityService`, `flutter_secure_storage`, `cryptography` | يثبت حماية مفاتيح/بيانات محلية جزئياً، لا يثبت E2EE |

| Infrastructure | `AppInitializer`, logging، health monitoring، governance helpers | تهيئة الخدمات والتعامل مع فشل الإقلاع |



## تدفق الإقلاع



يبدأ `main.dart` بتهيئة Flutter، ثم يستدعي `AppInitializer.initialize()`. تهيئ هذه العملية Service Locator وHive والخدمات الأساسية وقاعدة البيانات وخدمات الإشعارات والسياق النفسي، ثم تمرر الخدمات المهيأة إلى التطبيق. عند فشل الإقلاع يُشغّل التطبيق وضع طوارئ بدلاً من الادعاء بأن كل الخدمات جاهزة.



## التخزين



يستخدم Drift لقاعدة البيانات المحلية المنظمة، بينما تستخدم Hive لبعض النماذج والصناديق. يجب التعامل مع اختلاف مخططي التخزين بعناية عند إضافة نموذج جديد. وجود `cryptography` و`flutter_secure_storage` لا يعني أن كل عمود أو ملف وسائط مشفر تلقائياً؛ يجب أن يذكر كل مسار تخزين سياسة التشفير والاختبار المرتبط بها.



## حدود المعمارية الحالية



لا يوجد في هذه الوثيقة ادعاء بأن المشروع يحتوي حالياً على Riverpod أو FastAPI أو PostgreSQL أو Firebase Auth أو Signal Protocol أو TensorFlow Lite أو MediaPipe أو Gemma أو Llama. هذه العناصر يمكن وصفها في وثائق `Proposed` فقط إلى أن تُضاف فعلياً وتُختبر.



## قرارات التطوير



أي انتقال من Provider إلى Riverpod، أو من التخزين المحلي إلى Backend، أو إضافة نموذج محلي، يجب أن يُسجل في ADR يحدد سبب التغيير، نطاقه، خطة الترحيل، أثر الخصوصية، ونتيجة الاختبار. لا تعدّل هذه الوثيقة لتصف التصميم الجديد قبل أن يصبح قابلاً للتشغيل والتحقق.
